enum chess_pieces_type {
  pawn,
  rook,
  knight,
  bishop,
  queen,
  king,
}

class Chess_Piece {
  final chess_pieces_type type;
  final bool isWhite;
  final String imagePath;

  Chess_Piece(this.type, this.isWhite, this.imagePath);
}
