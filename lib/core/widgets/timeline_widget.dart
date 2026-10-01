import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

class TimelineStep {
  final String title;
  final String description;
  final bool isCompleted;
  final bool isCurrent;
  final String? time;

  const TimelineStep({
    required this.title,
    required this.description,
    required this.isCompleted,
    required this.isCurrent,
    this.time,
  });
}

class StatusTimeline extends StatelessWidget {
  final List<TimelineStep> steps;

  const StatusTimeline({super.key, required this.steps});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(steps.length, (index) {
        final step = steps[index];
        final isLast = index == steps.length - 1;

        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              children: [
                Container(
                  width: 28,
                  height: 28,
                  decoration: BoxDecoration(
                    color: step.isCompleted
                        ? AppColors.success
                        : step.isCurrent
                            ? AppColors.cyanAccent
                            : Colors.grey.shade300,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    step.isCompleted
                        ? Icons.check
                        : step.isCurrent
                            ? Icons.radio_button_checked
                            : Icons.circle_outlined,
                    color: Colors.white,
                    size: 16,
                  ),
                ),
                if (!isLast)
                  Container(
                    width: 2,
                    height: 38,
                    color: step.isCompleted
                        ? AppColors.success
                        : Colors.grey.shade300,
                  ),
              ],
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          step.title,
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: step.isCurrent || step.isCompleted
                                ? FontWeight.bold
                                : FontWeight.normal,
                            color: step.isCurrent || step.isCompleted
                                ? Theme.of(context).textTheme.bodyLarge?.color
                                : AppColors.textMuted,
                          ),
                        ),
                        if (step.time != null)
                          Text(
                            step.time!,
                            style: const TextStyle(
                              fontSize: 11,
                              color: AppColors.textMuted,
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 2),
                    Text(
                      step.description,
                      style: const TextStyle(
                        fontSize: 13,
                        color: AppColors.textMuted,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      }),
    );
  }
}
