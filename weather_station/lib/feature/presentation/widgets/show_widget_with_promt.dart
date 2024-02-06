import 'package:flutter/material.dart';
import 'package:weather_station/feature/presentation/widgets/widgets.dart';


class ShowWidgetWithPrompt extends StatefulWidget {
  const ShowWidgetWithPrompt({
    required Widget child,
    required String prompt,
    bool transparent = true,
    Color textColor = Colors.white,
    super.key,
  }) : _child = child,
       _prompt = prompt,
       _textColor = textColor,
        _transparent = transparent;

  final Widget _child;
  final String _prompt;
  final Color  _textColor;
  final bool  _transparent;

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
                  offset: const Offset(-1, 1),
                  targetAnchor: Alignment.bottomLeft,
                  //followerAnchor: Alignment.topLeft,
                  showWhenUnlinked: false,
                  child: PromtWidget(
                      transparent: widget._transparent,
                      prompt: widget._prompt,
                      textColor: widget._textColor
                  ),
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
