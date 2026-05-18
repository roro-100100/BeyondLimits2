import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';

import 'beyond_theme.dart';

class LettersGamePage extends StatefulWidget {
  final String childName;
  final String praiseWord;
  final String characterImage;
  final String userLanguage;
  final int totalStars;
  final int currentLevel;

  const LettersGamePage({
    super.key,
    required this.childName,
    required this.praiseWord,
    required this.characterImage,
    required this.userLanguage,
    required this.totalStars,
    this.currentLevel = 1,
  });

  @override
  State<LettersGamePage> createState() => _LettersGamePageState();
}

class _LettersGamePageState extends State<LettersGamePage>
    with SingleTickerProviderStateMixin {
  late final AnimationController _starController;

  final AudioPlayer _letterPlayer = AudioPlayer();
  final AudioPlayer _effectPlayer = AudioPlayer();

  final List<_LetterStage> stages = const [
    _LetterStage(word: ['ق', 'م', 'ر'], tray: ['ر', 'ق', 'م'], emoji: '🌙'),
    _LetterStage(word: ['ب', 'ا', 'ب'], tray: ['ب', 'ب', 'ا'], emoji: '🚪'),
    _LetterStage(word: ['ن', 'ج', 'م'], tray: ['م', 'ن', 'ج'], emoji: '⭐'),
  ];

  int stageIndex = 0;
  int earnedStars = 0;

  bool scattered = false;
  bool completed = false;
  bool showPraiseBubble = false;

  List<String?> placedLetters = [];
  List<String> availableLetters = [];

  bool get isArabic => widget.userLanguage == 'ar';

  int get displayedStars => widget.totalStars + earnedStars;

  _LetterStage get currentStage => stages[stageIndex];

  @override
  void initState() {
    super.initState();

    _starController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1900),
    );

    _startStage();
  }

  Future<void> _playEffect(String path) async {
    await _effectPlayer.stop();
    await _effectPlayer.play(AssetSource(path));
  }

  String? _letterSoundPath(String letter) {
    switch (letter) {
      case 'ق':
        return 'audio/letters/qaf_loop.mp3';
      case 'م':
        return 'audio/letters/meem_loop.mp3';
      case 'ر':
        return 'audio/letters/raa_loop.mp3';
      case 'ب':
        return 'audio/letters/baa_loop.mp3';
      case 'ا':
        return 'audio/letters/alif_loop.mp3';
      case 'ن':
        return 'audio/letters/noon_loop.mp3';
      case 'ج':
        return 'audio/letters/jeem_loop.mp3';
    }
    return null;
  }

  String? _wordSoundPath() {
    switch (currentStage.word.join()) {
      case 'قمر':
        return 'audio/words/qamar.mp3';
      case 'باب':
        return 'audio/words/bab.mp3';
      case 'نجم':
        return 'audio/words/najm.mp3';
    }
    return null;
  }

  Future<void> _startLetterSound(String letter) async {
    final path = _letterSoundPath(letter);
    if (path == null) return;

    await _letterPlayer.stop();
    await _letterPlayer.setReleaseMode(ReleaseMode.release);
    await _letterPlayer.play(AssetSource(path));
  }

  Future<void> _stopLetterSound() async {
    await _letterPlayer.stop();
  }

  Future<void> _playWordSound() async {
    final path = _wordSoundPath();
    if (path == null) return;

    await _effectPlayer.stop();
    await _effectPlayer.play(AssetSource(path));
  }

  Future<void> _startStage() async {
    _starController.reset();

    setState(() {
      scattered = false;
      completed = false;
      showPraiseBubble = false;
      placedLetters = List<String?>.filled(currentStage.word.length, null);
      availableLetters = [];
    });

    await Future.delayed(const Duration(milliseconds: 500));

    if (!mounted) return;

    await _playWordSound();

    await Future.delayed(const Duration(milliseconds: 1200));

    if (!mounted) return;

    await _playEffect('audio/effects/magic_star.mp3');
    _starController.forward();

    await Future.delayed(const Duration(milliseconds: 1900));

    if (!mounted) return;

    setState(() {
      scattered = true;
      availableLetters = List<String>.from(currentStage.tray);
    });
  }

  @override
  void dispose() {
    _starController.dispose();
    _letterPlayer.dispose();
    _effectPlayer.dispose();
    super.dispose();
  }

  Future<void> _checkWin() async {
    final ok = List.generate(
      currentStage.word.length,
      (i) => placedLetters[i] == currentStage.word[i],
    ).every((v) => v);

    if (ok && !completed) {
      setState(() {
        completed = true;
        earnedStars += 1;
        showPraiseBubble = true;
      });

      await _playWordSound();

      await Future.delayed(const Duration(milliseconds: 1000));

      await _playEffect('audio/effects/clap.mp3');
    }
  }

  void _nextStage() {
    if (stageIndex < stages.length - 1) {
      setState(() {
        stageIndex++;
      });
      _startStage();
    } else {
      _playEffect('audio/effects/complete.mp3');
      Navigator.pop(context, displayedStars);
    }
  }

  void _wrongAnswer() {
    _playEffect('audio/effects/wrong_soft.mp3');

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: BeyondTheme.pink,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        content: Text(
          isArabic ? 'حاول مرة ثانية ✨' : 'Try again ✨',
          textAlign: TextAlign.center,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final wordText = currentStage.word.join('');

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
                      _CircleBackButton(
                        onTap: () => Navigator.pop(context, displayedStars),
                      ),
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
                    isArabic ? 'كوكب الحروف' : 'Letters Planet',
                    style: isArabic
                        ? BeyondTheme.arabicTitle(size: 36)
                        : BeyondTheme.title(size: 34),
                  ),

                  const SizedBox(height: 6),

                  Text(
                    scattered
                        ? isArabic
                              ? 'اسحب الحروف ورجع كلمة $wordText'
                              : 'Drag the letters to build $wordText'
                        : isArabic
                        ? 'اسمع الكلمة ثم انتظر النجم السحري ✨'
                        : 'Listen to the word, then wait for the magic star ✨',
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
                                : BeyondTheme.cyan,
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

                              Align(
                                alignment: Alignment.topCenter,
                                child: Padding(
                                  padding: const EdgeInsets.only(top: 25),
                                  child: Text(
                                    currentStage.emoji,
                                    style: const TextStyle(fontSize: 76),
                                  ),
                                ),
                              ),

                              Center(
                                child: scattered
                                    ? _PuzzleArea(
                                        targetWord: currentStage.word,
                                        placedLetters: placedLetters,
                                        onAccept: (index, letter) async {
                                          await _stopLetterSound();

                                          if (currentStage.word[index] ==
                                              letter) {
                                            await _playEffect(
                                              'audio/effects/correct.mp3',
                                            );

                                            setState(() {
                                              placedLetters[index] = letter;
                                              availableLetters.remove(letter);
                                            });

                                            await _checkWin();
                                          } else {
                                            _wrongAnswer();
                                          }
                                        },
                                      )
                                    : _FullWord(word: currentStage.word),
                              ),

                              if (!scattered)
                                AnimatedBuilder(
                                  animation: _starController,
                                  builder: (context, child) {
                                    final x = lerpDouble(
                                      -120,
                                      MediaQuery.of(context).size.width - 250,
                                      _starController.value,
                                    )!;

                                    final y =
                                        190 +
                                        (40 *
                                            (0.5 - _starController.value)
                                                .abs());

                                    return Positioned(
                                      left: x,
                                      top: y,
                                      child: Transform.rotate(
                                        angle: _starController.value * 6.2,
                                        child: const Text(
                                          '⭐',
                                          style: TextStyle(
                                            fontSize: 72,
                                            shadows: [
                                              Shadow(
                                                color: Colors.yellowAccent,
                                                blurRadius: 28,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                ),

                              if (scattered && !completed)
                                Positioned(
                                  left: 0,
                                  right: 0,
                                  bottom: 42,
                                  child: _LettersTray(
                                    letters: availableLetters,
                                    onStartDrag: _startLetterSound,
                                    onStopDrag: _stopLetterSound,
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
                                            ? 'إنهاء ⭐'
                                            : 'Finish ⭐',
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

class _LetterStage {
  final List<String> word;
  final List<String> tray;
  final String emoji;

  const _LetterStage({
    required this.word,
    required this.tray,
    required this.emoji,
  });
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

class _FullWord extends StatelessWidget {
  final List<String> word;

  const _FullWord({required this.word});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      textDirection: TextDirection.rtl,
      children: word.map((letter) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 9),
          child: _BigLetter(letter: letter),
        );
      }).toList(),
    );
  }
}

class _PuzzleArea extends StatelessWidget {
  final List<String> targetWord;
  final List<String?> placedLetters;
  final void Function(int index, String letter) onAccept;

  const _PuzzleArea({
    required this.targetWord,
    required this.placedLetters,
    required this.onAccept,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      textDirection: TextDirection.rtl,
      children: List.generate(targetWord.length, (index) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 9),
          child: DragTarget<String>(
            onWillAcceptWithDetails: (_) => placedLetters[index] == null,
            onAcceptWithDetails: (details) => onAccept(index, details.data),
            builder: (context, candidate, rejected) {
              final letter = placedLetters[index];

              return Container(
                width: 118,
                height: 118,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(28),
                  color: Colors.white.withOpacity(0.10),
                  border: Border.all(
                    color: letter == null
                        ? BeyondTheme.cyan.withOpacity(0.75)
                        : BeyondTheme.yellow,
                    width: 3,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: BeyondTheme.cyan.withOpacity(0.25),
                      blurRadius: 24,
                    ),
                  ],
                ),
                child: Center(
                  child: Text(
                    letter ?? targetWord[index],
                    style: TextStyle(
                      fontSize: 58,
                      fontWeight: FontWeight.w900,
                      color: letter == null
                          ? Colors.white.withOpacity(0.25)
                          : Colors.white,
                      shadows: const [
                        Shadow(color: Colors.cyanAccent, blurRadius: 18),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        );
      }),
    );
  }
}

class _LettersTray extends StatelessWidget {
  final List<String> letters;
  final void Function(String letter) onStartDrag;
  final VoidCallback onStopDrag;

  const _LettersTray({
    required this.letters,
    required this.onStartDrag,
    required this.onStopDrag,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      textDirection: TextDirection.rtl,
      children: letters.map((letter) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Draggable<String>(
            data: letter,
            onDragStarted: () => onStartDrag(letter),
            onDragEnd: (_) => onStopDrag(),
            onDraggableCanceled: (_, _) => onStopDrag(),
            onDragCompleted: onStopDrag,
            feedback: Material(
              color: Colors.transparent,
              child: _BigLetter(letter: letter, dragging: true),
            ),
            childWhenDragging: Opacity(
              opacity: 0.25,
              child: _BigLetter(letter: letter),
            ),
            child: _BigLetter(letter: letter),
          ),
        );
      }).toList(),
    );
  }
}

class _BigLetter extends StatelessWidget {
  final String letter;
  final bool dragging;

  const _BigLetter({required this.letter, this.dragging = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: dragging ? 112 : 98,
      height: dragging ? 112 : 98,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
        gradient: const LinearGradient(
          colors: [Color(0xFF7DF9FF), Color(0xFF6A00FF)],
        ),
        border: Border.all(color: Colors.white, width: 2),
        boxShadow: const [
          BoxShadow(color: Colors.cyanAccent, blurRadius: 24, spreadRadius: 2),
        ],
      ),
      child: Center(
        child: Text(
          letter,
          style: const TextStyle(
            fontSize: 56,
            fontWeight: FontWeight.w900,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
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
