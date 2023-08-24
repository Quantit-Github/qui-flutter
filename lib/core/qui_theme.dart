import 'package:flutter/material.dart';
import 'package:qui_flutter/core/theme_manager.dart';
import 'package:qui_flutter/core/theme_preferences.dart';
import 'package:qui_flutter/style/color_pallete.dart';
import 'package:qui_flutter/style/theme.dart';

///
/// Material App builder with custom theme.
///
typedef ThemeBuilder = Widget Function(
  ThemeData light,
  ThemeData dark,
  ThemeMode mode,
);

///
/// Custom theme widget.
///
class QuiTheme extends StatefulWidget {
  /// Default value [ThemeMode.system]
  final ThemeMode initThemeMode;

  /// [builder] function define.
  final ThemeBuilder builder;

  /// [lightTheme] define.
  final ThemeData? lightTheme;

  /// [darkTheme] define.
  final ThemeData? darkTheme;

  final QuiColorPalette? colorPaletteLight;
  final QuiColorPalette? colorPaletteDark;

  const QuiTheme({
    this.initThemeMode = ThemeMode.system,
    required this.builder,
    this.darkTheme,
    this.lightTheme,
    this.colorPaletteLight,
    this.colorPaletteDark,
    super.key,
  });

  /// [of] function define.
  static QuiThemeManager of(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<InheritedCustomTheme>()!
        .themeManager;
  }

  /// [getThemeMode] function define.
  /// return of [ThemeMode] from shared preferences .
  static Future<ThemeMode> getThemeMode() async {
    return await QuiThemePreferences().getThemeMode();
  }

  @override
  State<QuiTheme> createState() => _QuiThemeState();
}

class _QuiThemeState extends State<QuiTheme> with QuiThemeManager {
  @override
  void initState() {
    initTheme(
      themeMode: widget.initThemeMode,
      light: widget.lightTheme ?? QuiThemeData.light,
      dark: widget.darkTheme ?? QuiThemeData.dark,
      colorPaletteLight: widget.colorPaletteLight,
      colorPaletteDark: widget.colorPaletteDark,
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
        valueListenable: themeMode,
        builder: (context, value, _) {
          return InheritedCustomTheme(
            themeManager: this,
            themeMode: widget.initThemeMode,
            child: widget.builder(
              lightTheme,
              darkTheme,
              value,
            ),
          );
        });
  }
}

class InheritedCustomTheme extends InheritedWidget {
  final ThemeMode themeMode;
  final QuiThemeManager themeManager;

  const InheritedCustomTheme({
    required this.themeMode,
    required this.themeManager,
    super.key,
    required super.child,
  });

  @override
  bool updateShouldNotify(InheritedCustomTheme oldWidget) {
    return themeMode != oldWidget.themeMode;
  }
}