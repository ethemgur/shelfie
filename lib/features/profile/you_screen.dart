import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../app/routes.dart';
import '../../app/widgets/cover_image.dart';
import '../../data/models/models.dart';
import '../../data/remote/remote_providers.dart';
import '../../l10n/gen/app_localizations.dart';
import '../auth/session_gate.dart';
import '../library/library_repository.dart';

part 'you_screen.g.dart';

typedef FollowCounts = ({int followers, int following});

@riverpod
Future<FollowCounts> followCounts(Ref ref, String userId) async {
  final follows = ref.watch(firestoreProvider).collection('follows');
  final results = await Future.wait([
    follows.where('followeeId', isEqualTo: userId).count().get(),
    follows.where('followerId', isEqualTo: userId).count().get(),
  ]);
  return (followers: results[0].count ?? 0, following: results[1].count ?? 0);
}

/// Own profile (Section 6.8). Stats, updates and recaps land in later phases.
class YouScreen extends ConsumerWidget {
  const YouScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final profile = ref.watch(currentProfileProvider);
    if (profile == null) return const SizedBox.shrink();
    final avatarUrl = profile.avatarUrl;
    final counts = ref.watch(followCountsProvider(profile.id)).value;
    final reading = (ref.watch(myBooksProvider).value ?? const [])
        .where((b) => b.userBook.shelf == Shelf.currentlyReading)
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.tabYou),
        actions: [
          IconButton(
            tooltip: l10n.settingsTitle,
            icon: const Icon(Icons.settings_outlined),
            onPressed: () => context.push(Routes.settings),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 36,
                backgroundImage: avatarUrl == null
                    ? null
                    : NetworkImage(
                        avatarUrl,
                        webHtmlElementStrategy: WebHtmlElementStrategy.fallback,
                      ),
                child: avatarUrl == null
                    ? Text(
                        profile.displayName.characters.first.toUpperCase(),
                        style: theme.textTheme.headlineMedium,
                      )
                    : null,
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      profile.displayName,
                      style: theme.textTheme.titleLarge,
                    ),
                    Text(
                      '@${profile.username}',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                    if (counts != null) ...[
                      const SizedBox(height: 4),
                      Text(
                        l10n.followCounts(counts.followers, counts.following),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
          if (profile.bio != null) ...[
            const SizedBox(height: 12),
            Text(profile.bio!),
          ],
          const SizedBox(height: 24),
          Text(
            l10n.shelfName(Shelf.currentlyReading.name),
            style: theme.textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          if (reading.isEmpty)
            Text(l10n.youNothingReading)
          else
            SizedBox(
              height: 150,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: reading.length,
                separatorBuilder: (_, _) => const SizedBox(width: 12),
                itemBuilder: (context, i) => InkWell(
                  onTap: () => context.push(Routes.book(reading[i].work.id)),
                  child: CoverImage(
                    url: reading[i].coverUrl,
                    width: 100,
                    title: reading[i].work.title,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
