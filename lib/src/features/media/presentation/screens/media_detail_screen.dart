import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../domain/media_item.dart';
import '../../domain/media_type.dart';
import '../../domain/media_status.dart';
import '../providers/media_provider.dart';
import 'package:not_defterim/src/app/l10n/l10n_extension.dart';
import 'package:not_defterim/src/app/l10n/l10n_enums.dart';

/// Screen for viewing and editing a media item.
class MediaDetailScreen extends ConsumerStatefulWidget {
  final String mediaId;

  const MediaDetailScreen({super.key, required this.mediaId});

  @override
  ConsumerState<MediaDetailScreen> createState() => _MediaDetailScreenState();
}

class _MediaDetailScreenState extends ConsumerState<MediaDetailScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _notesController = TextEditingController();

  bool _isEditing = false;
  MediaType? _selectedType;
  MediaStatus? _selectedStatus;
  int? _selectedYear;
  int? _rating;
  MediaItem? _originalItem;

  void _populateFields(MediaItem item) {
    if (_originalItem != null) return; // Already populated
    _originalItem = item;
    _titleController.text = item.title;
    _notesController.text = item.notes ?? '';
    _selectedType = item.type;
    _selectedStatus = item.status;
    _selectedYear = item.year;
    _rating = item.rating;
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    if (_originalItem == null) return;

    final updatedItem = _originalItem!.copyWith(
      title: _titleController.text.trim(),
      type: _selectedType,
      status: _selectedStatus,
      year: _selectedYear,
      rating: _rating,
      notes: _notesController.text.trim().isEmpty
          ? null
          : _notesController.text.trim(),
      updatedAt: DateTime.now(),
    );

    final success =
        await ref.read(mediaNotifierProvider.notifier).upsertMediaItem(updatedItem);

    if (success && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(context.l10n.changesSaved)),
      );
      setState(() {
        _isEditing = false;
        _originalItem = updatedItem;
      });
    }
  }

  Future<void> _delete() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(context.l10n.deleteConfirmationTitle),
        content: Text(context.l10n.deleteConfirmationContent),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(context.l10n.cancel),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(context.l10n.delete),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      final success = await ref
          .read(mediaNotifierProvider.notifier)
          .deleteMediaItem(widget.mediaId);

      if (success && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(context.l10n.contentDeleted)),
        );
        context.pop();
      }
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final mediaAsync = ref.watch(mediaItemProvider(widget.mediaId));
    final isLoading = ref.watch(mediaNotifierProvider).isLoading;

    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditing ? context.l10n.edit : context.l10n.details),
        actions: [
          if (!_isEditing)
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () => setState(() => _isEditing = true),
            ),
          if (!_isEditing)
            IconButton(
              icon: const Icon(Icons.delete_outline),
              onPressed: _delete,
            ),
          if (_isEditing)
            TextButton(
              onPressed: () {
                setState(() => _isEditing = false);
                if (_originalItem != null) {
                  _populateFields(_originalItem!);
                }
              },
              child: Text(context.l10n.cancel),
            ),
        ],
      ),
      body: mediaAsync.when(
        data: (item) {
          if (item == null) {
            return Center(child: Text(context.l10n.contentNotFound));
          }
          _populateFields(item);

          return Form(
            key: _formKey,
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                // Header with icon
                if (!_isEditing)
                  Center(
                    child: Column(
                      children: [
                        Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            color: theme.colorScheme.primaryContainer,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Center(
                            child: Text(
                              item.type.icon,
                              style: const TextStyle(fontSize: 40),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          item.title,
                          style: theme.textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 8),
                        Wrap(
                          spacing: 8,
                          children: [
                            Chip(label: Text(item.type.displayName(context))),
                            Chip(label: Text(item.status.displayName(context))),
                            Chip(label: Text('${item.year}')),
                            if (item.rating != null)
                              Chip(
                                avatar: const Icon(Icons.star, size: 16),
                                label: Text('${item.rating}'),
                              ),
                          ],
                        ),
                        if (item.notes != null) ...[
                          const SizedBox(height: 16),
                          Text(
                            item.notes!,
                            style: theme.textTheme.bodyLarge,
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ],
                    ),
                  ),

                // Edit form
                if (_isEditing) ...[
                  TextFormField(
                    controller: _titleController,
                    enabled: !isLoading,
                    decoration: InputDecoration(
                      labelText: context.l10n.title,
                      border: const OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return context.l10n.titleRequired;
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  SegmentedButton<MediaType>(
                    segments: MediaType.values.map((type) {
                      return ButtonSegment(
                        value: type,
                        label: Text(type.displayName(context)),
                      );
                    }).toList(),
                    selected: {_selectedType!},
                    onSelectionChanged: isLoading
                        ? null
                        : (selected) {
                            setState(() => _selectedType = selected.first);
                          },
                  ),
                  const SizedBox(height: 16),
                  SegmentedButton<MediaStatus>(
                    segments: MediaStatus.values.map((status) {
                      return ButtonSegment(
                        value: status,
                        label: Text(status.displayName(context)),
                      );
                    }).toList(),
                    selected: {_selectedStatus!},
                    onSelectionChanged: isLoading
                        ? null
                        : (selected) {
                            setState(() => _selectedStatus = selected.first);
                          },
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: DropdownButtonFormField<int>(
                          initialValue: _selectedYear,
                          decoration: InputDecoration(
                            labelText: context.l10n.filterYear,
                            border: const OutlineInputBorder(),
                          ),
                          items: List.generate(20, (i) => DateTime.now().year - i)
                              .map((year) => DropdownMenuItem(
                                    value: year,
                                    child: Text('$year'),
                                  ))
                              .toList(),
                          onChanged: isLoading
                              ? null
                              : (year) => setState(() => _selectedYear = year),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: DropdownButtonFormField<int?>(
                          initialValue: _rating,
                          decoration: InputDecoration(
                            labelText: context.l10n.rating,
                            border: const OutlineInputBorder(),
                          ),
                          items: [
                            DropdownMenuItem(
                                value: null, child: Text(context.l10n.noRating)),
                            ...List.generate(10, (i) => 10 - i).map((r) =>
                                DropdownMenuItem(value: r, child: Text('$r'))),
                          ],
                          onChanged: isLoading
                              ? null
                              : (r) => setState(() => _rating = r),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _notesController,
                    enabled: !isLoading,
                    maxLines: 3,
                    decoration: InputDecoration(
                      labelText: context.l10n.notes,
                      border: const OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 24),
                  FilledButton(
                    onPressed: isLoading ? null : _save,
                    child: isLoading
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : Text(context.l10n.save),
                  ),
                ],
              ],
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(child: Text('Hata: $error')),
      ),
    );
  }
}
