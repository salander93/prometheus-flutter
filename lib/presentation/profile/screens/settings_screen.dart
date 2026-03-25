import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:palestra/core/theme/app_colors.dart';
import 'package:palestra/presentation/workouts/services/audio_service.dart';
import 'package:palestra/presentation/workouts/services/haptic_service.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  // UI-only placeholders — real persistence is a future task
  bool _darkMode = true;
  bool _pushNotifications = true;
  bool _hapticEnabled = true;
  bool _audioEnabled = true;

  Future<void> _showDeleteAccountDialog() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Elimina Account'),
        content: const Text(
          'Sei sicuro di voler eliminare il tuo account? '
          'Questa azione è irreversibile e tutti i tuoi dati '
          'verranno cancellati definitivamente.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text('Annulla'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: Theme.of(ctx).colorScheme.error,
              foregroundColor: Theme.of(ctx).colorScheme.onError,
            ),
            onPressed: () => Navigator.of(ctx).pop(true),
            child: const Text('Elimina'),
          ),
        ],
      ),
    );

    if ((confirmed ?? false) && mounted) {
      // TODO(dev): implement account deletion API call
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Funzionalità in arrivo prossimamente.'),
        ),
      );
    }
  }

  void _showPlaceholderSnackBar(String feature) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('$feature — prossimamente!')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(title: const Text('Impostazioni')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // ── Aspetto ─────────────────────────────────────────────────────
          _SectionHeader(title: 'Aspetto', textTheme: textTheme),
          Card(
            child: SwitchListTile(
              secondary: const Icon(Icons.dark_mode_outlined),
              title: const Text('Modalità Scura'),
              subtitle: const Text("Tema scuro per l'app"),
              value: _darkMode,
              onChanged: (value) {
                setState(() => _darkMode = value);
                // TODO(dev): persist theme preference via Hive
              },
            ),
          ),

          const SizedBox(height: 16),

          // ── Notifiche ───────────────────────────────────────────────────
          _SectionHeader(title: 'Notifiche', textTheme: textTheme),
          Card(
            child: SwitchListTile(
              secondary: const Icon(Icons.notifications_outlined),
              title: const Text('Notifiche Push'),
              subtitle: const Text('Ricevi aggiornamenti e promemoria'),
              value: _pushNotifications,
              onChanged: (value) {
                setState(() => _pushNotifications = value);
                // TODO(dev): implement push notification permission request
              },
            ),
          ),

          const SizedBox(height: 16),

          // ── Allenamento ─────────────────────────────────────────────────
          _SectionHeader(title: 'Allenamento', textTheme: textTheme),
          Card(
            child: Column(
              children: [
                SwitchListTile(
                  secondary: const Icon(Icons.vibration),
                  title: const Text('Feedback aptico'),
                  subtitle: const Text("Vibrazione durante l'allenamento"),
                  value: _hapticEnabled,
                  activeThumbColor: AppColors.primary,
                  onChanged: (v) {
                    setState(() => _hapticEnabled = v);
                    ref.read(hapticServiceProvider).enabled = v;
                  },
                ),
                const Divider(height: 1, indent: 56),
                SwitchListTile(
                  secondary: const Icon(Icons.volume_up_outlined),
                  title: const Text('Suoni timer'),
                  subtitle: const Text('Beep al termine del recupero'),
                  value: _audioEnabled,
                  activeThumbColor: AppColors.primary,
                  onChanged: (v) {
                    setState(() => _audioEnabled = v);
                    ref.read(audioServiceProvider).enabled = v;
                  },
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // ── Account ─────────────────────────────────────────────────────
          _SectionHeader(title: 'Account', textTheme: textTheme),
          Card(
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.lock_outline),
                  title: const Text('Cambia Password'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => context.push('/forgot-password'),
                ),
                const Divider(height: 1, indent: 56),
                ListTile(
                  leading: Icon(
                    Icons.delete_forever_outlined,
                    color: colorScheme.error,
                  ),
                  title: Text(
                    'Elimina Account',
                    style: TextStyle(color: colorScheme.error),
                  ),
                  trailing: Icon(
                    Icons.chevron_right,
                    color: colorScheme.error,
                  ),
                  onTap: _showDeleteAccountDialog,
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // ── Info ────────────────────────────────────────────────────────
          _SectionHeader(title: 'Informazioni', textTheme: textTheme),
          Card(
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.info_outline),
                  title: const Text('Versione App'),
                  trailing: Text(
                    '1.0.0',
                    style: textTheme.bodyMedium?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                ),
                const Divider(height: 1, indent: 56),
                ListTile(
                  leading: const Icon(Icons.privacy_tip_outlined),
                  title: const Text('Informativa Privacy'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => _showPlaceholderSnackBar('Informativa Privacy'),
                ),
                const Divider(height: 1, indent: 56),
                ListTile(
                  leading: const Icon(Icons.description_outlined),
                  title: const Text('Termini di Servizio'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => _showPlaceholderSnackBar('Termini di Servizio'),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Section header helper
// ---------------------------------------------------------------------------

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({
    required this.title,
    required this.textTheme,
  });

  final String title;
  final TextTheme textTheme;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 8),
      child: Text(
        title,
        style: textTheme.labelLarge?.copyWith(
          color: colorScheme.primary,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
