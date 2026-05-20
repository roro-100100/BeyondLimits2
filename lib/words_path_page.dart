import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';

import 'beyond_theme.dart';
import 'words_game_page.dart';
import 'game_words_stage2.dart';
import 'space_dictionary_page.dart';

class WordsPathPage extends StatefulWidget {
  final String childName;
  final String praiseWord;
  final String characterImage;
  final int totalStars;

  const WordsPathPage({
    super.key,
    required this.childName,
    required this.praiseWord,
    required this.characterImage,
    required this.totalStars,
  });

  @override
  State<WordsPathPage> createState() => _WordsPathPageState();
}

class _WordsPathPageState extends State<WordsPathPage>
    with SingleTickerProviderStateMixin {
  late final AnimationController _floatController;

  final AudioPlayer _effectPlayer = AudioPlayer();

  final int unlockedLevel = 2;

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

  Future<void> _playEffect(String path) async {
    try {
      await _effectPlayer.stop();
      await _effectPlayer.play(AssetSource(path));
    } catch (_) {}
  }

  @override
  void dispose() {
    _floatController.dispose();
    _effectPlayer.dispose();
    super.dispose();
  }

  void _lockedMessage() {
    _playEffect('audio/effects/wrong_soft.mp3');

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
    await _playEffect('audio/effects/magic_star.mp3');

    final result = await Navigator.push<int>(
      context,
      MaterialPageRoute(
        builder: (_) => WordsGamePage(
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

  Future<void> _openLevelTwo() async {
    await _playEffect('audio/effects/magic_star.mp3');

    final result = await Navigator.push<int>(
      context,
      MaterialPageRoute(
        builder: (_) => GameWordsStage2(
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

  void _openDictionary() async {
    await _playEffect('audio/effects/magic_star.mp3');

    if (!mounted) return;

    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const SpaceDictionaryPage()),
    );
  }

  void _goHome() async {
    await _playEffect('audio/effects/correct.mp3');

    if (mounted) {
      Navigator.pop(context, currentStars);
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
                child: CustomPaint(painter: _WordsSpacePathPainter()),
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
                        child: Row(
                          children: [
                            _DictionaryButton(onTap: _openDictionary),
                            const SizedBox(width: 12),
                            _StarsBadge(totalStars: currentStars),
                          ],
                        ),
                      ),

                      Align(
                        alignment: Alignment.topCenter,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'Words Planet Path',
                              textAlign: TextAlign.center,
                              style: BeyondTheme.title(size: 34),
                            ),

                            const SizedBox(height: 8),

                            Text(
                              'Let’s start the words adventure 🚀',
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
                        left: 150,
                        bottom: 100 + float,
                        child: _LevelStar(
                          number: 1,
                          unlocked: unlockedLevel >= 1,
                          glow: BeyondTheme.pink,
                          onTap: _openLevelOne,
                        ),
                      ),

                      Positioned(
                        left: 390,
                        top: 210 - float,
                        child: _LevelStar(
                          number: 2,
                          unlocked: unlockedLevel >= 2,
                          glow: BeyondTheme.cyan,
                          onTap: _openLevelTwo,
                        ),
                      ),

                      Positioned(
                        right: 680,
                        top: 350 + float,
                        child: _LevelStar(
                          number: 3,
                          unlocked: unlockedLevel >= 3,
                          glow: BeyondTheme.violet,
                          onTap: _lockedMessage,
                        ),
                      ),

                      Positioned(
                        right: 150,
                        top: 340 - float,
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

class _DictionaryButton extends StatelessWidget {
  final VoidCallback onTap;

  const _DictionaryButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(22),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
        child: InkWell(
          borderRadius: BorderRadius.circular(22),
          onTap: onTap,
          child: Container(
            height: 54,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BeyondTheme.mirrorNeonPanel(
              borderColor: BeyondTheme.cyan,
              radius: 22,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.menu_book_rounded,
                  color: Colors.white,
                  size: 25,
                ),
                const SizedBox(width: 8),
                Text('Dictionary', style: BeyondTheme.normalText(size: 15)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _WordsSpacePathPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final glowPaint = Paint()
      ..color = BeyondTheme.pink.withOpacity(0.22)
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
        size.width * 0.30,
        size.height * 0.56,
        size.width * 0.25,
        size.height * 0.35,
        size.width * 0.44,
        size.height * 0.34,
      )
      ..cubicTo(
        size.width * 0.60,
        size.height * 0.33,
        size.width * 0.70,
        size.height * 0.44,
        size.width * 0.57,
        size.height * 0.57,
      )
      ..cubicTo(
        size.width * 0.46,
        size.height * 0.70,
        size.width * 0.68,
        size.height * 0.78,
        size.width * 0.80,
        size.height * 0.60,
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
