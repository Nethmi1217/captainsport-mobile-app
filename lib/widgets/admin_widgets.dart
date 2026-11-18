import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../models/product_model.dart';

/// Core Black Card with subtle Red Accent styling
/// Adheres directly to:
/// "primary red accent red dark black card black background light grey"
class CaptainBlackCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final VoidCallback? onTap;
  final bool hasRedLeftGlow;

  const CaptainBlackCard({
    Key? key,
    required this.child,
    this.padding,
    this.margin,
    this.onTap,
    this.hasRedLeftGlow = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin ?? const EdgeInsets.symmetric(vertical: 6, horizontal: 16),
      decoration: BoxDecoration(
        color: AppTheme.cardBlack,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: hasRedLeftGlow ? AppTheme.accentRed.withOpacity(0.6) : AppTheme.borderSubtleRed,
          width: 1.2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.35),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
          if (hasRedLeftGlow)
            BoxShadow(
              color: AppTheme.primaryRed.withOpacity(0.2),
              blurRadius: 12,
              offset: const Offset(-2, 0),
            ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          splashColor: AppTheme.primaryRed.withOpacity(0.15),
          highlightColor: AppTheme.accentRed.withOpacity(0.08),
          child: Padding(
            padding: padding ?? const EdgeInsets.all(16.0),
            child: child,
          ),
        ),
      ),
    );
  }
}

/// Stock status badge with athletic red/warning/success pills
class StockStatusBadge extends StatelessWidget {
  final StockStatus status;
  final int count;

  const StockStatusBadge({
    Key? key,
    required this.status,
    required this.count,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Color bg;
    Color fg;
    String label;
    IconData icon;

    switch (status) {
      case StockStatus.inStock:
        bg = const Color(0xFF064E3B).withOpacity(0.7);
        fg = const Color(0xFF34D399);
        label = 'In Stock ($count)';
        icon = Icons.check_circle_outline;
        break;
      case StockStatus.lowStock:
        bg = const Color(0xFF7F1D1D).withOpacity(0.6);
        fg = AppTheme.accentRed;
        label = 'Low Stock ($count)';
        icon = Icons.warning_amber_rounded;
        break;
      case StockStatus.outOfStock:
        bg = AppTheme.primaryRedDark.withOpacity(0.85);
        fg = Colors.white;
        label = 'Out of Stock';
        icon = Icons.cancel_outlined;
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: fg.withOpacity(0.5), width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: fg),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              color: fg,
              fontSize: 11,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.3,
            ),
          ),
        ],
      ),
    );
  }
}

/// Executive KPI Metric Card displayed in Black Cards with Red accents
class KpiMetricCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color? accentColor;
  final String? subtitle;

  const KpiMetricCard({
    Key? key,
    required this.title,
    required this.value,
    required this.icon,
    this.accentColor,
    this.subtitle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final effectiveAccent = accentColor ?? AppTheme.accentRed;

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppTheme.cardBlack,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: effectiveAccent.withOpacity(0.35), width: 1.2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.25),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title.toUpperCase(),
                style: const TextStyle(
                  color: AppTheme.textMutedGrey,
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.8,
                ),
              ),
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: effectiveAccent.withOpacity(0.18),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, size: 18, color: effectiveAccent),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              color: AppTheme.textWhite,
              fontSize: 22,
              fontWeight: FontWeight.bold,
              letterSpacing: -0.5,
              shadows: [
                Shadow(
                  color: effectiveAccent.withOpacity(0.4),
                  blurRadius: 6,
                )
              ],
            ),
          ),
          if (subtitle != null) ...[
            const SizedBox(height: 4),
            Text(
              subtitle!,
              style: TextStyle(
                color: effectiveAccent,
                fontSize: 11,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

/// Primary Red Athletic Button with glowing gradient
class CaptainPrimaryButton extends StatelessWidget {
  final String label;
  final IconData? icon;
  final VoidCallback? onPressed;
  final bool isFullWidth;
  final bool isSecondary;

  const CaptainPrimaryButton({
    Key? key,
    required this.label,
    this.icon,
    required this.onPressed,
    this.isFullWidth = true,
    this.isSecondary = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final buttonContent = Row(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: isFullWidth ? MainAxisSize.max : MainAxisSize.min,
      children: [
        if (icon != null) ...[
          Icon(icon, size: 18, color: isSecondary ? AppTheme.accentRed : Colors.white),
          const SizedBox(width: 8),
        ],
        Text(
          label,
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.4,
            color: isSecondary ? AppTheme.accentRed : Colors.white,
          ),
        ),
      ],
    );

    if (isSecondary) {
      return OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          side: const BorderSide(color: AppTheme.primaryRed, width: 1.5),
          backgroundColor: AppTheme.cardBlack,
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
        child: buttonContent,
      );
    }

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        gradient: const LinearGradient(
          colors: [AppTheme.primaryRed, AppTheme.accentRed],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        boxShadow: [
          BoxShadow(
            color: AppTheme.primaryRed.withOpacity(0.4),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
        child: buttonContent,
      ),
    );
  }
}

/// Sports Department Filter Chip
class SportDepartmentFilterChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onSelected;

  const SportDepartmentFilterChip({
    Key? key,
    required this.label,
    required this.isSelected,
    required this.onSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onSelected,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 9),
        margin: const EdgeInsets.only(right: 8),
        decoration: BoxDecoration(
          color: isSelected ? AppTheme.primaryRed : AppTheme.cardBlack,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: isSelected ? AppTheme.accentRed : const Color(0xFF33333D),
            width: 1.2,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: AppTheme.primaryRed.withOpacity(0.35),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  )
                ]
              : null,
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : AppTheme.textMutedGrey,
            fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
            fontSize: 13,
          ),
        ),
      ),
    );
  }
}
