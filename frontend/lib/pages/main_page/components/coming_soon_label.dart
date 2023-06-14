
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ComingSoonLabel extends StatelessWidget {
  const ComingSoonLabel({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Transform.rotate(
      angle: 2.5 * pi / 12.0,
      child: Stack(
        children: [
          Shimmer.fromColors(
            baseColor: Colors.amber,
            highlightColor: Colors.yellow,
            child: Card(
              elevation: 1,
              color: Colors.amber,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              child: Padding(
                padding: const EdgeInsets.all(4),
                child: Text(
                  'COMING SOON',
                  textAlign: TextAlign.center,
                  style: Theme.of(context)
                      .textTheme
                      .bodySmall!
                      .apply(color: Colors.black),
                ),
              ),
            ),
          ),
          const Positioned.fill(
            child: Align(
              alignment: Alignment.center,
              child: Text(
                'COMING SOON',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
