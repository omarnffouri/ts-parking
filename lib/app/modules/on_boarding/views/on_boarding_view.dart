import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ts_parking/app/core/gen/assets.gen.dart';

import '../../../theme/app_colors.dart';
import '../controllers/on_boarding_controller.dart';

class OnBoardingView extends GetView<OnBoardingController> {
  const OnBoardingView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.secondaryDark,
      body: Stack(
        children: [
          PageView.builder(
            controller: controller.pageController,
            onPageChanged: controller.onPageChanged,
            itemCount: controller.pages.length,
            itemBuilder: (context, index) {
              final page = controller.pages[index];

              return Obx(
                () => _OnBoardingPage(
                  page: page,
                  active: controller.currentPage == index,
                  onNext: controller.nextPage,
                  controller: controller,
                ),
              );
            },
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 22,
            child: Obx(
              () => Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  controller.pages.length,
                  (index) => Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: _PagerDot(active: controller.currentPage == index),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _OnBoardingPage extends StatefulWidget {
  final OnBoardingPageData page;
  final bool active;
  final VoidCallback onNext;
  final OnBoardingController controller;

  const _OnBoardingPage({
    required this.page,
    required this.active,
    required this.onNext,
    required this.controller,
  });

  @override
  State<_OnBoardingPage> createState() => _OnBoardingPageState();
}

class _OnBoardingPageState extends State<_OnBoardingPage>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _scaleAnim;
  late final Animation<Offset> _logoOffset;
  late final Animation<double> _logoFade;
  late final Animation<Offset> _headlineOffset;
  late final Animation<double> _headlineFade;
  late final Animation<Offset> _ctaOffset;
  late final Animation<double> _ctaFade;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    _scaleAnim = Tween<double>(
      begin: 0.98,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    _logoOffset = Tween<Offset>(begin: const Offset(0, -0.30), end: Offset.zero)
        .animate(
          CurvedAnimation(
            parent: _controller,
            curve: const Interval(0.0, 0.25, curve: Curves.easeOut),
          ),
        );
    _logoFade = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.25, curve: Curves.easeIn),
      ),
    );

    _headlineOffset =
        Tween<Offset>(begin: const Offset(0, -0.40), end: Offset.zero).animate(
          CurvedAnimation(
            parent: _controller,
            curve: const Interval(0.15, 0.55, curve: Curves.easeOut),
          ),
        );
    _headlineFade = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.15, 0.55, curve: Curves.easeIn),
      ),
    );

    _ctaOffset = Tween<Offset>(begin: const Offset(0, -0.35), end: Offset.zero)
        .animate(
          CurvedAnimation(
            parent: _controller,
            curve: const Interval(0.45, 1.0, curve: Curves.elasticOut),
          ),
        );
    _ctaFade = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.45, 1.0, curve: Curves.easeIn),
      ),
    );

    if (widget.active) {
      _controller.forward();
    }
  }

  @override
  void didUpdateWidget(covariant _OnBoardingPage oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (!oldWidget.active && widget.active) {
      _controller.forward(from: 0);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context);
    final height = mq.size.height;
    final width = mq.size.width;
    final logoSize = (height * 0.07).clamp(44.0, 78.0).toDouble();
    final ctaHeight = (height * 0.085).clamp(52.0, 80.0).toDouble();

    return ScaleTransition(
      scale: _scaleAnim,
      child: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(widget.page.imageAsset, fit: BoxFit.cover),
          ),
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    AppColors.darkBackground.withValues(alpha: 0.94),
                    AppColors.secondaryDark.withValues(alpha: 0.78),
                    AppColors.secondaryDark.withValues(alpha: 0.58),
                  ],
                  stops: const [0.0, 0.55, 1.0],
                ),
              ),
            ),
          ),
          SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: width * 0.06),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: height * 0.09),
                  SlideTransition(
                    position: _logoOffset,
                    child: FadeTransition(
                      opacity: _logoFade,
                      child: Image.asset(
                        Assets.images.iconLogo.path,
                        color: AppColors.primary,
                        height: logoSize,
                      ),
                    ),
                  ),
                  SizedBox(height: height * 0.02),
                  SlideTransition(
                    position: _headlineOffset,
                    child: FadeTransition(
                      opacity: _headlineFade,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.page.title,
                            style: const TextStyle(
                              fontSize: 45,
                              color: AppColors.primary,
                              fontWeight: FontWeight.w800,
                              height: 1.08,
                            ),
                          ),
                          const SizedBox(height: 14),
                          ConstrainedBox(
                            constraints: BoxConstraints(maxWidth: width * 0.84),
                            child: Text(
                              widget.page.description,
                              style: TextStyle(
                                color: Colors.white.withValues(alpha: 0.84),
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                height: 1.45,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const Spacer(),
                  SlideTransition(
                    position: _ctaOffset,
                    child: FadeTransition(
                      opacity: _ctaFade,
                      child: SizedBox(
                        width: width * 0.86,
                        height: 60,
                        child: ElevatedButton(
                          onPressed: widget.onNext,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary.withValues(
                              alpha: 0.8,
                            ),
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                ctaHeight / 2,
                              ),
                            ),
                          ),
                          child: Text(
                            widget.controller.currentPage <
                                    widget.controller.pages.length - 1
                                ? 'Next'
                                : 'Start',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                              fontSize: 18,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: height * 0.03),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _PagerDot extends StatelessWidget {
  final bool active;

  const _PagerDot({required this.active});

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      width: active ? 22 : 8,
      height: 8,
      decoration: BoxDecoration(
        color: active ? AppColors.primary : Colors.white24,
        borderRadius: BorderRadius.circular(8),
      ),
    );
  }
}
