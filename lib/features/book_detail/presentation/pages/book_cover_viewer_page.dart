import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

/// Main UI for the BookCoverViewer screen.
@RoutePage(name: 'BookCoverViewerRoute')
class BookCoverViewerPage extends StatelessWidget {
  const BookCoverViewerPage({super.key, required this.imageUrl, required this.heroTag});

  final String? imageUrl;
  final Object heroTag;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          Center(
            child: Hero(
              tag: heroTag,
              child: (imageUrl == null || imageUrl!.isEmpty)
                  ? const Icon(Icons.menu_book_rounded, size: 160, color: Colors.white54)
                  : Image.network(imageUrl!, fit: BoxFit.contain),
            ),
          ),
          Positioned(
            top: 8,
            left: 8,
            child: SafeArea(
              child: IconButton(
                icon: const Icon(Icons.close_rounded, color: Colors.white),
                onPressed: () => context.router.maybePop(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
