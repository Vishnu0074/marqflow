import 'package:flutter/foundation.dart';

/// Imperative controls for a [Marqflow] widget.
///
/// Attach the controller through [Marqflow.controller]. The controller can be
/// shared with only one mounted marquee at a time.
class MarqflowController extends ChangeNotifier {
  VoidCallback? _onStart;
  VoidCallback? _onPause;
  VoidCallback? _onResume;
  VoidCallback? _onStop;
  bool _isAttached = false;

  /// Whether a marquee is currently attached to this controller.
  bool get isAttached => _isAttached;

  /// Starts or restarts the attached marquee.
  void start() => _onStart?.call();

  /// Pauses the attached marquee at its current position.
  void pause() => _onPause?.call();

  /// Resumes a paused marquee.
  void resume() => _onResume?.call();

  /// Stops the attached marquee and returns it to its initial position.
  void stop() => _onStop?.call();

  /// Connects a marquee state to this controller.
  @internal
  void attach({
    required VoidCallback start,
    required VoidCallback pause,
    required VoidCallback resume,
    required VoidCallback stop,
  }) {
    _onStart = start;
    _onPause = pause;
    _onResume = resume;
    _onStop = stop;
    _isAttached = true;
    notifyListeners();
  }

  /// Disconnects a marquee state from this controller.
  @internal
  void detach() {
    _onStart = null;
    _onPause = null;
    _onResume = null;
    _onStop = null;
    _isAttached = false;
    notifyListeners();
  }
}
