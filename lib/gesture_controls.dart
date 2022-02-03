import 'dart:math';
import 'package:flutter/material.dart';

import 'package:flutter/cupertino.dart';

enum Direction { up, down, left, right, none }

class GestureControl extends StatefulWidget {
  final ValueChanged<Direction>? onDirectionChanged;

  const GestureControl({Key? key, this.onDirectionChanged}) : super(key: key);

  @override
  GestureControlState createState() => GestureControlState();
}

class GestureControlState extends State<GestureControl> {
  Direction direction = Direction.none;
  Offset delta = Offset.zero;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: SizedBox.expand(
        child: Container(
          decoration: BoxDecoration(
            color: const Color(0xccffffff),
            borderRadius: BorderRadius.circular(30),
          ),
        ),
      ),
      onPanDown: onDragDown,
      onPanUpdate: onDragUpdate,
      onPanEnd: onDragEnd,
    );
  }

  void updateDelta(Offset newDelta) {
    final newDirection = getDirectionFromOffset(newDelta);

    if (newDirection != direction) {
      direction = newDirection;
      widget.onDirectionChanged!(direction);
    }

    setState(() {
      delta = newDelta;
    });
  }

  Direction getDirectionFromOffset(Offset offset) {
    if (offset.dx > 20) {
      return Direction.right;
    } else if (offset.dx < -20) {
      return Direction.left;
    } else if (offset.dy > 20) {
      return Direction.down;
    } else if (offset.dy < -20) {
      return Direction.up;
    }
    return Direction.none;
  }

  void onDragDown(DragDownDetails d) {
    calculateDelta(d.localPosition);
  }

  void onDragUpdate(DragUpdateDetails d) {
    calculateDelta(d.localPosition);
  }

  void onDragEnd(DragEndDetails d) {
    updateDelta(Offset.zero);
  }

  void calculateDelta(Offset offset) {
    final newDelta = offset - const Offset(60, 60);
    updateDelta(
      Offset.fromDirection(
        newDelta.direction,
        min(30, newDelta.distance),
      ),
    );
  }
}
