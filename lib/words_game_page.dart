import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';

import 'beyond_theme.dart';

class WordsGamePage extends StatefulWidget {
  final String childName;
  final String praiseWord;
  final String characterImage;
  final String userLanguage;
  final int totalStars;
  final int currentLevel;

  const WordsGamePage({
    super.key,
    required this.childName,
    required this.praiseWord,
    required this.characterImage,
    required this.userLanguage,
    required this.totalStars,
    this.currentLevel = 1,
  });

  @override
  State<WordsGamePage> createState() => _WordsGamePageState();
}

class _WordsGamePageState extends State<WordsGamePage> {
  final AudioPlayer _effectPlayer = AudioPlayer();
  final AudioPlayer _wordPlayer = AudioPlayer();

  final List<_WordStage> stages = const [
    _WordStage(emoji: '🌙', correctWord: 'قمر', options: ['باب', 'قمر', 'نجم']),
    _WordStage(emoji: '🚪', correctWord: 'باب', options: ['باب', 'قمر', 'بيت']),
    _WordStage(emoji: '⭐', correctWord: 'نجم', options: ['نور', 'نجم', 'ماء']),
  ];

  int stageIndex = 0;
  int earnedStars = 0;

  bool completed = false;
  bool showPraiseBubble = false;

  bool get isArabic => widget.userLanguage == 'ar';

  int get displayedStars => widget.totalStars + earnedStars;

  _WordStage get currentStage => stages[stageIndex];

  Future<void> _playEffect(String path) async {
    await _effectPlayer.stop();
    await _effectPlayer.play(AssetSource(path));
  }

  String? _wordSoundPath(String word) {
    switch (word) {
      case 'قمر':
        return 'audio/words/qamar.mp3';
      case 'باب':
        return 'audio/words/bab.mp3';
      case 'نجم':
        return 'audio/words/najm.mp3';
      case 'بيت':
        return 'audio/words/bayt.mp3';
      case 'نور':
        return 'audio/words/noor.mp3';
      case 'ماء':
        return 'audio/words/maa.mp3';
    }
    return null;
  }

  Future<void> _playWordOnce(String word) async {
    final path = _wordSoundPath(word);
    if (path == null) return;

    await _wordPlayer.stop();
    await _wordPlayer.setReleaseMode(ReleaseMode.release);
    await _wordPlayer.play(AssetSource(path));
  }

  void _goBack() {
    Navigator.pop(context, displayedStars);
  }

  Future<void> _chooseWord(String word) async {
    if (completed) return;

    if (word == currentStage.correctWord) {
      await _playWordOnce(word);

      await Future.delayed(const Duration(milliseconds: 900));

      if (!mounted) return;

      setState(() {
        completed = true;
        showPraiseBubble = true;
        earnedStars += 1;
      });

      await _playEffect('audio/effects/clap.mp3');
    } else {
      await _playWordOnce(word);

      await Future.delayed(const Duration(milliseconds: 500));

      await _playEffect('audio/effects/wrong_soft.mp3');

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: BeyondTheme.pink,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
          content: Text(
            isArabic ? 'حاول مرة ثانية ✨' : 'Try again ✨',
            textAlign: TextAlign.center,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
      );
    }
  }

  Future<void> _nextStage() async {
    if (stageIndex < stages.length - 1) {
      await _playEffect('audio/effects/magic_star.mp3');

      setState(() {
        stageIndex++;
        completed = false;
        showPraiseBubble = false;
      });
    } else {
      await _playEffect('audio/effects/complete.mp3');
      Navigator.pop(context, displayedStars);
    }
  }

  @override
  void dispose() {
    _effectPlayer.dispose();
    _wordPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: BeyondTheme.bgDark,
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset('assets/images/AA.png', fit: BoxFit.cover),
          ),

          Positioned.fill(
            child: Container(color: Colors.black.withOpacity(0.30)),
          ),

          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 56, vertical: 22),
              child: Column(
                children: [
                  Row(
                    children: [
                      _CircleBackButton(onTap: _goBack),
                      const Spacer(),
                      _StageBox(
                        stage: stageIndex + 1,
                        total: stages.length,
                        isArabic: isArabic,
                      ),
                      const SizedBox(width: 14),
                      _StarsBox(stars: displayedStars),
                    ],
                  ),

                  const SizedBox(height: 8),

                  Text(
                    isArabic ? 'كوكب الكلمات' : 'Words Planet',
                    style: isArabic
                        ? BeyondTheme.arabicTitle(size: 36)
                        : BeyondTheme.title(size: 34),
                  ),

                  const SizedBox(height: 6),

                  Text(
                    isArabic
                        ? 'اضغط على الكلمة لسماعها واختر الإجابة الصحيحة'
                        : 'Tap a word to hear it and choose the correct answer',
                    textAlign: TextAlign.center,
                    style: BeyondTheme.normalText(
                      size: 19,
                      color: Colors.white.withOpacity(0.85),
                    ),
                  ),

                  const SizedBox(height: 18),

                  Expanded(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(38),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
                        child: Container(
                          width: double.infinity,
                          decoration: BeyondTheme.mirrorNeonPanel(
                            borderColor: completed
                                ? BeyondTheme.yellow
                                : BeyondTheme.pink,
                            radius: 38,
                          ),
                          child: Stack(
                            children: [
                              Positioned(
                                left: 30,
                                bottom: 20,
                                child: Image.asset(
                                  widget.characterImage,
                                  width: 160,
                                  fit: BoxFit.contain,
                                ),
                              ),

                              if (showPraiseBubble)
                                Positioned(
                                  left: 145,
                                  bottom: 170,
                                  child: _SpeechBubble(
                                    text:
                                        '${widget.praiseWord} ${widget.childName} ⭐',
                                  ),
                                ),

                              Center(
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      currentStage.emoji,
                                      style: const TextStyle(
                                        fontSize: 105,
                                        shadows: [
                                          Shadow(
                                            color: Colors.cyanAccent,
                                            blurRadius: 18,
                                          ),
                                        ],
                                      ),
                                    ),

                                    const SizedBox(height: 28),

                                    Wrap(
                                      alignment: WrapAlignment.center,
                                      spacing: 22,
                                      runSpacing: 18,
                                      children: currentStage.options.map((
                                        word,
                                      ) {
                                        final isCorrect =
                                            completed &&
                                            word == currentStage.correctWord;

                                        return _WordOption(
                                          word: word,
                                          selected: isCorrect,
                                          disabled: completed,
                                          onTap: () => _chooseWord(word),
                                        );
                                      }).toList(),
                                    ),
                                  ],
                                ),
                              ),

                              if (completed)
                                Positioned(
                                  right: 35,
                                  bottom: 35,
                                  child: InkWell(
                                    onTap: _nextStage,
                                    borderRadius: BorderRadius.circular(40),
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 34,
                                        vertical: 14,
                                      ),
                                      decoration: BeyondTheme.glowButton(),
                                      child: Text(
                                        stageIndex < stages.length - 1
                                            ? isArabic
                                                  ? 'التالي ⭐'
                                                  : 'Next ⭐'
                                            : isArabic
                                            ? 'الرجوع للمسار ⭐'
                                            : 'Back to Path ⭐',
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 20,
                                          fontWeight: FontWeight.w900,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _WordStage {
  final String emoji;
  final String correctWord;
  final List<String> options;

  const _WordStage({
    required this.emoji,
    required this.correctWord,
    required this.options,
  });
}

class _WordOption extends StatefulWidget {
  final String word;
  final bool selected;
  final bool disabled;
  final VoidCallback onTap;

  const _WordOption({
    required this.word,
    required this.selected,
    required this.disabled,
    required this.onTap,
  });

  @override
  State<_WordOption> createState() => _WordOptionState();
}

class _WordOptionState extends State<_WordOption> {
  bool hover = false;
  bool pressed = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) {
        if (!widget.disabled) {
          setState(() => hover = true);
        }
      },
      onExit: (_) {
        setState(() {
          hover = false;
          pressed = false;
        });
      },
      child: GestureDetector(
        onTapDown: (_) {
          if (!widget.disabled) {
            setState(() => pressed = true);
          }
        },
        onTapUp: (_) {
          if (!widget.disabled) {
            setState(() => pressed = false);
            widget.onTap();
          }
        },
        onTapCancel: () {
          setState(() => pressed = false);
        },
        child: AnimatedScale(
          scale: pressed
              ? 1.10
              : hover
              ? 1.07
              : 1,
          duration: const Duration(milliseconds: 160),
          curve: Curves.easeOutBack,
          child: Container(
            width: 150,
            height: 78,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(28),
              gradient: LinearGradient(
                colors: widget.selected || pressed
                    ? const [Color(0xFFFFD84D), Color(0xFFFF8A00)]
                    : const [Color(0xFF7DF9FF), Color(0xFF6A00FF)],
              ),
              border: Border.all(color: Colors.white, width: 2),
              boxShadow: [
                BoxShadow(
                  color: widget.selected || pressed
                      ? BeyondTheme.yellow.withOpacity(0.70)
                      : BeyondTheme.cyan.withOpacity(0.45),
                  blurRadius: 26,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: Center(
              child: Text(
                widget.word,
                style: const TextStyle(
                  fontSize: 34,
                  fontWeight: FontWeight.w900,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _SpeechBubble extends StatelessWidget {
  final String text;

  const _SpeechBubble({required this.text});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _BubbleTailPainter(),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 14),
        decoration: BoxDecoration(
          color: BeyondTheme.bgDark.withOpacity(0.88),
          borderRadius: BorderRadius.circular(26),
          border: Border.all(color: BeyondTheme.cyan, width: 2),
          boxShadow: [
            BoxShadow(
              color: BeyondTheme.cyan.withOpacity(0.45),
              blurRadius: 22,
            ),
          ],
        ),
        child: Text(text, style: BeyondTheme.arabicTitle(size: 22)),
      ),
    );
  }
}

class _BubbleTailPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = BeyondTheme.bgDark.withOpacity(0.88)
      ..style = PaintingStyle.fill;

    final path = Path()
      ..moveTo(25, size.height - 4)
      ..lineTo(-18, size.height + 22)
      ..lineTo(55, size.height - 8)
      ..close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _StarsBox extends StatelessWidget {
  final int stars;

  const _StarsBox({required this.stars});

  @override
  Widget build(BuildContext context) {
    return Container(
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
    );
  }
}

class _StageBox extends StatelessWidget {
  final int stage;
  final int total;
  final bool isArabic;

  const _StageBox({
    required this.stage,
    required this.total,
    required this.isArabic,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
      decoration: BeyondTheme.mirrorNeonPanel(
        borderColor: BeyondTheme.cyan,
        radius: 22,
      ),
      child: Text(
        isArabic ? 'المرحلة $stage / $total' : 'Level $stage / $total',
        style: BeyondTheme.normalText(size: 18),
      ),
    );
  }
}

class _CircleBackButton extends StatelessWidget {
  final VoidCallback onTap;

  const _CircleBackButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return ClipOval(
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
    );
  }
}
