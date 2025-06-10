import 'package:flutter/material.dart';

class ResponsiveWidget extends StatefulWidget {
  Widget? child;
  double? localWidthRatio;
  double? localHeightRatio;
  double? fixedHeight;
  bool isFixed;
  double startPadding;
  double topPadding;
  double endPadding;
  double bottomPadding;
  BoxDecoration? decoration;

  ResponsiveWidget({super.key,
    this.child,
    this.localWidthRatio,
    this.localHeightRatio,
    this.isFixed = true,
    this.fixedHeight,
    this.startPadding = 0,
    this.endPadding = 0,
    this.bottomPadding = 0,
    this.topPadding = 0,
    this.decoration
  });

  @override
  State<ResponsiveWidget> createState() => _ResponsiveWidgetState();
}

class _ResponsiveWidgetState extends State<ResponsiveWidget> {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      double width = constraints.minWidth;
      debugPrint("minWidth $width");
      return Padding(
        padding: EdgeInsetsDirectional.only(start: widget.startPadding, top: widget.topPadding, end: widget.endPadding, bottom: widget.bottomPadding),
        child: Container(
          width: constraints.maxWidth * widget.localWidthRatio!,
          height: widget.isFixed == true ? widget.fixedHeight : constraints.maxHeight * widget.localHeightRatio!,
          decoration: widget.decoration,
          child: widget.child,
        ),
      );
    });
  }
}
