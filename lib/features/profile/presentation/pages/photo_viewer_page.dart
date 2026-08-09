import 'dart:io';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

/// Main UI for the PhotoViewer screen.
@RoutePage(name: 'PhotoViewerRoute')
class PhotoViewerPage extends StatelessWidget {
  const PhotoViewerPage({super.key, required this.photoPath});

  final String? photoPath;

  bool get _isNetworkUrl => photoPath != null && photoPath!.startsWith('http');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          Center(
            child: Hero(
              tag: 'profile-avatar',
              child: photoPath == null
                  ? const Icon(Icons.person_rounded, size: 160, color: Colors.white54)
                  : (_isNetworkUrl ? Image.network(photoPath!) : Image.file(File(photoPath!))),
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
