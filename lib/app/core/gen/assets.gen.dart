// dart format width=80

/// GENERATED CODE - DO NOT MODIFY BY HAND
/// *****************************************************
///  FlutterGen
/// *****************************************************

// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: deprecated_member_use,directives_ordering,implicit_dynamic_list_literal,unnecessary_import

import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart' as _svg;
import 'package:vector_graphics/vector_graphics.dart' as _vg;

class $AssetsImagesGen {
  const $AssetsImagesGen();

  /// File path: assets/images/Icon_logo.png
  AssetGenImage get iconLogo =>
      const AssetGenImage('assets/images/Icon_logo.png');

  /// File path: assets/images/Logo-full-grey.png
  AssetGenImage get logoFullGrey =>
      const AssetGenImage('assets/images/Logo-full-grey.png');

  /// File path: assets/images/bobtail.png
  AssetGenImage get bobtail => const AssetGenImage('assets/images/bobtail.png');

  /// File path: assets/images/cover_photo.png
  AssetGenImage get coverPhoto =>
      const AssetGenImage('assets/images/cover_photo.png');

  /// File path: assets/images/flipped_truck.png
  AssetGenImage get flippedTruck =>
      const AssetGenImage('assets/images/flipped_truck.png');

  /// File path: assets/images/horizontal_view_truck.png
  AssetGenImage get horizontalViewTruck =>
      const AssetGenImage('assets/images/horizontal_view_truck.png');

  /// File path: assets/images/trailer.png
  AssetGenImage get trailer => const AssetGenImage('assets/images/trailer.png');

  /// File path: assets/images/truck.png
  AssetGenImage get truck => const AssetGenImage('assets/images/truck.png');

  /// File path: assets/images/truck_driver.png
  AssetGenImage get truckDriver =>
      const AssetGenImage('assets/images/truck_driver.png');

  /// File path: assets/images/truck_placeholder.png
  AssetGenImage get truckPlaceholder =>
      const AssetGenImage('assets/images/truck_placeholder.png');

  /// List of all assets
  List<AssetGenImage> get values => [
    iconLogo,
    logoFullGrey,
    bobtail,
    coverPhoto,
    flippedTruck,
    horizontalViewTruck,
    trailer,
    truck,
    truckDriver,
    truckPlaceholder,
  ];
}

class $AssetsSvgsGen {
  const $AssetsSvgsGen();

  /// File path: assets/svgs/car.svg
  SvgGenImage get car => const SvgGenImage('assets/svgs/car.svg');

  /// File path: assets/svgs/nav_home.svg
  SvgGenImage get navHome => const SvgGenImage('assets/svgs/nav_home.svg');

  /// File path: assets/svgs/nav_map.svg
  SvgGenImage get navMap => const SvgGenImage('assets/svgs/nav_map.svg');

  /// File path: assets/svgs/nav_profile.svg
  SvgGenImage get navProfile =>
      const SvgGenImage('assets/svgs/nav_profile.svg');

  /// File path: assets/svgs/on_boarding1.svg
  SvgGenImage get onBoarding1 =>
      const SvgGenImage('assets/svgs/on_boarding1.svg');

  /// File path: assets/svgs/on_boarding2.svg
  SvgGenImage get onBoarding2 =>
      const SvgGenImage('assets/svgs/on_boarding2.svg');

  /// File path: assets/svgs/on_boarding3.svg
  SvgGenImage get onBoarding3 =>
      const SvgGenImage('assets/svgs/on_boarding3.svg');

  /// List of all assets
  List<SvgGenImage> get values => [
    car,
    navHome,
    navMap,
    navProfile,
    onBoarding1,
    onBoarding2,
    onBoarding3,
  ];
}

class Assets {
  const Assets._();

  static const $AssetsImagesGen images = $AssetsImagesGen();
  static const $AssetsSvgsGen svgs = $AssetsSvgsGen();
}

class AssetGenImage {
  const AssetGenImage(
    this._assetName, {
    this.size,
    this.flavors = const {},
    this.animation,
  });

  final String _assetName;

  final Size? size;
  final Set<String> flavors;
  final AssetGenImageAnimation? animation;

  Image image({
    Key? key,
    AssetBundle? bundle,
    ImageFrameBuilder? frameBuilder,
    ImageErrorWidgetBuilder? errorBuilder,
    String? semanticLabel,
    bool excludeFromSemantics = false,
    double? scale,
    double? width,
    double? height,
    Color? color,
    Animation<double>? opacity,
    BlendMode? colorBlendMode,
    BoxFit? fit,
    AlignmentGeometry alignment = Alignment.center,
    ImageRepeat repeat = ImageRepeat.noRepeat,
    Rect? centerSlice,
    bool matchTextDirection = false,
    bool gaplessPlayback = true,
    bool isAntiAlias = false,
    String? package,
    FilterQuality filterQuality = FilterQuality.medium,
    int? cacheWidth,
    int? cacheHeight,
  }) {
    return Image.asset(
      _assetName,
      key: key,
      bundle: bundle,
      frameBuilder: frameBuilder,
      errorBuilder: errorBuilder,
      semanticLabel: semanticLabel,
      excludeFromSemantics: excludeFromSemantics,
      scale: scale,
      width: width,
      height: height,
      color: color,
      opacity: opacity,
      colorBlendMode: colorBlendMode,
      fit: fit,
      alignment: alignment,
      repeat: repeat,
      centerSlice: centerSlice,
      matchTextDirection: matchTextDirection,
      gaplessPlayback: gaplessPlayback,
      isAntiAlias: isAntiAlias,
      package: package,
      filterQuality: filterQuality,
      cacheWidth: cacheWidth,
      cacheHeight: cacheHeight,
    );
  }

  ImageProvider provider({AssetBundle? bundle, String? package}) {
    return AssetImage(_assetName, bundle: bundle, package: package);
  }

  String get path => _assetName;

  String get keyName => _assetName;
}

class AssetGenImageAnimation {
  const AssetGenImageAnimation({
    required this.isAnimation,
    required this.duration,
    required this.frames,
  });

  final bool isAnimation;
  final Duration duration;
  final int frames;
}

class SvgGenImage {
  const SvgGenImage(this._assetName, {this.size, this.flavors = const {}})
    : _isVecFormat = false;

  const SvgGenImage.vec(this._assetName, {this.size, this.flavors = const {}})
    : _isVecFormat = true;

  final String _assetName;
  final Size? size;
  final Set<String> flavors;
  final bool _isVecFormat;

  _svg.SvgPicture svg({
    Key? key,
    bool matchTextDirection = false,
    AssetBundle? bundle,
    String? package,
    double? width,
    double? height,
    BoxFit fit = BoxFit.contain,
    AlignmentGeometry alignment = Alignment.center,
    bool allowDrawingOutsideViewBox = false,
    WidgetBuilder? placeholderBuilder,
    String? semanticsLabel,
    bool excludeFromSemantics = false,
    _svg.SvgTheme? theme,
    _svg.ColorMapper? colorMapper,
    ColorFilter? colorFilter,
    Clip clipBehavior = Clip.hardEdge,
    @deprecated Color? color,
    @deprecated BlendMode colorBlendMode = BlendMode.srcIn,
    @deprecated bool cacheColorFilter = false,
  }) {
    final _svg.BytesLoader loader;
    if (_isVecFormat) {
      loader = _vg.AssetBytesLoader(
        _assetName,
        assetBundle: bundle,
        packageName: package,
      );
    } else {
      loader = _svg.SvgAssetLoader(
        _assetName,
        assetBundle: bundle,
        packageName: package,
        theme: theme,
        colorMapper: colorMapper,
      );
    }
    return _svg.SvgPicture(
      loader,
      key: key,
      matchTextDirection: matchTextDirection,
      width: width,
      height: height,
      fit: fit,
      alignment: alignment,
      allowDrawingOutsideViewBox: allowDrawingOutsideViewBox,
      placeholderBuilder: placeholderBuilder,
      semanticsLabel: semanticsLabel,
      excludeFromSemantics: excludeFromSemantics,
      colorFilter:
          colorFilter ??
          (color == null ? null : ColorFilter.mode(color, colorBlendMode)),
      clipBehavior: clipBehavior,
      cacheColorFilter: cacheColorFilter,
    );
  }

  String get path => _assetName;

  String get keyName => _assetName;
}
