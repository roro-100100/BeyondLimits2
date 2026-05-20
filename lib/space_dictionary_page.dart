import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';

import 'beyond_theme.dart';

class SpaceDictionaryPage extends StatefulWidget {
  const SpaceDictionaryPage({super.key});

  @override
  State<SpaceDictionaryPage> createState() => _SpaceDictionaryPageState();
}

class _SpaceDictionaryPageState extends State<SpaceDictionaryPage> {
  final AudioPlayer _wordPlayer = AudioPlayer();
  final PageController _pageController = PageController(viewportFraction: 0.72);

  int currentIndex = 0;
  int? activeIndex;

  final List<_DictionaryWord> words = const [
    _DictionaryWord(
      arabic: 'قمر',
      english: 'Moon',
      emoji: '🌙',
      audioPath: 'audio/words/qamar.mp3',
    ),
    _DictionaryWord(
      arabic: 'نجمة',
      english: 'Star',
      emoji: '⭐',
      audioPath: 'audio/words/najmatan.mp3',
    ),
    _DictionaryWord(
      arabic: 'باب',
      english: 'Door',
      emoji: '🚪',
      audioPath: 'audio/words/bab.mp3',
    ),
    _DictionaryWord(
      arabic: 'بيت',
      english: 'House',
      emoji: '🏠',
      audioPath: 'audio/words/bayt.mp3',
    ),
  ];

  Future<void> _playWord(int index) async {
    setState(() => activeIndex = index);

    try {
      await _wordPlayer.stop();
      await _wordPlayer.play(AssetSource(words[index].audioPath));
    } catch (_) {}

    await Future.delayed(const Duration(milliseconds: 700));

    if (mounted) {
      setState(() => activeIndex = null);
    }
  }

  void _goNext() {
    if (currentIndex < words.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 420),
        curve: Curves.easeOutBack,
      );
    }
  }

  void _goPrevious() {
    if (currentIndex > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 420),
        curve: Curves.easeOutBack,
      );
    }
  }

  @override
  void dispose() {
    _wordPlayer.dispose();
    _pageController.dispose();
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

          Positioned.fill(
            child: IgnorePointer(
              child: CustomPaint(painter: _SpaceSparklesPainter()),
            ),
          ),

          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 46, vertical: 22),
              child: Column(
                children: [
                  Row(
                    children: [
                      _CircleBackButton(onTap: () => Navigator.pop(context)),
                      const Spacer(),
                      _TitleGlass(),
                      const Spacer(),
                      const SizedBox(width: 56),
                    ],
                  ),

                  const SizedBox(height: 10),

                  Text(
                    'Swipe the space cards and tap to hear the word',
                    textAlign: TextAlign.center,
                    style: BeyondTheme.normalText(
                      size: 18,
                      color: Colors.white.withOpacity(0.84),
                    ),
                  ),

                  const SizedBox(height: 18),

                  Expanded(
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        PageView.builder(
                          controller: _pageController,
                          itemCount: words.length,
                          scrollDirection: Axis.horizontal,
                          onPageChanged: (index) {
                            setState(() => currentIndex = index);
                          },
                          itemBuilder: (context, index) {
                            return AnimatedBuilder(
                              animation: _pageController,
                              builder: (context, child) {
                                double value = 0;

                                if (_pageController.position.haveDimensions) {
                                  value = (_pageController.page ?? 0) - index;
                                } else {
                                  value = currentIndex.toDouble() - index;
                                }

                                final distance = value.abs().clamp(0.0, 1.0);
                                final scale = 1 - (distance * 0.14);
                                final rotate = value * 0.10;

                                return Transform(
                                  alignment: Alignment.center,
                                  transform: Matrix4.identity()
                                    ..setEntry(3, 2, 0.001)
                                    ..rotateY(rotate)
                                    ..scale(scale),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 18,
                                      vertical: 22,
                                    ),
                                    child: _DictionaryNotebookCard(
                                      word: words[index],
                                      active: activeIndex == index,
                                      onTap: () => _playWord(index),
                                    ),
                                  ),
                                );
                              },
                            );
                          },
                        ),

                        Positioned(
                          left: 0,
                          child: _SideArrowButton(
                            icon: Icons.arrow_back_ios_new_rounded,
                            enabled: currentIndex > 0,
                            onTap: _goPrevious,
                          ),
                        ),

                        Positioned(
                          right: 0,
                          child: _SideArrowButton(
                            icon: Icons.arrow_forward_ios_rounded,
                            enabled: currentIndex < words.length - 1,
                            onTap: _goNext,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 10),

                  _PageDots(count: words.length, currentIndex: currentIndex),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _DictionaryWord {
  final String arabic;
  final String english;
  final String emoji;
  final String audioPath;

  const _DictionaryWord({
    required this.arabic,
    required this.english,
    required this.emoji,
    required this.audioPath,
  });
}

class _DictionaryNotebookCard extends StatelessWidget {
  final _DictionaryWord word;
  final bool active;
  final VoidCallback onTap;

  const _DictionaryNotebookCard({
    required this.word,
    required this.active,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedScale(
      scale: active ? 1.06 : 1,
      duration: const Duration(milliseconds: 240),
      curve: Curves.easeOutBack,
      child: InkWell(
        borderRadius: BorderRadius.circular(42),
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 260),
          curve: Curves.easeOut,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(42),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: active
                  ? [
                      BeyondTheme.yellow.withOpacity(0.96),
                      BeyondTheme.orange.withOpacity(0.92),
                      BeyondTheme.pink.withOpacity(0.88),
                    ]
                  : [
                      Colors.white.withOpacity(0.20),
                      BeyondTheme.cyan.withOpacity(0.50),
                      BeyondTheme.purple.withOpacity(0.62),
                    ],
            ),
            border: Border.all(
              color: Colors.white.withOpacity(active ? 1 : 0.70),
              width: active ? 3 : 2,
            ),
            boxShadow: [
              BoxShadow(
                color: active
                    ? BeyondTheme.yellow.withOpacity(0.75)
                    : BeyondTheme.cyan.withOpacity(0.38),
                blurRadius: active ? 48 : 28,
                spreadRadius: active ? 8 : 3,
              ),
            ],
          ),
          child: Stack(
            children: [
              Positioned(
                left: 0,
                top: 30,
                bottom: 30,
                child: Container(
                  width: 20,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.30),
                    borderRadius: const BorderRadius.horizontal(
                      right: Radius.circular(18),
                    ),
                  ),
                ),
              ),

              Positioned(
                top: 24,
                left: 38,
                child: Text(
                  '📖',
                  style: TextStyle(
                    fontSize: 34,
                    color: Colors.white.withOpacity(0.90),
                  ),
                ),
              ),

              if (active) ...const [
                Positioned(
                  top: 24,
                  right: 30,
                  child: Text('✨', style: TextStyle(fontSize: 34)),
                ),
                Positioned(
                  bottom: 28,
                  left: 42,
                  child: Text('🪐', style: TextStyle(fontSize: 42)),
                ),
                Positioned(
                  bottom: 32,
                  right: 42,
                  child: Text('🌟', style: TextStyle(fontSize: 38)),
                ),
              ],

              Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      word.emoji,
                      style: TextStyle(
                        fontSize: active ? 150 : 135,
                        shadows: const [
                          Shadow(color: Colors.cyanAccent, blurRadius: 22),
                        ],
                      ),
                    ),

                    const SizedBox(height: 12),

                    Text(
                      word.arabic,
                      textDirection: TextDirection.rtl,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: active ? 62 : 56,
                        fontWeight: FontWeight.w900,
                        color: Colors.white,
                        shadows: const [
                          Shadow(color: Colors.cyanAccent, blurRadius: 18),
                        ],
                      ),
                    ),

                    const SizedBox(height: 8),

                    Text(
                      word.english,
                      textAlign: TextAlign.center,
                      style: BeyondTheme.normalText(
                        size: active ? 26 : 23,
                        color: Colors.white.withOpacity(0.88),
                      ),
                    ),

                    const SizedBox(height: 16),

                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 22,
                        vertical: 10,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.20),
                        borderRadius: BorderRadius.circular(30),
                        border: Border.all(
                          color: Colors.white.withOpacity(0.45),
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.volume_up_rounded,
                            color: Colors.white,
                            size: 26,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Tap to listen',
                            style: BeyondTheme.normalText(size: 16),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SideArrowButton extends StatelessWidget {
  final IconData icon;
  final bool enabled;
  final VoidCallback onTap;

  const _SideArrowButton({
    required this.icon,
    required this.enabled,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: enabled ? 1 : 0.25,
      child: ClipOval(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
          child: InkWell(
            onTap: enabled ? onTap : null,
            child: Container(
              width: 62,
              height: 62,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(0.12),
                border: Border.all(color: BeyondTheme.cyan, width: 2),
                boxShadow: [
                  BoxShadow(
                    color: BeyondTheme.cyan.withOpacity(0.35),
                    blurRadius: 20,
                  ),
                ],
              ),
              child: Icon(icon, color: Colors.white, size: 30),
            ),
          ),
        ),
      ),
    );
  }
}

class _PageDots extends StatelessWidget {
  final int count;
  final int currentIndex;

  const _PageDots({required this.count, required this.currentIndex});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(count, (index) {
        final active = index == currentIndex;

        return AnimatedContainer(
          duration: const Duration(milliseconds: 220),
          margin: const EdgeInsets.symmetric(horizontal: 5),
          width: active ? 22 : 9,
          height: 9,
          decoration: BoxDecoration(
            color: active ? BeyondTheme.cyan : Colors.white.withOpacity(0.35),
            borderRadius: BorderRadius.circular(20),
            boxShadow: active
                ? [
                    BoxShadow(
                      color: BeyondTheme.cyan.withOpacity(0.75),
                      blurRadius: 16,
                    ),
                  ]
                : [],
          ),
        );
      }),
    );
  }
}

class _TitleGlass extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(30),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 14, sigmaY: 14),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 36, vertical: 12),
          decoration: BeyondTheme.mirrorNeonPanel(
            borderColor: BeyondTheme.cyan,
            radius: 30,
          ),
          child: Text('Galaxy Dictionary', style: BeyondTheme.title(size: 30)),
        ),
      ),
    );
  }
}

class _SpaceSparklesPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = Colors.white.withOpacity(0.18);

    final points = [
      Offset(size.width * 0.12, size.height * 0.20),
      Offset(size.width * 0.22, size.height * 0.72),
      Offset(size.width * 0.42, size.height * 0.18),
      Offset(size.width * 0.58, size.height * 0.78),
      Offset(size.width * 0.78, size.height * 0.22),
      Offset(size.width * 0.90, size.height * 0.65),
    ];

    for (final p in points) {
      canvas.drawCircle(p, 3, paint);
      canvas.drawCircle(p.translate(18, 10), 2, paint);
      canvas.drawCircle(p.translate(-14, 18), 1.8, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _CircleBackButton extends StatelessWidget {
  final VoidCallback onTap;

  const _CircleBackButton({required this.onTap});

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
              Icons.arrow_back_rounded,
              color: Colors.white,
              size: 30,
            ),
          ),
        ),
      ),
    );
  }
}
