import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';

import 'beyond_theme.dart';

class GameWordsStage2 extends StatefulWidget {
  final String childName;
  final String praiseWord;
  final String characterImage;
  final int totalStars;

  const GameWordsStage2({
    super.key,
    required this.childName,
    required this.praiseWord,
    required this.characterImage,
    required this.totalStars,
  });

  @override
  State<GameWordsStage2> createState() => _GameWordsStage2State();
}

class _GameWordsStage2State extends State<GameWordsStage2> {
  final AudioPlayer _wordPlayer = AudioPlayer();

  final AudioPlayer _effectPlayer = AudioPlayer();

  final AudioPlayer _sentencePlayer = AudioPlayer();

  final List<_SentenceStage> stages = const [
    _SentenceStage(
      focusWord: 'نجمة',
      sentence: ['رأيت', 'نجمة', 'في', 'السماء'],
      blanks: ['نجمة', 'السماء'],
      availableWords: ['السماء', 'نجمة'],
      completedSentence: 'رأيت نجمة في السماء',
      stageLabel: 'Level 1 / 2',
      sentenceAudio: 'audio/sentences/raaytu_najmatan_fi_alsamaa.mp3',
    ),

    _SentenceStage(
      focusWord: 'قمرًا',
      sentence: ['رأيت', 'قمرًا', 'في', 'السماء'],
      blanks: ['قمرًا', 'السماء'],
      availableWords: ['السماء', 'قمرًا'],
      completedSentence: 'رأيت قمرًا في السماء',
      stageLabel: 'Level 2 / 2',
      sentenceAudio: 'audio/sentences/raaytu_qamaran_fi_alsamaa.mp3',
    ),
  ];

  int stageIndex = 0;
  int earnedStars = 0;

  late List<String?> placedWords;
  late List<String> availableWords;

  bool completed = false;

  _SentenceStage get stage => stages[stageIndex];

  @override
  void initState() {
    super.initState();

    _loadStage();
  }

  void _loadStage() {
    placedWords = List<String?>.filled(stage.sentence.length, null);

    availableWords = List<String>.from(stage.availableWords);

    completed = false;
  }

  String _cleanWord(String word) {
    return word
        .replaceAll('َ', '')
        .replaceAll('ً', '')
        .replaceAll('ُ', '')
        .replaceAll('ٌ', '')
        .replaceAll('ِ', '')
        .replaceAll('ٍ', '')
        .replaceAll('ْ', '')
        .replaceAll('ّ', '')
        .trim();
  }

  String? _wordSoundPath(String word) {
    final clean = _cleanWord(word);

    if (clean.contains('رأيت')) {
      return 'audio/words/raaytu.mp3';
    }

    if (clean.contains('نجمة')) {
      return 'audio/words/najmatan.mp3';
    }

    if (clean.contains('قمر')) {
      return 'audio/words/qamaran.mp3';
    }

    if (clean.contains('في')) {
      return 'audio/words/fi.mp3';
    }

    if (clean.contains('السماء')) {
      return 'audio/words/alsamaa.mp3';
    }

    return null;
  }

  Future<void> _safePlayWord(String word) async {
    final path = _wordSoundPath(word);

    if (path == null) return;

    try {
      await _wordPlayer.stop();

      await _wordPlayer.play(AssetSource(path));
    } catch (_) {}
  }

  Future<void> _safePlayEffect(String path) async {
    try {
      await _effectPlayer.stop();

      await _effectPlayer.play(AssetSource(path));
    } catch (_) {}
  }

  Future<void> _safePlaySentence() async {
    try {
      await _sentencePlayer.stop();

      await _sentencePlayer.play(AssetSource(stage.sentenceAudio));
    } catch (_) {}
  }

  bool _isBlank(String word) {
    return stage.blanks.contains(word);
  }

  bool _isComplete() {
    for (int i = 0; i < stage.sentence.length; i++) {
      if (_isBlank(stage.sentence[i]) && placedWords[i] != stage.sentence[i]) {
        return false;
      }
    }

    return true;
  }

  Future<void> _onCorrectDrop(String word, int index) async {
    if (completed) return;

    await _safePlayWord(word);

    if (!mounted) return;

    setState(() {
      placedWords[index] = word;
      availableWords.remove(word);
    });

    await _safePlayEffect('audio/effects/correct.mp3');

    if (_isComplete()) {
      if (!mounted) return;

      setState(() {
        completed = true;
        earnedStars += 1;
      });

      await Future.delayed(const Duration(milliseconds: 500));

      await _safePlaySentence();

      await Future.delayed(const Duration(milliseconds: 3000));

      await _safePlayEffect('audio/effects/clap.mp3');
    }
  }

  Future<void> _onWrongDrop() async {
    await _safePlayEffect('audio/effects/wrong_soft.mp3');

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: BeyondTheme.pink,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        content: const Text(
          'Try again ✨',
          textAlign: TextAlign.center,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  void _nextStage() async {
    try {
      await _effectPlayer.stop();
      await _sentencePlayer.stop();
      await _wordPlayer.stop();
    } catch (_) {}

    if (stageIndex < stages.length - 1) {
      setState(() {
        stageIndex++;
        _loadStage();
      });
    } else {
      if (!mounted) return;

      Navigator.pop(context, widget.totalStars + earnedStars);
    }
  }

  void _goBack() async {
    try {
      await _effectPlayer.stop();
      await _sentencePlayer.stop();
      await _wordPlayer.stop();
    } catch (_) {}

    if (!mounted) return;

    Navigator.pop(context, widget.totalStars + earnedStars);
  }

  @override
  void dispose() {
    _wordPlayer.dispose();
    _effectPlayer.dispose();
    _sentencePlayer.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final totalDisplayedStars = widget.totalStars + earnedStars;

    return Directionality(
      textDirection: TextDirection.rtl,

      child: Scaffold(
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
                padding: const EdgeInsets.symmetric(
                  horizontal: 56,
                  vertical: 22,
                ),

                child: Column(
                  children: [
                    Row(
                      children: [
                        _CircleButton(icon: Icons.home_rounded, onTap: _goBack),

                        const Spacer(),

                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 18,
                            vertical: 10,
                          ),

                          decoration: BeyondTheme.mirrorNeonPanel(
                            borderColor: BeyondTheme.cyan,
                            radius: 22,
                          ),

                          child: Text(
                            stage.stageLabel,

                            style: BeyondTheme.normalText(size: 18),

                            textAlign: TextAlign.center,
                          ),
                        ),

                        const SizedBox(width: 14),

                        _StarsBox(stars: totalDisplayedStars),
                      ],
                    ),

                    const SizedBox(height: 10),

                    Text('Sentence Game', style: BeyondTheme.title(size: 36)),

                    const SizedBox(height: 6),

                    Text(
                      completed
                          ? 'Great job! You completed the sentence ⭐'
                          : 'Drag each word to its correct place',

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

                                  child: Text(
                                    stageIndex == 0 ? '⭐' : '🌙',

                                    style: const TextStyle(fontSize: 120),
                                  ),
                                ),

                                Center(
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,

                                    children: [
                                      GestureDetector(
                                        onTap: () =>
                                            _safePlayWord(stage.focusWord),

                                        child: Text(
                                          stage.focusWord,

                                          style: TextStyle(
                                            fontSize: 82,

                                            fontWeight: FontWeight.w900,

                                            color: Colors.white,

                                            shadows: [
                                              const Shadow(
                                                color: Colors.cyanAccent,

                                                blurRadius: 20,
                                              ),

                                              Shadow(
                                                color: BeyondTheme.pink
                                                    .withOpacity(0.9),

                                                blurRadius: 34,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),

                                      const SizedBox(height: 8),

                                      Text(
                                        'Focus Word',

                                        style: BeyondTheme.normalText(
                                          size: 16,

                                          color: Colors.white.withOpacity(0.72),
                                        ),
                                      ),

                                      const SizedBox(height: 40),

                                      _SentenceLine(
                                        sentence: stage.sentence,

                                        placedWords: placedWords,

                                        isBlank: _isBlank,

                                        onTapWord: _safePlayWord,

                                        onAccept: (draggedWord, index) async {
                                          if (stage.sentence[index] ==
                                              draggedWord) {
                                            await _onCorrectDrop(
                                              draggedWord,
                                              index,
                                            );
                                          } else {
                                            await _onWrongDrop();
                                          }
                                        },
                                      ),

                                      const SizedBox(height: 48),

                                      if (!completed)
                                        _WordsTray(
                                          words: availableWords,

                                          onTapWord: _safePlayWord,
                                        )
                                      else
                                        Text(
                                          stage.completedSentence,

                                          textAlign: TextAlign.center,

                                          style: BeyondTheme.arabicTitle(
                                            size: 34,
                                          ),
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
                                              ? 'Next ⭐'
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
      ),
    );
  }
}

class _SentenceStage {
  final String focusWord;
  final List<String> sentence;
  final List<String> blanks;
  final List<String> availableWords;
  final String completedSentence;
  final String stageLabel;
  final String sentenceAudio;

  const _SentenceStage({
    required this.focusWord,
    required this.sentence,
    required this.blanks,
    required this.availableWords,
    required this.completedSentence,
    required this.stageLabel,
    required this.sentenceAudio,
  });
}

class _SentenceLine extends StatelessWidget {
  final List<String> sentence;

  final List<String?> placedWords;

  final bool Function(String word) isBlank;

  final Future<void> Function(String word) onTapWord;

  final Future<void> Function(String word, int index) onAccept;

  const _SentenceLine({
    required this.sentence,
    required this.placedWords,
    required this.isBlank,
    required this.onTapWord,
    required this.onAccept,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      alignment: WrapAlignment.center,

      crossAxisAlignment: WrapCrossAlignment.center,

      spacing: 14,
      runSpacing: 16,

      children: List.generate(sentence.length, (index) {
        final word = sentence[index];

        if (!isBlank(word)) {
          return _FixedWordBox(word: word, onTap: () => onTapWord(word));
        }

        return _BlankWordBox(
          targetWord: word,
          placedWord: placedWords[index],
          onAccept: (draggedWord) => onAccept(draggedWord, index),
        );
      }),
    );
  }
}

class _FixedWordBox extends StatelessWidget {
  final String word;
  final VoidCallback onTap;

  const _FixedWordBox({required this.word, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,

      child: Container(
        width: 150,
        height: 72,

        alignment: Alignment.center,

        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),

          color: Colors.white.withOpacity(0.13),

          border: Border.all(color: Colors.white.withOpacity(0.30), width: 2),
        ),

        child: Text(
          word,

          textAlign: TextAlign.center,

          style: const TextStyle(
            fontSize: 34,
            fontWeight: FontWeight.w900,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}

class _BlankWordBox extends StatelessWidget {
  final String targetWord;
  final String? placedWord;

  final Future<void> Function(String word) onAccept;

  const _BlankWordBox({
    required this.targetWord,
    required this.placedWord,
    required this.onAccept,
  });

  @override
  Widget build(BuildContext context) {
    final filled = placedWord != null;

    return DragTarget<String>(
      onWillAcceptWithDetails: (_) => !filled,

      onAcceptWithDetails: (details) => onAccept(details.data),

      builder: (context, candidateData, rejectedData) {
        final hover = candidateData.isNotEmpty;

        return AnimatedContainer(
          duration: const Duration(milliseconds: 120),

          width: 170,
          height: 76,

          alignment: Alignment.center,

          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),

            color: filled
                ? BeyondTheme.yellow.withOpacity(0.95)
                : Colors.white.withOpacity(0.06),

            border: Border.all(
              color: filled || hover
                  ? BeyondTheme.yellow
                  : BeyondTheme.cyan.withOpacity(0.90),

              width: 3,
            ),
          ),

          child: Text(
            filled ? placedWord! : targetWord,

            textAlign: TextAlign.center,

            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.w900,

              color: filled ? Colors.white : Colors.white.withOpacity(0.20),
            ),
          ),
        );
      },
    );
  }
}

class _WordsTray extends StatelessWidget {
  final List<String> words;

  final Future<void> Function(String word) onTapWord;

  const _WordsTray({required this.words, required this.onTapWord});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      alignment: WrapAlignment.center,

      spacing: 28,
      runSpacing: 16,

      children: words.map((word) {
        return Draggable<String>(
          data: word,

          onDragStarted: () => onTapWord(word),

          feedback: Material(
            color: Colors.transparent,

            child: _WordCard(word: word, big: true),
          ),

          childWhenDragging: Opacity(
            opacity: 0.25,
            child: _WordCard(word: word),
          ),

          child: GestureDetector(
            onTap: () => onTapWord(word),

            child: _WordCard(word: word),
          ),
        );
      }).toList(),
    );
  }
}

class _WordCard extends StatelessWidget {
  final String word;
  final bool big;

  const _WordCard({required this.word, this.big = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: big ? 180 : 160,
      height: big ? 82 : 74,

      alignment: Alignment.center,

      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),

        gradient: LinearGradient(
          colors: [BeyondTheme.orange, BeyondTheme.pink],
        ),

        border: Border.all(color: Colors.white, width: 2),
      ),

      child: Text(
        word,

        textAlign: TextAlign.center,

        style: TextStyle(
          fontSize: big ? 34 : 31,

          fontWeight: FontWeight.w900,

          color: Colors.white,
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

class _CircleButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _CircleButton({required this.icon, required this.onTap});

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
          ),

          child: Icon(icon, color: Colors.white, size: 29),
        ),
      ),
    );
  }
}
