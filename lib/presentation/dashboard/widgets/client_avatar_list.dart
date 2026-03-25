import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:palestra/core/theme/app_colors.dart';
import 'package:palestra/data/models/relation_models.dart';

class ClientAvatarList extends StatelessWidget {
  const ClientAvatarList({
    required this.clients,
    required this.onClientTap,
    super.key,
  });

  final List<TrainerClient> clients;
  final void Function(TrainerClient client) onClientTap;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    if (clients.isEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Text(
          'Nessun cliente ancora.',
          style: textTheme.bodyMedium?.copyWith(
            color: colorScheme.onSurfaceVariant,
          ),
        ),
      );
    }

    return SizedBox(
      height: 104,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: clients.length,
        separatorBuilder: (_, __) => const SizedBox(width: 16),
        itemBuilder: (context, index) {
          final tc = clients[index];
          return GestureDetector(
            onTap: () => onClientTap(tc),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _ClientAvatar(
                  name: tc.clientName,
                  photoUrl: tc.clientPhoto,
                ),
                const SizedBox(height: 6),
                SizedBox(
                  width: 70,
                  child: Text(
                    tc.clientName.split(' ').first,
                    style: textTheme.labelSmall,
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _ClientAvatar extends StatelessWidget {
  const _ClientAvatar({required this.name, this.photoUrl});

  final String name;
  final String? photoUrl;

  static String _initials(String name) {
    final parts = name.trim().split(' ');
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    }
    return name.isNotEmpty ? name[0].toUpperCase() : '?';
  }

  @override
  Widget build(BuildContext context) {
    const radius = 32.0;
    const borderWidth = 3.0;
    final url = photoUrl;

    Widget avatarContent;

    if (url != null && url.isNotEmpty) {
      avatarContent = CircleAvatar(
        radius: radius,
        backgroundImage: CachedNetworkImageProvider(url),
        backgroundColor: AppColors.backgroundCard,
      );
    } else {
      avatarContent = Container(
        width: radius * 2,
        height: radius * 2,
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [AppColors.primary, AppColors.primaryDark],
          ),
        ),
        child: Center(
          child: Text(
            _initials(name),
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ),
      );
    }

    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: AppColors.primary,
          width: borderWidth,
        ),
      ),
      child: avatarContent,
    );
  }
}
