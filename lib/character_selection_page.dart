import 'dart:ui';
import 'package:flutter/material.dart';

import 'beyond_theme.dart';
import 'mission_selection_page.dart';
import 'space_hub_page.dart';

class CharacterSelectionPage extends StatefulWidget {
  const CharacterSelectionPage({super.key});

  @override
  State<CharacterSelectionPage> createState() => _CharacterSelectionPageState();
}

class _CharacterSelectionPageState extends State<CharacterSelectionPage> {
  final TextEditingController nameController = TextEditingController();

  int selectedIndex = 0;

  final List<_CharacterOption> characters = const [
    _CharacterOption(
      title: 'Boy Astronaut',
      imagePath: 'assets/images/boy.png',
      glow: BeyondTheme.blue,
      praiseWord: 'Great job',
    ),

    _CharacterOption(
      title: 'Girl Astronaut',
      imagePath: 'assets/images/girl.png',
      glow: BeyondTheme.pink,
      praiseWord: 'Amazing',
    ),
  ];

  void _goBack() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const MissionSelectionPage()),
    );
  }

  void _startAdventure() {
    final name = nameController.text.trim();
    final selected = characters[selectedIndex];

    if (name.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: BeyondTheme.pink,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
          content: const Text(
            'Enter the child name first ✨',
            textAlign: TextAlign.center,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
      );
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => SpaceHubPage(
          childName: name,
          praiseWord: selected.praiseWord,
          characterImage: selected.imagePath,
          totalStars: 0,
        ),
      ),
    );
  }

  @override
  void dispose() {
    nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final selected = characters[selectedIndex];

    return Scaffold(
      backgroundColor: BeyondTheme.bgDark,
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset('assets/images/AA.png', fit: BoxFit.cover),
          ),

          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withOpacity(0.12),
                    BeyondTheme.bgDark.withOpacity(0.48),
                    Colors.black.withOpacity(0.72),
                  ],
                ),
              ),
            ),
          ),

          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 64, vertical: 24),
              child: Column(
                children: [
                  Row(
                    children: [
                      _CircleBackButton(onTap: _goBack),

                      const Spacer(),

                      const _GlassTitle(),

                      const Spacer(),

                      const _StarsBadge(totalStars: 0),
                    ],
                  ),

                  const SizedBox(height: 12),

                  Text(
                    'Choose Your Character',
                    textAlign: TextAlign.center,
                    style: BeyondTheme.title(size: 30),
                  ),

                  const SizedBox(height: 6),

                  Text(
                    'Pick your astronaut and start the adventure',
                    textAlign: TextAlign.center,
                    style: BeyondTheme.normalText(
                      size: 18,
                      color: Colors.white.withOpacity(0.85),
                    ),
                  ),

                  const SizedBox(height: 26),

                  Expanded(
                    child: Row(
                      children: [
                        Expanded(
                          flex: 5,
                          child: _PreviewPanel(character: selected),
                        ),

                        const SizedBox(width: 34),

                        Expanded(
                          flex: 5,
                          child: Center(
                            child: SizedBox(
                              width: 620,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Row(
                                    children: [
                                      Expanded(
                                        child: _CharacterCard(
                                          character: characters[0],
                                          selected: selectedIndex == 0,
                                          onTap: () {
                                            setState(() {
                                              selectedIndex = 0;
                                            });
                                          },
                                        ),
                                      ),

                                      const SizedBox(width: 18),

                                      Expanded(
                                        child: _CharacterCard(
                                          character: characters[1],
                                          selected: selectedIndex == 1,
                                          onTap: () {
                                            setState(() {
                                              selectedIndex = 1;
                                            });
                                          },
                                        ),
                                      ),
                                    ],
                                  ),

                                  const SizedBox(height: 24),

                                  _NameField(controller: nameController),

                                  const SizedBox(height: 24),

                                  InkWell(
                                    onTap: _startAdventure,
                                    borderRadius: BorderRadius.circular(40),
                                    child: Container(
                                      width: double.infinity,
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 16,
                                        horizontal: 26,
                                      ),
                                      decoration: BeyondTheme.glowButton(),
                                      child: const Text(
                                        '🚀 Start Adventure',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 22,
                                          fontWeight: FontWeight.w900,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
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

class _CharacterOption {
  final String title;
  final String imagePath;
  final Color glow;
  final String praiseWord;

  const _CharacterOption({
    required this.title,
    required this.imagePath,
    required this.glow,
    required this.praiseWord,
  });
}

class _StarsBadge extends StatelessWidget {
  final int totalStars;

  const _StarsBadge({required this.totalStars});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(26),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
        child: Container(
          height: 54,
          padding: const EdgeInsets.symmetric(horizontal: 18),
          decoration: BeyondTheme.mirrorNeonPanel(
            borderColor: BeyondTheme.orange,
            radius: 26,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('⭐', style: TextStyle(fontSize: 24)),

              const SizedBox(width: 8),

              Text('$totalStars', style: BeyondTheme.cardTitle(size: 22)),
            ],
          ),
        ),
      ),
    );
  }
}

class _GlassTitle extends StatelessWidget {
  const _GlassTitle();

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(34),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 14, sigmaY: 14),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 15),
          decoration: BeyondTheme.mirrorNeonPanel(
            borderColor: BeyondTheme.cyan,
          ),
          child: Text('⭐ CHARACTER ⭐', style: BeyondTheme.title(size: 32)),
        ),
      ),
    );
  }
}

class _PreviewPanel extends StatelessWidget {
  final _CharacterOption character;

  const _PreviewPanel({required this.character});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(38),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
        child: Container(
          decoration: BeyondTheme.mirrorNeonPanel(
            borderColor: character.glow,
            radius: 38,
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              Positioned(
                top: 30,
                child: Text(
                  character.title,
                  textAlign: TextAlign.center,
                  style: BeyondTheme.cardTitle(size: 30),
                ),
              ),

              Positioned(
                bottom: 10,
                child: Container(
                  width: 390,
                  height: 440,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: character.glow.withOpacity(0.45),
                        blurRadius: 95,
                        spreadRadius: 18,
                      ),
                    ],
                  ),
                  child: Image.asset(character.imagePath, fit: BoxFit.contain),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CharacterCard extends StatelessWidget {
  final _CharacterOption character;
  final bool selected;
  final VoidCallback onTap;

  const _CharacterCard({
    required this.character,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(30),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 14, sigmaY: 14),
          child: Container(
            height: 255,
            padding: const EdgeInsets.all(16),
            decoration: BeyondTheme.mirrorNeonPanel(
              borderColor: selected
                  ? character.glow
                  : Colors.white.withOpacity(0.28),
              radius: 30,
            ),
            child: Stack(
              children: [
                Positioned.fill(
                  child: Image.asset(character.imagePath, fit: BoxFit.contain),
                ),

                Positioned(
                  left: 0,
                  right: 0,
                  bottom: 6,
                  child: Text(
                    character.title,
                    textAlign: TextAlign.center,
                    style: BeyondTheme.cardTitle(size: 20),
                  ),
                ),

                if (selected)
                  Positioned(
                    top: 6,
                    right: 6,
                    child: Icon(
                      Icons.check_circle_rounded,
                      color: character.glow,
                      size: 32,
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

class _NameField extends StatelessWidget {
  final TextEditingController controller;

  const _NameField({required this.controller});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(26),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 14, sigmaY: 14),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 6),
          decoration: BeyondTheme.mirrorNeonPanel(
            borderColor: BeyondTheme.cyan,
            radius: 26,
          ),
          child: TextField(
            controller: controller,
            textAlign: TextAlign.center,
            style: BeyondTheme.normalText(size: 22),
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText: 'Enter child name here',
              hintStyle: BeyondTheme.normalText(
                size: 18,
                color: Colors.white.withOpacity(0.55),
              ),
            ),
          ),
        ),
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
