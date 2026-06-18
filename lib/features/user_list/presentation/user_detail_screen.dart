import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_theme.dart';
import 'notifiers/user_list_notifier.dart';
import '../../../core/widgets/common_app_bar.dart';
import '../../../generated/locale_keys.g.dart';

class UserDetailScreen extends ConsumerWidget {
  final int userId;

  const UserDetailScreen({
    super.key,
    required this.userId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final usersAsync = ref.watch(userListNotifierProvider);

    return Scaffold(
      appBar: CommonAppBar(
        title: LocaleKeys.user_list_title.tr(),
        showBackButton: true,
        showActions: true,
        onBack: () => context.pop(),
      ),
      body: SafeArea(
        child: usersAsync.when(
          data: (users) {
            final user = users.firstWhere(
              (u) => u.id == userId,
              orElse: () => throw Exception('User not found'),
            );

            return SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Center(
                    child: Column(
                      children: [
                        CircleAvatar(
                          radius: 40,
                          backgroundColor: context.colorScheme.primary.withValues(alpha: 0.1),
                          foregroundColor: context.colorScheme.primary,
                          child: Text(
                            user.name.isNotEmpty ? user.name.substring(0, 1).toUpperCase() : 'U',
                            style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          user.name,
                          style: context.textTheme.headlineMedium?.copyWith(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '@${user.username}',
                          style: context.textTheme.bodyMedium?.copyWith(
                            color: context.colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  _DetailCard(
                    title: LocaleKeys.user_list_contact_info.tr(),
                    icon: Icons.contact_page_outlined,
                    children: [
                      _DetailRow(icon: Icons.email_outlined, label: LocaleKeys.user_list_email.tr(), value: user.email),
                      _DetailRow(icon: Icons.phone_outlined, label: LocaleKeys.user_list_phone.tr(), value: user.phone),
                      _DetailRow(icon: Icons.language_rounded, label: LocaleKeys.user_list_website.tr(), value: user.website),
                    ],
                  ),
                  const SizedBox(height: 16),
                  _DetailCard(
                    title: LocaleKeys.user_list_company.tr(),
                    icon: Icons.business_outlined,
                    children: [
                      _DetailRow(icon: Icons.storefront_outlined, label: LocaleKeys.user_list_company_name.tr(), value: user.company.name),
                      _DetailRow(icon: Icons.star_border_rounded, label: LocaleKeys.user_list_catch_phrase.tr(), value: user.company.catchPhrase),
                      _DetailRow(icon: Icons.work_outline_rounded, label: LocaleKeys.user_list_business.tr(), value: user.company.bs),
                    ],
                  ),
                  const SizedBox(height: 16),
                  _DetailCard(
                    title: LocaleKeys.user_list_address.tr(),
                    icon: Icons.location_on_outlined,
                    children: [
                      _DetailRow(
                        icon: Icons.home_outlined,
                        label: LocaleKeys.user_list_street.tr(),
                        value: '${user.address.suite}, ${user.address.street}',
                      ),
                      _DetailRow(icon: Icons.location_city_outlined, label: LocaleKeys.user_list_city.tr(), value: user.address.city),
                      _DetailRow(icon: Icons.markunread_mailbox_outlined, label: LocaleKeys.user_list_zipcode.tr(), value: user.address.zipcode),
                      _DetailRow(
                        icon: Icons.map_outlined,
                        label: LocaleKeys.user_list_coordinates.tr(),
                        value: '${LocaleKeys.user_list_lat.tr()}: ${user.address.geo.lat}, ${LocaleKeys.user_list_lng.tr()}: ${user.address.geo.lng}',
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (err, _) => Center(
            child: Text(
              '${LocaleKeys.user_list_error_loading_details.tr()}: $err',
              style: TextStyle(color: context.colorScheme.error),
            ),
          ),
        ),
      ),
    );
  }
}

class _DetailCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final List<Widget> children;

  const _DetailCard({
    required this.title,
    required this.icon,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, size: 20, color: context.colorScheme.primary),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: context.textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: context.colorScheme.primary,
                  ),
                ),
              ],
            ),
            const Divider(height: 24, thickness: 0.5),
            ...children,
          ],
        ),
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _DetailRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            icon,
            size: 18,
            color: context.colorScheme.onSurfaceVariant.withValues(alpha: 0.6),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: context.textTheme.bodyMedium?.copyWith(
                  fontSize: 12,
                  color: context.colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: context.textTheme.bodyLarge?.copyWith(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
