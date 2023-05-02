import 'package:flutter/material.dart';
import 'package:flutter_hanoi/components/block_details.dart';
import 'package:provider/provider.dart';

import 'controller.dart';

class Hanoi extends StatelessWidget {
  const Hanoi({Key? key, required this.size}) : super(key: key);
  final Size size;

  @override
  Widget build(BuildContext context) {
    return SizedBox.fromSize(
      size: size,
      child: Stack(
        children: context
            .watch<HanoiController>()
            .details
            .map((e) => _Block(details: e))
            .toList(),
      ),
    );
  }
}

class _Block extends StatelessWidget {
  const _Block({Key? key, required this.details}) : super(key: key);
  final BlockDetails details;

  @override
  Widget build(BuildContext context) {
    return Positioned(
        left: details.left,
        top: details.top,
        child: GestureDetector(
          onPanUpdate: (d) {
            final canMove =
                context.read<HanoiController>().canMove(details.blockId);
            if (!canMove) {
              return;
            }
            context.read<HanoiController>().changePosition(details.blockId, d);
          },
          onPanEnd: (d) {
            final canMove =
                context.read<HanoiController>().canMove(details.blockId);
            if (!canMove) {
              return;
            }
            context.read<HanoiController>().onMoveDone(details.blockId);
          },
          child: Container(
            width: details.width,
            height: details.height,
            color: Colors.blue,
          ),
        ));
  }
}
