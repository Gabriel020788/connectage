import 'dart:convert';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SpriteImage extends StatefulWidget {
  const SpriteImage({
    super.key,
    required this.index,
    this.fit = BoxFit.cover,
    this.borderRadius = BorderRadius.zero,
  });

  final int index;
  final BoxFit fit;
  final BorderRadius borderRadius;

  static const asset = 'assets/images/connectage_gallery_fixed.b64';
  static const columns = 5;
  static const rows = 3;

  @override
  State<SpriteImage> createState() => _SpriteImageState();
}

class _SpriteImageState extends State<SpriteImage> {
  late final Future<ui.Image> _imageFuture = _loadImage();

  Future<ui.Image> _loadImage() async {
    final encoded = await rootBundle.loadString(SpriteImage.asset);
    final bytes = base64Decode(encoded.trim());
    final codec = await ui.instantiateImageCodec(bytes);
    final frame = await codec.getNextFrame();
    return frame.image;
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: widget.borderRadius,
      child: FutureBuilder<ui.Image>(
        future: _imageFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const ColoredBox(
              color: Color(0xFFE7F3EE),
              child: Center(
                child: SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
              ),
            );
          }

          if (snapshot.hasError || snapshot.data == null) {
            return const ColoredBox(
              color: Color(0xFFE7F3EE),
              child: Center(
                child: Icon(Icons.broken_image_outlined, size: 40),
              ),
            );
          }

          return CustomPaint(
            painter: _SpritePainter(
              image: snapshot.data!,
              index: widget.index,
              fit: widget.fit,
            ),
            child: const SizedBox.expand(),
          );
        },
      ),
    );
  }
}

class _SpritePainter extends CustomPainter {
  const _SpritePainter({
    required this.image,
    required this.index,
    required this.fit,
  });

  final ui.Image image;
  final int index;
  final BoxFit fit;

  @override
  void paint(Canvas canvas, Size size) {
    final maxIndex = SpriteImage.columns * SpriteImage.rows - 1;
    final safeIndex = index.clamp(0, maxIndex).toInt();
    final column = safeIndex % SpriteImage.columns;
    final row = safeIndex ~/ SpriteImage.columns;

    final cellWidth = image.width / SpriteImage.columns;
    final cellHeight = image.height / SpriteImage.rows;
    final cellRect = Rect.fromLTWH(
      column * cellWidth,
      row * cellHeight,
      cellWidth,
      cellHeight,
    );

    final fitted = applyBoxFit(fit, Size(cellWidth, cellHeight), size);
    final source = Alignment.center.inscribe(fitted.source, cellRect);
    final destination = Alignment.center.inscribe(
      fitted.destination,
      Offset.zero & size,
    );

    canvas.drawImageRect(
      image,
      source,
      destination,
      Paint()..filterQuality = FilterQuality.medium,
    );
  }

  @override
  bool shouldRepaint(covariant _SpritePainter oldDelegate) {
    return oldDelegate.image != image ||
        oldDelegate.index != index ||
        oldDelegate.fit != fit;
  }
}
