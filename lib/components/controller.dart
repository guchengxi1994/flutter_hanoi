import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hanoi/components/block_details.dart';
import 'dart:math' as math;
import 'movement.dart';

class HanoiController extends ChangeNotifier {
  static final ConfettiController confettiController =
      ConfettiController(duration: const Duration(seconds: 5));

  int _hanoiBlockCount = 3;

  int get hanoiCount => _hanoiBlockCount;
  late Size boardSize = Size.zero;

  List<Movement> movements = [];
  List<BlockDetails> details = [];

  /// TODO
  ///
  /// 开启仅能移动到隔壁柱子的模式
  bool onlyMoveToNext = false;

  changeMoveType(bool b) {
    onlyMoveToNext = b;
    notifyListeners();
  }

  @override
  void dispose() {
    confettiController.dispose();
    super.dispose();
  }

  num _getBest() {
    if (!onlyMoveToNext) {
      return math.pow(2, _hanoiBlockCount) - 1;
    }
    return math.pow(3, _hanoiBlockCount) - 1;
  }

  num get best => _getBest();

  setCount({int? count}) {
    if (count != null) {
      _hanoiBlockCount = count;
      details.clear();
      movements.clear();
      initPosition(boardSize, refresh: false);
    } else {
      details.clear();
      movements.clear();
      initPosition(boardSize, refresh: false);
    }

    notifyListeners();
  }

  addMovement(Movement m) {
    movements.add(m);
  }

  initPosition(Size size, {bool refresh = true}) {
    boardSize = size;
    for (int i = 1; i <= _hanoiBlockCount; i++) {
      final center = size.width * 0.25;
      details.add(BlockDetails(
          height: 30,
          left: center - (center - i * 10) / 2,
          top: size.height - (30.0 * i) - 5,
          width: center - (i) * 10,
          blockId: i));
    }
    if (refresh) {
      notifyListeners();
    }
  }

  prevStep() {
    if (movements.isEmpty) {
      return;
    }
    final m = movements.removeLast();
    final count =
        details.where((element) => element.towerPosition == m.from).length + 1;

    final a = boardSize.width * 0.25;

    final double center = a * (m.from + 1);
    details[m.blockId - 1].left = center - (a - m.blockId * 10) / 2;
    details[m.blockId - 1].top = boardSize.height - (30.0 * count) - 5;
    details[m.blockId - 1].towerPosition = m.from;

    notifyListeners();
  }

  changePosition(int blockId, DragUpdateDetails d) {
    details[blockId - 1].left += d.delta.dx;
    details[blockId - 1].top += d.delta.dy;

    notifyListeners();
  }

  bool canMove(int blockId) {
    final d = details[blockId - 1];
    final elements =
        details.where((element) => element.towerPosition == d.towerPosition);
    if (elements.last.blockId != blockId) {
      return false;
    }
    return true;
  }

  void printSteps() {
    debugPrint("$_hanoiBlockCount\n ${movements.steps()}");
  }

  void _moveTo(int to, int blockId) {
    final int count;
    final double center;
    final elements = details.where((element) => element.towerPosition == to);
    center = boardSize.width * 0.25 * (to + 1);
    count = elements.length + 1;
    details[blockId - 1].left =
        center - (boardSize.width * 0.25 - blockId * 10) / 2;
    details[blockId - 1].top = boardSize.height - (30.0 * count) - 5;
    details[blockId - 1].towerPosition = to;
  }

  onMoveDone(int blockId) {
    final right = details[blockId - 1].left + details[blockId - 1].width;
    final before = details[blockId - 1].towerPosition;

    if (right > boardSize.width * 0.75) {
      final elements = details.where((element) => element.towerPosition == 2);

      final int count;
      final double center;

      if (elements.isNotEmpty) {
        if (blockId < elements.last.blockId) {
          debugPrint(
              "cannot move $blockId from ${details[blockId - 1].towerPosition} to 2");
          center =
              boardSize.width * 0.25 * (details[blockId - 1].towerPosition + 1);
          count = details
              .where((element) =>
                  element.towerPosition == details[blockId - 1].towerPosition)
              .length;
        } else {
          center = boardSize.width * 0.75;
          if (before != 2) {
            count = elements.length + 1;
          } else {
            count = elements.length;
          }
          details[blockId - 1].towerPosition = 2;
        }
      } else {
        center = boardSize.width * 0.75;
        if (before != 2) {
          count = elements.length + 1;
        } else {
          count = elements.length;
        }
        details[blockId - 1].towerPosition = 2;
      }

      details[blockId - 1].left =
          center - (boardSize.width * 0.25 - blockId * 10) / 2;
      details[blockId - 1].top = boardSize.height - (30.0 * count) - 5;
      if (onlyMoveToNext && before != 1) {
        debugPrint(
            "cannot move $blockId from $before to 2 because only move to next");

        if (before != 2) {
          _moveTo(before, blockId);
        }
      } else {
        if (before != 2) {
          addMovement(Movement(blockId: blockId, from: before, to: 2));
        }
      }
    } else if (right > boardSize.width * 0.5) {
      final elements = details.where((element) => element.towerPosition == 1);

      final int count;
      final double center;

      if (elements.isNotEmpty) {
        if (blockId < elements.last.blockId) {
          debugPrint(
              "cannot move $blockId from ${details[blockId - 1].towerPosition} to 1");
          center =
              boardSize.width * 0.25 * (details[blockId - 1].towerPosition + 1);
          count = details
              .where((element) =>
                  element.towerPosition == details[blockId - 1].towerPosition)
              .length;
        } else {
          center = boardSize.width * 0.5;
          if (before != 1) {
            count = elements.length + 1;
          } else {
            count = elements.length;
          }
          details[blockId - 1].towerPosition = 1;
        }
      } else {
        center = boardSize.width * 0.5;
        if (before != 1) {
          count = elements.length + 1;
        } else {
          count = elements.length;
        }
        details[blockId - 1].towerPosition = 1;
      }

      details[blockId - 1].left =
          center - (boardSize.width * 0.25 - blockId * 10) / 2;
      details[blockId - 1].top = boardSize.height - (30.0 * count) - 5;
      if (onlyMoveToNext && before != 0 && before != 2) {
        if (before != 1) {
          _moveTo(before, blockId);
        }
      } else {
        if (before != 1) {
          addMovement(Movement(blockId: blockId, from: before, to: 1));
        }
      }
    } else {
      final elements = details.where((element) => element.towerPosition == 0);

      final int count;
      final double center;

      if (elements.isNotEmpty) {
        if (blockId < elements.last.blockId) {
          debugPrint(
              "cannot move $blockId from ${details[blockId - 1].towerPosition} to 0");
          center =
              boardSize.width * 0.25 * (details[blockId - 1].towerPosition + 1);
          count = details
              .where((element) =>
                  element.towerPosition == details[blockId - 1].towerPosition)
              .length;
        } else {
          center = boardSize.width * 0.25;
          if (before != 0) {
            count = elements.length + 1;
          } else {
            count = elements.length;
          }
          details[blockId - 1].towerPosition = 0;
        }
      } else {
        center = boardSize.width * 0.25;
        if (before != 0) {
          count = elements.length + 1;
        } else {
          count = elements.length;
        }
        details[blockId - 1].towerPosition = 0;
      }

      details[blockId - 1].left = center - (center - blockId * 10) / 2;
      details[blockId - 1].top = boardSize.height - (30.0 * count) - 5;

      if (onlyMoveToNext && before != 1) {
        if (before != 0) {
          _moveTo(before, blockId);
        }
      } else {
        if (before != 0) {
          addMovement(Movement(blockId: blockId, from: before, to: 0));
        }
      }
    }
    notifyListeners();

    final moved = details.where((element) => element.towerPosition == 2);
    if (moved.length == details.length) {
      confettiController.play();
    }
  }
}

Path drawStar(Size size) {
  // Method to convert degree to radians
  double degToRad(double deg) => deg * (math.pi / 180.0);

  const numberOfPoints = 5;
  final halfWidth = size.width / 2;
  final externalRadius = halfWidth;
  final internalRadius = halfWidth / 2.5;
  final degreesPerStep = degToRad(360 / numberOfPoints);
  final halfDegreesPerStep = degreesPerStep / 2;
  final path = Path();
  final fullAngle = degToRad(360);
  path.moveTo(size.width, halfWidth);

  for (double step = 0; step < fullAngle; step += degreesPerStep) {
    path.lineTo(halfWidth + externalRadius * math.cos(step),
        halfWidth + externalRadius * math.sin(step));
    path.lineTo(
        halfWidth + internalRadius * math.cos(step + halfDegreesPerStep),
        halfWidth + internalRadius * math.sin(step + halfDegreesPerStep));
  }
  path.close();
  return path;
}
