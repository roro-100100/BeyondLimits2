import 'dart:ui';
import 'package:flutter/material.dart';

import 'beyond_theme.dart';
import 'character_selection_page.dart';
import 'language_selection_page.dart';

class MissionSelectionPage extends StatelessWidget {
  final String userLanguage;
  final int totalStars;

  const MissionSelectionPage({
    super.key,
    required this.userLanguage,
    required this.totalStars,
  });

  bool get isArabic => userLanguage == 'ar';

  void _goCharacter(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => CharacterSelectionPage(
          userLanguage: userLanguage,
          totalStars: totalStars,
        ),
      ),
    );
  }

  void _lockedMessage(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: BeyondTheme.purple,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        content: Text(
          isArabic ? 'قريبًا ✨' : 'Coming Soon ✨',
          textAlign: TextAlign.center,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final pageTitle = isArabic ? '⭐ مهمة العمر ⭐' : '⭐ AGE MISSION ⭐';
    final mainTitle = isArabic
        ? 'اختر مرحلتك العمرية'
        : 'Choose your age level';
    final subtitle = isArabic
        ? 'كل مرحلة مناسبة لعمر الطفل'
        : 'Each level is designed for the child age';
    final bottomText = isArabic
        ? 'كل مرحلة مصممة بطريقة مناسبة لعمر الطفل'
        : 'Each level is designed for the child age';

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
                    BeyondTheme.bgDark.withOpacity(0.35),
                    Colors.black.withOpacity(0.55),
                  ],
                ),
              ),
            ),
          ),

          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 52, vertical: 22),
              child: Column(
                children: [
                  Row(
                    children: [
                      _BackButton(
                        onTap: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const LanguageSelectionPage(),
                            ),
                          );
                        },
                      ),

                      const Spacer(),

                      ClipRRect(
                        borderRadius: BorderRadius.circular(32),
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 14, sigmaY: 14),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 52,
                              vertical: 14,
                            ),
                            decoration: BeyondTheme.mirrorNeonPanel(
                              borderColor: BeyondTheme.violet,
                            ),
                            child: Text(
                              pageTitle,
                              textAlign: TextAlign.center,
                              style: isArabic
                                  ? BeyondTheme.arabicTitle(size: 30)
                                  : BeyondTheme.title(size: 30),
                            ),
                          ),
                        ),
                      ),

                      const Spacer(),

                      _StarsBadge(totalStars: totalStars),
                    ],
                  ),

                  const SizedBox(height: 18),

                  Text(
                    mainTitle,
                    textDirection: isArabic
                        ? TextDirection.rtl
                        : TextDirection.ltr,
                    textAlign: TextAlign.center,
                    style: isArabic
                        ? BeyondTheme.arabicTitle(size: 31)
                        : BeyondTheme.title(size: 29),
                  ),

                  const SizedBox(height: 6),

                  Text(
                    subtitle,
                    textAlign: TextAlign.center,
                    style: BeyondTheme.normalText(
                      size: 16,
                      color: Colors.white.withOpacity(0.82),
                    ),
                  ),

                  const Spacer(),

                  Row(
                    children: [
                      Expanded(
                        child: _MissionCard(
                          icon: '🚀',
                          title: isArabic
                              ? 'مستكشفين الفضاء'
                              : 'Space Explorers',
                          age: 'KG 1 - KG 3',
                          hint: isArabic ? 'ابدأ الرحلة' : 'Start Mission',
                          borderColor: BeyondTheme.cyan,
                          locked: false,
                          isArabic: isArabic,
                          onTap: () => _goCharacter(context),
                        ),
                      ),

                      const SizedBox(width: 28),

                      Expanded(
                        child: _MissionCard(
                          icon: '🏆',
                          title: isArabic ? 'أبطال الفضاء' : 'Space Heroes',
                          age: 'Grade 1 - Grade 3',
                          hint: isArabic ? 'قريبًا' : 'Coming Soon',
                          borderColor: BeyondTheme.violet,
                          locked: true,
                          isArabic: isArabic,
                          onTap: () => _lockedMessage(context),
                        ),
                      ),

                      const SizedBox(width: 28),

                      Expanded(
                        child: _MissionCard(
                          icon: '🧑‍🚀',
                          title: isArabic ? 'رواد الفضاء' : 'Space Astronauts',
                          age: 'Grade 4 - Grade 6',
                          hint: isArabic ? 'قريبًا' : 'Coming Soon',
                          borderColor: BeyondTheme.orange,
                          locked: true,
                          isArabic: isArabic,
                          onTap: () => _lockedMessage(context),
                        ),
                      ),
                    ],
                  ),

                  const Spacer(),

                  Text(
                    bottomText,
                    textAlign: TextAlign.center,
                    style: BeyondTheme.normalText(
                      size: 16,
                      color: Colors.white.withOpacity(0.70),
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

class _MissionCard extends StatefulWidget {
  final String icon;
  final String title;
  final String age;
  final String hint;
  final Color borderColor;
  final bool locked;
  final bool isArabic;
  final VoidCallback onTap;

  const _MissionCard({
    required this.icon,
    required this.title,
    required this.age,
    required this.hint,
    required this.borderColor,
    required this.locked,
    required this.isArabic,
    required this.onTap,
  });

  @override
  State<_MissionCard> createState() => _MissionCardState();
}

class _MissionCardState extends State<_MissionCard> {
  bool hover = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => hover = true),
      onExit: (_) => setState(() => hover = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedScale(
          scale: hover ? 1.035 : 1,
          duration: const Duration(milliseconds: 220),
          curve: Curves.easeOutBack,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(34),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
              child: Container(
                height: 300,
                padding: const EdgeInsets.all(26),
                decoration: BeyondTheme.mirrorNeonPanel(
                  borderColor: widget.borderColor,
                  radius: 34,
                ),
                child: Stack(
                  children: [
                    if (widget.locked)
                      Positioned(
                        top: 0,
                        right: 0,
                        child: Icon(
                          Icons.lock_rounded,
                          color: Colors.white.withOpacity(0.78),
                          size: 30,
                        ),
                      ),

                    Column(
                      crossAxisAlignment: widget.isArabic
                          ? CrossAxisAlignment.end
                          : CrossAxisAlignment.start,
                      children: [
                        Text(widget.icon, style: const TextStyle(fontSize: 52)),

                        const Spacer(),

                        Text(
                          widget.title,
                          textDirection: widget.isArabic
                              ? TextDirection.rtl
                              : TextDirection.ltr,
                          textAlign: widget.isArabic
                              ? TextAlign.right
                              : TextAlign.left,
                          style: widget.isArabic
                              ? BeyondTheme.arabicTitle(size: 25)
                              : BeyondTheme.cardTitle(size: 25),
                        ),

                        const SizedBox(height: 12),

                        Text(
                          widget.age,
                          style: BeyondTheme.cardSubtitle(
                            size: 20,
                            color: widget.borderColor,
                          ),
                        ),

                        const SizedBox(height: 12),

                        Container(
                          width: 130,
                          height: 1.4,
                          color: Colors.white.withOpacity(0.32),
                        ),

                        const SizedBox(height: 14),

                        Row(
                          textDirection: widget.isArabic
                              ? TextDirection.rtl
                              : TextDirection.ltr,
                          children: [
                            Text(
                              widget.hint,
                              style: BeyondTheme.normalText(
                                size: 15,
                                color: Colors.white.withOpacity(0.85),
                              ),
                            ),
                            const Spacer(),
                            Text(
                              widget.locked ? '🔒' : '⭐',
                              style: TextStyle(
                                fontSize: 28,
                                shadows: [
                                  Shadow(
                                    color: widget.borderColor,
                                    blurRadius: 16,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
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
      borderRadius: BorderRadius.circular(24),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
        child: Container(
          height: 54,
          padding: const EdgeInsets.symmetric(horizontal: 18),
          decoration: BeyondTheme.mirrorNeonPanel(
            borderColor: BeyondTheme.orange,
            radius: 24,
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

class _BackButton extends StatelessWidget {
  final VoidCallback onTap;

  const _BackButton({required this.onTap});

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
