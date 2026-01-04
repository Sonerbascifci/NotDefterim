import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:animations/animations.dart';
import 'add_media_screen.dart';

import '../../domain/media_type.dart';
import '../../domain/media_status.dart';
import '../../domain/media_item.dart';
import '../providers/media_provider.dart';
import 'package:not_defterim/src/core/presentation/widgets/app_animated_icon.dart';
import 'package:not_defterim/src/app/l10n/l10n_extension.dart';
import 'package:not_defterim/src/core/presentation/widgets/async_value_view.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:not_defterim/src/app/l10n/l10n_enums.dart';

/// Media screen - displays list of tracked media with filters.
class MediaScreen extends ConsumerWidget {
  const MediaScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final selectedYear = ref.watch(selectedYearProvider);
    final selectedType = ref.watch(selectedTypeProvider);
    final selectedStatus = ref.watch(selectedStatusProvider);
    final mediaListAsync = ref.watch(mediaListProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(context.l10n.mediaTitle),
        actions: [
          // Year selector
          Tooltip(
            message: context.l10n.filterYear,
            child: PopupMenuButton<int>(
            icon: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  '$selectedYear',
                  style: theme.textTheme.titleMedium,
                ),
                const Icon(Icons.keyboard_arrow_down_rounded),
              ],
            ),
            onSelected: (year) {
              ref.read(selectedYearProvider.notifier).state = year;
            },
            itemBuilder: (context) {
              final currentYear = DateTime.now().year;
              return List.generate(
                10,
                (i) => currentYear - i,
              ).map((year) {
                return PopupMenuItem(
                  value: year,
                  child: Text('$year'),
                );
              }).toList();
            },
          ),
          ),
        ],
      ),
      body: Column(
        children: [
          // Filter chips
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                // Type filter chips
                ...MediaType.values.map((type) {
                  final isSelected = selectedType == type;
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: FilterChip(
                      label: Text('${type.icon} ${type.displayName(context)}'),
                      selected: isSelected,
                      onSelected: (selected) {
                        ref.read(selectedTypeProvider.notifier).state =
                            selected ? type : null;
                      },
                    ),
                  );
                }),
                const SizedBox(width: 8),
                const VerticalDivider(width: 1),
                const SizedBox(width: 8),
                // Status filter chips
                ...MediaStatus.values.map((status) {
                  final isSelected = selectedStatus == status;
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: FilterChip(
                      label: Text(status.displayName(context)),
                      selected: isSelected,
                      onSelected: (selected) {
                        ref.read(selectedStatusProvider.notifier).state =
                            selected ? status : null;
                      },
                    ),
                  );
                }),
              ],
            ),
          ),
          const Divider(height: 1),
          // Media list
          Expanded(
            child: AsyncValueView<List<MediaItem>>(
              value: mediaListAsync,
              isEmpty: (items) => items.isEmpty, // Not strictly needed if data builder handles it, but good for consistency
              onRetry: () => ref.refresh(mediaListProvider),
              data: (items) {
                 if (items.isEmpty) {
                  return _buildEmptyState(context, theme);
                }
                return ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: items.length,
                  itemBuilder: (context, index) {
                    final item = items[index];
                    return AnimationConfiguration.staggeredList(
                      position: index,
                      duration: const Duration(milliseconds: 375),
                      child: SlideAnimation(
                        verticalOffset: 50.0,
                        child: FadeInAnimation(
                          child: _MediaCard(item: item),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: OpenContainer(
        transitionType: ContainerTransitionType.fadeThrough,
        openBuilder: (BuildContext context, VoidCallback _) {
          return const AddMediaScreen();
        },
        closedElevation: 6.0,
        closedShape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(16)),
        ),
        closedColor: theme.colorScheme.primaryContainer,
        closedBuilder: (BuildContext context, VoidCallback openContainer) {
          return FloatingActionButton.extended(
            onPressed: openContainer,
            icon: const Icon(Icons.add_rounded),
            label: Text(context.l10n.add),
            elevation: 0,
          );
        },
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context, ThemeData theme) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          AppAnimatedIcon(
            iconPath: AppAnimatedIcons.archive,
            size: 120,
          ),
          const SizedBox(height: 16),
          Text(
            context.l10n.noContentYet,
            style: theme.textTheme.titleLarge?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            context.l10n.mediaEmptyStateHint,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.outline,
            ),
          ),
        ],
      ),
    );
  }
}

/// Card widget for displaying a media item.
class _MediaCard extends StatelessWidget {
  final MediaItem item;

  const _MediaCard({required this.item});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: () {
          context.push('/media/${item.id}');
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              // Type icon
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: theme.colorScheme.primaryContainer,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: Text(
                    item.type.icon,
                    style: const TextStyle(fontSize: 24),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              // Title and status
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.title,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: theme.colorScheme.secondaryContainer,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            item.status.displayName(context),
                            style: theme.textTheme.labelSmall?.copyWith(
                              color: theme.colorScheme.onSecondaryContainer,
                            ),
                          ),
                        ),
                        if (item.rating != null) ...[
                          const SizedBox(width: 8),
                          Icon(
                            Icons.star,
                            size: 16,
                            color: theme.colorScheme.tertiary,
                          ),
                          const SizedBox(width: 2),
                          Text(
                            '${item.rating}',
                            style: theme.textTheme.labelSmall,
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right),
            ],
          ),
        ),
      ),
    );
  }
}
