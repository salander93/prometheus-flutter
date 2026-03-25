import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:palestra/core/theme/app_colors.dart';
import 'package:palestra/data/models/connection_models.dart';
import 'package:palestra/data/models/relation_models.dart';
import 'package:palestra/presentation/shared/providers/social_providers.dart';
import 'package:palestra/presentation/shared/providers/user_providers.dart';

class TrainerSearchScreen extends ConsumerStatefulWidget {
  const TrainerSearchScreen({super.key});

  @override
  ConsumerState<TrainerSearchScreen> createState() =>
      _TrainerSearchScreenState();
}

class _TrainerSearchScreenState extends ConsumerState<TrainerSearchScreen> {
  final _searchController = TextEditingController();
  Timer? _debounce;
  String _activeQuery = '';
  // Track pending requests to avoid duplicate sends
  final Set<int> _pendingRequests = {};

  @override
  void dispose() {
    _debounce?.cancel();
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged(String value) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      if (mounted) {
        setState(() => _activeQuery = value.trim());
      }
    });
  }

  Future<void> _showCodeDialog() async {
    final codeController = TextEditingController();
    await showDialog<void>(
      context: context,
      builder: (context) => _TrainerCodeDialog(
        controller: codeController,
        onSearch: (code) {
          Navigator.of(context).pop();
          setState(() {
            _searchController.text = '';
            _activeQuery = '';
          });
          _showCodeResults(code);
        },
      ),
    );
    codeController.dispose();
  }

  void _showCodeResults(String code) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.backgroundCard,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => _CodeSearchSheet(code: code),
    );
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final trainersAsync = ref.watch(myTrainersProvider);
    final searchAsync = ref.watch(
      trainerSearchResultsProvider(_activeQuery),
    );

    return RefreshIndicator(
      onRefresh: () async {
        ref.invalidate(myTrainersProvider);
        if (_activeQuery.isNotEmpty) {
          ref.invalidate(trainerSearchResultsProvider(_activeQuery));
        }
      },
      child: CustomScrollView(
        slivers: [
          // ── Search bar ───────────────────────────────────────────────────
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Cerca Trainer',
                      style: textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _searchController,
                            onChanged: _onSearchChanged,
                            decoration: InputDecoration(
                              hintText: 'Nome o username...',
                              prefixIcon: const Icon(
                                Icons.search,
                                color: AppColors.textMuted,
                              ),
                              suffixIcon: _searchController.text.isNotEmpty
                                  ? IconButton(
                                      icon: const Icon(
                                        Icons.clear,
                                        color: AppColors.textMuted,
                                      ),
                                      onPressed: () {
                                        _searchController.clear();
                                        setState(() => _activeQuery = '');
                                      },
                                    )
                                  : null,
                              filled: true,
                              fillColor: AppColors.backgroundInput,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: const BorderSide(
                                  color: AppColors.border,
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: const BorderSide(
                                  color: AppColors.border,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: const BorderSide(
                                  color: AppColors.primary,
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        _CodeButton(onTap: _showCodeDialog),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            // ── My connections ─────────────────────────────────────────────
            SliverToBoxAdapter(
              child: trainersAsync.when(
                data: (trainers) {
                  if (trainers.isEmpty) return const SizedBox.shrink();
                  return _MyConnectionsSection(trainers: trainers);
                },
                loading: () => const SizedBox.shrink(),
                error: (_, __) => const SizedBox.shrink(),
              ),
            ),

            // ── Search results ─────────────────────────────────────────────
            if (_activeQuery.isEmpty)
              const SliverToBoxAdapter(
                child: _EmptySearchPrompt(),
              )
            else
              searchAsync.when(
                data: (results) {
                  if (results.isEmpty) {
                    return SliverToBoxAdapter(
                      child: _EmptyResults(query: _activeQuery),
                    );
                  }
                  final connectedIds = trainersAsync
                          .valueOrNull
                          ?.map((t) => t.trainer)
                          .toSet() ??
                      {};
                  return _SearchResultsGrid(
                    results: results,
                    connectedIds: connectedIds,
                    pendingRequests: _pendingRequests,
                    onRequestSent: (trainerId) {
                      setState(() => _pendingRequests.add(trainerId));
                    },
                  );
                },
                loading: () => const SliverToBoxAdapter(
                  child: Center(
                    child: Padding(
                      padding: EdgeInsets.all(48),
                      child: CircularProgressIndicator(),
                    ),
                  ),
                ),
                error: (e, _) => SliverToBoxAdapter(
                  child: _ErrorState(message: e.toString()),
                ),
              ),

            const SliverToBoxAdapter(child: SizedBox(height: 96)),
          ],
        ),
      );
  }
}

// ── Code button ──────────────────────────────────────────────────────────────

class _CodeButton extends StatelessWidget {
  const _CodeButton({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return OutlinedButton.icon(
      onPressed: onTap,
      icon: const Icon(Icons.qr_code, size: 18),
      label: const Text('Codice'),
      style: OutlinedButton.styleFrom(
        foregroundColor: AppColors.primary,
        side: const BorderSide(color: AppColors.primary),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }
}

// ── My connections section ───────────────────────────────────────────────────

class _MyConnectionsSection extends StatelessWidget {
  const _MyConnectionsSection({required this.trainers});

  final List<TrainerClient> trainers;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'I miei trainer',
            style: textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 88,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: trainers.length,
              separatorBuilder: (_, __) => const SizedBox(width: 12),
              itemBuilder: (context, index) {
                final trainer = trainers[index];
                return _ConnectedTrainerChip(trainer: trainer);
              },
            ),
          ),
          const SizedBox(height: 16),
          const Divider(color: AppColors.border),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}

class _ConnectedTrainerChip extends StatelessWidget {
  const _ConnectedTrainerChip({required this.trainer});

  final TrainerClient trainer;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final photoUrl = trainer.trainerPhoto;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        CircleAvatar(
          radius: 28,
          backgroundColor: AppColors.primaryDark,
          backgroundImage: photoUrl != null
              ? CachedNetworkImageProvider(photoUrl)
              : null,
          child: photoUrl == null
              ? Text(
                  _initials(trainer.trainerName),
                  style: textTheme.titleSmall?.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.bold,
                  ),
                )
              : null,
        ),
        const SizedBox(height: 4),
        SizedBox(
          width: 64,
          child: Text(
            trainer.trainerName.split(' ').first,
            style: textTheme.labelSmall?.copyWith(
              color: AppColors.textSecondary,
            ),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  String _initials(String name) {
    final parts = name.trim().split(' ');
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    }
    return name.isNotEmpty ? name[0].toUpperCase() : '?';
  }
}

// ── Search results grid ──────────────────────────────────────────────────────

class _SearchResultsGrid extends StatelessWidget {
  const _SearchResultsGrid({
    required this.results,
    required this.connectedIds,
    required this.pendingRequests,
    required this.onRequestSent,
  });

  final List<TrainerSearchResult> results;
  final Set<int> connectedIds;
  final Set<int> pendingRequests;
  final ValueChanged<int> onRequestSent;

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      sliver: SliverGrid(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
          childAspectRatio: 0.8,
        ),
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            final trainer = results[index];
            final isConnected = connectedIds.contains(trainer.id);
            final isPending = pendingRequests.contains(trainer.id);
            return _TrainerCard(
              trainer: trainer,
              isConnected: isConnected,
              isPending: isPending,
              onRequestSent: () => onRequestSent(trainer.id),
            );
          },
          childCount: results.length,
        ),
      ),
    );
  }
}

class _TrainerCard extends ConsumerWidget {
  const _TrainerCard({
    required this.trainer,
    required this.isConnected,
    required this.isPending,
    required this.onRequestSent,
  });

  final TrainerSearchResult trainer;
  final bool isConnected;
  final bool isPending;
  final VoidCallback onRequestSent;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textTheme = Theme.of(context).textTheme;
    final photoUrl = trainer.photo;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppColors.backgroundCard,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 32,
              backgroundColor: AppColors.primaryDark,
              backgroundImage: photoUrl != null
                  ? CachedNetworkImageProvider(photoUrl)
                  : null,
              child: photoUrl == null
                  ? Text(
                      _initials(trainer.fullName),
                      style: textTheme.titleMedium?.copyWith(
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.bold,
                      ),
                    )
                  : null,
            ),
            const SizedBox(height: 10),
            Text(
              trainer.fullName,
              style: textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            if (trainer.bio != null && trainer.bio!.isNotEmpty) ...[
              const SizedBox(height: 4),
              Text(
                trainer.bio!,
                style: textTheme.labelSmall?.copyWith(
                  color: AppColors.textMuted,
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
            const SizedBox(height: 12),
            _ActionButton(
              isConnected: isConnected,
              isPending: isPending,
              trainer: trainer,
              onRequestSent: onRequestSent,
            ),
          ],
        ),
      ),
    );
  }

  String _initials(String name) {
    final parts = name.trim().split(' ');
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    }
    return name.isNotEmpty ? name[0].toUpperCase() : '?';
  }
}

class _ActionButton extends ConsumerStatefulWidget {
  const _ActionButton({
    required this.isConnected,
    required this.isPending,
    required this.trainer,
    required this.onRequestSent,
  });

  final bool isConnected;
  final bool isPending;
  final TrainerSearchResult trainer;
  final VoidCallback onRequestSent;

  @override
  ConsumerState<_ActionButton> createState() => _ActionButtonState();
}

class _ActionButtonState extends ConsumerState<_ActionButton> {
  bool _loading = false;

  Future<void> _sendRequest() async {
    setState(() => _loading = true);
    try {
      final repo = ref.read(socialRepositoryProvider);
      await repo.sendConnectionRequest(trainerId: widget.trainer.id);
      widget.onRequestSent();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Richiesta inviata a ${widget.trainer.fullName}'),
            backgroundColor: AppColors.success,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Errore nell'invio della richiesta"),
            backgroundColor: AppColors.danger,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.isConnected) {
      return const _ChipLabel(
        icon: Icons.check_circle_outline,
        label: 'Collegato',
        color: AppColors.success,
      );
    }

    if (widget.isPending) {
      return const _ChipLabel(
        icon: Icons.schedule_outlined,
        label: 'In attesa',
        color: AppColors.accent,
      );
    }

    return SizedBox(
      width: double.infinity,
      child: FilledButton(
        onPressed: _loading ? null : _sendRequest,
        style: FilledButton.styleFrom(
          backgroundColor: AppColors.primary,
          padding: const EdgeInsets.symmetric(vertical: 6),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        child: _loading
            ? const SizedBox(
                width: 16,
                height: 16,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: AppColors.textPrimary,
                ),
              )
            : const Text(
                'Richiedi',
                style: TextStyle(fontSize: 13),
              ),
      ),
    );
  }
}

class _ChipLabel extends StatelessWidget {
  const _ChipLabel({
    required this.icon,
    required this.label,
    required this.color,
  });

  final IconData icon;
  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 14, color: color),
        const SizedBox(width: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: color,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}

// ── Code search bottom sheet ─────────────────────────────────────────────────

class _CodeSearchSheet extends ConsumerWidget {
  const _CodeSearchSheet({required this.code});

  final String code;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textTheme = Theme.of(context).textTheme;
    final searchAsync = ref.watch(trainerByCodeProvider(code));

    return DraggableScrollableSheet(
      initialChildSize: 0.6,
      minChildSize: 0.4,
      maxChildSize: 0.9,
      expand: false,
      builder: (context, scrollController) {
        return ListView(
          controller: scrollController,
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.border,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Risultato codice',
              style: textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 16),
            searchAsync.when(
              data: (results) {
                if (results.isEmpty) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 32),
                      child: Text(
                        'Nessun trainer trovato con questo codice',
                        style: textTheme.bodyMedium?.copyWith(
                          color: AppColors.textMuted,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  );
                }
                final connectedIds = ref
                        .watch(myTrainersProvider)
                        .valueOrNull
                        ?.map((t) => t.trainer)
                        .toSet() ??
                    {};
                return Column(
                  children: results
                      .map(
                        (trainer) => Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: _TrainerListTile(
                            trainer: trainer,
                            isConnected: connectedIds.contains(trainer.id),
                          ),
                        ),
                      )
                      .toList(),
                );
              },
              loading: () => const Center(
                child: Padding(
                  padding: EdgeInsets.all(32),
                  child: CircularProgressIndicator(),
                ),
              ),
              error: (e, _) => Center(
                child: Padding(
                  padding: const EdgeInsets.all(32),
                  child: Text(
                    'Errore nella ricerca',
                    style: textTheme.bodyMedium?.copyWith(
                      color: AppColors.danger,
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

class _TrainerListTile extends ConsumerStatefulWidget {
  const _TrainerListTile({
    required this.trainer,
    required this.isConnected,
  });

  final TrainerSearchResult trainer;
  final bool isConnected;

  @override
  ConsumerState<_TrainerListTile> createState() => _TrainerListTileState();
}

class _TrainerListTileState extends ConsumerState<_TrainerListTile> {
  bool _loading = false;
  bool _requested = false;

  Future<void> _sendRequest() async {
    setState(() => _loading = true);
    try {
      final repo = ref.read(socialRepositoryProvider);
      await repo.sendConnectionRequest(trainerId: widget.trainer.id);
      if (mounted) {
        setState(() => _requested = true);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Richiesta inviata a ${widget.trainer.fullName}'),
            backgroundColor: AppColors.success,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Errore nell'invio della richiesta"),
            backgroundColor: AppColors.danger,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final photoUrl = widget.trainer.photo;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppColors.backgroundCard,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: ListTile(
        leading: CircleAvatar(
          radius: 24,
          backgroundColor: AppColors.primaryDark,
          backgroundImage: photoUrl != null
              ? CachedNetworkImageProvider(photoUrl)
              : null,
          child: photoUrl == null
              ? Text(
                  _initials(widget.trainer.fullName),
                  style: textTheme.labelMedium?.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.bold,
                  ),
                )
              : null,
        ),
        title: Text(
          widget.trainer.fullName,
          style: textTheme.bodyMedium?.copyWith(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w600,
          ),
        ),
        subtitle: widget.trainer.bio != null && widget.trainer.bio!.isNotEmpty
            ? Text(
                widget.trainer.bio!,
                style: textTheme.labelSmall?.copyWith(
                  color: AppColors.textMuted,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              )
            : null,
        trailing: widget.isConnected
            ? const _ChipLabel(
                icon: Icons.check_circle_outline,
                label: 'Collegato',
                color: AppColors.success,
              )
            : _requested
                ? const _ChipLabel(
                    icon: Icons.schedule_outlined,
                    label: 'In attesa',
                    color: AppColors.accent,
                  )
                : FilledButton(
                    onPressed: _loading ? null : _sendRequest,
                    style: FilledButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: _loading
                        ? const SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: AppColors.textPrimary,
                            ),
                          )
                        : const Text(
                            'Richiedi',
                            style: TextStyle(fontSize: 13),
                          ),
                  ),
      ),
    );
  }

  String _initials(String name) {
    final parts = name.trim().split(' ');
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    }
    return name.isNotEmpty ? name[0].toUpperCase() : '?';
  }
}

// ── Trainer code dialog ──────────────────────────────────────────────────────

class _TrainerCodeDialog extends StatelessWidget {
  const _TrainerCodeDialog({
    required this.controller,
    required this.onSearch,
  });

  final TextEditingController controller;
  final ValueChanged<String> onSearch;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return AlertDialog(
      backgroundColor: AppColors.backgroundCard,
      title: Text(
        'Codice trainer',
        style: textTheme.titleMedium?.copyWith(
          color: AppColors.textPrimary,
          fontWeight: FontWeight.bold,
        ),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Inserisci il codice univoco del tuo trainer',
            style: textTheme.bodySmall?.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: controller,
            autofocus: true,
            textCapitalization: TextCapitalization.characters,
            decoration: InputDecoration(
              hintText: 'es. ABC123',
              filled: true,
              fillColor: AppColors.backgroundInput,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: AppColors.border),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: AppColors.border),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: AppColors.primary),
              ),
            ),
            onSubmitted: (v) {
              if (v.trim().isNotEmpty) onSearch(v.trim());
            },
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(
            'Annulla',
            style: textTheme.labelLarge?.copyWith(color: AppColors.textMuted),
          ),
        ),
        FilledButton(
          onPressed: () {
            final code = controller.text.trim();
            if (code.isNotEmpty) onSearch(code);
          },
          style: FilledButton.styleFrom(backgroundColor: AppColors.primary),
          child: const Text('Cerca'),
        ),
      ],
    );
  }
}

// ── Empty / error states ──────────────────────────────────────────────────────

class _EmptySearchPrompt extends StatelessWidget {
  const _EmptySearchPrompt();

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 48),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.person_search_outlined,
            size: 72,
            color: AppColors.textMuted,
          ),
          const SizedBox(height: 16),
          Text(
            'Cerca il tuo trainer',
            style: textTheme.titleMedium?.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Digita un nome o usa il codice univoco del trainer',
            style: textTheme.bodySmall?.copyWith(color: AppColors.textMuted),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class _EmptyResults extends StatelessWidget {
  const _EmptyResults({required this.query});

  final String query;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 48),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.search_off_outlined,
            size: 64,
            color: AppColors.textMuted,
          ),
          const SizedBox(height: 16),
          Text(
            'Nessun risultato per "$query"',
            style: textTheme.titleSmall?.copyWith(
              color: AppColors.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            'Prova con un nome diverso o usa il codice trainer',
            style: textTheme.bodySmall?.copyWith(color: AppColors.textMuted),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class _ErrorState extends StatelessWidget {
  const _ErrorState({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.all(32),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.error_outline, size: 48, color: AppColors.danger),
          const SizedBox(height: 12),
          Text(
            'Errore di caricamento',
            style: textTheme.titleSmall?.copyWith(color: AppColors.danger),
          ),
        ],
      ),
    );
  }
}
