import 'package:flutter/material.dart';
import 'language_selection_page.dart';
import 'beyond_theme.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1700),
    )..repeat(reverse: true);
  }

  void _goNext() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const LanguageSelectionPage()),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  TextStyle _tapStyle(double size, double opacity) {
    return BeyondTheme.normalText(
      size: size,
      color: Colors.white.withOpacity(opacity),
    ).copyWith(
      height: 1.25,
      shadows: const [Shadow(color: Colors.cyanAccent, blurRadius: 18)],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: BeyondTheme.bgDark,
      body: InkWell(
        onTap: _goNext,
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            final glow = 0.35 + (_controller.value * 0.25);

            return Stack(
              fit: StackFit.expand,
              children: [
                Image.asset('assets/images/AA.png', fit: BoxFit.cover),

                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.black.withOpacity(0.10),
                        BeyondTheme.bgDark.withOpacity(0.45),
                        Colors.black.withOpacity(0.70),
                      ],
                    ),
                  ),
                ),

                Positioned.fill(
                  child: IgnorePointer(
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: RadialGradient(
                          center: const Alignment(0, -0.08),
                          radius: 0.72,
                          colors: [
                            BeyondTheme.cyan.withOpacity(glow),
                            BeyondTheme.purple.withOpacity(glow * 0.7),
                            Colors.transparent,
                          ],
                          stops: const [0.0, 0.42, 1.0],
                        ),
                      ),
                    ),
                  ),
                ),

                Center(
                  child: Transform.scale(
                    scale: 0.97 + (_controller.value * 0.03),
                    child: Container(
                      padding: const EdgeInsets.all(30),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: BeyondTheme.cyan.withOpacity(glow),
                            blurRadius: 90,
                            spreadRadius: 18,
                          ),
                          BoxShadow(
                            color: BeyondTheme.purple.withOpacity(glow),
                            blurRadius: 140,
                            spreadRadius: 38,
                          ),
                        ],
                      ),
                      child: Image.asset(
                        'assets/images/AAA.png',
                        width: 430,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                ),

                Positioned(
                  bottom: 112,
                  left: 0,
                  right: 0,
                  child: _Dots(color: BeyondTheme.cyan),
                ),

                Positioned(
                  bottom: 36,
                  left: 0,
                  right: 0,
                  child: Center(
                    child: Opacity(
                      opacity: 0.88,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: 420,
                            child: Text(
                              'اضغط في أي مكان للانطلاق',
                              textAlign: TextAlign.center,
                              textDirection: TextDirection.rtl,
                              style: _tapStyle(22, 0.95),
                            ),
                          ),

                          const SizedBox(height: 7),

                          SizedBox(
                            width: 420,
                            child: Text(
                              'Tap anywhere to start',
                              textAlign: TextAlign.center,
                              textDirection: TextDirection.ltr,
                              style: _tapStyle(17, 0.78),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _Dots extends StatefulWidget {
  final Color color;

  const _Dots({required this.color});

  @override
  State<_Dots> createState() => _DotsState();
}

class _DotsState extends State<_Dots> with SingleTickerProviderStateMixin {
  late AnimationController _dotsController;

  @override
  void initState() {
    super.initState();

    _dotsController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 950),
    )..repeat();
  }

  @override
  void dispose() {
    _dotsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _dotsController,
      builder: (context, child) {
        final active = (_dotsController.value * 3).floor() % 3;

        Widget dot(bool on) {
          return AnimatedContainer(
            duration: const Duration(milliseconds: 220),
            width: 9,
            height: 9,
            margin: const EdgeInsets.symmetric(horizontal: 5),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: widget.color.withOpacity(on ? 1 : 0.20),
              boxShadow: on
                  ? [
                      BoxShadow(
                        color: widget.color.withOpacity(0.95),
                        blurRadius: 18,
                        spreadRadius: 3,
                      ),
                    ]
                  : [],
            ),
          );
        }

        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [dot(active == 0), dot(active == 1), dot(active == 2)],
        );
      },
    );
  }
}
