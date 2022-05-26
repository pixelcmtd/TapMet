import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sound/flutter_sound.dart';

void main() {
  runApp(const MyApp());
}

double? bpmFromSamples(final List<DateTime> samples) {
  if (samples.length < 2) return null;
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
        primarySwatch: Colors.pink,
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
// TODO: ways to config these 2
  int _samples = 10;
  double _speed = 1 / 1;
  List<DateTime> _taps = [];
  int _bpm = 120;
  int _index = 0;
  bool _running = false;
  final sound = FlutterSoundPlayer();

  void soundIndexLoop() {
    if (_running) {
      // TODO: play sound
      sound.stopPlayer();
      sound.startPlayer(
          fromURI:
              'file:///Users/chris/Library/Mobile Documents/com~apple~CloudDocs/emf/SAMPLES/drums (einzeln)/donks/UAMEE DONK1 G.wav');
      setState(() => _index = (_index + 1) % 4);
    }
    Future.delayed(
      Duration(microseconds: (60000000 / _bpm).round()),
      soundIndexLoop,
    );
  }

  _MyHomePageState() {
    sound.openPlayer();
    soundIndexLoop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size(600, 120),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 200,
              child: TextField(
                controller: TextEditingController.fromValue(
                  TextEditingValue(text: _bpm.round().toString()),
                ),
                style: const TextStyle(
                    fontSize: 100,
                    fontFamily: 'monospace',
                    fontFamilyFallback: [
                      'Menlo',
                      'Monaco',
                      'SF Mono',
                      'Ubuntu Mono'
                    ]),
                keyboardType: TextInputType.number,
                // TODO: NOTE: T?HING AH
                onChanged: (bpm) => _bpm = int.tryParse(bpm) ?? _bpm,
              ),
            ),
            const Text('BPM', style: TextStyle(fontSize: 100)),
          ],
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
              onPressed: () => _running = !_running,
              icon: Text(_index.toString()),
            ),
            ElevatedButton(
              child: const Text('Tap', style: TextStyle(fontSize: 72)),
              onPressed: () => setState(() {
                _taps.add(DateTime.now());
                // TODO: improve
                _bpm = ((bpmFromSamples(_taps.length < _samples
                                ? _taps
                                : _taps.sublist(_taps.length - _samples)) ??
                            120 / _speed) *
                        _speed)
                    .round();
              }),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  child: const Text('Reset'),
                  onPressed: () => setState(() {
                    _taps = [];
                    _bpm = 120;
                  }),
                ),
                IconButton(
                  icon: const Icon(CupertinoIcons.settings),
                  // TODO:
                  onPressed: () {},
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
