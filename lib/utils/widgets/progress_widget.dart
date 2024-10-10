import 'package:flutter/material.dart';
import 'dart:math';

class WaveProgressPainter extends CustomPainter {
  final double progress; // Progress from 0.0 to 1.0
  final Color waveColor;
  final Color backgroundColor;

  WaveProgressPainter({
    required this.progress,
    required this.waveColor,
    required this.backgroundColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    Paint wavePaint = Paint()
      ..color = waveColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4.0;

    Paint backgroundPaint = Paint()
      ..color = backgroundColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

    Path backgroundWavePath = Path();
    Path progressWavePath = Path();

    // Define the wave parameters
    double waveHeight = 10.0;
    double waveLength = size.width / 10; // Number of waves across the width

    // Draw the background wave (the unprogressed part)
    for (double i = 0; i <= size.width; i += waveLength) {
      backgroundWavePath.moveTo(i, size.height / 2);
      backgroundWavePath.relativeQuadraticBezierTo(
          waveLength / 4, -waveHeight, waveLength / 2, 0);
      backgroundWavePath.relativeQuadraticBezierTo(
          waveLength / 4, waveHeight, waveLength / 2, 0);
    }
    canvas.drawPath(backgroundWavePath, backgroundPaint);

    // Draw the progress wave (colored part) over the background wave
    for (double i = 0; i < size.width * progress; i += waveLength) {
      progressWavePath.moveTo(i, size.height / 2);
      progressWavePath.relativeQuadraticBezierTo(
          waveLength / 4, -waveHeight, waveLength / 2, 0);
      progressWavePath.relativeQuadraticBezierTo(
          waveLength / 4, waveHeight, waveLength / 2, 0);
    }

    canvas.drawPath(progressWavePath, wavePaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

class WaveProgressBar extends StatelessWidget {
  final double progress;
  final Color waveColor;
  final Color backgroundColor;

  const WaveProgressBar({
    Key? key,
    required this.progress,
    required this.waveColor,
    required this.backgroundColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 20,
      width: double.infinity,
      child: CustomPaint(
        painter: WaveProgressPainter(
          progress: progress,
          waveColor: waveColor,
          backgroundColor: backgroundColor,
        ),
      ),
    );
  }
}
