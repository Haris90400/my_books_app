import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import '../../../../core/theme/app_colors.dart';

/// Represents ProfileUpdateSuccessOverlay.
class ProfileUpdateSuccessOverlay extends StatefulWidget {
  const ProfileUpdateSuccessOverlay({super.key});

  static Future<void> show(BuildContext context) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.black.withValues(alpha: 0.4),
      builder: (_) => const ProfileUpdateSuccessOverlay(),
    );
  }

  @override
  State<ProfileUpdateSuccessOverlay> createState() => _ProfileUpdateSuccessOverlayState();
}

class _ProfileUpdateSuccessOverlayState extends State<ProfileUpdateSuccessOverlay>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(vsync: this);

  static const _totalFrames = 841.0;
  static const _successStartFrame = 238.0;
  static const _successEndFrame = 423.0;

  static const _startFraction = _successStartFrame / _totalFrames;
  static const _endFraction = _successEndFrame / _totalFrames;

  void _onLoaded(LottieComposition composition) {
    // Explicit `duration:` on animateTo (rather than relying on
    // AnimationController's implicit proportional-scaling of its default
    // `duration`) — safer to compute this ourselves than to guess how
    // that scaling behaves.
    final segmentDuration = composition.duration * (_endFraction - _startFraction);
    _controller.value = _startFraction;
    _controller.animateTo(_endFraction, duration: segmentDuration).whenComplete(() {
      if (!mounted) return;
      Future.delayed(const Duration(milliseconds: 400), () {
        if (mounted) Navigator.of(context).pop();
      });
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      elevation: 0,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Lottie.asset(
            'assets/lottie/profile_success.json',
            controller: _controller,
            onLoaded: _onLoaded,
            width: 120,
            height: 120,
          ),
          const SizedBox(height: 8),
          Text(
            'Profile updated',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(color: AppColors.white),
          ),
        ],
      ),
    );
  }
}
