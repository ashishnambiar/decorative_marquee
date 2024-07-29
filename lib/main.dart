import 'dart:math';
import 'dart:ui';

import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  ValueNotifier<int> tick = ValueNotifier(0);

  @override
  void initState() {
    final ticker = Ticker(
      (elapsed) {
        tick.value++;
      },
    );
    ticker.start();

    super.initState();
  }

  var v1 = 0.0;
  var padding = 0.0;
  var top = 0.0;
  var bottom = 0.0;
  var left = 0.0;
  var right = 0.0;
  final controller1 = TextEditingController(text: '1');
  final controller2 = TextEditingController(text: '2');
  final text = nouns.take(5);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Stack(
        children: [
          Positioned.fill(
              child:
                  ColoredBox(color: Theme.of(context).scaffoldBackgroundColor)),
          Positioned.fill(
            child: Opacity(
              opacity: .1,
              child: Center(
                child: SizedBox(
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                  child: ValueListenableBuilder(
                    valueListenable: tick,
                    builder: (context, value, child) {
                      return CustomPaint(
                        painter: MarqueePainter(
                          [
                            ...text,
                            // controller1.text,
                            // controller2.text,
                          ],
                          value,
                          style: Theme.of(context).textTheme.displayLarge,
                          delimiter:
                              ' ${String.fromCharCode(Icons.star.codePoint)} ',
                          topBuffer: 250,
                          bottomBuffer: 250,
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
          ),
          Positioned.fill(
            child: Scaffold(
              backgroundColor: Colors.transparent,
              body: Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            clipBehavior: Clip.antiAlias,
                            decoration: const BoxDecoration(
                              color: Colors.amber,
                            ),
                            height: 200,
                            // MediaQuery.of(context).size.height,
                            width: 200,
                            // MediaQuery.of(context).size.width,
                            // child: ListenableBuilder(
                            //   listenable: controller1,
                            //   builder: (context, child) {
                            //     return CustomPaint(
                            //       painter: MarqueePainter(
                            //         [
                            //           // 'hello world', 'other things'
                            //           controller1.text,
                            //           controller2.text,
                            //           'other',
                            //         ],
                            //         // v1.toInt(),
                            //         tick,
                            //         themeData: Theme.of(context),
                            //         delimiter:
                            //             ' ${String.fromCharCode(Icons.star.codePoint)} ',
                            //         padding: padding,
                            //         topBuffer: top,
                            //         bottomBuffer: bottom,
                            //         leftBuffer: left,
                            //         rightBuffer: right,
                            //         debug: true,
                            //       ),
                            //     );
                            //   },
                            // ),
                          ),
                          TextField(
                            controller: controller1,
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: Colors.white,
                            ),
                          ),
                          TextField(
                            controller: controller2,
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    child: Column(
                      children: [
                        Slider(
                          value: v1,
                          min: 0,
                          max: 5000,
                          onChanged: (value) {
                            setState(() {
                              v1 = value;
                            });
                          },
                        ),
                        Slider(
                          value: padding,
                          min: 0,
                          max: 1000,
                          onChanged: (value) {
                            setState(() {
                              padding = value;
                            });
                          },
                        ),
                        Slider(
                          value: top,
                          min: 0,
                          max: 200,
                          onChanged: (value) {
                            setState(() {
                              top = value;
                            });
                          },
                        ),
                        Slider(
                          value: bottom,
                          min: 0,
                          max: 200,
                          onChanged: (value) {
                            setState(() {
                              bottom = value;
                            });
                          },
                        ),
                        Slider(
                          value: left,
                          min: 0,
                          max: 200,
                          onChanged: (value) {
                            setState(() {
                              left = value;
                            });
                          },
                        ),
                        Slider(
                          value: right,
                          min: 0,
                          max: 200,
                          onChanged: (value) {
                            setState(() {
                              right = value;
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class MarqueePainter extends CustomPainter {
  late final List<String> _text;
  final String delimiter;
  final int tick;
  final double topBuffer;
  final double bottomBuffer;
  final double leftBuffer;
  final double rightBuffer;
  final bool debug;
  final TextStyle? style;
  MarqueePainter(
    List<String> text,
    this.tick, {
    required this.style,
    this.delimiter = '',
    this.topBuffer = 0,
    this.bottomBuffer = 0,
    this.leftBuffer = 0,
    this.rightBuffer = 0,
    this.debug = false,
  }) {
    _text = text.fold(
      [],
      (p, e) => [...p, e, delimiter],
    );
    tps = List.generate(
      _text.length,
      (i) {
        return TextPainter(
          textDirection: TextDirection.ltr,
          text: TextSpan(
            text: _text[i],
            style: style //

                ?.copyWith(fontFamilyFallback: [Icons.star.fontFamily ?? '']
                    // backgroundColor: switch (i % 3) {
                    //   0 => Colors.green,
                    //   1 => Colors.blue,
                    //   2 => Colors.purple,
                    //   int() => Colors.red,
                    // },
                    ),
          ),
        );
      },
    );
  }
  double get increment => tick * 0.4;

  late List<TextPainter> tps;
  List<({String text, Size size})> tpSizes = [];
  double get maxWidth => tpSizes.fold(0, (p, e) => p + e.size.width);
  double get height => tpSizes.fold(0, (p, e) => max(p, e.size.height));

  @override
  void paint(Canvas canvas, Size size) {
    // rotate from center of canvas
    canvas.translate(size.width / 2, size.height / 2);
    canvas.rotate(.4);
    canvas.translate(-size.width / 2, -size.height / 2);

    // Debug drawing
    if (debug) {
      final bounds = Rect.fromPoints(
        Offset(-leftBuffer, -topBuffer),
        Offset(size.width + rightBuffer, size.height + bottomBuffer),
      );
      canvas.drawRect(bounds, Paint()..color = Colors.amber.withOpacity(.5));
      canvas.drawRect(
          Rect.fromPoints(Offset.zero, Offset(size.width, size.height)),
          Paint()..color = Colors.teal);
    }

    // layout the text and get sizes for all text
    for (var (i, _) in tps.indexed) {
      tps[i].layout();
      tpSizes.add((text: _text[i], size: tps[i].size));
    }

    final finalWidth = size.width + leftBuffer + rightBuffer;
    final finalHeight = size.height + topBuffer + bottomBuffer;

    final o = -(increment % maxWidth) - leftBuffer;
    final hCount = (finalWidth / maxWidth).ceil() + 1;
    final vCount = (finalHeight / height).ceil();

    for (var j = 0; j < vCount; j++) {
      for (var i = 0; i < hCount; i++) {
        double w1 = 0;
        for (var tp in tps) {
          final o2 = o + (maxWidth * i);
          j % 2 == 0
              ? tp.paint(canvas, Offset(o2 + w1, (height * j) - topBuffer))
              : tp.paint(
                  canvas,
                  Offset(-o + finalWidth - tp.width - (maxWidth * i) - w1,
                      (height * j) - topBuffer));
          w1 += tp.width;
        }
      }
    }

    return;

    final t = _text[0] + ' ${delimiter}';
    final tp = TextPainter(
      textDirection: TextDirection.ltr,
      text: TextSpan(
        text: t,
        style: const TextStyle(
          color: Colors.black,
        ),
      ),
    );
    tp.layout();
    final w = tp.size.width;
    final h = tp.size.height;
    final offset = increment % w;

    final hcount = (size.width / w).ceil();
    final vcount = (size.height / h).ceil();

    for (var i = -(leftBuffer); i < hcount + 1 + (rightBuffer); i++) {
      for (var j = -(topBuffer); j < vcount + (bottomBuffer); j++) {
        if (j % 2 == 0) {
          tp.paint(canvas, Offset((i * w) - offset, j * h));
        } else {
          tp.paint(canvas, Offset(((i - 1) * w) + offset, j * h));
        }
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
