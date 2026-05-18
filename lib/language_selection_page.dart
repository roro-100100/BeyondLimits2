import 'dart:ui';
import 'package:flutter/material.dart';

import 'beyond_theme.dart';
import 'mission_selection_page.dart';
import 'splash_screen.dart';

int globalStars = 0;

class LanguageSelectionPage extends StatelessWidget {
  const LanguageSelectionPage({super.key});

  void _goMission(BuildContext context, String language) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => MissionSelectionPage(
          userLanguage: language,
          totalStars: globalStars,
        ),
      ),
    );
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
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withOpacity(0.10),
                    BeyondTheme.bgDark.withOpacity(0.35),
                    Colors.black.withOpacity(0.58),
                  ],
                ),
              ),
            ),
          ),

          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 64, vertical: 20),
              child: Column(
                children: [
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: _CircleBackButton(
                          onTap: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const SplashScreen(),
                              ),
                            );
                          },
                        ),
                      ),

                      Center(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(34),
                          child: BackdropFilter(
                            filter: ImageFilter.blur(sigmaX: 14, sigmaY: 14),
                            child: Container(
                              width: 405,
                              height: 74,
                              alignment: Alignment.center,
                              decoration: BeyondTheme.mirrorNeonPanel(
                                borderColor: BeyondTheme.cyan,
                              ),
                              child: Text(
                                'LANGUAGE',
                                textAlign: TextAlign.center,
                                style: BeyondTheme.title(size: 32),
                              ),
                            ),
                          ),
                        ),
                      ),

                      Align(
                        alignment: Alignment.centerRight,
                        child: _StarsBadge(totalStars: globalStars),
                      ),
                    ],
                  ),

                  const SizedBox(height: 22),

                  Center(
                    child: Column(
                      children: [
                        Text(
                          'اختر لغتك الأم',
                          textAlign: TextAlign.center,
                          textDirection: TextDirection.rtl,
                          style: BeyondTheme.arabicTitle(size: 34),
                        ),

                        const SizedBox(height: 5),

                        Text(
                          'Choose your native language',
                          textAlign: TextAlign.center,
                          style: BeyondTheme.normalText(
                            size: 18,
                            color: Colors.white.withOpacity(0.85),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const Spacer(),

                  Center(
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        _LanguageCard(
                          icon: '🇸🇦',
                          title: 'العربية',
                          subtitle: 'Arabic',
                          borderColor: BeyondTheme.orange,
                          onTap: () => _goMission(context, 'ar'),
                        ),

                        const SizedBox(width: 44),

                        _LanguageCard(
                          icon: '🇬🇧',
                          title: 'English',
                          subtitle: 'الإنجليزية',
                          borderColor: BeyondTheme.cyan,
                          onTap: () => _goMission(context, 'en'),
                        ),
                      ],
                    ),
                  ),

                  const Spacer(),

                  Center(
                    child: Column(
                      children: [
                        Text(
                          'الألعاب والأنشطة التعليمية ستكون باللغة العربية',
                          textDirection: TextDirection.rtl,
                          textAlign: TextAlign.center,
                          style: BeyondTheme.normalText(
                            size: 15,
                            color: Colors.white.withOpacity(0.72),
                          ),
                        ),

                        const SizedBox(height: 3),

                        Text(
                          'Instructions will appear based on your selected language',
                          textAlign: TextAlign.center,
                          style: BeyondTheme.normalText(
                            size: 13,
                            color: Colors.white.withOpacity(0.62),
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
          height: 52,
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

class _LanguageCard extends StatefulWidget {
  final String icon;
  final String title;
  final String subtitle;
  final Color borderColor;
  final VoidCallback onTap;

  const _LanguageCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.borderColor,
    required this.onTap,
  });

  @override
  State<_LanguageCard> createState() => _LanguageCardState();
}

class _LanguageCardState extends State<_LanguageCard> {
  bool isHover = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => isHover = true),
      onExit: (_) => setState(() => isHover = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedScale(
          scale: isHover ? 1.045 : 1,
          duration: const Duration(milliseconds: 220),
          curve: Curves.easeOutBack,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(34),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
              child: Container(
                width: 318,
                height: 230,
                padding: const EdgeInsets.symmetric(
                  horizontal: 28,
                  vertical: 18,
                ),
                decoration: BeyondTheme.mirrorNeonPanel(
                  borderColor: widget.borderColor,
                  radius: 34,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      widget.icon,
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 54),
                    ),

                    const SizedBox(height: 18),

                    Text(
                      widget.title,
                      textAlign: TextAlign.center,
                      style: BeyondTheme.arabicTitle(size: 28),
                    ),

                    const SizedBox(height: 8),

                    Text(
                      widget.subtitle,
                      textAlign: TextAlign.center,
                      style: BeyondTheme.normalText(
                        size: 19,
                        color: Colors.white.withOpacity(0.85),
                      ),
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
