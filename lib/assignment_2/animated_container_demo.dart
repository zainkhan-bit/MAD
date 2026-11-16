import 'package:flutter/material.dart';

class AnimatedContainerWidgetDemo extends StatefulWidget {
  const AnimatedContainerWidgetDemo({super.key});

  @override
  State<AnimatedContainerWidgetDemo> createState() =>
      _AnimatedContainerWidgetDemoState();
}

class _AnimatedContainerWidgetDemoState
    extends State<AnimatedContainerWidgetDemo> {
  double _height = 100.0;
  double _width = 100.0;

  void _increaseWidth() {
    setState(() {
      _width = _width >= 320.0 ? 100.0 : _width += 50.0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Animated Container')),
      body: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            AnimatedContainer(
              duration: const Duration(milliseconds: 500),
              curve: Curves.elasticOut,
              color: Colors.amber,
              height: _height,
              width: _width,
              child: TextButton(
                child: Text('Tap to\nGrow Width\n$_width'),
                onPressed: () {
                  _increaseWidth();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}