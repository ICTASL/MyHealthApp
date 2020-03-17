import 'package:flutter/material.dart';

import '../utils/tracker_colors.dart';

class AnimatedTrackerButton extends StatelessWidget {
  const AnimatedTrackerButton(
      {this.height = 100,
      this.width = 30,
      this.child,
      this.onPressed,
      this.active = true});

  final double height;
  final double width;
  final Widget child;
  final Function() onPressed;
  final bool active;

  @override
  Widget build(BuildContext context) {
    assert(child != null);
    if (active) assert(onPressed != null);
    return RaisedButton(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
        padding: const EdgeInsets.all(20.0),
        onPressed: active ? onPressed : () {},
        child: AnimatedContainer(
          duration: Duration(milliseconds: 200),
          curve: Curves.easeIn,
          height: height,
          width: width,
          child: Center(
              child: AnimatedSwitcher(
            switchInCurve: Curves.easeIn,
            duration: Duration(milliseconds: 200),
            child: child,
          )),
        ),
        color: TrackerColors.primaryColor);
  }
}
