import 'package:flutter/material.dart';
import 'package:weather_station/feature/presentation/widgets/widgets.dart';


class ShowWidgetWithPrompt extends StatefulWidget {
  const ShowWidgetWithPrompt({
    required Widget child,
    required String prompt,
    super.key,
  }) : _child = child,
       _prompt = prompt;

  final Widget _child;
  final String _prompt;

  @override
  State<ShowWidgetWithPrompt> createState() => _ShowWidgetWithPromptState();
}

class _ShowWidgetWithPromptState extends State<ShowWidgetWithPrompt> {
  final LayerLink _layerLink = LayerLink();
  OverlayEntry? _overlayEntry;

  @override
  void dispose() {
    super.dispose();
    _overlayEntry?..remove()..dispose();
  }

  @override
  Widget build(BuildContext context) {

    return MouseRegion(
      onEnter: (event) => Overlay.of(context).insert(
        _overlayEntry = OverlayEntry(
          builder: (context) =>
              Positioned(
                height: 48,
                child: CompositedTransformFollower(
                  link: _layerLink,
                  offset: const Offset(-2, 4),
                  targetAnchor: Alignment.bottomRight,
                  followerAnchor: Alignment.topRight,
                  showWhenUnlinked: false,
                  child: PromtWidget(prompt: widget._prompt),
                ),
              ),
        ),
      ),
      onExit: (event) {
        _overlayEntry?..remove()..dispose();
        _overlayEntry = null;
      },
      child: CompositedTransformTarget(
          link: _layerLink,
          child: widget._child),
    );
  }
}
