import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

import '../../../app/theme/app_radius.dart';
import '../../../app/theme/app_spacing.dart';

enum FileViewerType { pdf, image }

class FileViewerPage extends StatelessWidget {
  final String url;
  final String title;
  final Map<String, String>? headers;
  final FileViewerType type;

  const FileViewerPage({
    super.key,
    required this.url,
    required this.title,
    this.headers,
    this.type = FileViewerType.pdf,
  });

  factory FileViewerPage.fromUrl({
    Key? key,
    required String url,
    required String title,
    Map<String, String>? headers,
  }) {
    final path = Uri.tryParse(url)?.path.toLowerCase() ?? url.toLowerCase();
    final isImage =
        path.endsWith('.png') ||
        path.endsWith('.jpg') ||
        path.endsWith('.jpeg') ||
        path.endsWith('.gif') ||
        path.endsWith('.webp');

    return FileViewerPage(
      key: key,
      url: url,
      title: title,
      headers: headers,
      type: isImage ? FileViewerType.image : FileViewerType.pdf,
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.primary,
      body: Column(
        children: [
          SafeArea(
            bottom: false,
            child: Padding(
              padding: EdgeInsets.fromLTRB(
                AppSpacing.screenHorizontal,
                AppSpacing.md,
                AppSpacing.screenHorizontal,
                AppSpacing.md,
              ),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.white),
                    onPressed: Get.back,
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                  SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: Text(
                      title,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: ClipRRect(
              borderRadius: AppRadius.xlargeTopRadius,
              child: ColoredBox(
                color: colorScheme.surface,
                child: switch (type) {
                  FileViewerType.pdf => SfPdfViewer.network(
                    url,
                    headers: headers ?? const {},
                  ),
                  FileViewerType.image => InteractiveViewer(
                    minScale: 0.5,
                    maxScale: 4.0,
                    child: Center(
                      child: Image.network(
                        url,
                        headers: headers,
                        fit: BoxFit.contain,
                        loadingBuilder: (context, child, progress) {
                          if (progress == null) return child;
                          return Center(
                            child: CircularProgressIndicator(
                              value: progress.expectedTotalBytes != null
                                  ? progress.cumulativeBytesLoaded /
                                        progress.expectedTotalBytes!
                                  : null,
                              color: colorScheme.primary,
                            ),
                          );
                        },
                        errorBuilder: (context, error, stack) =>
                            SizedBox.expand(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.broken_image_rounded,
                                    size: 64,
                                    color: colorScheme.onSurface.withValues(
                                      alpha: 0.4,
                                    ),
                                  ),
                                  SizedBox(height: AppSpacing.sm),
                                  Text(
                                    'Failed to load image',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium
                                        ?.copyWith(
                                          color: Theme.of(context).hintColor,
                                        ),
                                  ),
                                ],
                              ),
                            ),
                      ),
                    ),
                  ),
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
