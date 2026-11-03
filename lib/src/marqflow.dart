import 'dart:async';

import 'package:flutter/material.dart';

import 'marqflow_config.dart';
import 'marqflow_controller.dart';
import 'marqflow_language.dart';

/// A lightweight marquee that scrolls any widget when it overflows.
///
/// Marqflow measures the laid-out child and starts scrolling only when the
/// content is wider than the available viewport. The child can be any widget;
/// text-specific measurement is not required.
///
/// Example:
/// ```dart
/// Marqflow(
///   config: const MarqflowConfig(velocity: 28),
///   child: const Text('A title that may not fit'),
/// )
/// ```
class Marqflow extends StatefulWidget {
  /// Creates an automatically scrolling widget.
  const Marqflow({
    super.key,
    required this.child,
    this.config = const MarqflowConfig(),
    this.language = const MarqflowLanguage(),
    this.controller,
    this.alignment = Alignment.centerLeft,
    this.restartKey,
    this.pauseOnPointerHover = false,
  });

  /// Content to display and scroll.
  final Widget child;

  /// Animation behavior.
  final MarqflowConfig config;

  /// Optional locale-based animation filter.
  final MarqflowLanguage language;

  /// Optional controller for imperative start, pause, resume, and stop.
  final MarqflowController? controller;

  /// Alignment of content when it does not overflow.
  final AlignmentGeometry alignment;

  /// Change this value to explicitly restart animation after child data changes.
  final Object? restartKey;

  /// Whether pointer hover pauses animation (desktop and web).
  final bool pauseOnPointerHover;

  @override
  State<Marqflow> createState() => _MarqflowState();
}

class _MarqflowState extends State<Marqflow>
    with SingleTickerProviderStateMixin {
  final ScrollController _scrollController = ScrollController();
  Timer? _delayTimer;
  Timer? _pauseTimer;
  int _session = 0;
  bool _disposed = false;
  bool _paused = false;
  bool _stopped = false;
  bool _hasOverflow = false;
  double _maxScrollExtent = 0;

  @override
  void initState() {
    super.initState();
    _attachController();
    WidgetsBinding.instance.addPostFrameCallback((_) => _measureAndSchedule());
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _scheduleAfterLayout();
  }

  @override
  void didUpdateWidget(covariant Marqflow oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.controller != widget.controller) {
      oldWidget.controller?.detach();
      _attachController();
    }

    if (oldWidget.child != widget.child ||
        oldWidget.config != widget.config ||
        oldWidget.language != widget.language ||
        oldWidget.restartKey != widget.restartKey ||
        oldWidget.alignment != widget.alignment) {
      _scheduleAfterLayout();
    }
  }

  void _attachController() {
    widget.controller?.attach(
      start: _start,
      pause: _pause,
      resume: _resume,
      stop: _stop,
    );
  }

  bool get _languageAllows {
    final code = Localizations.maybeLocaleOf(context)?.languageCode;
    return widget.language.allows(code);
  }

  void _scheduleAfterLayout() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _measureAndSchedule();
    });
  }

  void _measureAndSchedule() {
    if (!mounted || _disposed) return;
    _invalidateSession();

    if (!_languageAllows || !widget.config.autoStart || _stopped) {
      setState(() => _hasOverflow = false);
      return;
    }

    if (!_scrollController.hasClients) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) _measureAndSchedule();
      });
      return;
    }

    final position = _scrollController.position;
    _maxScrollExtent = position.maxScrollExtent;
    _hasOverflow = _maxScrollExtent > 0.5;
    if (position.hasPixels) position.jumpTo(0);

    if (_hasOverflow) {
      _scheduleStart();
    } else {
      setState(() {});
    }
  }

  void _scheduleStart() {
    final session = _session;
    _delayTimer?.cancel();
    _delayTimer = Timer(widget.config.startDelay, () {
      if (!mounted || session != _session || _paused || _stopped) return;
      _runRound(session);
    });
    setState(() {});
  }

  Future<void> _runRound(int session) async {
    if (!mounted || !_scrollController.hasClients ||
        session != _session || _paused || _stopped) {
      return;
    }

    final position = _scrollController.position;
    final target = widget.config.direction == MarqflowDirection.left
        ? position.maxScrollExtent
        : 0.0;

    final distance = (target - position.pixels).abs();
    if (distance <= 0.5) {
      if (widget.config.loop && widget.config.repeat) {
        _pauseTimer = Timer(widget.config.pauseAfterRound, () {
          if (mounted && session == _session) {
            _resetForNextRound(session);
          }
        });
      }
      return;
    }

    final duration = Duration(
      microseconds: (distance / widget.config.velocity * 1000000).round(),
    );

    try {
      await _scrollController.animateTo(
        target,
        duration: duration,
        curve: widget.config.curve,
      );
    } on TickerCanceled {
      return;
    } catch (_) {
      // ScrollPosition can be detached while a route is being removed.
      return;
    }

    if (!mounted || session != _session || _paused || _stopped) return;

    if (!widget.config.loop || !widget.config.repeat) return;

    _pauseTimer?.cancel();
    _pauseTimer = Timer(widget.config.pauseAfterRound, () {
      if (mounted && session == _session) _resetForNextRound(session);
    });
  }

  void _resetForNextRound(int session) {
    if (!mounted || !_scrollController.hasClients || session != _session) return;
    _scrollController.jumpTo(
      widget.config.direction == MarqflowDirection.left
          ? 0
          : _scrollController.position.maxScrollExtent,
    );
    _runRound(session);
  }

  void _invalidateSession() {
    _session++;
    _delayTimer?.cancel();
    _pauseTimer?.cancel();
  }

  void _start() {
    if (!mounted || !_languageAllows) return;
    _stopped = false;
    _paused = false;
    _scheduleAfterLayout();
  }

  void _pause() {
    _paused = true;
    _invalidateSession();
  }

  void _resume() {
    if (!_paused) return;
    _paused = false;
    if (_hasOverflow) _scheduleStart();
  }

  void _stop() {
    _stopped = true;
    _paused = false;
    _invalidateSession();
    if (_scrollController.hasClients) _scrollController.jumpTo(0);
  }

  void _handleHover(bool hovering) {
    if (!widget.pauseOnPointerHover) return;
    if (hovering) {
      _pause();
    } else {
      _resume();
    }
  }

  @override
  void dispose() {
    _disposed = true;
    _invalidateSession();
    widget.controller?.detach();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final maxWidth = widget.config.textWidthInCharacters == null
        ? null
        : widget.config.textWidthInCharacters! *
            (widget.child is Text
                ? ((widget.child as Text).style?.fontSize ??
                    DefaultTextStyle.of(context).style.fontSize ??
                    14) *
                    0.6
                : 14 * 0.6);

    final viewport = LayoutBuilder(
      builder: (context, constraints) {
        final width = maxWidth == null
            ? constraints.maxWidth
            : maxWidth.clamp(0.0, constraints.maxWidth);
        return SizedBox(
          width: width.isFinite ? width : null,
          child: ClipRect(
            child: Align(
              alignment: widget.alignment,
              child: SingleChildScrollView(
                controller: _scrollController,
                scrollDirection: Axis.horizontal,
                physics: const NeverScrollableScrollPhysics(),
                child: widget.child,
              ),
            ),
          ),
        );
      },
    );

    return widget.pauseOnPointerHover
        ? MouseRegion(
            onEnter: (_) => _handleHover(true),
            onExit: (_) => _handleHover(false),
            child: viewport,
          )
        : viewport;
  }
}
