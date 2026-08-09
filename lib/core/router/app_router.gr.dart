// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

part of 'app_router.dart';

/// Represents AnalyticsTabRoute.
class AnalyticsTabRoute extends PageRouteInfo<void> {
  const AnalyticsTabRoute({List<PageRouteInfo>? children})
    : super(AnalyticsTabRoute.name, initialChildren: children);

  static const String name = 'AnalyticsTabRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const AnalyticsTabPage();
    },
  );
}

/// Represents BookCoverViewerRoute.
class BookCoverViewerRoute extends PageRouteInfo<BookCoverViewerRouteArgs> {
  BookCoverViewerRoute({
    Key? key,
    required String? imageUrl,
    required Object heroTag,
    List<PageRouteInfo>? children,
  }) : super(
         BookCoverViewerRoute.name,
         args: BookCoverViewerRouteArgs(
           key: key,
           imageUrl: imageUrl,
           heroTag: heroTag,
         ),
         initialChildren: children,
       );

  static const String name = 'BookCoverViewerRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<BookCoverViewerRouteArgs>();
      return BookCoverViewerPage(
        key: args.key,
        imageUrl: args.imageUrl,
        heroTag: args.heroTag,
      );
    },
  );
}

class BookCoverViewerRouteArgs {
  const BookCoverViewerRouteArgs({
    this.key,
    required this.imageUrl,
    required this.heroTag,
  });

  final Key? key;

  final String? imageUrl;

  final Object heroTag;

  @override
  String toString() {
    return 'BookCoverViewerRouteArgs{key: $key, imageUrl: $imageUrl, heroTag: $heroTag}';
  }
}

/// Represents BookDetailRoute.
class BookDetailRoute extends PageRouteInfo<BookDetailRouteArgs> {
  BookDetailRoute({Key? key, required Book book, List<PageRouteInfo>? children})
    : super(
        BookDetailRoute.name,
        args: BookDetailRouteArgs(key: key, book: book),
        initialChildren: children,
      );

  static const String name = 'BookDetailRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<BookDetailRouteArgs>();
      return BookDetailPage(key: args.key, book: args.book);
    },
  );
}

class BookDetailRouteArgs {
  const BookDetailRouteArgs({this.key, required this.book});

  final Key? key;

  final Book book;

  @override
  String toString() {
    return 'BookDetailRouteArgs{key: $key, book: $book}';
  }
}

/// Represents ContactsTabRoute.
class ContactsTabRoute extends PageRouteInfo<void> {
  const ContactsTabRoute({List<PageRouteInfo>? children})
    : super(ContactsTabRoute.name, initialChildren: children);

  static const String name = 'ContactsTabRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const ContactsTabPage();
    },
  );
}

/// Represents DashboardRoute.
class DashboardRoute extends PageRouteInfo<void> {
  const DashboardRoute({List<PageRouteInfo>? children})
    : super(DashboardRoute.name, initialChildren: children);

  static const String name = 'DashboardRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const DashboardShell();
    },
  );
}

/// Represents HomeSearchRoute.
class HomeSearchRoute extends PageRouteInfo<void> {
  const HomeSearchRoute({List<PageRouteInfo>? children})
    : super(HomeSearchRoute.name, initialChildren: children);

  static const String name = 'HomeSearchRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const HomeSearchPage();
    },
  );
}

/// Represents HomeTabRoute.
class HomeTabRoute extends PageRouteInfo<void> {
  const HomeTabRoute({List<PageRouteInfo>? children})
    : super(HomeTabRoute.name, initialChildren: children);

  static const String name = 'HomeTabRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const HomeTabShell();
    },
  );
}

/// Represents LoginRoute.
class LoginRoute extends PageRouteInfo<void> {
  const LoginRoute({List<PageRouteInfo>? children})
    : super(LoginRoute.name, initialChildren: children);

  static const String name = 'LoginRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const LoginPage();
    },
  );
}

/// Represents OnboardingRoute.
class OnboardingRoute extends PageRouteInfo<void> {
  const OnboardingRoute({List<PageRouteInfo>? children})
    : super(OnboardingRoute.name, initialChildren: children);

  static const String name = 'OnboardingRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const OnboardingPage();
    },
  );
}

/// Represents PhotoViewerRoute.
class PhotoViewerRoute extends PageRouteInfo<PhotoViewerRouteArgs> {
  PhotoViewerRoute({
    Key? key,
    required String? photoPath,
    List<PageRouteInfo>? children,
  }) : super(
         PhotoViewerRoute.name,
         args: PhotoViewerRouteArgs(key: key, photoPath: photoPath),
         initialChildren: children,
       );

  static const String name = 'PhotoViewerRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<PhotoViewerRouteArgs>();
      return PhotoViewerPage(key: args.key, photoPath: args.photoPath);
    },
  );
}

class PhotoViewerRouteArgs {
  const PhotoViewerRouteArgs({this.key, required this.photoPath});

  final Key? key;

  final String? photoPath;

  @override
  String toString() {
    return 'PhotoViewerRouteArgs{key: $key, photoPath: $photoPath}';
  }
}

/// Represents ProfileTabRoute.
class ProfileTabRoute extends PageRouteInfo<void> {
  const ProfileTabRoute({List<PageRouteInfo>? children})
    : super(ProfileTabRoute.name, initialChildren: children);

  static const String name = 'ProfileTabRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const ProfileTabPage();
    },
  );
}

/// Represents ScannerRoute.
class ScannerRoute extends PageRouteInfo<void> {
  const ScannerRoute({List<PageRouteInfo>? children})
    : super(ScannerRoute.name, initialChildren: children);

  static const String name = 'ScannerRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const ScannerPage();
    },
  );
}

/// Represents SignUpRoute.
class SignUpRoute extends PageRouteInfo<void> {
  const SignUpRoute({List<PageRouteInfo>? children})
    : super(SignUpRoute.name, initialChildren: children);

  static const String name = 'SignUpRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const SignUpPage();
    },
  );
}

/// Represents SplashRoute.
class SplashRoute extends PageRouteInfo<void> {
  const SplashRoute({List<PageRouteInfo>? children})
    : super(SplashRoute.name, initialChildren: children);

  static const String name = 'SplashRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const SplashScreen();
    },
  );
}
