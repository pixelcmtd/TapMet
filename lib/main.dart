import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

double bpmFromSamples(final List<DateTime> samples) {
  if (samples.length < 2) return 0;
  final l = samples.reversed.map((x) => x.millisecondsSinceEpoch).toList();
  var y = l.removeAt(0);
  final ms = l.fold<double>(0, (ms, x) {
    ms += y - x;
    y = x;
    return ms;
  });
  return 1 / (ms / l.length / 1000 / 60);
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _samples = 10;
  List<DateTime> _taps = [];

  @override
  Widget build(BuildContext context) {
    final bpm = bpmFromSamples(_taps.sublist(max(_taps.length - _samples, 0)));
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'BPM: ${bpm.toStringAsFixed(1)} / ${(bpm / 2).toStringAsFixed(1)}',
              style: const TextStyle(fontSize: 100),
            ),
            ElevatedButton(
              child: const Text('Reset'),
              onPressed: () => setState(() => _taps = []),
            ),
            ElevatedButton(
              child: const Text('Tap'),
              onPressed: () => setState(() => _taps.add(DateTime.now())),
            ),
          ],
        ),
      ),
    );
  }
}
