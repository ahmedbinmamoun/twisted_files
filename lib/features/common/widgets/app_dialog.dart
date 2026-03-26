import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:twisted_files/core/constants/app_colors.dart';
import 'package:twisted_files/core/constants/app_style.dart';

/// زر واحد في الـ dialog
class AppDialogAction {
  final String label;
  final VoidCallback onPressed;
  final bool isPrimary;

  const AppDialogAction({
    required this.label,
    required this.onPressed,
    this.isPrimary = false,
  });
}

/// Custom Dialog قابل للاستخدام في كل التطبيق
///
/// الاستخدام:
/// ```dart
/// AppDialog.show(
///   context,
///   imagePath: AppAssets.caseClosedSticker,
///   title:     'Re-Investigation',
///   summary:   'This will reset your score.',
///   actions: [
///     AppDialogAction(label: 'Cancel',  onPressed: () => Navigator.pop(context)),
///     AppDialogAction(label: 'Confirm', isPrimary: true, onPressed: () { ... }),
///   ],
/// );
/// ```
class AppDialog extends StatelessWidget {
  final String imagePath;
  final bool isNetworkImage;
  final String title;
  final String? summary;
  final List<AppDialogAction> actions;
  final double? imageHeight;
  final bool barrierDismissible;

  const AppDialog({
    super.key,
    required this.imagePath,
    required this.title,
    required this.actions,
    this.summary,
    this.isNetworkImage = false,
    this.imageHeight,
    this.barrierDismissible = true,
  });

  /// Static helper — اعرض الـ dialog من أي مكان
  static Future<void> show(
    BuildContext context, {
    required String imagePath,
    required String title,
    String? summary,
    bool isNetworkImage = false,
    double? imageHeight,
    bool barrierDismissible = true,
    required List<AppDialogAction> actions,
  }) {
    return showDialog(
      context: context,
      barrierDismissible: barrierDismissible,
      barrierColor: Colors.black54,
      builder: (_) => AppDialog(
        imagePath: imagePath,
        title: title,
        summary: summary,
        isNetworkImage: isNetworkImage,
        imageHeight: imageHeight,
        barrierDismissible: barrierDismissible,
        actions: actions,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 40.h),
      child: _DialogCard(
        imagePath: imagePath,
        isNetworkImage: isNetworkImage,
        title: title,
        summary: summary,
        actions: actions,
        imageHeight: imageHeight ?? 200.h,
      ),
    );
  }
}

// ── الـ Card الداخلية ─────────────────────────────────────────────────────────
class _DialogCard extends StatelessWidget {
  final String imagePath;
  final bool isNetworkImage;
  final String title;
  final String? summary;
  final List<AppDialogAction> actions;
  final double imageHeight;

  const _DialogCard({
    required this.imagePath,
    required this.isNetworkImage,
    required this.title,
    required this.summary,
    required this.actions,
    required this.imageHeight,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20.r),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // ── النصف الفوقاني — الصورة ──────────────────────────────────────
          _ImageSection(
            imagePath: imagePath,
            isNetworkImage: isNetworkImage,
            height: imageHeight,
          ),

          // ── النصف التحتاني — المحتوى ─────────────────────────────────────
          Container(
            width: double.infinity,
            padding: EdgeInsets.fromLTRB(20.w, 24.h, 20.w, 20.h),
            color: AppColors.offWhiteColor,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // العنوان
                Text(
                  title,
                  textAlign: TextAlign.center,
                  style: AppStyles.mediumTitle.copyWith(
                    color: AppColors.primaryColor,
                  ),
                ),

                // الـ summary
                if (summary != null && summary!.isNotEmpty) ...[
                  SizedBox(height: 10.h),
                  Text(
                    summary!,
                    textAlign: TextAlign.center,
                    style: AppStyles.mediumBody.copyWith(
                      color: AppColors.lightBlack,
                      height: 1.5,
                    ),
                  ),
                ],

                SizedBox(height: 24.h),

                // الأزرار
                _ActionsSection(actions: actions),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ── قسم الصورة ───────────────────────────────────────────────────────────────
class _ImageSection extends StatelessWidget {
  final String imagePath;
  final bool isNetworkImage;
  final double height;

  const _ImageSection({
    required this.imagePath,
    required this.isNetworkImage,
    required this.height,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: height,
      child: isNetworkImage
          ? Image.network(
              imagePath,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => _placeholder(),
            )
          : Image.asset(
              imagePath,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => _placeholder(),
            ),
    );
  }

  Widget _placeholder() => Container(
        color: AppColors.primaryColor.withOpacity(0.1),
        child: Center(
          child: Icon(
            Icons.image_not_supported_outlined,
            size: 48,
            color: AppColors.primaryColor.withOpacity(0.4),
          ),
        ),
      );
}

// ── قسم الأزرار ──────────────────────────────────────────────────────────────
class _ActionsSection extends StatelessWidget {
  final List<AppDialogAction> actions;
  const _ActionsSection({required this.actions});

  @override
  Widget build(BuildContext context) {
    if (actions.isEmpty) return const SizedBox.shrink();

    // زر واحد → عرض كامل
    if (actions.length == 1) {
      return _buildButton(actions.first, fullWidth: true);
    }

    // زرين أو أكثر → صف أفقي
    return Row(
      children: actions.asMap().entries.map((entry) {
        final isLast = entry.key == actions.length - 1;
        return Expanded(
          child: Padding(
            padding: EdgeInsets.only(
              left: isLast && actions.length > 1 ? 8.w : 0,
            ),
            child: _buildButton(entry.value, fullWidth: false),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildButton(AppDialogAction action, {required bool fullWidth}) {
    return SizedBox(
      width: fullWidth ? double.infinity : null,
      height: 48.h,
      child: action.isPrimary
          ? ElevatedButton(
              onPressed: action.onPressed,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryColor,
                foregroundColor: AppColors.scenderyColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.r),
                ),
                elevation: 0,
              ),
              child: Text(
                action.label,
                style: AppStyles.mediumButtonText.copyWith(fontSize: 14.sp),
              ),
            )
          : OutlinedButton(
              onPressed: action.onPressed,
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.primaryColor,
                side: BorderSide(color: AppColors.primaryColor, width: 1.5),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.r),
                ),
              ),
              child: Text(
                action.label,
                style: AppStyles.mediumBody.copyWith(
                  color: AppColors.primaryColor,
                  fontWeight: FontWeight.w600,
                  fontSize: 14.sp,
                ),
              ),
            ),
    );
  }
}
