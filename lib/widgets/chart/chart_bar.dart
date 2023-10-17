import 'package:flutter/material.dart';

class ChartBar extends StatelessWidget {
  const ChartBar({
    Key? key,
    required this.fill, // The fill level (height) of the bar.
  }) : super(key: key);

  // The fill level of the bar.
  final double fill;

  @override
  Widget build(BuildContext context) {
    // Check if the device is in dark mode.
    final isDarkMode =
        MediaQuery.of(context).platformBrightness == Brightness.dark;

    // Expanded widget takes all available horizontal space.
    return Expanded(
      // Padding around the bar.
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4),
        // FractionallySizedBox scales its child based on a fraction of the available space.
        child: FractionallySizedBox(
          // The height factor of the box is determined by the 'fill' property.
          heightFactor: fill,
          child: DecoratedBox(
            // Decorate the box with a rounded rectangle shape and color.
            decoration: BoxDecoration(
              shape: BoxShape.rectangle, // Rounded rectangle shape.
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(8)), // Rounded corners at the top.
              color: isDarkMode
                  ? Theme.of(context).colorScheme.secondary // Dark mode color.
                  : Theme.of(context)
                      .colorScheme
                      .primary
                      .withOpacity(0.65), // Light mode color with opacity.
            ),
          ),
        ),
      ),
    );
  }
}
