import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';

/// Represents BookCoverImage.
class BookCoverImage extends StatelessWidget {
  const BookCoverImage({
    super.key,
    required this.imageUrl,
    required this.width,
    required this.height,
    this.borderRadius = 12,
    this.heroTag,
  });

  final String? imageUrl;
  final double width;
  final double height;
  final double borderRadius;

  /// The hero tag property.
  final Object? heroTag;

  @override
  Widget build(BuildContext context) {
    final image = ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: SizedBox(
        width: width,
        height: height,
        child: imageUrl == null || imageUrl!.isEmpty
            ? _placeholder()
            : Image.network(
                imageUrl!,
                fit: BoxFit.cover,
                loadingBuilder: (context, child, progress) {
                  if (progress == null) return child;
                  return _placeholder(loading: true);
                },
                errorBuilder: (context, error, stackTrace) => _placeholder(),
              ),
      ),
    );

    if (heroTag == null) return image;

    return Hero(
      tag: heroTag!,
      // Default Hero flights render the DESTINATION widget mid-flight —
      // if that end's `Image.network` hasn't resolved yet, the flight
      // shows a growing spinner box instead of the cover, which reads as
      // "no animation happened." Forcing the flight to always use
      // whichever side is ALREADY built (the one the user just saw,
      // fully loaded) makes the growing-cover motion visible regardless
      // of the destination's network timing.
      flightShuttleBuilder: (flightContext, animation, direction, fromContext, toContext) {
        final activeContext = direction == HeroFlightDirection.push ? fromContext : toContext;
        return (activeContext.widget as Hero).child;
      },
      child: image,
    );
  }

  Widget _placeholder({bool loading = false}) {
    return ColoredBox(
      color: AppColors.primary.withValues(alpha: 0.08),
      child: Center(
        child: loading
            ? const SizedBox(
                width: 18,
                height: 18,
                child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.primary),
              )
            : const Icon(Icons.menu_book_rounded, color: AppColors.primary, size: 28),
      ),
    );
  }
}
