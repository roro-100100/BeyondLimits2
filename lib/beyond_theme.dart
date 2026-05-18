import 'package:flutter/material.dart';

class BeyondTheme {
  BeyondTheme._();

  static const Color bgDark = Color(0xFF12002F);
  static const Color bgNavy = Color(0xFF18004B);
  static const Color purple = Color(0xFF6A00FF);
  static const Color violet = Color(0xFFB388FF);
  static const Color cyan = Color(0xFF7DF9FF);
  static const Color blue = Color(0xFF3DDCFF);
  static const Color yellow = Color(0xFFFFD84D);
  static const Color orange = Color(0xFFFFB347);
  static const Color pink = Color(0xFFFF5E7E);
  static const Color white = Colors.white;

  static const LinearGradient spaceBackground = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      Color(0xFF050018),
      Color(0xFF12002F),
      Color(0xFF1B004B),
      Color(0xFF2B0673),
    ],
  );

  static const LinearGradient blueCard = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF062CFF), Color(0xFF09005F)],
  );

  static const LinearGradient purpleCard = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF6A00FF), Color(0xFF22005F)],
  );

  static const LinearGradient orangeCard = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFFFF8A00), Color(0xFF4B0038)],
  );

  static BoxDecoration pageBackground() {
    return const BoxDecoration(gradient: spaceBackground);
  }

  static BoxDecoration glassCard({
    Color borderColor = cyan,
    Gradient? gradient,
  }) {
    return BoxDecoration(
      gradient: gradient ?? purpleCard,
      borderRadius: BorderRadius.circular(30),
      border: Border.all(color: borderColor, width: 3),
      boxShadow: [
        BoxShadow(
          color: borderColor.withOpacity(0.45),
          blurRadius: 25,
          spreadRadius: 2,
        ),
      ],
    );
  }

  static BoxDecoration glowButton() {
    return BoxDecoration(
      gradient: const LinearGradient(
        colors: [Color(0xFF3DDCFF), Color(0xFF6A00FF)],
      ),
      borderRadius: BorderRadius.circular(40),
      border: Border.all(color: white, width: 1.5),
      boxShadow: [
        BoxShadow(
          color: cyan.withOpacity(0.55),
          blurRadius: 22,
          spreadRadius: 2,
        ),
      ],
    );
  }

  static TextStyle title({double size = 46, Color color = white}) {
    return TextStyle(
      fontSize: size,
      fontWeight: FontWeight.w900,
      color: color,
      letterSpacing: 1.2,
      shadows: const [Shadow(color: cyan, blurRadius: 18)],
    );
  }

  static TextStyle arabicTitle({double size = 32, Color color = white}) {
    return TextStyle(
      fontSize: size,
      fontWeight: FontWeight.w800,
      color: color,
      shadows: const [Shadow(color: purple, blurRadius: 14)],
    );
  }

  static TextStyle cardTitle({double size = 30}) {
    return TextStyle(
      fontSize: size,
      fontWeight: FontWeight.w900,
      color: white,
      height: 1.1,
    );
  }

  static TextStyle cardSubtitle({double size = 20, Color color = cyan}) {
    return TextStyle(fontSize: size, fontWeight: FontWeight.w800, color: color);
  }

  static TextStyle normalText({double size = 18, Color color = white}) {
    return TextStyle(fontSize: size, fontWeight: FontWeight.w600, color: color);
  }

  static ThemeData themeData() {
    return ThemeData(
      useMaterial3: true,
      fontFamily: 'Arial',
      scaffoldBackgroundColor: bgDark,
      colorScheme: ColorScheme.fromSeed(
        seedColor: purple,
        brightness: Brightness.dark,
      ),
    );
  }

  static BoxDecoration missionHeader() {
    return BoxDecoration(
      gradient: const LinearGradient(
        colors: [Color(0xFF6A00FF), Color(0xFF22005F)],
      ),
      borderRadius: BorderRadius.circular(30),
      border: Border.all(color: cyan, width: 2),
      boxShadow: [
        BoxShadow(
          color: purple.withOpacity(0.55),
          blurRadius: 25,
          spreadRadius: 2,
        ),
      ],
    );
  }

  static BoxDecoration missionCard({
    required Gradient gradient,
    required Color borderColor,
  }) {
    return BoxDecoration(
      gradient: gradient,
      borderRadius: BorderRadius.circular(28),
      border: Border.all(color: borderColor, width: 3),
      boxShadow: [
        BoxShadow(
          color: borderColor.withOpacity(0.45),
          blurRadius: 24,
          spreadRadius: 1,
        ),
      ],
    );
  }

  static BoxDecoration mirrorNeonPanel({
    Color borderColor = cyan,
    double radius = 34,
  }) {
    return BoxDecoration(
      borderRadius: BorderRadius.circular(radius),
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          Colors.white.withOpacity(0.18),
          Colors.white.withOpacity(0.06),
          borderColor.withOpacity(0.10),
        ],
      ),
      border: Border.all(color: borderColor.withOpacity(0.85), width: 2.4),
      boxShadow: [
        BoxShadow(
          color: borderColor.withOpacity(0.50),
          blurRadius: 30,
          spreadRadius: 1.5,
        ),
        BoxShadow(
          color: purple.withOpacity(0.35),
          blurRadius: 50,
          spreadRadius: 4,
        ),
      ],
    );
  }

  static BoxDecoration softDarkOverlay() {
    return BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          Colors.black.withOpacity(0.20),
          bgDark.withOpacity(0.55),
          Colors.black.withOpacity(0.65),
        ],
      ),
    );
  }
}
