import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:palestra/core/theme/app_colors.dart';
import 'package:palestra/data/models/body_check_model.dart';
import 'package:palestra/presentation/auth/providers/auth_providers.dart';
import 'package:palestra/presentation/shared/providers/body_check_providers.dart';
import 'package:palestra/presentation/shared/providers/user_providers.dart';
import 'package:shimmer/shimmer.dart';

// ---------------------------------------------------------------------------
// Detail screen
// ---------------------------------------------------------------------------

class BodyCheckDetailScreen extends ConsumerWidget {
  const BodyCheckDetailScreen({required this.bodyCheckId, super.key});

  final int bodyCheckId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final detailAsync = ref.watch(bodyCheckDetailProvider(bodyCheckId));

    return detailAsync.when(
      data: (bodyCheck) => _DetailContent(
        bodyCheck: bodyCheck,
        onRefresh: () =>
            ref.invalidate(bodyCheckDetailProvider(bodyCheckId)),
      ),
      loading: () => Scaffold(
        backgroundColor: AppColors.backgroundBase,
        appBar: AppBar(
          backgroundColor: AppColors.backgroundBase,
          title: const Text('Body Check'),
        ),
        body: const Center(child: CircularProgressIndicator()),
      ),
      error: (err, _) => Scaffold(
        backgroundColor: AppColors.backgroundBase,
        appBar: AppBar(
          backgroundColor: AppColors.backgroundBase,
          title: const Text('Body Check'),
        ),
        body: _ErrorBody(
          onRetry: () =>
              ref.invalidate(bodyCheckDetailProvider(bodyCheckId)),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Main content
// ---------------------------------------------------------------------------

class _DetailContent extends ConsumerStatefulWidget {
  const _DetailContent({
    required this.bodyCheck,
    required this.onRefresh,
  });

  final BodyCheckModel bodyCheck;
  final VoidCallback onRefresh;

  @override
  ConsumerState<_DetailContent> createState() => _DetailContentState();
}

class _DetailContentState extends ConsumerState<_DetailContent> {
  final _commentController = TextEditingController();
  final _scrollController = ScrollController();
  bool _isSendingComment = false;
  int _currentPage = 0;

  @override
  void dispose() {
    _commentController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _sendComment() async {
    final text = _commentController.text.trim();
    if (text.isEmpty) return;

    setState(() => _isSendingComment = true);
    try {
      final repo = ref.read(bodyCheckRepositoryProvider);
      await repo.addComment(
        bodyCheckId: widget.bodyCheck.id,
        message: text,
      );
      _commentController.clear();
      widget.onRefresh();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Errore: $e'),
            backgroundColor: AppColors.danger,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isSendingComment = false);
    }
  }

  Future<void> _addPhoto() async {
    final position = await _showPositionPicker(context);
    if (position == null || !mounted) return;

    try {
      final picker = ImagePicker();
      final picked = await picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 85,
      );
      if (picked == null || !mounted) return;

      final repo = ref.read(bodyCheckRepositoryProvider);
      await repo.uploadPhoto(
        bodyCheckId: widget.bodyCheck.id,
        filePath: picked.path,
        position: position,
      );
      widget.onRefresh();
    } on Exception catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Errore caricamento foto: $e'),
            backgroundColor: AppColors.danger,
          ),
        );
      }
    }
  }

  Future<void> _deleteBodyCheck() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.backgroundCard,
        title: const Text('Elimina Body Check'),
        content: const Text(
          'Sei sicuro di voler eliminare questo body check? '
          "L'operazione non è reversibile.",
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Annulla'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: TextButton.styleFrom(
              foregroundColor: AppColors.danger,
            ),
            child: const Text('Elimina'),
          ),
        ],
      ),
    );

    if (confirmed != true || !mounted) return;

    try {
      final repo = ref.read(bodyCheckRepositoryProvider);
      await repo.deleteBodyCheck(widget.bodyCheck.id);
      ref.invalidate(bodyChecksProvider);
      if (mounted) context.pop();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Errore: $e'),
            backgroundColor: AppColors.danger,
          ),
        );
      }
    }
  }

  Future<void> _shareWithTrainer() async {
    final trainersAsync = ref.read(myTrainersProvider);
    final trainers = trainersAsync.valueOrNull ?? [];

    if (trainers.isEmpty) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Nessun trainer disponibile'),
          backgroundColor: AppColors.textMuted,
        ),
      );
      return;
    }

    if (!mounted) return;
    await showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.backgroundCard,
        title: const Text('Condividi con trainer'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: trainers
              .map(
                (t) => ListTile(
                  title: Text(t.trainerName),
                  trailing: const Icon(
                    Icons.share_rounded,
                    color: AppColors.primary,
                  ),
                  onTap: () async {
                    Navigator.pop(ctx);
                    try {
                      final repo = ref.read(bodyCheckRepositoryProvider);
                      await repo.shareWithTrainer(
                        bodyCheckId: widget.bodyCheck.id,
                        trainerId: t.trainer,
                      );
                      widget.onRefresh();
                      if (ctx.mounted) {
                        ScaffoldMessenger.of(ctx).showSnackBar(
                          const SnackBar(
                            content: Text('Condiviso con successo'),
                            backgroundColor: AppColors.success,
                          ),
                        );
                      }
                    } catch (e) {
                      if (ctx.mounted) {
                        ScaffoldMessenger.of(ctx).showSnackBar(
                          SnackBar(
                            content: Text('Errore: $e'),
                            backgroundColor: AppColors.danger,
                          ),
                        );
                      }
                    }
                  },
                ),
              )
              .toList(),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Chiudi'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bodyCheck = widget.bodyCheck;
    final userAsync = ref.watch(currentUserProvider);
    final currentUserId = userAsync.valueOrNull?.id;
    final isOwner = bodyCheck.isOwner ||
        (currentUserId != null && currentUserId == bodyCheck.client);

    return Scaffold(
      backgroundColor: AppColors.backgroundBase,
      appBar: AppBar(
        backgroundColor: AppColors.backgroundBase,
        title: Text(
          bodyCheck.title,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.compare_rounded),
            tooltip: 'Confronta progressi',
            onPressed: () =>
                context.push('/body-checks/compare'),
          ),
          if (isOwner) ...[
            IconButton(
              icon: const Icon(Icons.share_rounded),
              tooltip: 'Condividi',
              onPressed: _shareWithTrainer,
            ),
            IconButton(
              icon: const Icon(
                Icons.delete_outline_rounded,
                color: AppColors.danger,
              ),
              tooltip: 'Elimina',
              onPressed: _deleteBodyCheck,
            ),
          ],
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: CustomScrollView(
              controller: _scrollController,
              slivers: [
                SliverToBoxAdapter(
                  child: _PhotoCarousel(
                    photos: bodyCheck.photos,
                    isOwner: isOwner,
                    currentPage: _currentPage,
                    onPageChanged: (p) =>
                        setState(() => _currentPage = p),
                    onAddPhoto: isOwner ? _addPhoto : null,
                  ),
                ),
                SliverToBoxAdapter(
                  child: _InfoSection(bodyCheck: bodyCheck),
                ),
                SliverToBoxAdapter(
                  child: _CommentsSection(
                    comments: bodyCheck.comments,
                    currentUserId: currentUserId,
                  ),
                ),
                const SliverToBoxAdapter(
                  child: SizedBox(height: 16),
                ),
              ],
            ),
          ),
          _CommentInput(
            controller: _commentController,
            isSending: _isSendingComment,
            onSend: _sendComment,
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Photo carousel
// ---------------------------------------------------------------------------

class _PhotoCarousel extends StatelessWidget {
  const _PhotoCarousel({
    required this.photos,
    required this.isOwner,
    required this.currentPage,
    required this.onPageChanged,
    required this.onAddPhoto,
  });

  final List<BodyCheckPhoto> photos;
  final bool isOwner;
  final int currentPage;
  final void Function(int) onPageChanged;
  final VoidCallback? onAddPhoto;

  @override
  Widget build(BuildContext context) {
    if (photos.isEmpty) {
      return _EmptyCarousel(isOwner: isOwner, onAddPhoto: onAddPhoto);
    }

    return Column(
      children: [
        SizedBox(
          height: 320,
          child: PageView.builder(
            itemCount: photos.length,
            onPageChanged: onPageChanged,
            itemBuilder: (context, index) =>
                _PhotoPage(photo: photos[index]),
          ),
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ...List.generate(
              photos.length,
              (i) => AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                width: i == currentPage ? 20 : 6,
                height: 6,
                margin: const EdgeInsets.symmetric(horizontal: 3),
                decoration: BoxDecoration(
                  color: i == currentPage
                      ? AppColors.primary
                      : AppColors.textMuted,
                  borderRadius: BorderRadius.circular(3),
                ),
              ),
            ),
            if (isOwner && onAddPhoto != null) ...[
              const SizedBox(width: 12),
              InkWell(
                onTap: onAddPhoto,
                borderRadius: BorderRadius.circular(16),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: AppColors.primary.withValues(alpha: 0.4),
                    ),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.add_photo_alternate_rounded,
                        size: 14,
                        color: AppColors.primary,
                      ),
                      SizedBox(width: 4),
                      Text(
                        'Aggiungi',
                        style: TextStyle(
                          color: AppColors.primary,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ],
        ),
        const SizedBox(height: 8),
      ],
    );
  }
}

class _PhotoPage extends StatelessWidget {
  const _PhotoPage({required this.photo});

  final BodyCheckPhoto photo;

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        const ColoredBox(color: AppColors.backgroundDeepest),
        Image.network(
          photo.photo,
          fit: BoxFit.contain,
          loadingBuilder: (_, child, progress) {
            if (progress == null) return child;
            return Shimmer.fromColors(
              baseColor: AppColors.backgroundCard,
              highlightColor: AppColors.backgroundCardHover,
              child: const ColoredBox(color: AppColors.backgroundCard),
            );
          },
          errorBuilder: (_, __, ___) => const Center(
            child: Icon(
              Icons.broken_image_rounded,
              size: 64,
              color: AppColors.textMuted,
            ),
          ),
        ),
        Positioned(
          bottom: 12,
          left: 16,
          child: Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: AppColors.backgroundDeepest.withValues(alpha: 0.75),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              photo.positionDisplay,
              style: const TextStyle(
                color: AppColors.textPrimary,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _EmptyCarousel extends StatelessWidget {
  const _EmptyCarousel({
    required this.isOwner,
    required this.onAddPhoto,
  });

  final bool isOwner;
  final VoidCallback? onAddPhoto;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 220,
      color: AppColors.backgroundDeepest,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.photo_camera_outlined,
              size: 56,
              color: AppColors.textMuted,
            ),
            const SizedBox(height: 12),
            const Text(
              'Nessuna foto',
              style: TextStyle(
                color: AppColors.textMuted,
                fontSize: 14,
              ),
            ),
            if (isOwner && onAddPhoto != null) ...[
              const SizedBox(height: 16),
              FilledButton.icon(
                onPressed: onAddPhoto,
                style: FilledButton.styleFrom(
                  backgroundColor: AppColors.primary,
                ),
                icon: const Icon(Icons.add_photo_alternate_rounded),
                label: const Text('Aggiungi Foto'),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Info section
// ---------------------------------------------------------------------------

class _InfoSection extends StatelessWidget {
  const _InfoSection({required this.bodyCheck});

  final BodyCheckModel bodyCheck;

  @override
  Widget build(BuildContext context) {
    final dateStr = _formatDate(bodyCheck.date);

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            bodyCheck.title,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              const Icon(
                Icons.calendar_today_outlined,
                size: 14,
                color: AppColors.textMuted,
              ),
              const SizedBox(width: 6),
              Text(
                dateStr,
                style: const TextStyle(
                  color: AppColors.textMuted,
                  fontSize: 13,
                ),
              ),
            ],
          ),
          if (bodyCheck.weightKg != null ||
              bodyCheck.bodyFatPercent != null) ...[
            const SizedBox(height: 12),
            Row(
              children: [
                if (bodyCheck.weightKg != null)
                  _StatChip(
                    icon: Icons.monitor_weight_outlined,
                    label:
                        '${bodyCheck.weightKg!.toStringAsFixed(1)} kg',
                  ),
                if (bodyCheck.weightKg != null &&
                    bodyCheck.bodyFatPercent != null)
                  const SizedBox(width: 8),
                if (bodyCheck.bodyFatPercent != null)
                  _StatChip(
                    icon: Icons.percent_rounded,
                    label:
                        // ignore: lines_longer_than_80_chars
                        '${bodyCheck.bodyFatPercent!.toStringAsFixed(1)}% grasso',
                  ),
              ],
            ),
          ],
          if (bodyCheck.notes != null &&
              bodyCheck.notes!.isNotEmpty) ...[
            const SizedBox(height: 14),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.backgroundCard,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: AppColors.border),
              ),
              child: Text(
                bodyCheck.notes!,
                style: const TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 14,
                  height: 1.5,
                ),
              ),
            ),
          ],
          const SizedBox(height: 20),
          const Divider(color: AppColors.border, height: 1),
        ],
      ),
    );
  }

  String _formatDate(String dateStr) {
    try {
      final date = DateTime.parse(dateStr);
      return DateFormat('EEEE d MMMM yyyy', 'it').format(date);
    } catch (_) {
      return dateStr;
    }
  }
}

class _StatChip extends StatelessWidget {
  const _StatChip({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: AppColors.primary.withValues(alpha: 0.3),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: AppColors.primary),
          const SizedBox(width: 6),
          Text(
            label,
            style: const TextStyle(
              color: AppColors.primary,
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Comments section
// ---------------------------------------------------------------------------

class _CommentsSection extends StatelessWidget {
  const _CommentsSection({
    required this.comments,
    required this.currentUserId,
  });

  final List<BodyCheckComment> comments;
  final int? currentUserId;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Commenti (${comments.length})',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
          ),
          const SizedBox(height: 12),
          if (comments.isEmpty)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 12),
              child: Text(
                'Nessun commento ancora.',
                style: TextStyle(
                  color: AppColors.textMuted,
                  fontSize: 14,
                ),
              ),
            )
          else
            ...comments.map(
              (c) => _CommentBubble(
                comment: c,
                isOwn: c.isOwn ||
                    (currentUserId != null &&
                        currentUserId == c.author),
              ),
            ),
        ],
      ),
    );
  }
}

class _CommentBubble extends StatelessWidget {
  const _CommentBubble({
    required this.comment,
    required this.isOwn,
  });

  final BodyCheckComment comment;
  final bool isOwn;

  @override
  Widget build(BuildContext context) {
    final timeAgo = _timeAgo(comment.createdAt);
    final isTrainer = comment.authorRole.toUpperCase() == 'TRAINER';

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: isOwn
            ? MainAxisAlignment.end
            : MainAxisAlignment.start,
        children: [
          if (!isOwn) ...[
            _Avatar(
              photoUrl: comment.authorPhoto,
              name: comment.authorName,
            ),
            const SizedBox(width: 8),
          ],
          Flexible(
            child: Column(
              crossAxisAlignment: isOwn
                  ? CrossAxisAlignment.end
                  : CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      comment.authorName,
                      style: const TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    if (isTrainer) ...[
                      const SizedBox(width: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color:
                              AppColors.secondary.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: const Text(
                          'TRAINER',
                          style: TextStyle(
                            color: AppColors.secondary,
                            fontSize: 9,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: 4),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: isOwn
                        ? AppColors.primary.withValues(alpha: 0.15)
                        : AppColors.backgroundCard,
                    borderRadius: BorderRadius.only(
                      topLeft: const Radius.circular(16),
                      topRight: const Radius.circular(16),
                      bottomLeft: Radius.circular(isOwn ? 16 : 4),
                      bottomRight: Radius.circular(isOwn ? 4 : 16),
                    ),
                    border: Border.all(
                      color: isOwn
                          ? AppColors.primary.withValues(alpha: 0.25)
                          : AppColors.border,
                    ),
                  ),
                  child: Text(
                    comment.message,
                    style: const TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 14,
                      height: 1.4,
                    ),
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  timeAgo,
                  style: const TextStyle(
                    color: AppColors.textMuted,
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),
          if (isOwn) ...[
            const SizedBox(width: 8),
            _Avatar(
              photoUrl: comment.authorPhoto,
              name: comment.authorName,
            ),
          ],
        ],
      ),
    );
  }

  String _timeAgo(String createdAt) {
    try {
      final dt = DateTime.parse(createdAt).toLocal();
      final now = DateTime.now();
      final diff = now.difference(dt);
      if (diff.inMinutes < 1) return 'adesso';
      if (diff.inMinutes < 60) return '${diff.inMinutes} min fa';
      if (diff.inHours < 24) return '${diff.inHours} ore fa';
      if (diff.inDays < 7) return '${diff.inDays} giorni fa';
      return DateFormat('d MMM', 'it').format(dt);
    } catch (_) {
      return '';
    }
  }
}

class _Avatar extends StatelessWidget {
  const _Avatar({required this.name, this.photoUrl});

  final String? photoUrl;
  final String name;

  @override
  Widget build(BuildContext context) {
    final initial =
        name.isNotEmpty ? name[0].toUpperCase() : '?';

    return Container(
      width: 32,
      height: 32,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        color: AppColors.backgroundCardHover,
      ),
      clipBehavior: Clip.hardEdge,
      child: photoUrl != null
          ? Image.network(
              photoUrl!,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Center(
                child: Text(
                  initial,
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            )
          : Center(
              child: Text(
                initial,
                style: const TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
    );
  }
}

// ---------------------------------------------------------------------------
// Comment input
// ---------------------------------------------------------------------------

class _CommentInput extends StatelessWidget {
  const _CommentInput({
    required this.controller,
    required this.isSending,
    required this.onSend,
  });

  final TextEditingController controller;
  final bool isSending;
  final VoidCallback onSend;

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.viewInsetsOf(context).bottom;

    return Container(
      padding: EdgeInsets.fromLTRB(12, 8, 12, 8 + bottomInset),
      decoration: const BoxDecoration(
        color: AppColors.backgroundCard,
        border: Border(
          top: BorderSide(color: AppColors.border),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: controller,
              decoration: const InputDecoration(
                hintText: 'Scrivi un commento…',
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 10,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(24)),
                  borderSide: BorderSide(color: AppColors.border),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(24)),
                  borderSide: BorderSide(color: AppColors.border),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(24)),
                  borderSide: BorderSide(color: AppColors.primary),
                ),
                filled: true,
                fillColor: AppColors.backgroundInput,
              ),
              maxLines: 3,
              minLines: 1,
              textCapitalization: TextCapitalization.sentences,
              onSubmitted: (_) => onSend(),
            ),
          ),
          const SizedBox(width: 8),
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 200),
            child: isSending
                ? const SizedBox(
                    key: ValueKey('loading'),
                    width: 44,
                    height: 44,
                    child: Center(
                      child: SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                  )
                : IconButton(
                    key: const ValueKey('send'),
                    onPressed: onSend,
                    icon: const Icon(Icons.send_rounded),
                    color: AppColors.primary,
                    style: IconButton.styleFrom(
                      backgroundColor:
                          AppColors.primary.withValues(alpha: 0.12),
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Position picker
// ---------------------------------------------------------------------------

Future<String?> _showPositionPicker(BuildContext context) {
  return showModalBottomSheet<String>(
    context: context,
    backgroundColor: AppColors.backgroundCard,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (ctx) => SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: AppColors.border,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            Text(
              'Posizione foto',
              style: Theme.of(ctx).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              mainAxisSpacing: 10,
              crossAxisSpacing: 10,
              childAspectRatio: 3,
              physics: const NeverScrollableScrollPhysics(),
              children: const [
                ('front', 'Fronte', Icons.face_rounded),
                ('back', 'Retro', Icons.accessibility_new_rounded),
                ('left', 'Sinistra', Icons.arrow_back_ios_rounded),
                ('right', 'Destra', Icons.arrow_forward_ios_rounded),
              ]
                  .map(
                    (p) => _PositionTile(
                      value: p.$1,
                      label: p.$2,
                      icon: p.$3,
                    ),
                  )
                  .toList(),
            ),
          ],
        ),
      ),
    ),
  );
}

class _PositionTile extends StatelessWidget {
  const _PositionTile({
    required this.value,
    required this.label,
    required this.icon,
  });

  final String value;
  final String label;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => Navigator.pop(context, value),
      borderRadius: BorderRadius.circular(10),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.backgroundCardHover,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: AppColors.border),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 18, color: AppColors.primary),
            const SizedBox(width: 8),
            Text(
              label,
              style: const TextStyle(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Error body
// ---------------------------------------------------------------------------

class _ErrorBody extends StatelessWidget {
  const _ErrorBody({required this.onRetry});

  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.error_outline_rounded,
            size: 48,
            color: AppColors.danger,
          ),
          const SizedBox(height: 12),
          Text(
            'Errore nel caricamento',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 16),
          FilledButton(
            onPressed: onRetry,
            child: const Text('Riprova'),
          ),
        ],
      ),
    );
  }
}
