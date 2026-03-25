import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:palestra/core/theme/app_colors.dart';
import 'package:palestra/data/models/connection_models.dart';
import 'package:palestra/data/models/relation_models.dart';
import 'package:palestra/data/models/user_model.dart';
import 'package:palestra/presentation/auth/providers/auth_providers.dart';
import 'package:palestra/presentation/shared/providers/social_providers.dart';
import 'package:palestra/presentation/shared/providers/user_providers.dart';

// ---------------------------------------------------------------------------
// Screen
// ---------------------------------------------------------------------------

class RequestsScreen extends ConsumerWidget {
  const RequestsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return const DefaultTabController(
      length: 2,
      child: Column(
        children: [
          TabBar(
            indicatorColor: AppColors.primary,
            labelColor: AppColors.primary,
            unselectedLabelColor: AppColors.textMuted,
            labelStyle: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 14,
            ),
            tabs: [
              Tab(text: 'Connessioni'),
              Tab(text: 'Schede'),
            ],
          ),
          Expanded(
            child: TabBarView(
              children: [
                _ConnectionsTab(),
                _PlansTab(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Tab 1 – Connessioni
// ---------------------------------------------------------------------------

class _ConnectionsTab extends ConsumerWidget {
  const _ConnectionsTab();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userAsync = ref.watch(currentUserProvider);
    final connectionRequestsAsync = ref.watch(connectionRequestsProvider);

    return userAsync.when(
      data: (user) {
        if (user == null) {
          return const Center(child: CircularProgressIndicator());
        }

        final isTrainer = user.role == 'TRAINER';
        final connectionsAsync = isTrainer
            ? ref.watch(myClientsProvider)
            : ref.watch(myTrainersProvider);

        return RefreshIndicator(
          onRefresh: () async {
            ref
              ..invalidate(connectionRequestsProvider)
              ..invalidate(myClientsProvider)
              ..invalidate(myTrainersProvider);
          },
          child: connectionRequestsAsync.when(
            data: (requests) {
              final pending = requests
                  .where((r) => r.status == 'PENDING')
                  .toList();

              return connectionsAsync.when(
                data: (active) => _ConnectionsContent(
                  user: user,
                  isTrainer: isTrainer,
                  pendingRequests: pending,
                  activeConnections: active,
                ),
                loading: () => _ConnectionsContent(
                  user: user,
                  isTrainer: isTrainer,
                  pendingRequests: pending,
                  activeConnections: const [],
                  loadingActive: true,
                ),
                error: (e, _) => _ConnectionsContent(
                  user: user,
                  isTrainer: isTrainer,
                  pendingRequests: pending,
                  activeConnections: const [],
                ),
              );
            },
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, _) => _ErrorState(
              message: 'Impossibile caricare le richieste',
              onRetry: () => ref.invalidate(connectionRequestsProvider),
            ),
          ),
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => const Center(child: CircularProgressIndicator()),
    );
  }
}

class _ConnectionsContent extends ConsumerStatefulWidget {
  const _ConnectionsContent({
    required this.user,
    required this.isTrainer,
    required this.pendingRequests,
    required this.activeConnections,
    this.loadingActive = false,
  });

  final UserModel user;
  final bool isTrainer;
  final List<ConnectionRequest> pendingRequests;
  final List<TrainerClient> activeConnections;
  final bool loadingActive;

  @override
  ConsumerState<_ConnectionsContent> createState() =>
      _ConnectionsContentState();
}

class _ConnectionsContentState extends ConsumerState<_ConnectionsContent> {
  final Set<int> _processingIds = {};

  Future<void> _acceptConnection(int requestId) async {
    setState(() => _processingIds.add(requestId));
    try {
      await ref
          .read(socialRepositoryProvider)
          .acceptConnectionRequest(requestId);
      ref
        ..invalidate(connectionRequestsProvider)
        ..invalidate(myClientsProvider)
        ..invalidate(myTrainersProvider);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Connessione accettata')),
        );
      }
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Errore durante l'accettazione"),
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _processingIds.remove(requestId));
    }
  }

  Future<void> _rejectConnection(int requestId) async {
    setState(() => _processingIds.add(requestId));
    try {
      await ref
          .read(socialRepositoryProvider)
          .rejectConnectionRequest(requestId);
      ref.invalidate(connectionRequestsProvider);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Richiesta rifiutata')),
        );
      }
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Errore durante il rifiuto')),
        );
      }
    } finally {
      if (mounted) setState(() => _processingIds.remove(requestId));
    }
  }

  Future<void> _cancelRequest(int requestId) async {
    setState(() => _processingIds.add(requestId));
    try {
      await ref
          .read(socialRepositoryProvider)
          .rejectConnectionRequest(requestId);
      ref.invalidate(connectionRequestsProvider);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Richiesta annullata')),
        );
      }
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Errore durante la cancellazione')),
        );
      }
    } finally {
      if (mounted) setState(() => _processingIds.remove(requestId));
    }
  }

  Future<void> _disconnect(TrainerClient connection) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) {
        final otherName = widget.isTrainer
            ? connection.clientName
            : connection.trainerName;
        return AlertDialog(
          title: const Text('Disconnetti'),
          content: Text(
            'Sei sicuro di voler rimuovere la connessione con $otherName?',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(false),
              child: const Text('Annulla'),
            ),
            TextButton(
              style: TextButton.styleFrom(
                foregroundColor: AppColors.danger,
              ),
              onPressed: () => Navigator.of(ctx).pop(true),
              child: const Text('Disconnetti'),
            ),
          ],
        );
      },
    );

    if (confirmed != true || !mounted) return;

    try {
      await ref
          .read(socialRepositoryProvider)
          .rejectConnectionRequest(connection.id);
      ref
        ..invalidate(myClientsProvider)
        ..invalidate(myTrainersProvider);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Connessione rimossa')),
        );
      }
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Impossibile rimuovere la connessione'),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final hasContent = widget.pendingRequests.isNotEmpty ||
        widget.activeConnections.isNotEmpty;

    if (!hasContent && !widget.loadingActive) {
      return const _EmptyState(
        icon: Icons.people_outline,
        title: 'Nessuna connessione',
        subtitle: 'Le tue richieste di connessione appariranno qui',
      );
    }

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // ── Pending section ──────────────────────────────────────────────
        if (widget.pendingRequests.isNotEmpty) ...[
          _SectionHeader(
            title: 'In Attesa',
            count: widget.pendingRequests.length,
          ),
          const SizedBox(height: 8),
          ...widget.pendingRequests.map(
            (r) => _PendingConnectionCard(
              request: r,
              isTrainer: widget.isTrainer,
              currentUserId: widget.user.id,
              isProcessing: _processingIds.contains(r.id),
              onAccept:
                  widget.isTrainer ? () => _acceptConnection(r.id) : null,
              onReject:
                  widget.isTrainer ? () => _rejectConnection(r.id) : null,
              onCancel: !widget.isTrainer ? () => _cancelRequest(r.id) : null,
            ),
          ),
          const SizedBox(height: 24),
        ],

        // ── Active section ───────────────────────────────────────────────
        if (widget.activeConnections.isNotEmpty || widget.loadingActive) ...[
          _SectionHeader(
            title: 'Attive',
            count: widget.loadingActive
                ? null
                : widget.activeConnections.length,
          ),
          const SizedBox(height: 8),
          if (widget.loadingActive)
            const Center(
              child: Padding(
                padding: EdgeInsets.all(24),
                child: CircularProgressIndicator(),
              ),
            )
          else
            ...widget.activeConnections.map(
              (c) => _ActiveConnectionCard(
                connection: c,
                isTrainer: widget.isTrainer,
                onDisconnect: () => _disconnect(c),
              ),
            ),
        ],

        // ── Empty state (no pending, no active) ──────────────────────────
        if (widget.pendingRequests.isEmpty &&
            widget.activeConnections.isEmpty &&
            !widget.loadingActive)
          const _EmptyState(
            icon: Icons.people_outline,
            title: 'Nessuna connessione',
            subtitle: 'Le tue richieste di connessione appariranno qui',
          ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// Tab 2 – Schede
// ---------------------------------------------------------------------------

class _PlansTab extends ConsumerWidget {
  const _PlansTab();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userAsync = ref.watch(currentUserProvider);
    final planRequestsAsync = ref.watch(planRequestsProvider);

    return userAsync.when(
      data: (user) {
        if (user == null) {
          return const Center(child: CircularProgressIndicator());
        }
        final isTrainer = user.role == 'TRAINER';

        return RefreshIndicator(
          onRefresh: () async => ref.invalidate(planRequestsProvider),
          child: planRequestsAsync.when(
            data: (requests) => _PlansContent(
              requests: requests,
              isTrainer: isTrainer,
              user: user,
            ),
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, _) => _ErrorState(
              message: 'Impossibile caricare le richieste schede',
              onRetry: () => ref.invalidate(planRequestsProvider),
            ),
          ),
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => const Center(child: CircularProgressIndicator()),
    );
  }
}

class _PlansContent extends ConsumerStatefulWidget {
  const _PlansContent({
    required this.requests,
    required this.isTrainer,
    required this.user,
  });

  final List<PlanRequest> requests;
  final bool isTrainer;
  final UserModel user;

  @override
  ConsumerState<_PlansContent> createState() => _PlansContentState();
}

class _PlansContentState extends ConsumerState<_PlansContent> {
  final Set<int> _processingIds = {};

  Future<void> _acceptPlan(int requestId) async {
    setState(() => _processingIds.add(requestId));
    try {
      await ref.read(socialRepositoryProvider).acceptPlanRequest(requestId);
      ref.invalidate(planRequestsProvider);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Richiesta scheda accettata')),
        );
      }
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Errore durante l'accettazione"),
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _processingIds.remove(requestId));
    }
  }

  Future<void> _rejectPlan(int requestId) async {
    setState(() => _processingIds.add(requestId));
    try {
      await ref.read(socialRepositoryProvider).rejectPlanRequest(requestId);
      ref.invalidate(planRequestsProvider);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Richiesta scheda rifiutata')),
        );
      }
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Errore durante il rifiuto')),
        );
      }
    } finally {
      if (mounted) setState(() => _processingIds.remove(requestId));
    }
  }

  Future<void> _showRequestPlanDialog() async {
    final trainers = await ref.read(myTrainersProvider.future);

    if (!mounted) return;

    await showDialog<void>(
      context: context,
      builder: (ctx) => _RequestPlanDialog(
        trainers: trainers,
        onSubmit: (trainerId, message) async {
          try {
            await ref.read(socialRepositoryProvider).createPlanRequest(
                  trainerId: trainerId,
                  message: message,
                );
            ref.invalidate(planRequestsProvider);
            if (ctx.mounted) Navigator.of(ctx).pop();
            if (mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Richiesta scheda inviata'),
                ),
              );
            }
          } catch (_) {
            if (mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text(
                    "Errore durante l'invio della richiesta",
                  ),
                ),
              );
            }
          }
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // ── Client CTA ─────────────────────────────────────────────────
        if (!widget.isTrainer) ...[
          OutlinedButton.icon(
            style: OutlinedButton.styleFrom(
              minimumSize: const Size(double.infinity, 48),
              side: const BorderSide(color: AppColors.primary),
              foregroundColor: AppColors.primary,
            ),
            onPressed: _showRequestPlanDialog,
            icon: const Icon(Icons.add),
            label: const Text('Richiedi Nuova Scheda'),
          ),
          const SizedBox(height: 24),
        ],

        // ── Requests list ──────────────────────────────────────────────
        if (widget.requests.isEmpty)
          const _EmptyState(
            icon: Icons.assignment_outlined,
            title: 'Nessuna richiesta scheda',
            subtitle: 'Le richieste di schede appariranno qui',
          )
        else ...[
          _SectionHeader(
            title: widget.isTrainer
                ? 'Richieste dai Clienti'
                : 'Le Mie Richieste',
            count: widget.requests.length,
          ),
          const SizedBox(height: 8),
          ...widget.requests.map(
            (r) => _PlanRequestCard(
              request: r,
              isTrainer: widget.isTrainer,
              isProcessing: _processingIds.contains(r.id),
              onAccept: widget.isTrainer && r.status == 'PENDING'
                  ? () => _acceptPlan(r.id)
                  : null,
              onReject: widget.isTrainer && r.status == 'PENDING'
                  ? () => _rejectPlan(r.id)
                  : null,
            ),
          ),
        ],
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// Dialog: request a new plan (client)
// ---------------------------------------------------------------------------

class _RequestPlanDialog extends StatefulWidget {
  const _RequestPlanDialog({
    required this.trainers,
    required this.onSubmit,
  });

  final List<TrainerClient> trainers;
  final Future<void> Function(int trainerId, String? message) onSubmit;

  @override
  State<_RequestPlanDialog> createState() => _RequestPlanDialogState();
}

class _RequestPlanDialogState extends State<_RequestPlanDialog> {
  int? _selectedTrainerId;
  final _messageController = TextEditingController();
  bool _submitting = false;

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (_selectedTrainerId == null) return;
    setState(() => _submitting = true);
    try {
      final msg = _messageController.text.trim();
      await widget.onSubmit(
        _selectedTrainerId!,
        msg.isEmpty ? null : msg,
      );
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Richiedi Nuova Scheda'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (widget.trainers.isEmpty)
            const Text(
              'Non hai trainer collegati. '
              'Connettiti prima con un trainer.',
              style: TextStyle(color: AppColors.textSecondary),
            )
          else ...[
            const Text(
              'Trainer',
              style: TextStyle(
                color: AppColors.textSecondary,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 6),
            DropdownButtonFormField<int>(
              decoration: const InputDecoration(
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 10,
                ),
              ),
              hint: const Text('Seleziona trainer'),
              initialValue: _selectedTrainerId,
              items: widget.trainers
                  .map(
                    (t) => DropdownMenuItem<int>(
                      value: t.trainer,
                      child: Text(t.trainerName),
                    ),
                  )
                  .toList(),
              onChanged: (v) => setState(() => _selectedTrainerId = v),
            ),
            const SizedBox(height: 16),
            const Text(
              'Messaggio (opzionale)',
              style: TextStyle(
                color: AppColors.textSecondary,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 6),
            TextField(
              controller: _messageController,
              maxLines: 3,
              decoration: const InputDecoration(
                hintText: 'Descrivi i tuoi obiettivi...',
              ),
            ),
          ],
        ],
      ),
      actions: [
        TextButton(
          onPressed: _submitting ? null : () => Navigator.of(context).pop(),
          child: const Text('Annulla'),
        ),
        if (widget.trainers.isNotEmpty)
          FilledButton(
            style: FilledButton.styleFrom(
              minimumSize: const Size(100, 40),
            ),
            onPressed:
                _submitting || _selectedTrainerId == null ? null : _submit,
            child: _submitting
                ? const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: AppColors.textPrimary,
                    ),
                  )
                : const Text('Invia'),
          ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// Cards
// ---------------------------------------------------------------------------

class _PendingConnectionCard extends StatelessWidget {
  const _PendingConnectionCard({
    required this.request,
    required this.isTrainer,
    required this.currentUserId,
    required this.isProcessing,
    this.onAccept,
    this.onReject,
    this.onCancel,
  });

  final ConnectionRequest request;
  final bool isTrainer;
  final int currentUserId;
  final bool isProcessing;
  final VoidCallback? onAccept;
  final VoidCallback? onReject;
  final VoidCallback? onCancel;

  String get _otherName =>
      isTrainer ? request.clientName : request.trainerName;

  String? get _otherPhoto =>
      isTrainer ? request.clientPhoto : request.trainerPhoto;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: AppColors.backgroundCard,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              _UserAvatar(photoUrl: _otherPhoto, name: _otherName),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _otherName,
                      style: textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      _formatDate(request.createdAt),
                      style: textTheme.labelSmall?.copyWith(
                        color: AppColors.textMuted,
                      ),
                    ),
                  ],
                ),
              ),
              _StatusBadge(status: request.status),
            ],
          ),
          if (request.message != null && request.message!.isNotEmpty) ...[
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: AppColors.backgroundCardHover,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                request.message!,
                style: textTheme.bodySmall?.copyWith(
                  color: AppColors.textSecondary,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ),
          ],
          const SizedBox(height: 12),
          if (isTrainer) ...[
            Row(
              children: [
                Expanded(
                  child: _ActionButton(
                    label: 'Accetta',
                    color: AppColors.success,
                    icon: Icons.check_rounded,
                    isLoading: isProcessing,
                    onPressed: onAccept,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _ActionButton(
                    label: 'Rifiuta',
                    color: AppColors.danger,
                    icon: Icons.close_rounded,
                    isLoading: isProcessing,
                    onPressed: onReject,
                  ),
                ),
              ],
            ),
          ] else ...[
            Row(
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    decoration: BoxDecoration(
                      color: AppColors.backgroundCardHover,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Center(
                      child: Text(
                        'In attesa...',
                        style: textTheme.labelMedium?.copyWith(
                          color: AppColors.textMuted,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                _ActionButton(
                  label: 'Annulla',
                  color: AppColors.danger,
                  icon: Icons.close_rounded,
                  isLoading: isProcessing,
                  onPressed: onCancel,
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

class _ActiveConnectionCard extends StatelessWidget {
  const _ActiveConnectionCard({
    required this.connection,
    required this.isTrainer,
    required this.onDisconnect,
  });

  final TrainerClient connection;
  final bool isTrainer;
  final VoidCallback onDisconnect;

  String get _name =>
      isTrainer ? connection.clientName : connection.trainerName;

  String? get _photo =>
      isTrainer ? connection.clientPhoto : connection.trainerPhoto;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: AppColors.backgroundCard,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          _UserAvatar(photoUrl: _photo, name: _name),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _name,
                  style: textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'Dal ${_formatDate(connection.createdAt)}',
                  style: textTheme.labelSmall?.copyWith(
                    color: AppColors.textMuted,
                  ),
                ),
              ],
            ),
          ),
          const _StatusBadge(status: 'ACCEPTED'),
          const SizedBox(width: 8),
          IconButton(
            onPressed: onDisconnect,
            icon: const Icon(Icons.link_off_rounded),
            color: AppColors.danger,
            tooltip: 'Disconnetti',
            style: IconButton.styleFrom(
              backgroundColor: AppColors.danger.withValues(alpha: 0.1),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _PlanRequestCard extends StatelessWidget {
  const _PlanRequestCard({
    required this.request,
    required this.isTrainer,
    required this.isProcessing,
    this.onAccept,
    this.onReject,
  });

  final PlanRequest request;
  final bool isTrainer;
  final bool isProcessing;
  final VoidCallback? onAccept;
  final VoidCallback? onReject;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: AppColors.backgroundCard,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.assignment_outlined,
                color: AppColors.primary,
                size: 20,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      isTrainer
                          ? 'Da: ${request.clientName}'
                          : 'A: ${request.trainerName ?? 'Trainer'}',
                      style: textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      _formatDate(request.createdAt),
                      style: textTheme.labelSmall?.copyWith(
                        color: AppColors.textMuted,
                      ),
                    ),
                  ],
                ),
              ),
              _StatusBadge(status: request.status),
            ],
          ),
          if (request.message != null && request.message!.isNotEmpty) ...[
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: AppColors.backgroundCardHover,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                request.message!,
                style: textTheme.bodySmall?.copyWith(
                  color: AppColors.textSecondary,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ),
          ],
          if (request.notes != null && request.notes!.isNotEmpty) ...[
            const SizedBox(height: 6),
            Text(
              'Note: ${request.notes}',
              style: textTheme.bodySmall?.copyWith(
                color: AppColors.textMuted,
              ),
            ),
          ],
          if (isTrainer && request.status == 'PENDING') ...[
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _ActionButton(
                    label: 'Accetta',
                    color: AppColors.success,
                    icon: Icons.check_rounded,
                    isLoading: isProcessing,
                    onPressed: onAccept,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _ActionButton(
                    label: 'Rifiuta',
                    color: AppColors.danger,
                    icon: Icons.close_rounded,
                    isLoading: isProcessing,
                    onPressed: onReject,
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Shared widgets
// ---------------------------------------------------------------------------

class _UserAvatar extends StatelessWidget {
  const _UserAvatar({required this.name, this.photoUrl});

  final String name;
  final String? photoUrl;

  @override
  Widget build(BuildContext context) {
    if (photoUrl != null && photoUrl!.isNotEmpty) {
      return CircleAvatar(
        radius: 24,
        backgroundImage: CachedNetworkImageProvider(photoUrl!),
      );
    }
    final initials = name.isNotEmpty
        ? name
            .split(' ')
            .take(2)
            .map((w) => w.isNotEmpty ? w[0].toUpperCase() : '')
            .join()
        : '?';
    return CircleAvatar(
      radius: 24,
      backgroundColor: AppColors.primary.withValues(alpha: 0.2),
      child: Text(
        initials,
        style: const TextStyle(
          color: AppColors.primary,
          fontWeight: FontWeight.w700,
          fontSize: 14,
        ),
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  const _StatusBadge({required this.status});

  final String status;

  @override
  Widget build(BuildContext context) {
    final (label, color) = switch (status.toUpperCase()) {
      'PENDING' => ('In Attesa', const Color(0xFFFF9800)),
      'ACCEPTED' => ('Attiva', AppColors.success),
      'REJECTED' => ('Rifiutata', AppColors.danger),
      _ => (status, AppColors.textMuted),
    };

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: color.withValues(alpha: 0.4)),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontSize: 11,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  const _ActionButton({
    required this.label,
    required this.color,
    required this.icon,
    required this.isLoading,
    this.onPressed,
  });

  final String label;
  final Color color;
  final IconData icon;
  final bool isLoading;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      style: ElevatedButton.styleFrom(
        backgroundColor: color.withValues(alpha: 0.15),
        foregroundColor: color,
        side: BorderSide(color: color.withValues(alpha: 0.4)),
        minimumSize: const Size(0, 40),
        padding: const EdgeInsets.symmetric(horizontal: 12),
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      onPressed: isLoading ? null : onPressed,
      icon: isLoading
          ? SizedBox(
              width: 16,
              height: 16,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: color,
              ),
            )
          : Icon(icon, size: 16),
      label: Text(
        label,
        style: const TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 13,
        ),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.title, this.count});

  final String title;
  final int? count;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Row(
      children: [
        Text(
          title,
          style: textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),
        if (count != null) ...[
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              '$count',
              style: const TextStyle(
                color: AppColors.primary,
                fontSize: 12,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ],
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  final IconData icon;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(48),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 64, color: AppColors.textMuted),
            const SizedBox(height: 16),
            Text(
              title,
              style: textTheme.titleMedium?.copyWith(
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              subtitle,
              style: textTheme.bodySmall?.copyWith(
                color: AppColors.textMuted,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class _ErrorState extends StatelessWidget {
  const _ErrorState({required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.error_outline,
              size: 48,
              color: AppColors.danger,
            ),
            const SizedBox(height: 12),
            Text(
              message,
              style: const TextStyle(color: AppColors.textSecondary),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            OutlinedButton(
              onPressed: onRetry,
              child: const Text('Riprova'),
            ),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Helpers
// ---------------------------------------------------------------------------

String _formatDate(String isoDate) {
  try {
    final dt = DateTime.parse(isoDate).toLocal();
    return DateFormat('dd MMM yyyy', 'it_IT').format(dt);
  } catch (_) {
    return isoDate;
  }
}
