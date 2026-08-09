import 'package:auto_route/auto_route.dart';
import 'package:flutter/widgets.dart';

/// Represents HomeTabShell.
@RoutePage(name: 'HomeTabRoute')
class HomeTabShell extends StatelessWidget {
  const HomeTabShell({super.key});

  @override
  Widget build(BuildContext context) => const AutoRouter();
}
