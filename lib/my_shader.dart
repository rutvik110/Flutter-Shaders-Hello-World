import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:shaders_hello_world/shaders/hello_world.dart';

class MyShader extends StatefulWidget {
  const MyShader({Key? key}) : super(key: key);

  @override
  State<MyShader> createState() => _MyShaderState();
}

class _MyShaderState extends State<MyShader> {
  late Future<HelloWorld> helloWorld;

  late Ticker ticker;

  late double delta;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    helloWorld = HelloWorld.compile();
    delta = 0;
    ticker = Ticker((elapsedTime) {
      setState(() {
        delta += 1 / 60;
      });
    })
      ..start();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    ticker.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<HelloWorld>(
        future: helloWorld,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return CustomPaint(
              painter: MyPainter(
                snapshot.data!.shader(
                  resolution: MediaQuery.of(context).size,
                  uTime: delta,
                ),
              ),
              size: Size(
                MediaQuery.of(context).size.width,
                MediaQuery.of(context).size.height,
              ),
            );
          } else if (snapshot.hasError) {
            return Text('${snapshot.error}');
          }
          return const CircularProgressIndicator();
        },
      ),
    );
  }
}

class MyPainter extends CustomPainter {
  MyPainter(this.shader) : _paint = Paint()..shader = shader;

  final Shader shader;

  final Paint _paint;

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawRect(
        Rect.fromLTWH(
          0,
          0,
          size.width,
          size.height,
        ),
        _paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
