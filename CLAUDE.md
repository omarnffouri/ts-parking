# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Flutter Version

Project uses FVM (Flutter Version Manager). Flutter version locked to **3.41.0** in `.fvmrc`. Use `fvm flutter` prefix if FVM is installed, or ensure your global Flutter matches.

## Build & Run Commands

```bash
flutter pub get                    # Install dependencies
flutter run                        # Run app (debug)
flutter build apk                  # Build Android APK
flutter build ios                  # Build iOS
dart run build_runner build --delete-conflicting-outputs  # Regenerate flutter_gen assets & mockito mocks
dart analyze lib/                  # Lint/analyze
dart format lib/ test/             # Format code
flutter test                       # Run all tests
flutter test test/path_test.dart   # Run single test
```

## Architecture

Clean Architecture with GetX for state management/routing and GetIt for dependency injection.

**Layer flow:** UI (Modules) → UseCases → Repositories (abstract) → DataSources → API/Storage

```text
lib/app/
├── core/           # DI, network, services, errors, shared widgets, utils
├── data/           # Models, datasource impls, repository impls
├── domain/         # Entities, abstract repos, usecases, enums, params
├── modules/        # Feature modules (each has bindings/, controllers/, views/)
├── routes/         # GetX route definitions (app_pages.dart + app_routes.dart)
└── theme/          # App theme (colors, typography, spacing, shadows, radius)
```

## Dependency Injection

**GetIt** (`lib/app/core/di/injection_container.dart`) is the service locator. Access via `sl<Type>()`.

Registration order matters — called sequentially in `init()`:

1. `initExternal()` — DioClient, SecureTokenStorage, GetStorage, ThemeService
2. `initDataSources()` — Auth (remote/local), Vehicle, PaymentMethod, Yard, Subscription, Settings, Notification, VehicleCharge
3. `initRepositories()` — Auth, Vehicle, PaymentMethod, Yard, Subscription, Settings, Notification, VehicleCharge
4. `initUsecases()` — All business logic usecases
5. `initServices()` — AuthService, StripeCardTokenService, NotificationService (depend on usecases/repos)

**GetX bindings** are only used for per-route controller registration (`Get.lazyPut<XxxController>`). Views access their controller via `GetView<ControllerType>` (e.g. `class LoginView extends GetView<LoginController>`) — `Get.find<T>()` is reserved for cross-controller lookups.

**Exception:** `YardDiscoveryController` is a permanent singleton (`Get.put(..., permanent: true)`) registered in `MainScreenBinding`, shared between Home and Map tabs.

## Key Patterns

- **Error handling:** DataSources throw custom exceptions (`AuthException`, `NetworkException`, `ServerException`, `ValidationException`, `CacheException` in `core/errors/exceptions.dart`). Repositories catch them and return `Either<Failure, T>` using dartz. Corresponding `Failure` subclasses are in `core/errors/failures.dart`. Repositories use a `_safe<T>()` helper to wrap datasource calls with exception-to-failure mapping.
- **DataSource method ordering:** Implementation classes follow: constructor → `_handleDioError` (private helper) → `@override` methods (public API). All datasources use a `Never _handleDioError(DioException e)` method that maps status codes to typed exceptions.
- **ErrorHandler utility:** `core/utils/error_handler.dart` provides `handleEither()`, `handleEitherAsync()`, `wrapInEitherAsync()`, and snackbar helpers (`showError`, `showSuccess`, `showInfo`, `showWarning`). Use this instead of raw snackbar calls.
- **Usecase pattern:** Each usecase takes a repository via constructor, exposes a single `execute()` method returning `Future<Either<Failure, T>>`. Params are dedicated classes in `domain/params/`.
- **Route arguments:** `domain/params/` also contains navigation argument classes (`SlotSelectionArgs`, `BookingConfirmationArgs`, `PaymentArgs`, `PaymentSuccessArgs`) — not just usecase params.
- **Models extend entities:** Data models (with JSON serialization) in `data/models/` extend domain entities (pure business objects) in `domain/entities/`.
- **Token management:** `SecureTokenStorage` encrypts tokens via flutter_secure_storage. `DioClient` auto-attaches Bearer tokens via `QueuedInterceptorsWrapper` and clears auth data on 401. Public endpoints (login, OTP, register) skip auth headers.
- **Theme system:** Dual theme support (light/dark) via `ThemeService`. Use `AppColors`, `AppSpacing`, `AppRadius`, `AppTypography`, `AppShadows` from `lib/app/theme/`. Access via `AppTheme.dark()` / `AppTheme.light()`.
- **Shared widgets:** Barrel export at `core/widgets/widgets.dart` — includes `AppButton`, `AppTextField`, `AppCard`, `StatusBadge`, `EmptyState`, `LoadingWidget`. Additional shared widgets (not barrel-exported): `InvoiceSummaryCard`, `LabelValueRow`, `FileViewerPage`, `AppLinearProgress`, `AddCardBottomSheet`.
- **`AppFloatingField`** (in `core/widgets/app_floating_field.dart`) is the primary input used across auth/forms (label-floating outlined style). For password inputs use `AppFloatingField.password(...)` — its State owns the obscure-toggle and lock prefix internally; do NOT add an `_isPasswordHidden` RxBool or a `togglePasswordVisibility` method to controllers.
- **FileViewerPage:** Reusable viewer in `core/widgets/file_viewer_page.dart` for PDF and image URLs. Use `FileViewerPage.fromUrl(url:, title:, headers:)` — auto-detects type from URL extension. Accepts auth headers for protected resources.
- **Generated assets:** flutter_gen outputs to `lib/app/core/gen/assets.gen.dart`. Run `dart run build_runner build --delete-conflicting-outputs` after adding/removing assets.
- **Stripe integration:** Publishable key is in `AppConstants`. `StripeCardTokenService` wraps card payment method creation. Stripe is initialized in `main.dart` before DI.
- **Paginated lists:** Controllers use scroll listener with `_loadMoreThreshold`, `_checkIfNeedsMore()` post-frame callback, and `_isLoadingMore` guard. See `SubscriptionsController` or `InvoicesController` for the pattern. `PaginatedResponse<T>` in `data/models/` handles dual-key JSON (`totalPages`/`total_pages`, `hasMorePages`/`has_more`).
- **Page scaffold pattern:** Most feature views use the same layout: `Scaffold(backgroundColor: primary)` with `SafeArea` header (back button + title) and `Expanded(Container(color: surface, borderRadius: xlargeTopRadius))` body.

## API

Base URL: `https://parking.ts-portal.com/api` (configured in `lib/app/core/constants/app_constants.dart`)

Endpoints and storage keys are defined in `AppConstants`. Auth uses **mobile + password**: driver login → if unverified, OTP send → OTP verify. All four endpoints (`/drivers/login`, `/otp/send`, `/otp/verify`, `/drivers/register`) take `password` in the request body. Registration is a direct POST to `/drivers/register` (multipart form-data, no OTP) and accepts `documents[N]` + `document_types[N]` array fields for license uploads (e.g. `document_types[0] = 'company_license'`). SSN is an **optional** registration input — `RegisterParams.ssn` is sent as `ss_no` only when non-null/non-empty (controller emits null for empty strings; view enforces digits-only, max 9 chars). The user profile response also exposes `ss_no` via `UserEntity.ssNo`.

Subscription/Invoice flow: slot selection → booking confirmation → create subscription → invoice generated → payment (if invoice exists) → success.

**Invoice domain shares the Subscription layer** — invoice operations (`getInvoices`, `getInvoiceById`, `payInvoice`) live in `SubscriptionRemoteDataSource` and `SubscriptionRepository`, not in separate files.

`CreateSubscriptionResponseModel.fromJson` handles two API response shapes: if `data` is a `List` → flat subscriptions with no invoice; if `data` is a `Map` → `{ subscriptions, invoice }`.

**Overstay Charges** — separate domain (`VehicleCharge`) for drivers charged for exceeding subscription duration. Has its own datasource/repository/usecase chain. Payment uses a bottom sheet (card/cash selection) instead of navigating to the full Payment screen, since overstay charges don't have invoices. Entity exposes `isUnpaid`/`isPaid` getters.

**Invoice types:** `InvoiceEntity` supports two types via `isOverstay`/`isSubscription` getters. Subscription invoices carry `List<SubscriptionEntity> subscriptions`; overstay invoices carry `List<OverstayItemEntity> overstays`. `InvoiceModel.fromJson` parses both arrays. The detail view conditionally renders `SubscriptionCard` or `OverstayItemCard`.

**Shared `AccentCard` widget:** `core/widgets/accent_card.dart` renders a Card with a 4px colored left accent strip using a `Stack` (single layout pass). Used by invoice, subscription, and overstay charge list cards. Pass `accentColor` (typically from `AppColors.getStatusColor(status)`) and `child`.

## Utilities (`core/utils/`)

- `DateTimeUtils` — static date formatting/parsing using `AppConstants` format strings, plus `timeAgo()`, `formatDuration()`.
- `Validators` — static form validators (email, password, name, phone, etc.).
- `ThemeExtensions` — `BuildContext.isDark` / `.isLight` getters.
- `ColorExtensions` / `ContextColorExtensions` — `BuildContext.panelColor`, `.tileColor`, `.primaryTextColor`, etc.
- `MobileInputFormatter` — `TextInputFormatter` that auto-formats phone input as `XXX-XXX-XXXX`.

## Domain Enums (`domain/enums/`)

- `ParkingVehicleType` — truck/trailer/bobtail/unknown, with `ParkingVehicleTypeX` extension providing `fromApiName()`, `apiId`, `label`, `iconAsset`.
- `UserType` — client/driver/ownerOperator/unknown, with `UserTypeX` extension providing `fromApiName()`, `apiName`, `label`. Parsed from API field `user_type` (e.g. `cat_client`, `cat_driver`, `cat_owner_operator`).
- `SlotStatus` — available/booked, with color/title extensions.
- `BookingStatus`, `PaymentStatus`.

## Notifications (FCM)

`NotificationService` in `core/services/` handles Firebase Cloud Messaging. Initialized in `main.dart` after DI. Deep-links push notifications to relevant screens. Local notifications via `flutter_local_notifications`.

## Tests

Test structure mirrors `lib/app/`:

```text
test/app/
├── core/services/          # Service unit tests
├── data/models/            # Model serialization tests
├── data/repositories/      # Repository impl tests (all domains covered)
├── domain/entities/        # Entity behavior tests
├── domain/usecases/        # UseCase execution tests (auth, vehicle, payment, subscription, yard)
├── modules/                # Controller & view tests
└── helpers/mocks.dart      # Shared mocks (mockito-generated via build_runner)
```

Run `dart run build_runner build --delete-conflicting-outputs` to regenerate mock files after changing test dependencies.

## Product Spec

`prompt.md` in the repo root contains the full product specification: ~28 driver app screens across auth, home/discovery, booking, vehicles, subscriptions, invoices, notifications, and profile modules. Also includes yard owner app specs (not yet implemented).

## Adding a New Feature

1. Create entity in `domain/entities/`
2. Create abstract repository in `domain/repositories/`
3. Create usecase(s) in `domain/usecases/` with `execute()` method
4. Create model (extends entity) in `data/models/`
5. Create datasource interface + impl in `data/datasources/`
6. Create repository impl in `data/repositories/`
7. Register all in `core/di/injection_container.dart` (respect order: datasource → repo → usecase)
8. Create module folder in `modules/` with `bindings/`, `controllers/`, `views/`
9. Add route in `routes/app_pages.dart` and path in `routes/app_routes.dart`
