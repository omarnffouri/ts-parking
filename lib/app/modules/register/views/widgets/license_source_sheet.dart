import 'package:flutter/material.dart';
import 'package:ts_parking/app/core/utils/color_extensions.dart';
import 'package:ts_parking/app/core/utils/theme_extensions.dart';

void showLicenseSourceSheet({
  required BuildContext context,
  required Future<void> Function() onCameraTap,
  required Future<void> Function() onGalleryTap,
  required Future<void> Function() onFileTap,
}) {
  final isDark = context.isDark;
  final surfaceColor = isDark ? const Color(0xFF1E1E1E) : Colors.white;

  showModalBottomSheet<void>(
    context: context,
    backgroundColor: Colors.transparent,
    isScrollControlled: true,
    builder: (sheetContext) {
      Future<void> selectSource(Future<void> Function() onTap) async {
        Navigator.of(sheetContext).pop();
        await onTap();
      }

      return Container(
        decoration: BoxDecoration(
          color: surfaceColor,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
        ),
        child: SafeArea(
          top: false,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: context.secondaryTextColor.withValues(alpha: 0.25),
                    borderRadius: BorderRadius.circular(999),
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  'Company license',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: context.primaryTextColor,
                  ),
                ),
                const SizedBox(height: 8),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: const Icon(Icons.photo_camera_outlined),
                  title: const Text('Camera'),
                  onTap: () => selectSource(onCameraTap),
                ),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: const Icon(Icons.photo_library_outlined),
                  title: const Text('Gallery'),
                  onTap: () => selectSource(onGalleryTap),
                ),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: const Icon(Icons.folder_open_outlined),
                  title: const Text('Files'),
                  onTap: () => selectSource(onFileTap),
                ),
              ],
            ),
          ),
        ),
      );
    },
  );
}
