import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/services/mock_data_service.dart';
import '../../core/widgets/custom_card.dart';

class MessScreen extends StatefulWidget {
  const MessScreen({super.key});

  @override
  State<MessScreen> createState() => _MessScreenState();
}

class _MessScreenState extends State<MessScreen> {
  int _selectedDayIndex = 0; // Monday
  double _userRating = 4.0;
  final _feedbackController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final weeklyMenu = MockDataService.weeklyMessMenu;
    final activeMenu = weeklyMenu[_selectedDayIndex];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Campus Mess & Dining'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Day selector tabs
            SizedBox(
              height: 40,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: weeklyMenu.length,
                itemBuilder: (context, index) {
                  final isSelected = index == _selectedDayIndex;
                  return Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: ChoiceChip(
                      label: Text(weeklyMenu[index].day),
                      selected: isSelected,
                      selectedColor: AppColors.navyPrimary,
                      labelStyle: TextStyle(
                        color: isSelected ? Colors.white : AppColors.textDark,
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                      ),
                      onSelected: (val) {
                        if (val) setState(() => _selectedDayIndex = index);
                      },
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 20),

            // Today's Menu Cards
            Text(
              '${activeMenu.day}\'s Dining Schedule',
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            const SizedBox(height: 12),

            _buildMealCard(
              mealTitle: 'Breakfast',
              time: '07:30 AM - 09:30 AM',
              items: activeMenu.breakfast,
              icon: Icons.free_breakfast_rounded,
              color: Colors.orange.shade700,
            ),
            const SizedBox(height: 12),

            _buildMealCard(
              mealTitle: 'Lunch',
              time: '12:15 PM - 02:15 PM',
              items: activeMenu.lunch,
              icon: Icons.lunch_dining_rounded,
              color: Colors.green.shade700,
            ),
            const SizedBox(height: 12),

            _buildMealCard(
              mealTitle: 'Evening Snacks',
              time: '05:00 PM - 06:15 PM',
              items: activeMenu.snacks,
              icon: Icons.bakery_dining_rounded,
              color: Colors.purple.shade700,
            ),
            const SizedBox(height: 12),

            _buildMealCard(
              mealTitle: 'Dinner',
              time: '07:30 PM - 09:30 PM',
              items: activeMenu.dinner,
              icon: Icons.dinner_dining_rounded,
              color: AppColors.navyPrimary,
            ),
            const SizedBox(height: 28),

            // Meal Rating & Feedback
            CustomCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Rate Today\'s Mess Food', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(5, (index) {
                      return IconButton(
                        icon: Icon(
                          index < _userRating ? Icons.star_rounded : Icons.star_outline_rounded,
                          color: AppColors.warning,
                          size: 32,
                        ),
                        onPressed: () {
                          setState(() => _userRating = index + 1.0);
                        },
                      );
                    }),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: _feedbackController,
                    decoration: const InputDecoration(
                      hintText: 'Share feedback about cleanliness or food quality...',
                    ),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Thank you! Your mess feedback has been recorded.'),
                            backgroundColor: AppColors.success,
                          ),
                        );
                        _feedbackController.clear();
                      },
                      child: const Text('Submit Feedback'),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMealCard({
    required String mealTitle,
    required String time,
    required String items,
    required IconData icon,
    required Color color,
  }) {
    return CustomCard(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color, size: 28),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(mealTitle, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    Text(time, style: const TextStyle(fontSize: 11, color: AppColors.textMuted)),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  items,
                  style: const TextStyle(fontSize: 14, height: 1.3),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
