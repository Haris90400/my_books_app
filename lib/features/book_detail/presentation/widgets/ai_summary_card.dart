import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';

/// Represents AiSummaryCard.
class AiSummaryCard extends StatelessWidget {
  const AiSummaryCard({super.key, required this.isLoading, this.summary, this.hasError = false});

  final bool isLoading;
  final String? summary;
  final bool hasError;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.15)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.auto_awesome_rounded, size: 18, color: AppColors.primary),
              const SizedBox(width: 8),
              Text(
                'AI Summary',
                style: AppTextStyles.titleMedium.copyWith(color: AppColors.primary, fontWeight: FontWeight.w700),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _buildBody(),
        ],
      ),
    );
  }

  Widget _buildBody() {
    if (isLoading) {
      return Shimmer.fromColors(
        baseColor: AppColors.textMuted.withValues(alpha: 0.25),
        highlightColor: AppColors.textMuted.withValues(alpha: 0.08),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _shimmerLine(width: double.infinity),
            const SizedBox(height: 8),
            _shimmerLine(width: double.infinity),
            const SizedBox(height: 8),
            _shimmerLine(width: 160),
          ],
        ),
      );
    }

    if (hasError || summary == null) {
      return Text(
        'Summary could not be generated right now.',
        style: AppTextStyles.bodySmall.copyWith(color: AppColors.textMuted),
      );
    }

    return _TypewriterText(text: summary!, style: AppTextStyles.bodyMedium.copyWith(height: 1.5));
  }

  Widget _shimmerLine({required double width}) {
    return Container(width: width, height: 12, decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(6)));
  }
}

/// Represents _TypewriterText.
class _TypewriterText extends StatefulWidget {
  const _TypewriterText({required this.text, required this.style});

  final String text;
  final TextStyle style;

  @override
  State<_TypewriterText> createState() => _TypewriterTextState();
}

class _TypewriterTextState extends State<_TypewriterText> with SingleTickerProviderStateMixin {
  static const _msPerChar = 18;
  static const _minDuration = Duration(milliseconds: 300);
  static const _maxDuration = Duration(milliseconds: 2500);

  late AnimationController _controller;
  late Animation<int> _charCount;

  @override
  void initState() {
    super.initState();
    _startAnimation();
  }

  @override
  void didUpdateWidget(covariant _TypewriterText oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.text != widget.text) {
      _controller.dispose();
      _startAnimation();
    }
  }

  void _startAnimation() {
    final estimated = Duration(milliseconds: widget.text.length * _msPerChar);
    final duration = estimated < _minDuration
        ? _minDuration
        : (estimated > _maxDuration ? _maxDuration : estimated);

    _controller = AnimationController(vsync: this, duration: duration);
    _charCount = StepTween(begin: 0, end: widget.text.length).animate(_controller);
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _charCount,
      builder: (context, _) => Text(widget.text.substring(0, _charCount.value), style: widget.style),
    );
  }
}
