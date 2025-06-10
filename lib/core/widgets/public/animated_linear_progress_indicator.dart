import 'package:flutter/material.dart';

class AnimatedLinearProgressIndicator extends StatefulWidget {
   const AnimatedLinearProgressIndicator({Key? key}) : super(key: key);
  @override
  State<AnimatedLinearProgressIndicator> createState() => _AnimatedLinearProgressIndicatorState();
}

class _AnimatedLinearProgressIndicatorState extends State<AnimatedLinearProgressIndicator>

    with SingleTickerProviderStateMixin {

  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    // TODO: implement initState
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(
          seconds: 3), // Adjust duration to slow down or speed up the animation
    );
    _animation = Tween(begin: 0.0, end: 1.0).animate(_controller);
    _controller.repeat(
        reverse: false); // Reverse the animation to make it loop smoothly

    super.initState();
  }
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (BuildContext context, Widget? child) {
        // Calculate the value for the LinearProgressIndicator
        double value = _controller.value;

        // Check if animation has reached the end, and reset it
        if (value == 1.0) {
          // _controller.reset();
          // _controller.forward();
        }

        return LinearProgressIndicator(
          color: Color(0xFFCA423B),
          backgroundColor: Colors.white,
          minHeight: 1,
          value: value,
        );
      },
    ) ;
  }
}
