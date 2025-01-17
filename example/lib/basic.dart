import 'package:flutter/material.dart';

import 'package:scratcher/scratcher.dart';

class BasicScreen extends StatefulWidget {
  @override
  _BasicScreenState createState() => _BasicScreenState();
}

class _BasicScreenState extends State<BasicScreen> {
  double brushSize = 30;
  double progress = 0;
  bool thresholdReached = false;
  bool enabled = true;
  double? size;
  final key = GlobalKey<ScratcherState>();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                child: const Text('Reset'),
                onPressed: () {
                  key.currentState?.reset(
                    duration: const Duration(milliseconds: 2000),
                  );
                  setState(() => thresholdReached = false);
                },
              ),
              ElevatedButton(
                child: const Text('Change size'),
                onPressed: () {
                  setState(() {
                    if (size == null) {
                      size = 200;
                    } else if (size == 200) {
                      size = 0;
                    } else {
                      size = null;
                    }
                  });
                },
              ),
              ElevatedButton(
                child: const Text('Reveal'),
                onPressed: () {
                  key.currentState?.reveal(
                    duration: const Duration(milliseconds: 2000),
                  );
                },
              ),
            ],
          ),
          Column(
            children: [
              Text('Brush size (${brushSize.round()})'),
              Slider(
                value: brushSize,
                onChanged: (v) => setState(() => brushSize = v),
                min: 5,
                max: 100,
              ),
            ],
          ),
          CheckboxListTile(
            value: enabled,
            title: Text('Scratcher enabled'),
            onChanged: (e) => setState(() {
              enabled = e ?? false;
            }),
          ),
          Expanded(
            child: Stack(
              children: [
                SizedBox(
                  height: size,
                  width: size,
                  child: Scratcher(
                    key: key,
                    enabled: enabled,
                    pointerImage: Image.asset('assets/xnb.png', width: 113, height: 133),
                    brushSize: brushSize,
                    color: Colors.transparent,
                    threshold: 30,
                    image: Image.asset('assets/op.png'),
                    onThreshold: () => setState(() => thresholdReached = true),
                    onChange: (value) {
                      setState(() {
                        progress = value;
                      });
                    },
                    onScratchStart: (details) {
                      print("Scratching has started" + details.localPosition.toString());
                    },
                    onScratchUpdate: (details) {
                      print("Scratching in progress" + details.localPosition.toString());
                    },
                    onScratchEnd: (details) {
                      print("Scratching has finished");
                    },
                    child: Image.asset(
                      'assets/bg.jpeg',
                      width: double.infinity,
                      height: double.infinity,
                      fit: BoxFit.cover,
                    ),
                    // child: Container(
                    //   color: Colors.black,
                    //   alignment: Alignment.center,
                    //   child: Column(
                    //     mainAxisAlignment: MainAxisAlignment.center,
                    //     children: [
                    //       const Text(
                    //         'Scratch the screen!',
                    //         textAlign: TextAlign.center,
                    //         style: TextStyle(
                    //           fontSize: 36,
                    //           fontWeight: FontWeight.bold,
                    //           color: Colors.amber,
                    //         ),
                    //       ),
                    //       SizedBox(height: 8),
                    //       const Text(
                    //         'Photo by Fabian Wiktor from Pexels',
                    //         textAlign: TextAlign.center,
                    //         style: TextStyle(
                    //           fontSize: 12,
                    //           fontWeight: FontWeight.bold,
                    //           color: Colors.amber,
                    //         ),
                    //       )
                    //     ],
                    //   ),
                    // ),
                  ),
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 12,
                    ),
                    color: Colors.black,
                    child: Text(
                      '${progress.floor().toString()}% '
                      '(${thresholdReached ? 'done' : 'pending'})',
                      textAlign: TextAlign.right,
                      style: const TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
