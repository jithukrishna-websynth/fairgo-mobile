import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router/app_routes.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../ride/presentation/widgets/trip_actions.dart';
import '../../data/demo_contacts.dart';
import '../providers/safety_providers.dart';

/// Quick SOS opens the (demo) SOS screen. Call Police opens the phone dialer
/// with 112 filled in. Contacts are demo data; editing, in-app support and
/// safety tips are not built yet.
class SafetyEmergencyScreen extends ConsumerWidget {
  const SafetyEmergencyScreen({super.key});

  Future<void> _callPolice(BuildContext context, WidgetRef ref) async {
    final opened = await ref.read(emergencyDialerProvider).dial(policeNumber);
    if (!opened && context.mounted) {
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          const SnackBar(content: Text("Couldn't open the phone dialer.")),
        );
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 4, 16, 0),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () => context.pop(),
                    icon: const Icon(Icons.chevron_left),
                  ),
                  const Text(
                    'Safety & Emergency',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.screenPadding,
                  vertical: AppSpacing.sm,
                ),
                children: [
                  _QuickSosCard(onTrigger: () => context.push(AppRoutes.sos)),
                  const SizedBox(height: 18),
                  Row(
                    children: [
                      const Text(
                        'Emergency Contacts',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const Spacer(),
                      GestureDetector(
                        key: const Key('add_contact'),
                        onTap: () =>
                            showNotAvailable(context, 'Adding a contact'),
                        child: const Text(
                          '+ Add New',
                          style: TextStyle(
                            fontSize: 9,
                            fontWeight: FontWeight.w700,
                            color: AppColors.forestLight,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  _Card(
                    children: [
                      for (var i = 0; i < demoEmergencyContacts.length; i++)
                        _ContactRow(
                          index: i,
                          contact: demoEmergencyContacts[i],
                          showDivider: i < demoEmergencyContacts.length - 1,
                          onEdit: () =>
                              showNotAvailable(context, 'Editing a contact'),
                        ),
                    ],
                  ),
                  const SizedBox(height: 18),
                  const Text(
                    'Safety Options',
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 10),
                  _Card(
                    children: [
                      _OptionRow(
                        key: const Key('option_share_location'),
                        icon: Icons.location_on_outlined,
                        title: 'Share Live Location',
                        subtitle: 'Share your trip with trusted contacts',
                        onTap: () => context.push(AppRoutes.shareTrip),
                      ),
                      _OptionRow(
                        key: const Key('option_call_police'),
                        icon: Icons.phone_outlined,
                        title: 'Call Police',
                        subtitle: 'Dial $policeNumber directly',
                        onTap: () => _callPolice(context, ref),
                      ),
                      _OptionRow(
                        key: const Key('option_support'),
                        icon: Icons.chat_bubble_outline,
                        title: 'In-App Support',
                        subtitle: 'Get help from Fairgo support team',
                        onTap: () =>
                            showNotAvailable(context, 'In-app support'),
                      ),
                      _OptionRow(
                        key: const Key('option_tips'),
                        icon: Icons.shield_outlined,
                        title: 'Safety Tips',
                        subtitle: 'Learn how to stay safe while travelling',
                        showDivider: false,
                        onTap: () => showNotAvailable(context, 'Safety tips'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _QuickSosCard extends StatelessWidget {
  const _QuickSosCard({required this.onTrigger});

  final VoidCallback onTrigger;

  @override
  Widget build(BuildContext context) {
    const red = Color(0xFFE53935);
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF0F0),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFF5C6C6)),
      ),
      child: Row(
        children: [
          Container(
            width: 30,
            height: 30,
            decoration: const BoxDecoration(
              color: Color(0xFFFFD9D9),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.notifications_none, size: 16, color: red),
          ),
          const SizedBox(width: 10),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Quick SOS',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: red,
                  ),
                ),
                SizedBox(height: 2),
                Text(
                  'Get immediate help.\nYour location will be shared.',
                  style: TextStyle(fontSize: 8, height: 1.3, color: red),
                ),
              ],
            ),
          ),
          FilledButton(
            key: const Key('trigger_sos'),
            onPressed: onTrigger,
            style: FilledButton.styleFrom(
              backgroundColor: red,
              minimumSize: const Size(0, 30),
              padding: const EdgeInsets.symmetric(horizontal: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text(
              'Trigger SOS',
              style: TextStyle(fontSize: 9, fontWeight: FontWeight.w700),
            ),
          ),
        ],
      ),
    );
  }
}

class _Card extends StatelessWidget {
  const _Card({required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(children: children),
    );
  }
}

class _ContactRow extends StatelessWidget {
  const _ContactRow({
    required this.index,
    required this.contact,
    required this.showDivider,
    required this.onEdit,
  });

  final int index;
  final EmergencyContact contact;
  final bool showDivider;
  final VoidCallback onEdit;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        border: showDivider
            ? const Border(bottom: BorderSide(color: AppColors.border))
            : null,
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 14,
            backgroundColor: AppColors.border,
            child: Text(
              contact.name[0],
              style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: AppColors.forest,
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  contact.name,
                  style: const TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Text(
                  contact.phone,
                  style: const TextStyle(
                    fontSize: 9,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          GestureDetector(
            key: Key('edit_contact_$index'),
            onTap: onEdit,
            behavior: HitTestBehavior.opaque,
            child: const Padding(
              padding: EdgeInsets.all(4),
              child: Icon(
                Icons.edit_outlined,
                size: 14,
                color: AppColors.textSecondary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _OptionRow extends StatelessWidget {
  const _OptionRow({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
    this.showDivider = true,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;
  final bool showDivider;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        decoration: BoxDecoration(
          border: showDivider
              ? const Border(bottom: BorderSide(color: AppColors.border))
              : null,
        ),
        child: Row(
          children: [
            Container(
              width: 28,
              height: 28,
              decoration: BoxDecoration(
                color: AppColors.fieldFill,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, size: 15, color: AppColors.textSecondary),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontSize: 8,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.chevron_right,
              size: 16,
              color: AppColors.textSecondary,
            ),
          ],
        ),
      ),
    );
  }
}
