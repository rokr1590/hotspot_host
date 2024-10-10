import 'package:flutter/material.dart';
import 'package:hotspot_hosts/utils/images.dart';

class HotspotBackground extends StatelessWidget {
  final Widget child;

  const HotspotBackground({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.black, // Black background
        image: DecorationImage(
          image: AssetImage(
              CustomImages.BACKGROUND_IMAGE), // Path to your background image
          fit: BoxFit.cover, // Make the image cover the entire screen
        ),
      ),
      child: child, // Widget that will be placed on top of the background
    );
  }
}
