import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../domain/media_item.dart';
import '../../domain/media_type.dart';
import '../../domain/media_status.dart';
import '../providers/media_provider.dart';
import 'package:not_defterim/src/core/presentation/widgets/app_animated_icon.dart';
import 'package:not_defterim/src/app/l10n/l10n_extension.dart';
import 'package:not_defterim/src/app/l10n/l10n_enums.dart';

/// Screen for adding a new media item.
class AddMediaScreen extends ConsumerStatefulWidget {
  const AddMediaScreen({super.key});

  @override
  ConsumerState<AddMediaScreen> createState() => _AddMediaScreenState();
}

class _AddMediaScreenState extends ConsumerState<AddMediaScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _notesController = TextEditingController();

  MediaType _selectedType = MediaType.movie;
  MediaStatus _selectedStatus = MediaStatus.planned;
  late int _selectedYear;
  int? _rating;

  @override
  void initState() {
    super.initState();
    _selectedYear = DateTime.now().year;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    final now = DateTime.now();
    final item = MediaItem(
      id: '', // Empty ID = new document
      title: _titleController.text.trim(),
      type: _selectedType,
      status: _selectedStatus,
      year: _selectedYear,
      rating: _rating,
      notes: _notesController.text.trim().isEmpty
          ? null
          : _notesController.text.trim(),
      createdAt: now,
      updatedAt: now,
    );

    final success = await ref.read(mediaNotifierProvider.notifier).upsertMediaItem(item);

    if (success && mounted) {
      AppAnimatedIcon.showSuccess(context, context.l10n.contentAdded);
      context.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isLoading = ref.watch(mediaNotifierProvider).isLoading;

    return Scaffold(
      appBar: AppBar(
        title: Text(context.l10n.newContent),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Title field
            TextFormField(
              controller: _titleController,
              enabled: !isLoading,
              decoration: InputDecoration(
                labelText: context.l10n.title,
                hintText: context.l10n.titleHint,
                border: const OutlineInputBorder(),
                prefixIcon: Icon(Icons.title),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return context.l10n.titleRequired;
                }
                return null;
              },
            ),
            const SizedBox(height: 16),

            // Type selector
            Text(context.l10n.type, style: theme.textTheme.titleSmall),
            const SizedBox(height: 8),
            SegmentedButton<MediaType>(
              segments: MediaType.values.map((type) {
                return ButtonSegment(
                  value: type,
                  label: Text(type.displayName(context)),
                  icon: Text(type.icon),
                );
              }).toList(),
              selected: {_selectedType},
              onSelectionChanged: isLoading
                  ? null
                  : (selected) {
                      setState(() {
                        _selectedType = selected.first;
                      });
                    },
            ),
            const SizedBox(height: 16),

            // Status selector
            Text(context.l10n.status, style: theme.textTheme.titleSmall),
            const SizedBox(height: 8),
            SegmentedButton<MediaStatus>(
              segments: MediaStatus.values.map((status) {
                return ButtonSegment(
                  value: status,
                  label: Text(status.displayName(context)),
                );
              }).toList(),
              selected: {_selectedStatus},
              onSelectionChanged: isLoading
                  ? null
                  : (selected) {
                      setState(() {
                        _selectedStatus = selected.first;
                      });
                    },
            ),
            const SizedBox(height: 16),

            // Year selector
            Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField<int>(
                    initialValue: _selectedYear,
                    decoration: InputDecoration(
                      labelText: context.l10n.filterYear,
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.calendar_today),
                    ),
                    items: List.generate(20, (i) => DateTime.now().year - i)
                        .map((year) {
                      return DropdownMenuItem(
                        value: year,
                        child: Text('$year'),
                      );
                    }).toList(),
                    onChanged: isLoading
                        ? null
                        : (year) {
                            if (year != null) {
                              setState(() {
                                _selectedYear = year;
                              });
                            }
                          },
                  ),
                ),
                const SizedBox(width: 16),
                // Rating selector
                Expanded(
                  child: DropdownButtonFormField<int?>(
                    initialValue: _rating,
                    decoration: InputDecoration(
                      labelText: context.l10n.rating,
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.star),
                    ),
                    items: [
                      DropdownMenuItem(
                        value: null,
                        child: Text(context.l10n.noRating),
                      ),
                      ...List.generate(10, (i) => 10 - i).map((rating) {
                        return DropdownMenuItem(
                          value: rating,
                          child: Text('$rating'),
                        );
                      }),
                    ],
                    onChanged: isLoading
                        ? null
                        : (rating) {
                            setState(() {
                              _rating = rating;
                            });
                          },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Notes field
            TextFormField(
              controller: _notesController,
              enabled: !isLoading,
              maxLines: 3,
              decoration: InputDecoration(
                labelText: context.l10n.notesOptional,
                hintText: context.l10n.notesHint,
                border: const OutlineInputBorder(),
                prefixIcon: Icon(Icons.notes),
                alignLabelWithHint: true,
              ),
            ),
            const SizedBox(height: 24),

            // Save button
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
        ),
      ),
    );
  }
}
