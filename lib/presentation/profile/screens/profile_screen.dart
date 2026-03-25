import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:palestra/data/models/body_metric_model.dart';
import 'package:palestra/data/models/user_model.dart';
import 'package:palestra/presentation/auth/providers/auth_providers.dart';
import 'package:palestra/presentation/shared/providers/user_providers.dart';
import 'package:palestra/presentation/shared/widgets/shimmer_loading.dart';


class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userAsync = ref.watch(currentUserProvider);

    return userAsync.when(
      data: (user) {
        if (user == null) {
          return const ShimmerLoading(type: ShimmerType.profile);
        }
        return _ProfileBody(user: user);
      },
      loading: () => const ShimmerLoading(type: ShimmerType.profile),
      error: (error, _) => Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 48),
            const SizedBox(height: 8),
            Text('Errore nel caricamento: $error'),
            const SizedBox(height: 16),
            FilledButton(
              onPressed: () => ref.invalidate(currentUserProvider),
              child: const Text('Riprova'),
            ),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Main body
// ---------------------------------------------------------------------------

class _ProfileBody extends ConsumerWidget {
  const _ProfileBody({required this.user});

  final UserModel user;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final metricsAsync = ref.watch(latestMetricsProvider);

    Future<void> onRefresh() async {
      ref
        ..invalidate(currentUserProvider)
        ..invalidate(latestMetricsProvider)
        ..invalidate(myClientsProvider)
        ..invalidate(myTrainersProvider);
    }

    return RefreshIndicator(
      onRefresh: onRefresh,
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Align(
            alignment: Alignment.centerRight,
            child: IconButton(
              icon: const Icon(Icons.settings_outlined),
              tooltip: 'Impostazioni',
              onPressed: () => context.push('/profile/settings'),
            ),
          ),
          _PhotoSection(user: user),
          const SizedBox(height: 16),
          _PersonalInfoCard(user: user),
          const SizedBox(height: 16),
          _InfoGrid(user: user),
          const SizedBox(height: 16),
          metricsAsync.when(
            data: (metric) => _BodyMeasurementsCard(metric: metric),
            loading: () => const ShimmerLoading(type: ShimmerType.card),
            error: (_, __) => const SizedBox.shrink(),
          ),
          if (metricsAsync.hasValue) const SizedBox(height: 16),
          if (user.role == 'CLIENT') ...[
            _PrivacySettingsCard(user: user),
            const SizedBox(height: 16),
          ],
          _RelationsSection(user: user),
          const SizedBox(height: 24),
          _LogoutButton(),
          const SizedBox(height: 96),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Photo section
// ---------------------------------------------------------------------------

class _PhotoSection extends StatelessWidget {
  const _PhotoSection({required this.user});

  final UserModel user;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final initials = _initials(user);

    return Center(
      child: Stack(
        children: [
          CircleAvatar(
            radius: 60,
            backgroundColor: colorScheme.primaryContainer,
            backgroundImage: user.photo != null
                ? CachedNetworkImageProvider(user.photo!)
                : null,
            child: user.photo == null
                ? Text(
                    initials,
                    style: textTheme.headlineMedium?.copyWith(
                      color: colorScheme.onPrimaryContainer,
                      fontWeight: FontWeight.bold,
                    ),
                  )
                : null,
          ),
          Positioned(
            bottom: 0,
            right: 0,
            child: Material(
              color: colorScheme.primary,
              shape: const CircleBorder(),
              child: InkWell(
                customBorder: const CircleBorder(),
                onTap: () => context.push('/profile/edit'),
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: Icon(
                    Icons.camera_alt,
                    size: 18,
                    color: colorScheme.onPrimary,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _initials(UserModel u) {
    final first = u.firstName.isNotEmpty ? u.firstName[0] : '';
    final last = u.lastName.isNotEmpty ? u.lastName[0] : '';
    return '$first$last'.toUpperCase();
  }
}

// ---------------------------------------------------------------------------
// Personal info card
// ---------------------------------------------------------------------------

class _PersonalInfoCard extends StatelessWidget {
  const _PersonalInfoCard({required this.user});

  final UserModel user;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    final isTrainer = user.role == 'TRAINER';

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    user.fullName,
                    style: textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Chip(
                  label: Text(
                    isTrainer ? 'Trainer' : 'Cliente',
                    style: textTheme.labelSmall?.copyWith(
                      color: isTrainer
                          ? colorScheme.onTertiaryContainer
                          : colorScheme.onSecondaryContainer,
                    ),
                  ),
                  backgroundColor: isTrainer
                      ? colorScheme.tertiaryContainer
                      : colorScheme.secondaryContainer,
                  visualDensity: VisualDensity.compact,
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              user.email,
              style: textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
            if (user.bio != null && user.bio!.isNotEmpty) ...[
              const SizedBox(height: 8),
              Text(user.bio!, style: textTheme.bodySmall),
            ],
            const SizedBox(height: 12),
            OutlinedButton.icon(
              onPressed: () => context.push('/profile/edit'),
              icon: const Icon(Icons.edit_outlined, size: 18),
              label: const Text('Modifica'),
            ),
          ],
        ),
      ),
    );
  }


}

// ---------------------------------------------------------------------------
// Info grid
// ---------------------------------------------------------------------------

class _InfoGrid extends StatelessWidget {
  const _InfoGrid({required this.user});

  final UserModel user;

  @override
  Widget build(BuildContext context) {
    final height = user.height != null ? '${user.height!.toInt()} cm' : '—';
    final age = user.age != null ? '${user.age} anni' : '—';
    final phone = user.phone ?? '—';

    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Row(
          children: [
            _InfoGridItem(label: 'Altezza', value: height),
            _InfoGridItem(label: 'Età', value: age),
            _InfoGridItem(label: 'Telefono', value: phone),
          ],
        ),
      ),
    );
  }
}

class _InfoGridItem extends StatelessWidget {
  const _InfoGridItem({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Expanded(
      child: Column(
        children: [
          Text(
            value,
            style: textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: textTheme.labelSmall?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Body measurements card
// ---------------------------------------------------------------------------

class _BodyMeasurementsCard extends StatelessWidget {
  const _BodyMeasurementsCard({required this.metric});

  final BodyMetric? metric;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    String fmt(double? v, String unit) =>
        v != null ? '${v.toStringAsFixed(1)} $unit' : '—';

    String? dateLabel;
    if (metric != null) {
      try {
        final dt = DateTime.parse(metric!.recordedAt);
        dateLabel =
            DateFormat('dd MMM yyyy', 'it_IT').format(dt);
      } catch (_) {
        dateLabel = metric!.recordedAt;
      }
    }

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    'Misurazioni Corporee',
                    style: textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                if (dateLabel != null)
                  Text(
                    dateLabel,
                    style: textTheme.labelSmall?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 12),
            if (metric == null)
              Text(
                'Nessuna misurazione disponibile',
                style: textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              )
            else ...[
              Row(
                children: [
                  _MeasurementItem(
                    label: 'Peso',
                    value: fmt(metric!.weight, 'kg'),
                  ),
                  _MeasurementItem(
                    label: 'Petto',
                    value: fmt(metric!.chest, 'cm'),
                  ),
                  _MeasurementItem(
                    label: 'Vita',
                    value: fmt(metric!.waist, 'cm'),
                  ),
                  _MeasurementItem(
                    label: 'Fianchi',
                    value: fmt(metric!.hips, 'cm'),
                  ),
                ],
              ),
            ],
            const SizedBox(height: 8),
            TextButton(
              onPressed: () => context.push('/body-metrics'),
              child: const Text('Vedi storico'),
            ),
          ],
        ),
      ),
    );
  }
}

class _MeasurementItem extends StatelessWidget {
  const _MeasurementItem({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Expanded(
      child: Column(
        children: [
          Text(
            value,
            style: textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          Text(
            label,
            style: textTheme.labelSmall?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Privacy settings (CLIENT only)
// ---------------------------------------------------------------------------

class _PrivacySettingsCard extends ConsumerWidget {
  const _PrivacySettingsCard({required this.user});

  final UserModel user;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: SwitchListTile(
          title: const Text('Condividi Body Check con i Trainer'),
          subtitle: const Text(
            'I tuoi trainer potranno vedere le tue '
            'foto e misurazioni corporee',
          ),
          value: user.shareBodyChecksWithTrainers,
          onChanged: (value) async {
            final repo = ref.read(userRepositoryProvider);
            await repo.updateProfile({
              'share_body_checks_with_trainers': value,
            });
            ref.invalidate(currentUserProvider);
          },
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Relations section
// ---------------------------------------------------------------------------

class _RelationsSection extends ConsumerWidget {
  const _RelationsSection({required this.user});

  final UserModel user;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isTrainer = user.role == 'TRAINER';
    final textTheme = Theme.of(context).textTheme;

    if (isTrainer) {
      final clientsAsync = ref.watch(myClientsProvider);
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'I Miei Clienti',
            style: textTheme.titleMedium
                ?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          clientsAsync.when(
            data: (clients) => clients.isEmpty
                ? const _EmptyRelations(
                    message: 'Nessun cliente associato',
                  )
                : _RelationList(
                    items: clients
                        .map(
                          (c) => _RelationItem(
                            name: c.clientName,
                            photo: c.clientPhoto,
                          ),
                        )
                        .toList(),
                  ),
            loading: () => const ShimmerLoading(),
            error: (_, __) => const _EmptyRelations(
              message: 'Errore nel caricamento',
            ),
          ),
        ],
      );
    }

    final trainersAsync = ref.watch(myTrainersProvider);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'I Miei Trainer',
          style: textTheme.titleMedium
              ?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        trainersAsync.when(
          data: (trainers) => trainers.isEmpty
              ? const _EmptyRelations(
                  message: 'Nessun trainer associato',
                )
              : _RelationList(
                  items: trainers
                      .map(
                        (t) => _RelationItem(
                          name: t.trainerName,
                          photo: t.trainerPhoto,
                        ),
                      )
                      .toList(),
                ),
          loading: () => const ShimmerLoading(),
          error: (_, __) => const _EmptyRelations(
            message: 'Errore nel caricamento',
          ),
        ),
      ],
    );
  }
}

class _RelationItem {
  const _RelationItem({required this.name, this.photo});

  final String name;
  final String? photo;
}

class _RelationList extends StatelessWidget {
  const _RelationList({required this.items});

  final List<_RelationItem> items;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: items.map((item) {
          final isLast = item == items.last;
          return Column(
            children: [
              ListTile(
                leading: _RelationAvatar(
                  name: item.name,
                  photo: item.photo,
                ),
                title: Text(item.name),
              ),
              if (!isLast) const Divider(height: 1, indent: 72),
            ],
          );
        }).toList(),
      ),
    );
  }
}

class _RelationAvatar extends StatelessWidget {
  const _RelationAvatar({required this.name, this.photo});

  final String name;
  final String? photo;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final initial =
        name.isNotEmpty ? name[0].toUpperCase() : '?';

    if (photo != null) {
      return CircleAvatar(
        backgroundImage: CachedNetworkImageProvider(photo!),
      );
    }
    return CircleAvatar(
      backgroundColor: colorScheme.primaryContainer,
      child: Text(
        initial,
        style: TextStyle(color: colorScheme.onPrimaryContainer),
      ),
    );
  }
}

class _EmptyRelations extends StatelessWidget {
  const _EmptyRelations({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Center(
          child: Text(
            message,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
          ),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Logout button
// ---------------------------------------------------------------------------

class _LogoutButton extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;

    return FilledButton.tonal(
      style: FilledButton.styleFrom(
        backgroundColor: colorScheme.errorContainer,
        foregroundColor: colorScheme.onErrorContainer,
        minimumSize: const Size.fromHeight(48),
      ),
      onPressed: () async {
        final repo = ref.read(authRepositoryProvider);
        await repo.logout();
        ref.read(authStateProvider.notifier).state =
            const AsyncData(AuthState.unauthenticated);
      },
      child: const Text('Esci'),
    );
  }
}
