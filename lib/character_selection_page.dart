import 'dart:ui';
import 'package:flutter/material.dart';

import 'beyond_theme.dart';
import 'mission_selection_page.dart';
import 'space_hub_page.dart';

class CharacterSelectionPage extends StatefulWidget {
  final String userLanguage;
  final int totalStars;

  const CharacterSelectionPage({
    super.key,
    required this.userLanguage,
    required this.totalStars,
  });

  @override
  State<CharacterSelectionPage> createState() => _CharacterSelectionPageState();
}

class _CharacterSelectionPageState extends State<CharacterSelectionPage> {
  final TextEditingController nameController = TextEditingController();

  int selectedIndex = 0;

  bool get isArabic => widget.userLanguage == 'ar';

  final List<_CharacterOption> characters = const [
    _CharacterOption(
      titleAr: 'رائد الفضاء',
      titleEn: 'Boy Astronaut',
      imagePath: 'assets/images/boy.png',
      glow: BeyondTheme.blue,
      praiseWordAr: 'أحسنت يا',
      praiseWordEn: 'Great job',
    ),
    _CharacterOption(
      titleAr: 'رائدة الفضاء',
      titleEn: 'Girl Astronaut',
      imagePath: 'assets/images/girl.png',
      glow: BeyondTheme.pink,
      praiseWordAr: 'أحسنت يا',
      praiseWordEn: 'Great job',
    ),
  ];

  void _goBack() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => MissionSelectionPage(
          userLanguage: widget.userLanguage,
          totalStars: widget.totalStars,
        ),
      ),
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
          content: Text(
            isArabic
                ? 'اكتب اسم الطفل أولًا ✨'
                : 'Enter the child name first ✨',
            textAlign: TextAlign.center,
            style: const TextStyle(fontWeight: FontWeight.bold),
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
          praiseWord: isArabic ? selected.praiseWordAr : selected.praiseWordEn,
          characterImage: selected.imagePath,
          userLanguage: widget.userLanguage,
          totalStars: widget.totalStars,
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
                      _GlassTitle(isArabic: isArabic),
                      const Spacer(),
                      _StarsBadge(totalStars: widget.totalStars),
                    ],
                  ),

                  const SizedBox(height: 12),

                  Text(
                    isArabic ? 'اختر شخصية الطفل' : 'Choose Your Character',
                    textDirection: isArabic
                        ? TextDirection.rtl
                        : TextDirection.ltr,
                    style: isArabic
                        ? BeyondTheme.arabicTitle(size: 30)
                        : BeyondTheme.title(size: 30),
                  ),

                  const SizedBox(height: 6),

                  Text(
                    isArabic
                        ? 'اكتب اسم الطفل ثم ابدأ الرحلة'
                        : 'Enter the child name then start the adventure',
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
                          child: _PreviewPanel(
                            character: selected,
                            isArabic: isArabic,
                          ),
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
                                          isArabic: isArabic,
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
                                          isArabic: isArabic,
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

                                  _NameField(
                                    controller: nameController,
                                    isArabic: isArabic,
                                  ),

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
                                      child: Text(
                                        isArabic ? '🚀 انطلق' : '🚀 Start',
                                        textAlign: TextAlign.center,
                                        style: const TextStyle(
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
  final String titleAr;
  final String titleEn;
  final String imagePath;
  final Color glow;
  final String praiseWordAr;
  final String praiseWordEn;

  const _CharacterOption({
    required this.titleAr,
    required this.titleEn,
    required this.imagePath,
    required this.glow,
    required this.praiseWordAr,
    required this.praiseWordEn,
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
  final bool isArabic;

  const _GlassTitle({required this.isArabic});

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
          child: Text(
            isArabic ? '⭐ الشخصية ⭐' : '⭐ CHARACTER ⭐',
            style: isArabic
                ? BeyondTheme.arabicTitle(size: 32)
                : BeyondTheme.title(size: 32),
          ),
        ),
      ),
    );
  }
}

class _PreviewPanel extends StatelessWidget {
  final _CharacterOption character;
  final bool isArabic;

  const _PreviewPanel({required this.character, required this.isArabic});

  @override
  Widget build(BuildContext context) {
    final title = isArabic ? character.titleAr : character.titleEn;

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
                  title,
                  textAlign: TextAlign.center,
                  textDirection: isArabic
                      ? TextDirection.rtl
                      : TextDirection.ltr,
                  style: isArabic
                      ? BeyondTheme.arabicTitle(size: 30)
                      : BeyondTheme.cardTitle(size: 30),
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
  final bool isArabic;
  final VoidCallback onTap;

  const _CharacterCard({
    required this.character,
    required this.selected,
    required this.isArabic,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final title = isArabic ? character.titleAr : character.titleEn;

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
                    title,
                    textAlign: TextAlign.center,
                    textDirection: isArabic
                        ? TextDirection.rtl
                        : TextDirection.ltr,
                    style: isArabic
                        ? BeyondTheme.arabicTitle(size: 20)
                        : BeyondTheme.cardTitle(size: 20),
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
  final bool isArabic;

  const _NameField({required this.controller, required this.isArabic});

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
            style: isArabic
                ? BeyondTheme.arabicTitle(size: 22)
                : BeyondTheme.normalText(size: 22),
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText: isArabic
                  ? 'اكتب اسم الطفل هنا'
                  : 'Enter child name here',
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
