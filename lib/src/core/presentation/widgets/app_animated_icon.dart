import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:flutter_animated_icons/icons8.dart';
import 'package:flutter_animated_icons/lottiefiles.dart';

/// A reusable widget to display animated icons using flutter_animated_icons (Lottie).
class AppAnimatedIcon extends StatefulWidget {
  final String iconPath;
  final double size;
  final Color? color;
  final bool loop;
  final bool autoPlay;

  const AppAnimatedIcon({
    super.key,
    required this.iconPath,
    this.size = 50,
    this.color,
    this.loop = true,
    this.autoPlay = true,
  });

  @override
  State<AppAnimatedIcon> createState() => _AppAnimatedIconState();

  /// Shows a success snackbar with an animated icon.
  static void showSuccess(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        content: Row(
          children: [
            AppAnimatedIcon(
              iconPath: AppAnimatedIcons.success,
              size: 32,
              loop: false,
            ),
            const SizedBox(width: 12),
            Expanded(child: Text(message)),
          ],
        ),
      ),
    );
  }
}

class _AppAnimatedIconState extends State<AppAnimatedIcon> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2), // Default duration, Lottie will override if needed
    );

    if (widget.autoPlay) {
      if (widget.loop) {
        _controller.repeat();
      } else {
        _controller.forward();
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Lottie.asset(
      widget.iconPath,
      controller: _controller,
      width: widget.size,
      height: widget.size,
      fit: BoxFit.contain,
      onLoaded: (composition) {
        _controller.duration = composition.duration;
        if (widget.autoPlay) {
          if (widget.loop) {
            _controller.repeat();
          } else {
            _controller.forward();
          }
        }
      },
    );
  }
}

/// Common Animated Icon paths for the project.
class AppAnimatedIcons {
  /// Welcome / User animated icon
  static final String welcome = Icons8.user_male;
  
  /// Archive / Box animated icon
  static final String archive = Icons8.box;
  
  /// Goal / Target animated icon
  static final String target = LottieFiles.$33303_target_icon;
  
  /// Planner / Calendar / Notebook animated icon
  static final String notebook = Icons8.calendar;

  /// Success / Checkmark animated icon
  static final String success = Icons8.checkmark_ok;

  /// Error / Warning animated icon
  static final String error = Icons8.warning_blink;

  /// Settings / Palette animated icon
  static final String palette = Icons8.settings_color;
}
