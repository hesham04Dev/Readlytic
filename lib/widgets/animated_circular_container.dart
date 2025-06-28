import 'package:flutter/material.dart';
import 'PrimaryContainer.dart';


class AnimatedCircularContainer extends StatefulWidget {
  final Widget child;
  final double? width;
  final double? height;
  final bool startStopped;
  final AnimatedCircularController? controller;

  const AnimatedCircularContainer({super.key, required this.child,  this.width,  this.height, this.controller,  this.startStopped = false});

  @override
  State<AnimatedCircularContainer> createState() => _MorphingBlobState();
}

class _MorphingBlobState extends State<AnimatedCircularContainer>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  final List<List<double>> borderKeyframes = [
    [63, 37, 54, 46, 55, 48, 52, 45],
    [40, 60, 54, 46, 49, 60, 40, 51],
    [54, 46, 38, 62, 49, 70, 30, 51],
    [61, 39, 55, 45, 61, 38, 62, 39],
    [61, 39, 67, 33, 70, 50, 50, 30],
    [50, 50, 34, 66, 56, 68, 32, 44],
    [46, 54, 50, 50, 35, 61, 39, 65],
    [63, 37, 54, 46, 55, 48, 52, 45], // loop back
  ];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 8),
      vsync: this,
    )..repeat();
    _animation = CurvedAnimation(parent: _controller, curve: Curves.linear);
    widget.controller?._attach(this);
    if(widget.startStopped){
      _controller.stop();
    } 
  }

  List<double> _interpolateBorder(double t) {
    final section = 1.0 / (borderKeyframes.length - 1);
    final index = (t / section).floor();
    final localT = (t % section) / section;
    final current = borderKeyframes[index];
    final next = borderKeyframes[(index + 1) % borderKeyframes.length];
    return List.generate(
      current.length,
      (i) => lerpDouble(current[i], next[i], localT),
    );
  }

  double lerpDouble(double a, double b, double t) => a + (b - a) * t;

  @override
  Widget build(BuildContext context) {
    return  AnimatedBuilder(
      animation: _animation,
      builder: (_, __) {
        final border = _interpolateBorder(_animation.value);
        return ClipPath(
          clipper: BlobClipper(border),
          child: PrimaryContainer(
            padding: 0,
            margin: 0,
            width: widget.width,
            height: widget.height,
            child: Center(child:widget.child),
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}

class BlobClipper extends CustomClipper<Path> {
  final List<double> radius;

  BlobClipper(this.radius);

  @override
  Path getClip(Size size) {
    final path = Path();
    final width = size.width;
    final height = size.height;

    path.moveTo(0, height * radius[4] / 100);
    path.quadraticBezierTo(0, 0, width * radius[0] / 100, 0);
    path.lineTo(width * (1 - radius[1] / 100), 0);
    path.quadraticBezierTo(width, 0, width, height * radius[5] / 100);
    path.lineTo(width, height * (1 - radius[6] / 100));
    path.quadraticBezierTo(width, height, width * (1 - radius[2] / 100), height);
    path.lineTo(width * radius[3] / 100, height);
    path.quadraticBezierTo(0, height, 0, height * (1 - radius[7] / 100));
    path.close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => true;
}

class AnimatedCircularController {
  _MorphingBlobState? _state;

  /// Called internally by the widget to attach itself
  void _attach(_MorphingBlobState state) {
    _state = state;
  }

  /// Call this to start the animation
  void start() => _state?._controller.repeat();

  /// Call this to stop the animation
  void stop() => _state?._controller.stop();
}