import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/services/app_state_provider.dart';
import '../../core/widgets/custom_card.dart';
import '../auth/login_screen.dart';
import '../../admin/dashboard/admin_dashboard_screen.dart';
import '../digital_id/digital_id_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AppStateProvider>(
      builder: (context, appState, child) {
        final s = appState.student;

        return Scaffold(
          appBar: AppBar(
            title: const Text('Student Profile'),
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                CustomCard(
                  backgroundColor: AppColors.navyPrimary,
                  child: Column(
                    children: [
                      const CircleAvatar(
                        radius: 40,
                        backgroundColor: AppColors.navySecondary,
                        child: Icon(Icons.person, size: 50, color: AppColors.cyanAccent),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        s.name,
                        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${s.rollNumber} • ${s.course} (${s.year})',
                        style: const TextStyle(color: AppColors.cyanAccent, fontSize: 13, fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${s.department} | ${s.hostelBlock}, ${s.roomNumber}',
                        style: const TextStyle(color: AppColors.textMutedDark, fontSize: 12),
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton.icon(
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(builder: (context) => const DigitalIdScreen()),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.cyanAccent,
                          foregroundColor: AppColors.navyPrimary,
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                        ),
                        icon: const Icon(Icons.badge_rounded, size: 18),
                        label: const Text('View Digital Student ID', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text('Prototype Simulation Settings', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                ),
                const SizedBox(height: 10),

                CustomCard(
                  child: Column(
                    children: [
                      SwitchListTile(
                        title: const Text('Simulate Network Connection', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                        subtitle: Text(
                          appState.isOnline ? 'Online Mode (Server Connected)' : 'Offline Mode (Local Storage & Auto Sync)',
                          style: TextStyle(
                            color: appState.isOnline ? AppColors.tealPrimary : AppColors.offline,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        value: appState.isOnline,
                        activeThumbColor: AppColors.cyanAccent,
                        onChanged: (value) {
                          appState.setOnlineStatus(value);
                        },
                      ),
                      const Divider(height: 1),

                      SwitchListTile(
                        title: const Text('Dark Mode Architecture', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                        subtitle: const Text('Toggle app theme', style: TextStyle(fontSize: 12)),
                        value: appState.isDarkMode,
                        activeThumbColor: AppColors.cyanAccent,
                        onChanged: (value) {
                          appState.toggleDarkMode(value);
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text('Role Switcher (Demo)', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                ),
                const SizedBox(height: 10),

                CustomCard(
                  child: ListTile(
                    leading: const Icon(Icons.admin_panel_settings_rounded, color: AppColors.warning, size: 28),
                    title: const Text('Switch to Admin Dashboard', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                    subtitle: const Text('View and resolve student complaints and requests', style: TextStyle(fontSize: 12)),
                    trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 16),
                    onTap: () {
                      appState.setRole('admin');
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(builder: (context) => const AdminDashboardScreen()),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 24),

                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: () {
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(builder: (context) => const LoginScreen()),
                      );
                    },
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.error,
                      side: const BorderSide(color: AppColors.error),
                    ),
                    icon: const Icon(Icons.logout_rounded),
                    label: const Text('Sign Out'),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
