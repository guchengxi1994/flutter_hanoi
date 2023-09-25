import 'package:confetti/confetti.dart';
import 'package:cool_dropdown/cool_dropdown.dart';
import 'package:cool_dropdown/models/cool_dropdown_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:provider/provider.dart';
import 'dart:math' as math;

import 'components/board.dart';
import 'components/controller.dart';
import 'components/hanoi.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'hanoi tower',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Hanoi tower demo'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<String> types = [
    'easy',
    'normal',
    'hard',
  ];

  List<CoolDropdownItem<String>> dropdownItemList = [];
  final dropdownController = DropdownController();

  @override
  void initState() {
    super.initState();
    for (var i = 0; i < types.length; i++) {
      dropdownItemList.add(
        CoolDropdownItem<String>(label: types[i], value: types[i]),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: MultiProvider(
            providers: [
              ChangeNotifierProvider(
                  create: (_) =>
                      HanoiController()..initPosition(const Size(500, 300)))
            ],
            builder: (ctx, child) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 500,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Current: ${ctx.select<HanoiController, int>((value) => value.movements.length)} (Best: ${ctx.select<HanoiController, num>((value) => value.best).toString()})",
                          style: const TextStyle(fontSize: 25),
                        )
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Align(
                      alignment: Alignment.center,
                      child: ConfettiWidget(
                        confettiController: HanoiController.confettiController,
                        blastDirection: math.pi, // radial value - LEFT
                        particleDrag: 0.05, // apply drag to the confetti
                        emissionFrequency: 0.05, // how often it should emit
                        numberOfParticles: 20, // number of particles to emit
                        gravity: 0.05, // gravity - or fall speed
                        shouldLoop: false,
                        colors: const [
                          Colors.green,
                          Colors.blue,
                          Colors.pink
                        ], // manually specify the colors to be used
                        strokeWidth: 1,
                        strokeColor: Colors.white,
                      )),
                  SizedBox.fromSize(
                      size: const Size(500, 300),
                      child: CustomPaint(
                        painter: HanoiBoard(),
                        child: const Hanoi(
                          size: Size(500, 300),
                        ),
                      )),
                  const SizedBox(
                    height: 20,
                  ),
                  SizedBox(
                    width: 500,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(
                          width: 20,
                        ),
                        InkWell(
                          onTap: () {
                            ctx.read<HanoiController>().prevStep();
                          },
                          child: const Tooltip(
                            message: "回退一步",
                            child: Icon(Icons.arrow_back),
                          ),
                        ),
                        const Expanded(child: SizedBox()),
                        Tooltip(
                          message: "激活后，仅能移动至隔壁柱子",
                          child: FlutterSwitch(
                            width: 55.0,
                            height: 25.0,
                            valueFontSize: 12.0,
                            toggleSize: 18.0,
                            value: ctx.watch<HanoiController>().onlyMoveToNext,
                            onToggle: (val) {
                              setState(() {
                                ctx.read<HanoiController>().changeMoveType(val);
                                ctx.read<HanoiController>().setCount();
                              });
                            },
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        CoolDropdown(
                          defaultItem: dropdownItemList.first,
                          controller: dropdownController,
                          dropdownList: dropdownItemList,
                          onChange: (dropdownItem) {
                            switch (dropdownItem) {
                              case 'easy':
                                ctx.read<HanoiController>().setCount(count: 3);
                                break;
                              case 'normal':
                                ctx.read<HanoiController>().setCount(count: 4);
                                break;
                              case 'hard':
                                ctx.read<HanoiController>().setCount(count: 5);
                                break;
                              default:
                                ctx.read<HanoiController>().setCount(count: 3);
                            }
                          },
                          resultOptions: const ResultOptions(
                            padding: EdgeInsets.symmetric(horizontal: 10),
                            width: 200,
                            icon: SizedBox(
                              width: 10,
                              height: 10,
                              child: CustomPaint(
                                painter: DropdownArrowPainter(),
                              ),
                            ),
                            render: ResultRender.all,
                            placeholder: '选择难度',
                            isMarquee: true,
                          ),
                          dropdownOptions: const DropdownOptions(
                              top: 20,
                              height: 400,
                              gap: DropdownGap.all(5),
                              borderSide:
                                  BorderSide(width: 1, color: Colors.black),
                              padding: EdgeInsets.symmetric(horizontal: 10),
                              align: DropdownAlign.left,
                              animationType: DropdownAnimationType.size),
                          dropdownTriangleOptions:
                              const DropdownTriangleOptions(
                            width: 20,
                            height: 30,
                            align: DropdownTriangleAlign.left,
                            borderRadius: 3,
                            left: 20,
                          ),
                          dropdownItemOptions: const DropdownItemOptions(
                            isMarquee: true,
                            mainAxisAlignment: MainAxisAlignment.start,
                            render: DropdownItemRender.all,
                            height: 50,
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        InkWell(
                          onTap: () => ctx.read<HanoiController>().printSteps(),
                          child: const Icon(Icons.error),
                        ),
                      ],
                    ),
                  )
                ],
              );
            }));
  }
}
