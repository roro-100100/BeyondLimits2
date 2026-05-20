import 'dart:ui';
import 'package:flutter/material.dart';

import 'beyond_theme.dart';
import 'character_selection_page.dart';
import 'letters_path_page.dart';
import 'words_path_page.dart';

class SpaceHubPage extends StatefulWidget {
  final String childName;
  final String praiseWord;
  final String characterImage;
  final int totalStars;

  const SpaceHubPage({
    super.key,
    required this.childName,
    required this.praiseWord,
    required this.characterImage,
    required this.totalStars,
  });

  @override
  State<SpaceHubPage> createState() => _SpaceHubPageState();
}

class _SpaceHubPageState extends State<SpaceHubPage>
    with SingleTickerProviderStateMixin {
  late final AnimationController _move;

  late int currentStars;

  @override
  void initState() {
    super.initState();

    currentStars = widget.totalStars;

    _move = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _move.dispose();
    super.dispose();
  }

  void _soon() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: BeyondTheme.purple,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        content: const Text(
          'Coming Soon ✨',
          textAlign: TextAlign.center,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  Future<void> _openLettersPlanet() async {
    final result = await Navigator.push<int>(
      context,
      MaterialPageRoute(
        builder: (_) => LettersPathPage(
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

  Future<void> _openWordsPlanet() async {
    final result = await Navigator.push<int>(
      context,
      MaterialPageRoute(
        builder: (_) => WordsPathPage(
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
        animation: _move,
        builder: (context, _) {
          final float = (_move.value - 0.5) * 18;

          return Stack(
            children: [
              Positioned.fill(
                child: Image.asset('assets/images/AA.png', fit: BoxFit.cover),
              ),

              Positioned.fill(
                child: Container(color: Colors.black.withOpacity(0.22)),
              ),

              Positioned.fill(child: CustomPaint(painter: _StarPathPainter())),

              SafeArea(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 48,
                    vertical: 20,
                  ),
                  child: Stack(
                    children: [
                      _BackButtonHub(
                        onTap: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const CharacterSelectionPage(),
                            ),
                          );
                        },
                      ),

                      Positioned(
                        top: 0,
                        right: 0,
                        child: _StarsBox(stars: currentStars),
                      ),

                      Align(
                        alignment: Alignment.topCenter,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'Welcome ${widget.childName}',
                              style: BeyondTheme.title(size: 32),
                            ),

                            const SizedBox(height: 4),

                            Text(
                              'Choose Your Learning Planet',
                              style: BeyondTheme.normalText(
                                size: 18,
                                color: Colors.white.withOpacity(0.85),
                              ),
                            ),
                          ],
                        ),
                      ),

                      Positioned(
                        left: 35,
                        bottom: 35 + float,
                        child: Image.asset(
                          widget.characterImage,
                          width: 170,
                          fit: BoxFit.contain,
                        ),
                      ),

                      Positioned(
                        left: 260,
                        top: 105 + float,
                        child: _PlanetButton(
                          imagePath: 'assets/images/ABC.png',
                          title: 'Letters Planet',
                          active: true,
                          borderColor: BeyondTheme.cyan,
                          onTap: _openLettersPlanet,
                        ),
                      ),

                      Positioned(
                        right: 333,
                        top: 150 - float,
                        child: _PlanetButton(
                          imagePath: 'assets/images/WORLD.png',
                          title: 'Words Planet',
                          active: true,
                          borderColor: BeyondTheme.pink,
                          onTap: _openWordsPlanet,
                        ),
                      ),

                      Positioned(
                        left: 480,
                        bottom: 111 - float,
                        child: _PlanetButton(
                          imagePath: 'assets/images/book.png',
                          title: 'Stories Planet',
                          active: false,
                          borderColor: BeyondTheme.violet,
                          onTap: _soon,
                        ),
                      ),

                      Positioned(
                        right: 160,
                        bottom: 45 + float,
                        child: _PlanetButton(
                          imagePath: 'assets/images/Win.png',
                          title: 'Challenges Planet',
                          active: false,
                          borderColor: BeyondTheme.orange,
                          onTap: _soon,
                        ),
                      ),

                      Positioned(
                        bottom: 8,
                        left: 0,
                        right: 0,
                        child: Text(
                          'Planet World',
                          textAlign: TextAlign.center,
                          style: BeyondTheme.normalText(
                            size: 16,
                            color: Colors.white.withOpacity(0.75),
                          ),
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

class _PlanetButton extends StatefulWidget {
  final String imagePath;
  final String title;
  final bool active;
  final Color borderColor;
  final VoidCallback onTap;

  const _PlanetButton({
    required this.imagePath,
    required this.title,
    required this.active,
    required this.borderColor,
    required this.onTap,
  });

  @override
  State<_PlanetButton> createState() => _PlanetButtonState();
}

class _PlanetButtonState extends State<_PlanetButton> {
  bool hover = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => hover = true),
      onExit: (_) => setState(() => hover = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedScale(
          scale: hover ? 1.08 : 1,
          duration: const Duration(milliseconds: 220),
          curve: Curves.easeOutBack,
          child: SizedBox(
            width: 250,
            height: 250,
            child: Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  width: 210,
                  height: 210,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: widget.borderColor.withOpacity(0.65),
                        blurRadius: 45,
                        spreadRadius: 8,
                      ),
                    ],
                  ),
                ),

                Image.asset(widget.imagePath, width: 230, fit: BoxFit.contain),

                Positioned(
                  bottom: 12,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 18,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: BeyondTheme.bgDark.withOpacity(0.55),
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(color: widget.borderColor, width: 1.5),
                    ),
                    child: Text(
                      widget.title,
                      style: BeyondTheme.cardTitle(size: 20),
                    ),
                  ),
                ),

                if (!widget.active)
                  Positioned(
                    top: 28,
                    right: 28,
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.45),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.lock_rounded,
                        color: Colors.white,
                        size: 24,
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

class _StarPathPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final pathPaint = Paint()
      ..color = BeyondTheme.yellow.withOpacity(0.75)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4
      ..strokeCap = StrokeCap.round;

    final path = Path()
      ..moveTo(size.width * 0.17, size.height * 0.42)
      ..cubicTo(
        size.width * 0.34,
        size.height * 0.26,
        size.width * 0.48,
        size.height * 0.30,
        size.width * 0.60,
        size.height * 0.40,
      )
      ..cubicTo(
        size.width * 0.73,
        size.height * 0.52,
        size.width * 0.62,
        size.height * 0.78,
        size.width * 0.46,
        size.height * 0.70,
      )
      ..cubicTo(
        size.width * 0.63,
        size.height * 0.92,
        size.width * 0.78,
        size.height * 0.70,
        size.width * 0.88,
        size.height * 0.77,
      );

    canvas.drawPath(path, pathPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}

class _StarsBox extends StatelessWidget {
  final int stars;

  const _StarsBox({required this.stars});

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
            children: [
              const Text('⭐', style: TextStyle(fontSize: 24)),

              const SizedBox(width: 8),

              Text('$stars', style: BeyondTheme.normalText(size: 18)),
            ],
          ),
        ),
      ),
    );
  }
}

class _BackButtonHub extends StatelessWidget {
  final VoidCallback onTap;

  const _BackButtonHub({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return ClipOval(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
        child: InkWell(
          onTap: onTap,
          child: Container(
            width: 54,
            height: 54,
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
              Icons.arrow_back_rounded,
              color: Colors.white,
              size: 28,
            ),
          ),
        ),
      ),
    );
  }
}
