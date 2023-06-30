import 'package:chess_toturial/shared/components/pieces.dart';
import 'package:chess_toturial/values/colors.dart';
import 'package:flutter/material.dart';

class square extends StatelessWidget {
  const square(
      {super.key,
      required this.isWhite,
      this.piece,
      required this.isSelected,
      this.onTap,
      required this.isValidMove});
  final Chess_Piece? piece;
  final bool isWhite;
  final bool isSelected;
  final bool isValidMove;
  final onTap;
  @override
  Widget build(BuildContext context) {
    Color? squreColor;
    if (isSelected) {
      squreColor = Colors.red.withOpacity(0.5);
    } else if (isValidMove) {
      squreColor = Colors.green;
    } else {
      squreColor = isWhite ? foregroundColor : backgroundColor;
    }
    return GestureDetector(
      onTap: onTap,
      child: Container(
        color: squreColor,
        margin: EdgeInsets.all(isValidMove ? 5 : 0),
        child: piece != null
            ? Image.asset(
                '${piece!.imagePath}',
                color: piece!.isWhite ? Colors.white : Colors.black,
              )
            : null,
      ),
    );
  }
}
