import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../errors/error_mapper.dart';
import 'app_error_view.dart';
import 'skeletons/skeleton_list.dart';
import 'app_empty_view.dart';

/// A wrapper for handling AsyncValue states consistently across the app.
class AsyncValueView<T> extends StatelessWidget {
  final AsyncValue<T> value;
  final Widget Function(T data) data;
  final bool Function(T data)? isEmpty;
  final String? emptyMessage;
  final VoidCallback? onRetry;

  const AsyncValueView({
    super.key,
    required this.value,
    required this.data,
    this.isEmpty,
    this.emptyMessage,
    this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return value.when(
      data: (d) {
        if (isEmpty != null && isEmpty!(d)) {
          return AppEmptyView(message: emptyMessage ?? 'No data found');
        }
        return data(d);
      },
      loading: () => const SkeletonList(),
      error: (e, st) => AppErrorView(
        message: ErrorMapper.mapErrorToMessage(context, e),
        onRetry: onRetry,
      ),
    );
  }
}
