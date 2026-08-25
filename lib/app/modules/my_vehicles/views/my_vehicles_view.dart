import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ts_parking/app/core/utils/color_extensions.dart';
import 'package:ts_parking/app/core/utils/theme_extensions.dart';
import 'package:ts_parking/app/core/widgets/empty_state.dart';
import 'package:ts_parking/app/core/widgets/loading_widget.dart';

import '../../../theme/app_colors.dart';
import '../../../theme/app_spacing.dart';
import 'widgets/header_chips.dart';
import 'widgets/page_header.dart';
import 'widgets/vehicle_board.dart';
import 'widgets/vehicle_details_bottom_sheet.dart';
import 'widgets/vehicle_list.dart';
import '../controllers/my_vehicles_controller.dart';

const double _roadWidth = 34;

class MyVehiclesView extends GetView<MyVehiclesController> {
  const MyVehiclesView({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;

    return Scaffold(
      backgroundColor: isDark ? AppColors.primaryDark : AppColors.primary,
      floatingActionButton: controller.isClient
          ? FloatingActionButton(
              onPressed: controller.navigateToAddVehicle,
              backgroundColor: Theme.of(context).colorScheme.primary,
              foregroundColor: Colors.white,
              child: const Icon(Icons.add),
            )
          : null,
      body: SafeArea(
        bottom: false,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(34),
          child: Container(
            width: double.infinity,
            color: context.backgroundColor,
            child: Obx(() {
              final vehicles = controller.vehicles;
              final isListView = controller.isListView;

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(
                      10,
                      AppSpacing.lg,
                      AppSpacing.lg,
                      0,
                    ),
                    child: const PageHeader(),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(
                      AppSpacing.lg,
                      AppSpacing.lg,
                      AppSpacing.lg,
                      AppSpacing.md,
                    ),
                    child: HeaderChips(
                      vehicleCount: vehicles.length,
                      isListView: isListView,
                      onToggleView: controller.toggleViewMode,
                    ),
                  ),
                  Expanded(
                    child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 260),
                      switchInCurve: Curves.easeOutCubic,
                      switchOutCurve: Curves.easeInCubic,
                      transitionBuilder: (child, animation) => FadeTransition(
                        opacity: animation,
                        child: SlideTransition(
                          position: Tween<Offset>(
                            begin: const Offset(0, 0.03),
                            end: Offset.zero,
                          ).animate(animation),
                          child: child,
                        ),
                      ),
                      child: () {
                        if (controller.isLoading) {
                          return const Center(
                            key: ValueKey('loading'),
                            child: LoadingWidget(size: 40),
                          );
                        }

                        if (vehicles.isEmpty) {
                          return const EmptyState(
                            key: ValueKey('empty'),
                            icon: Icons.directions_car_outlined,
                            title: 'No vehicles yet',
                            message: 'Your saved vehicles will appear here.',
                          );
                        }

                        if (isListView) {
                          return VehicleList(key: const ValueKey('list'));
                        }

                        return VehicleBoard(
                          key: const ValueKey('board'),
                          onTap: (vehicle) =>
                              showVehicleDetailsBottomSheet(context, vehicle),
                          roadWidth: _roadWidth,
                        );
                      }(),
                    ),
                  ),
                ],
              );
            }),
          ),
        ),
      ),
    );
  }
}
