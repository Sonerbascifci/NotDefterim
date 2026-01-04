import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../core/presentation/widgets/app_error_view.dart';

class RouteErrorScreen extends StatelessWidget {
  final GoException? error;

  const RouteErrorScreen({super.key, this.error});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Error')),
      body: AppErrorView(
        message: 'Page not found',
        onRetry: () => context.go('/'),
        icon: Icons.broken_image_rounded,
      ),
    );
  }
}
