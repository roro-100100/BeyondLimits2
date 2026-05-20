import 'dart:ui';
import 'package:flutter/material.dart';

import 'beyond_theme.dart';
import 'letters_game_page.dart';
import 'space_hub_page.dart';

class LettersPathPage extends StatefulWidget {
  final String childName;
  final String praiseWord;
  final String characterImage;
  final int totalStars;

  const LettersPathPage({
    super.key,
    required this.childName,
    required this.praiseWord,
    required this.characterImage,
    required this.totalStars,
  });

  @override
  State<LettersPathPage> createState() => _LettersPathPageState();
}

class _LettersPathPageState extends State<LettersPathPage>
    with SingleTickerProviderStateMixin {
  late final AnimationController _floatController;

  final int unlockedLevel = 1;

  late int currentStars;

  @override
  void initState() {
    super.initState();

    currentStars = widget.totalStars;

    _floatController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1900),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _floatController.dispose();
    super.dispose();
  }

  void _goHome() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => SpaceHubPage(
          childName: widget.childName,
          praiseWord: widget.praiseWord,
          characterImage: widget.characterImage,
          totalStars: currentStars,
        ),
      ),
    );
  }

  void _lockedMessage() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: BeyondTheme.purple,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        content: const Text(
          'Finish the previous level first ✨',
          textAlign: TextAlign.center,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  Future<void> _openLevelOne() async {
    final result = await Navigator.push<int>(
      context,
      MaterialPageRoute(
        builder: (_) => LettersGamePage(
          childName: widget.childName,
          praiseWord: widget.praiseWord,
          characterImage: widget.characterImage,
          totalStars: currentStars,
        ),
      ),
    );

    if (result != null && mounted) {
      setState(() {
        currentStars = result;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: BeyondTheme.bgDark,
      body: AnimatedBuilder(
        animation: _floatController,
        builder: (context, _) {
          final float = (_floatController.value - 0.5) * 18;

          return Stack(
            children: [
              Positioned.fill(
                child: Image.asset('assets/images/AA.png', fit: BoxFit.cover),
              ),

              Positioned.fill(
                child: Container(color: Colors.black.withOpacity(0.24)),
              ),

              Positioned.fill(
                child: CustomPaint(painter: _TuwaiqSpacePathPainter()),
              ),

              SafeArea(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 44,
                    vertical: 20,
                  ),
                  child: Stack(
                    children: [
                      _HomeButton(onTap: _goHome),

                      Positioned(
                        top: 0,
                        right: 0,
                        child: _StarsBadge(totalStars: currentStars),
                      ),

                      Align(
                        alignment: Alignment.topCenter,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'Letters Planet Path',
                              style: BeyondTheme.title(size: 34),
                            ),

                            const SizedBox(height: 8),

                            Text(
                              'Climb from Tuwaiq Mountain to space 🚀',
                              textAlign: TextAlign.center,
                              style: BeyondTheme.normalText(
                                size: 18,
                                color: Colors.white.withOpacity(0.82),
                              ),
                            ),
                          ],
                        ),
                      ),

                      Positioned(
                        left: 18,
                        bottom: 38 + float,
                        child: Image.asset(
                          widget.characterImage,
                          width: 165,
                          fit: BoxFit.contain,
                        ),
                      ),

                      Positioned(
                        left: 135,
                        bottom: 95 + float,
                        child: _LevelStar(
                          number: 1,
                          unlocked: unlockedLevel >= 1,
                          glow: BeyondTheme.yellow,
                          onTap: _openLevelOne,
                        ),
                      ),

                      Positioned(
                        left: 345,
                        top: 205 - float,
                        child: _LevelStar(
                          number: 2,
                          unlocked: unlockedLevel >= 2,
                          glow: BeyondTheme.cyan,
                          onTap: _lockedMessage,
                        ),
                      ),

                      Positioned(
                        right: 750,
                        top: 350 + float,
                        child: _LevelStar(
                          number: 3,
                          unlocked: unlockedLevel >= 3,
                          glow: BeyondTheme.pink,
                          onTap: _lockedMessage,
                        ),
                      ),

                      Positioned(
                        right: 160,
                        top: 330 - float,
                        child: _LevelStar(
                          number: 4,
                          unlocked: unlockedLevel >= 4,
                          glow: BeyondTheme.orange,
                          onTap: _lockedMessage,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _LevelStar extends StatefulWidget {
  final int number;
  final bool unlocked;
  final Color glow;
  final VoidCallback onTap;

  const _LevelStar({
    required this.number,
    required this.unlocked,
    required this.glow,
    required this.onTap,
  });

  @override
  State<_LevelStar> createState() => _LevelStarState();
}

class _LevelStarState extends State<_LevelStar> {
  bool hover = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => hover = true),
      onExit: (_) => setState(() => hover = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedScale(
          scale: hover ? 1.12 : 1,
          duration: const Duration(milliseconds: 220),
          curve: Curves.easeOutBack,
          child: SizedBox(
            width: 160,
            height: 160,
            child: Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  width: 110,
                  height: 110,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: widget.glow.withOpacity(0.55),
                        blurRadius: 38,
                        spreadRadius: 10,
                      ),
                    ],
                  ),
                ),

                Text(
                  widget.unlocked ? '⭐' : '🔒',
                  style: TextStyle(
                    fontSize: 92,
                    shadows: [Shadow(color: widget.glow, blurRadius: 24)],
                  ),
                ),

                Positioned(
                  bottom: 12,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: BeyondTheme.bgDark.withOpacity(0.55),
                      borderRadius: BorderRadius.circular(22),
                      border: Border.all(color: widget.glow, width: 1.5),
                    ),
                    child: Text(
                      'Level ${widget.number}',
                      style: BeyondTheme.normalText(size: 15),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _StarsBadge extends StatelessWidget {
  final int totalStars;

  const _StarsBadge({required this.totalStars});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(22),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
          decoration: BeyondTheme.mirrorNeonPanel(
            borderColor: BeyondTheme.yellow,
            radius: 22,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('⭐', style: TextStyle(fontSize: 24)),

              const SizedBox(width: 8),

              Text('$totalStars', style: BeyondTheme.normalText(size: 18)),
            ],
          ),
        ),
      ),
    );
  }
}

class _TuwaiqSpacePathPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final glowPaint = Paint()
      ..color = BeyondTheme.cyan.withOpacity(0.22)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 18
      ..strokeCap = StrokeCap.round;

    final pathPaint = Paint()
      ..color = BeyondTheme.yellow.withOpacity(0.90)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4.5
      ..strokeCap = StrokeCap.round;

    final path = Path()
      ..moveTo(size.width * 0.18, size.height * 0.72)
      ..cubicTo(
        size.width * 0.28,
        size.height * 0.55,
        size.width * 0.20,
        size.height * 0.38,
        size.width * 0.40,
        size.height * 0.31,
      )
      ..cubicTo(
        size.width * 0.56,
        size.height * 0.25,
        size.width * 0.64,
        size.height * 0.45,
        size.width * 0.54,
        size.height * 0.55,
      )
      ..cubicTo(
        size.width * 0.42,
        size.height * 0.69,
        size.width * 0.65,
        size.height * 0.76,
        size.width * 0.79,
        size.height * 0.58,
      );

    canvas.drawPath(path, glowPaint);
    canvas.drawPath(path, pathPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}

class _HomeButton extends StatelessWidget {
  final VoidCallback onTap;

  const _HomeButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return ClipOval(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
        child: InkWell(
          onTap: onTap,
          child: Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: BeyondTheme.cyan, width: 2),
              color: Colors.white.withOpacity(0.10),
              boxShadow: [
                BoxShadow(
                  color: BeyondTheme.cyan.withOpacity(0.35),
                  blurRadius: 18,
                ),
              ],
            ),
            child: const Icon(
              Icons.home_rounded,
              color: Colors.white,
              size: 30,
            ),
          ),
        ),
      ),
    );
  }
}
