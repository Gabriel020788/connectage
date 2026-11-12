import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../core/brand_colors.dart';

class BrandLogo extends StatefulWidget {
  const BrandLogo({
    super.key,
    this.height = 140,
  });

  final double height;

  @override
  State<BrandLogo> createState() => _BrandLogoState();
}

class _BrandLogoState extends State<BrandLogo> {
  late final Future<Uint8List> _bytes = _loadLogo();

  Future<Uint8List> _loadLogo() async {
    final parts = await Future.wait([
      rootBundle.loadString('assets/branding/logo_compact_0a.b64'),
      rootBundle.loadString('assets/branding/logo_compact_0b.b64'),
      rootBundle.loadString('assets/branding/logo_compact_0c.b64'),
      rootBundle.loadString('assets/branding/logo_compact_1.b64'),
      rootBundle.loadString('assets/branding/logo_compact_2.b64'),
    ]);

    final first = parts[0].trim();
    final fixedFirst = '${first.substring(0, 505)}RE${first.substring(505)}';
    final encoded = [
      fixedFirst,
      parts[1].trim(),
      parts[2].trim(),
      parts[3].trim(),
      parts[4].trim(),
    ].join();

    return base64Decode(encoded);
  }

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: 'Logo ConnectAge',
      image: true,
      child: SizedBox(
        height: widget.height,
        child: FutureBuilder<Uint8List>(
          future: _bytes,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return ClipRRect(
                borderRadius: BorderRadius.circular(24),
                child: ColoredBox(
                  color: Colors.white,
                  child: Padding(
                    padding: const EdgeInsets.all(4),
                    child: Image.memory(
                      snapshot.data!,
                      height: widget.height,
                      fit: BoxFit.contain,
                      filterQuality: FilterQuality.high,
                      gaplessPlayback: true,
                    ),
                  ),
                ),
              );
            }

            if (snapshot.hasError) {
              return const Center(child: BrandWordmark());
            }

            return const Center(
              child: CircularProgressIndicator(strokeWidth: 2),
            );
          },
        ),
      ),
    );
  }
}

class BrandWordmark extends StatelessWidget {
  const BrandWordmark({
    super.key,
    this.fontSize = 28,
    this.compact = false,
  });

  final double fontSize;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: 'ConnectAge',
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: compact ? 34 : 40,
            height: compact ? 34 : 40,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [BrandColors.blue, BrandColors.blueStrong],
              ),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.favorite_rounded,
              color: Colors.white,
              size: compact ? 19 : 22,
            ),
          ),
          const SizedBox(width: 8),
          RichText(
            text: TextSpan(
              style: TextStyle(
                fontSize: fontSize,
                fontWeight: FontWeight.w900,
                letterSpacing: -0.8,
              ),
              children: const [
                TextSpan(
                  text: 'Connect',
                  style: TextStyle(color: BrandColors.blueStrong),
                ),
                TextSpan(
                  text: 'Age',
                  style: TextStyle(color: BrandColors.orange),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
