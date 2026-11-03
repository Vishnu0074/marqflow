import 'package:flutter/animation.dart';
import 'package:flutter/foundation.dart';

/// Direction in which the marquee content travels.
enum MarqflowDirection {
  /// Scroll content towards the left.
  left,

  /// Scroll content towards the right.
  right,
}

/// Immutable configuration for a [Marqflow] animation.
@immutable
class MarqflowConfig {
  /// Creates marquee configuration.
  const MarqflowConfig({
    this.velocity = 30,
    this.direction = MarqflowDirection.left,
    this.startDelay = const Duration(milliseconds: 600),
    this.pauseAfterRound = const Duration(milliseconds: 800),
    this.loop = true,
    this.repeat = true,
    this.autoStart = true,
    this.curve = Curves.linear,
    this.textWidthInCharacters,
    this.gap = 32,
  }) : assert(velocity > 0, 'velocity must be greater than zero'),
       assert(gap >= 0, 'gap must not be negative'),
       assert(
         textWidthInCharacters == null || textWidthInCharacters > 0,
         'textWidthInCharacters must be greater than zero',
       );

  /// Travel speed in logical pixels per second.
  final double velocity;

  /// Direction of travel.
  final MarqflowDirection direction;

  /// Time to wait before the first animation starts.
  final Duration startDelay;

  /// Time to wait after reaching an edge before restarting.
  final Duration pauseAfterRound;

  /// Whether to return to the starting edge after each round.
  ///
  /// When false, the widget stops at the destination after one round.
  final bool loop;

  /// Whether to continue starting rounds while [loop] is true.
  ///
  /// Set to false to perform at most one round.
  final bool repeat;

  /// Whether animation starts automatically after layout.
  final bool autoStart;

  /// Curve applied to the scrolling animation.
  ///
  /// Linear is recommended for constant marquee velocity.
  final Curve curve;

  /// Optional approximate viewport width expressed in character units.
  ///
  /// This is a convenience for text-like content, not a measurement of the
  /// actual child. Omit it to use the available parent width.
  final int? textWidthInCharacters;

  /// Empty space between repeated copies when seamless repetition is added.
  final double gap;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MarqflowConfig &&
          velocity == other.velocity &&
          direction == other.direction &&
          startDelay == other.startDelay &&
          pauseAfterRound == other.pauseAfterRound &&
          loop == other.loop &&
          repeat == other.repeat &&
          autoStart == other.autoStart &&
          curve == other.curve &&
          textWidthInCharacters == other.textWidthInCharacters &&
          gap == other.gap;

  @override
  int get hashCode => Object.hash(
        velocity,
        direction,
        startDelay,
        pauseAfterRound,
        loop,
        repeat,
        autoStart,
        curve,
        textWidthInCharacters,
        gap,
      );
}
