import 'package:flutter/material.dart';

enum ButtonType { number, operator, action, equals }

class CalcButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  final ButtonType type;
  final IconData? icon;
  final int flex;

  const CalcButton({
    super.key,
    required this.label,
    required this.onTap,
    this.type = ButtonType.number,
    this.icon,
    this.flex = 1,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    Color backgroundColor;
    Color textColor;

    switch (type) {
      case ButtonType.operator:
        backgroundColor = isDark ? const Color(0xFFFF9F0A) : const Color(0xFFF1A33C);
        textColor = Colors.white;
        break;
      case ButtonType.action:
        backgroundColor = isDark ? const Color(0xFF3A3A3C) : const Color(0xFFD4D4D2);
        textColor = isDark ? const Color(0xFFFF453A) : const Color(0xFFD32F2F);
        break;
      case ButtonType.equals:
        backgroundColor = const Color(0xFF34C759);
        textColor = Colors.white;
        break;
      case ButtonType.number:
      default:
        backgroundColor = isDark ? const Color(0xFF2C2C2E) : const Color(0xFFE5E5EA);
        textColor = isDark ? Colors.white : Colors.black87;
        break;
    }

    return Expanded(
      flex: flex,
      child: Padding(
        padding: const EdgeInsets.all(6.0),
        child: Material(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(20),
          elevation: isDark ? 0 : 2,
          clipBehavior: Clip.antiAlias,
          child: InkWell(
            onTap: onTap,
            splashColor: Colors.white24,
            highlightColor: Colors.white12,
            child: Center(
              child: icon != null
                  ? Icon(icon, color: textColor, size: 28)
                  : Text(
                      label,
                      style: TextStyle(
                        color: textColor,
                        fontSize: 26,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.5,
                      ),
                    ),
            ),
          ),
        ),
      ),
    );
  }
}
