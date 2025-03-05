import 'package:flutter/material.dart';
import 'package:wardy/core/theme/app_theme.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final appTheme = theme.extension<AppTheme>();

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Profile',
                style: theme.textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: appTheme?.textColor,
                ),
              ),
              const SizedBox(height: 24),
              // Profile picture and name
              Center(
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 50,
                      backgroundColor: appTheme?.primaryGradientStart,
                      child: const Icon(
                        Icons.person,
                        size: 50,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'User Name',
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),
              // Settings sections
              _buildSection(context, 'Preferences', [
                _buildListTile(context, 'Style Preferences', Icons.style, () {
                  // TODO: Navigate to style preferences
                }),
                _buildListTile(
                  context,
                  'Size Information',
                  Icons.straighten,
                  () {
                    // TODO: Navigate to size information
                  },
                ),
              ]),
              const SizedBox(height: 16),
              _buildSection(context, 'App Settings', [
                _buildListTile(context, 'Appearance', Icons.palette, () {
                  // TODO: Navigate to appearance settings
                }),
                _buildListTile(
                  context,
                  'Notifications',
                  Icons.notifications,
                  () {
                    // TODO: Navigate to notification settings
                  },
                ),
                _buildListTile(context, 'Privacy', Icons.lock, () {
                  // TODO: Navigate to privacy settings
                }),
              ]),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSection(
    BuildContext context,
    String title,
    List<Widget> children,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Text(
            title,
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
          ),
        ),
        Card(margin: EdgeInsets.zero, child: Column(children: children)),
      ],
    );
  }

  Widget _buildListTile(
    BuildContext context,
    String title,
    IconData icon,
    VoidCallback onTap,
  ) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      trailing: const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }
}
