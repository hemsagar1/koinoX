import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/widgets/custom_card.dart';

class GalleryScreen extends StatelessWidget {
  const GalleryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final albums = [
      {'title': 'Annual Tech Fest "Ignite"', 'photos': '42 Photos', 'icon': Icons.bolt_rounded},
      {'title': 'Cultural Night & Band Showdown', 'photos': '68 Photos', 'icon': Icons.music_note_rounded},
      {'title': 'Annual Sports Meet 2026', 'photos': '55 Photos', 'icon': Icons.sports_soccer_rounded},
      {'title': 'Campus Infrastructure & Greenery', 'photos': '30 Photos', 'icon': Icons.nature_people_rounded},
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('Campus Gallery')),
      body: GridView.builder(
        padding: const EdgeInsets.all(20),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: 0.9,
        ),
        itemCount: albums.length,
        itemBuilder: (context, index) {
          final album = albums[index];
          return CustomCard(
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Opening album: ${album['title']}')),
              );
            },
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.navyPrimary,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Icon(album['icon'] as IconData, color: AppColors.cyanAccent, size: 36),
                ),
                const SizedBox(height: 12),
                Text(
                  album['title'] as String,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                ),
                const SizedBox(height: 4),
                Text(
                  album['photos'] as String,
                  style: const TextStyle(color: AppColors.textMuted, fontSize: 11),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
