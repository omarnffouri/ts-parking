Tech Stack
Flutter — Clean Architecture + GetX state management, feature-first folder structure
Backend: NestJS + PostgreSQL + Prisma
Payments: Stripe + Cash/Bank transfer options
Notifications: Firebase FCM + SMS gateway
Maps: Google Maps SDK
Media: S3/R2 for 360° images

📱 DRIVER APP
Auth Module (5 screens)
ScreenFunctionsSplashLogo, auto-login checkOnboarding2-3 slides explaining the appLoginPhone/email + passwordRegisterFirst name, last name, phone, email, passwordOTP Verification6-digit code, resend timerForgot PasswordEmail/phone reset flow
Home & Discovery Module (5 screens)
ScreenFunctionsHomeSearch bar, nearby yards on map, featured/promoted yards, quick filtersMap ViewGoogle Maps with yard pins, tap for preview card, cluster markersYard ListCard-based list, sort by price/distance/ratingFilterCity, state, date range, price range, zone typeYard DetailName, address, photos, 360° viewer, zones list, pricing table, operating hours
Booking Module (6 screens)
ScreenFunctionsZone SelectionVisual zone layout, slot count & price per zoneSlot SelectionGrid/map of slots (A-21, B-21 style), color-coded: green=available, red=booked, grey=blockedDate & Time PickerCalendar + time range selector, blocked dates shownBooking SummarySelected slot, date, time, vehicle, price breakdownCoupon InputApply code, show discount, dynamic total updatePaymentChoose method (cash/bank/card), saved cards, pay buttonBooking ConfirmationSuccess animation, receipt details, QR code for entry
Vehicle Management Module (3 screens)
ScreenFunctionsMy Vehicles ListAll registered trucks/trailers, edit/delete, set defaultAdd VehicleType (truck/trailer), license plate, nicknameVehicle DetailFull info, linked bookings/subscriptions
Subscription Module (4 screens)
ScreenFunctionsPlans OverviewWeekly / Monthly / Yearly cards with pricingSelect VehiclesMulti-select from registered trucks for this subscriptionPricing CalculatorDynamic total based on vehicles × durationSubscription CheckoutCoupon + payment + confirmationActive SubscriptionsStatus, renewal date, included vehicles, renew/cancel actions
Bookings Management Module (3 screens)
ScreenFunctionsMy BookingsTabs: Upcoming, Active, Past, CancelledBooking DetailSlot info, countdown timer, yard contact, QR codeRenew BookingExtend duration, select new time, repay
Notifications Module (1 screen)
ScreenFunctionsNotifications ListBooking confirmations, 1-hour expiry warnings, renewal reminders, subscription alerts

Push notifications deep-link to relevant booking. SMS sent for critical alerts (expiry warning).

Profile & Settings Module (5 screens)
ScreenFunctionsProfileView/edit personal info, profile photoPayment MethodsSaved cards, add new card, set defaultTransaction HistoryAll payments, receipts, refund statusSettingsNotification toggles, language, theme (dark/light)Help / AboutFAQs, terms, privacy policy, contact support
Driver App Total: ~28 screens

📱 YARD OWNER APP
Auth Module (5 screens)
ScreenFunctionsSplashLogo, auto-login checkLoginPhone/email + passwordRegisterName, phone, email, SSN, passwordOTP Verification6-digit codeForgot PasswordReset flow
Yard Registration Module (8 screens)
ScreenFunctionsAdd Yard — Basic InfoYard name, phone, email, state, city, address (map pin)Zone SetupCreate zones (Zone A, Zone B...), name each, set slot count per zoneSlot ConfigurationAuto-generate or manually name slots (A-1, A-2...), set capacityPricing SetupPrice per zone (hourly/daily rates), different prices per zone allowedBooking RestrictionsBlock specific dates/times per zone or whole yardMedia UploadUpload photos + 360° panoramic view, previewChoose Registration PlanMonthly vs Yearly comparison card, price shownPayment & SubmitPay for yard plan, submit for admin approval, pending status screen
Yard Management Dashboard Module (6 screens)
ScreenFunctionsMy Yards ListAll yards with status badges (Active / Pending / Expired), switch between yardsYard DashboardOverview: total slots, booked %, available %, today's bookings count, revenue todayLive Slot MapReal-time visual grid — green=available, red=booked, grey=blocked, tap for detailsEdit YardUpdate info, zones, pricing, restrictions, mediaAdd/Remove SlotsModify slot count within zones (if access level permits)Manage RestrictionsUpdate blocked dates/times
Bookings & Drivers Module (3 screens)
ScreenFunctionsAll BookingsList with filters: date range, zone, status (active/upcoming/past)Booking DetailDriver info, vehicle details, slot, time, payment statusDriver Info ViewName, phone, vehicle, booking history at this yard
Earnings & Analytics Module (3 screens)
ScreenFunctionsEarnings DashboardTotal revenue card, line chart over time (week/month/year toggle)Earnings by YardRevenue breakdown per yard (if multiple)Earnings by ZoneZone-level breakdown, occupancy rates, peak hours heatmap
Subscription & Renewal Module (2 screens)
ScreenFunctionsMy PlanCurrent plan type, expiry date, auto-renew toggle, payment historyRenew/UpgradeRenew expired plan or switch monthly↔yearly, payment flow

When plan expires: yard hidden from drivers, owner gets warning notifications before expiry.

Notifications Module (1 screen)
ScreenFunctionsNotificationsNew bookings, cancellations, plan expiry reminders, admin approval updates
Profile & Settings Module (4 screens)
ScreenFunctionsProfilePersonal + business info, editPayment MethodsSaved cards, add newTransaction HistoryPlan payments, earnings payoutsSettingsNotifications, language, theme, help, terms