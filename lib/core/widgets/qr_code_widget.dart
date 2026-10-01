import 'dart:math';
import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

class QrCodeWidget extends StatelessWidget {
  final String data;
  final double size;

  const QrCodeWidget({
    super.key,
    required this.data,
    this.size = 180,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          CustomPaint(
            size: Size(size - 24, size - 24),
            painter: _QrPainter(data: data, foregroundColor: AppColors.navyPrimary),
          ),
          Container(
            padding: const EdgeInsets.all(4),
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
            child: Container(
              padding: const EdgeInsets.all(6),
              decoration: const BoxDecoration(
                color: AppColors.navyPrimary,
                shape: BoxShape.circle,
              ),
              child: const Text(
                'KX',
                style: TextStyle(
                  color: AppColors.cyanAccent,
                  fontWeight: FontWeight.w900,
                  fontSize: 10,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _QrPainter extends CustomPainter {
  final String data;
  final Color foregroundColor;

  _QrPainter({required this.data, required this.foregroundColor});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = foregroundColor
      ..style = PaintingStyle.fill;

    const int gridCount = 21;
    final double cellSize = size.width / gridCount;

    final hash = data.hashCode;
    final rng = Random(hash);

    final grid = List.generate(gridCount, (_) => List.filled(gridCount, false));

    void drawFinderPattern(int startX, int startY) {
      for (int r = 0; r < 7; r++) {
        for (int c = 0; c < 7; c++) {
          grid[startY + r][startX + c] = true;
          if (r == 0 || r == 6 || c == 0 || c == 6 || (r >= 2 && r <= 4 && c >= 2 && c <= 4)) {
            canvas.drawRRect(
              RRect.fromRectAndRadius(
                Rect.fromLTWH(
                  (startX + c) * cellSize,
                  (startY + r) * cellSize,
                  cellSize + 0.2,
                  cellSize + 0.2,
                ),
                const Radius.circular(1.5),
              ),
              paint,
            );
          }
        }
      }
    }

    drawFinderPattern(0, 0);
    drawFinderPattern(14, 0);
    drawFinderPattern(0, 14);

    for (int r = 0; r < gridCount; r++) {
      for (int c = 0; c < gridCount; c++) {
        if ((r >= 0 && r < 7 && c >= 0 && c < 7) ||
            (r >= 0 && r < 7 && c >= 14 && c < 21) ||
            (r >= 14 && r < 21 && c >= 0 && c < 7) ||
            (r >= 8 && r <= 12 && c >= 8 && c <= 12)) {
          continue;
        }

        if (rng.nextBool()) {
          canvas.drawRRect(
            RRect.fromRectAndRadius(
              Rect.fromLTWH(
                c * cellSize,
                r * cellSize,
                cellSize - 0.4,
                cellSize - 0.4,
              ),
              const Radius.circular(1),
            ),
            paint,
          );
        }
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
