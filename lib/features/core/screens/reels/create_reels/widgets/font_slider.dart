
import 'package:flutter/material.dart';

class FontSizeSlider extends StatefulWidget {
  final double min;
  final double max;
  final ValueChanged<double> onChanged;

  const FontSizeSlider({
    super.key,
    this.min = 12,
    this.max = 48,
    required this.onChanged,
  });

  @override
  State<FontSizeSlider> createState() =>
      _FontSizeSliderState();
}

class _FontSizeSliderState
    extends State<FontSizeSlider> {
  double _value = 0.5; // 0 = top (max size), 1 = bottom (min size)

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final trackHeight = constraints.maxHeight;
        final handleY = _value * trackHeight;

        return GestureDetector(
          behavior: HitTestBehavior.translucent,
          onPanUpdate: (details) {
            double dy = details.localPosition.dy
                .clamp(0.0, trackHeight);

            setState(() {
              _value = dy / trackHeight;

              final fontSize = widget.min +
                  ((1 - _value) * (widget.max - widget.min));

              widget.onChanged(fontSize.clamp(widget.min, widget.max));
            });
          },
          child: Stack(
            alignment: Alignment.center,
            children: [
              SizedBox(height: 30,width: 30,),
              /// Slider Track
              Container(
                width: 4,
                height: trackHeight,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha:0.35),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),

              /// Slider Handle
              Positioned(
                top: handleY - 16,
                child: Container(
                  width: 20,
                  height: 20,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha:0.25),
                        blurRadius: 6,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Center(
                    child: Container(
                      width: 14,
                      height: 14,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
