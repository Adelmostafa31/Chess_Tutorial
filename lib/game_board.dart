import 'package:chess_toturial/shared/components/DeadPieces.dart';
import 'package:chess_toturial/shared/components/pieces.dart';
import 'package:chess_toturial/shared/components/square.dart';
import 'package:chess_toturial/shared/helper/helper_methods.dart';
import 'package:chess_toturial/values/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';

class game_board extends StatefulWidget {
  const game_board({super.key});

  @override
  State<game_board> createState() => _game_boardState();
}

class _game_boardState extends State<game_board> {
  late List<List<Chess_Piece?>> board;

  Chess_Piece? selectedPiece;

  int selectRow = -1;
  int selectCol = -1;

  List<List<int>> validMoves = [];

  // black dead pieces
  List<Chess_Piece> blackDead = [];

  // white dead pieces
  List<Chess_Piece> whiteDead = [];

  // turn
  bool isWhiteTurn = true;

  // intial position of kings
  List<int> whiteKingPosition = [7, 4];
  List<int> blackKingPosition = [0, 4];
  bool checkStatus = false;

  @override
  void initState() {
    super.initState();
    _intializeBoard();
  }

  void _intializeBoard() {
    List<List<Chess_Piece?>> newBoard = List.generate(
        8,
        (index) => List.generate(
              8,
              (index) => null,
            ));
    // place pawns
    for (int i = 0; i < 8; i++) {
      newBoard[1][i] = Chess_Piece(
        chess_pieces_type.pawn,
        false,
        'assets/images/pawn2.png',
      );
      newBoard[6][i] = Chess_Piece(
        chess_pieces_type.pawn,
        true,
        'assets/images/pawn2.png',
      );
    }

    // place rooks
    for (int i = 0; i < 8; i++) {
      newBoard[0][0] = Chess_Piece(
        chess_pieces_type.rook,
        false,
        'assets/images/rook2.png',
      );
      newBoard[0][7] = Chess_Piece(
        chess_pieces_type.rook,
        false,
        'assets/images/rook2.png',
      );
      newBoard[7][0] = Chess_Piece(
        chess_pieces_type.rook,
        true,
        'assets/images/rook2.png',
      );
      newBoard[7][7] = Chess_Piece(
        chess_pieces_type.rook,
        true,
        'assets/images/rook2.png',
      );
    }

    // place bishops
    for (int i = 0; i < 8; i++) {
      // black
      newBoard[0][2] = Chess_Piece(
        chess_pieces_type.bishop,
        false,
        'assets/images/bishop.png',
      );
      newBoard[0][5] = Chess_Piece(
        chess_pieces_type.bishop,
        false,
        'assets/images/bishop.png',
      );
      // white
      newBoard[7][2] = Chess_Piece(
        chess_pieces_type.bishop,
        true,
        'assets/images/bishop.png',
      );
      newBoard[7][5] = Chess_Piece(
        chess_pieces_type.bishop,
        true,
        'assets/images/bishop.png',
      );
    }

    // place knights
    for (int i = 0; i < 8; i++) {
      // black
      newBoard[0][1] = Chess_Piece(
        chess_pieces_type.knight,
        false,
        'assets/images/knight2.png',
      );
      newBoard[0][6] = Chess_Piece(
        chess_pieces_type.knight,
        false,
        'assets/images/knight2.png',
      );
      // white
      newBoard[7][1] = Chess_Piece(
        chess_pieces_type.knight,
        true,
        'assets/images/knight2.png',
      );
      newBoard[7][6] = Chess_Piece(
        chess_pieces_type.knight,
        true,
        'assets/images/knight2.png',
      );
    }

    // place queens
    for (int i = 0; i < 8; i++) {
      // black
      newBoard[0][3] = Chess_Piece(
        chess_pieces_type.queen,
        false,
        'assets/images/queen2.png',
      );
      // white
      newBoard[7][3] = Chess_Piece(
        chess_pieces_type.queen,
        true,
        'assets/images/queen2.png',
      );
    }

    // place kings
    for (int i = 0; i < 8; i++) {
      // black
      newBoard[0][4] = Chess_Piece(
        chess_pieces_type.king,
        false,
        'assets/images/king.png',
      );
      // white
      newBoard[7][4] = Chess_Piece(
        chess_pieces_type.king,
        true,
        'assets/images/king.png',
      );
    }
    // }
    board = newBoard;
  }

  // User select piece
  void pieceSelect(int row, int col) {
    setState(() {
      if (selectedPiece == null && board[row][col] != null) {
        if (board[row][col]!.isWhite == isWhiteTurn) {
          selectedPiece = board[row][col];
          selectRow = row;
          selectCol = col;
        }
      } else if (board[row][col] != null &&
          board[row][col]!.isWhite == selectedPiece!.isWhite) {
        selectedPiece = board[row][col];
        selectRow = row;
        selectCol = col;
      } else if (selectedPiece != null &&
          validMoves.any((element) => element[0] == row && element[1] == col)) {
        movePiece(row, col);
      }
      // if a piece is selected ,calculate it's valid moves
      validMoves =
          calculate_real_valid_moves(selectRow, selectCol, selectedPiece, true);
    });
  }

  // Calculate row valid moves

  List<List<int>> calculate_raw_valid_moves(
      int row, int col, Chess_Piece? piece) {
    List<List<int>> candidate_moves = [];
    // different direction based on their color

    if (piece == null) {
      return [];
    }
    var direction = piece.isWhite ? -1 : 1;

    switch (piece.type) {
      case chess_pieces_type.pawn:
        if ((isInBoard(row + direction, col)) &&
            board[row + direction][col] == null) {
          candidate_moves.add([row + direction, col]);
        }
        if ((row == 1 && !piece.isWhite) || (row == 6 && piece.isWhite)) {
          if (isInBoard(row + 2 * direction, col) &&
              board[row + 2 * direction][col] == null &&
              board[row + direction][col] == null) {
            candidate_moves.add([row + 2 * direction, col]);
          }
        }
        if ((isInBoard(row + direction, col - 1)) &&
            board[row + direction][col - 1] != null &&
            board[row + direction][col - 1]!.isWhite != piece.isWhite) {
          candidate_moves.add([row + direction, col - 1]);
        }
        if ((isInBoard(row + direction, col + 1)) &&
            board[row + direction][col + 1] != null &&
            board[row + direction][col + 1]!.isWhite != piece.isWhite) {
          candidate_moves.add([row + direction, col + 1]);
        }
        break;
      case chess_pieces_type.rook:
        var directions = [
          [-1, 0],
          [1, 0],
          [0, -1],
          [0, 1],
        ];
        for (var direction in directions) {
          var i = 1;
          while (true) {
            var newRow = row + i * direction[0];
            var newCol = col + i * direction[1];
            if (!isInBoard(newRow, newCol)) {
              break;
            }
            if (board[newRow][newCol] != null) {
              if (board[newRow][newCol]!.isWhite != piece.isWhite) {
                candidate_moves.add([newRow, newCol]);
              }
              break;
            }
            candidate_moves.add([newRow, newCol]);
            i++;
          }
        }
        break;
      case chess_pieces_type.knight:
        var knightmoves = [
          [-2, -1],
          [-2, 1],
          [-1, -2],
          [-1, 2],
          [1, -2],
          [1, 2],
          [2, -1],
          [2, 1],
        ];
        for (var move in knightmoves) {
          var newRow = row + move[0];
          var newCol = col + move[1];
          if (!isInBoard(newRow, newCol)) {
            continue;
          }
          if (board[newRow][newCol] != null) {
            if (board[newRow][newCol]!.isWhite != piece.isWhite) {
              candidate_moves.add([newRow, newCol]);
            }
            continue;
          }
          candidate_moves.add([newRow, newCol]);
        }
        break;

      case chess_pieces_type.bishop:
        var directions = [
          [-1, -1],
          [-1, 1],
          [1, -1],
          [1, 1],
        ];
        for (var direction in directions) {
          var i = 1;
          while (true) {
            var newRow = row + i * direction[0];
            var newCol = col + i * direction[1];
            if (!isInBoard(newRow, newCol)) {
              break;
            }
            if (board[newRow][newCol] != null) {
              if (board[newRow][newCol]!.isWhite != piece.isWhite) {
                candidate_moves.add([newRow, newCol]);
              }
              break;
            }
            candidate_moves.add([newRow, newCol]);
            i++;
          }
        }
        break;

      case chess_pieces_type.queen:
        var directions = [
          [-1, 0],
          [1, 0],
          [0, -1],
          [0, 1],
          [-1, -1],
          [-1, 1],
          [1, -1],
          [1, 1],
        ];
        for (var direction in directions) {
          var i = 1;
          while (true) {
            var newRow = row + i * direction[0];
            var newCol = col + i * direction[1];
            if (!isInBoard(newRow, newCol)) {
              break;
            }
            if (board[newRow][newCol] != null) {
              if (board[newRow][newCol]!.isWhite != piece.isWhite) {
                candidate_moves.add([newRow, newCol]);
              }
              break;
            }
            candidate_moves.add([newRow, newCol]);
            i++;
          }
        }
        break;

      case chess_pieces_type.king:
        var directions = [
          [-1, 0],
          [1, 0],
          [0, -1],
          [0, 1],
          [-1, -1],
          [-1, 1],
          [1, -1],
          [1, 1],
        ];
        for (var direction in directions) {
          var newRow = row + direction[0];
          var newCol = col + direction[1];
          if (!isInBoard(newRow, newCol)) {
            continue;
          }
          if (board[newRow][newCol] != null) {
            if (board[newRow][newCol]!.isWhite != piece.isWhite) {
              candidate_moves.add([newRow, newCol]);
            }
            continue;
          }
          candidate_moves.add([newRow, newCol]);
        }
        break;

      default:
    }
    return candidate_moves;
  }

  // calculate real valid move
  List<List<int>> calculate_real_valid_moves(
      int row, int col, Chess_Piece? piece, bool check_simulation) {
    List<List<int>> realValidMoves = [];
    List<List<int>> candidateMoves = calculate_raw_valid_moves(row, col, piece);

    // after generating all candidate moves , filter out any that would result in a check
    if (check_simulation) {
      for (var move in candidateMoves) {
        int endRow = move[0];
        int endCol = move[1];

        // this will simulate the future move to see if that safe
        if (simulatedMoveIsSafe(
          piece!,
          row,
          col,
          endRow,
          endCol,
        )) {
          realValidMoves.add(move);
        }
      }
    } else {
      realValidMoves = candidateMoves;
    }
    return realValidMoves;
  }

  void movePiece(int newRow, int newCol) {
    if (board[newRow][newCol] != null) {
      var capturedPiece = board[newRow][newCol];
      if (capturedPiece!.isWhite) {
        whiteDead.add(capturedPiece);
      } else {
        blackDead.add(capturedPiece);
      }
    }
    // check if the piece being moved in a king
    if (selectedPiece!.type == chess_pieces_type.king) {
      // update the appropriate king position
      if (selectedPiece!.isWhite) {
        whiteKingPosition = [newRow, newCol];
      } else {
        blackKingPosition = [newRow, newCol];
      }
    }

    board[newRow][newCol] = selectedPiece;
    board[selectRow][selectCol] = null;

    // if any king is under attack
    if (isKingInCheck(!isWhiteTurn)) {
      checkStatus = true;
    } else {
      checkStatus = false;
    }

    setState(() {
      selectedPiece = null;
      selectRow = -1;
      selectCol = -1;
      validMoves = [];
    });
    // check if it is checkmate
    if (isCheckMate(!isWhiteTurn)) {
      showToast(
        'CHECK MATE!',
        context: context,
        animation: StyledToastAnimation.slideFromLeftFade,
        reverseAnimation: StyledToastAnimation.fade,
        position: StyledToastPosition.center,
        animDuration: Duration(seconds: 1),
        duration: Duration(seconds: 4),
        backgroundColor: Colors.red,
        borderRadius: BorderRadius.circular(35),
        textStyle: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
        curve: Curves.fastLinearToSlowEaseIn,
        reverseCurve: Curves.fastLinearToSlowEaseIn,
      );
    }
    isWhiteTurn = !isWhiteTurn;
  }

  // is king in check
  bool isKingInCheck(bool isWhiteKing) {
    // get position of white king or black king
    List<int> kingPositoin =
        isWhiteKing ? whiteKingPosition : blackKingPosition;
    // check any attack the king
    for (int i = 0; i < 8; i++) {
      for (int j = 0; j < 8; j++) {
        if (board[i][j] == null || board[i][j]!.isWhite == isWhiteKing) {
          continue;
        }
        List<List<int>> pieceValidMove =
            calculate_real_valid_moves(i, j, board[i][j], false);
        // check if the king position is in this pieces valid moves
        if (pieceValidMove.any((move) =>
            move[0] == kingPositoin[0] && move[1] == kingPositoin[1])) {
          return true;
        }
      }
    }
    return false;
  }

  // simulate th future move safe
  bool simulatedMoveIsSafe(
      Chess_Piece? piece, int startRow, int startCol, int endRow, int endCol) {
    Chess_Piece? originalDestinationPiece = board[endRow][endCol];

    List<int>? originalKingPosition;
    if (piece!.type == chess_pieces_type.king) {
      originalKingPosition =
          piece.isWhite ? whiteKingPosition : blackKingPosition;
      if (piece.isWhite) {
        whiteKingPosition = [endRow, endCol];
      } else {
        blackKingPosition = [endRow, endCol];
      }
    }

    board[endRow][endCol] = piece;
    board[startRow][startCol] = null;

    bool kingInCheck = isKingInCheck(piece.isWhite);
    board[startRow][startCol] = piece;
    board[endRow][endCol] = originalDestinationPiece;

    if (piece.type == chess_pieces_type.king) {
      if (piece.isWhite) {
        whiteKingPosition = originalKingPosition!;
      } else {
        blackKingPosition = originalKingPosition!;
      }
    }
    return !kingInCheck;
  }

  // is checkmate
  bool isCheckMate(bool isWhiteKing) {
    if (!isKingInCheck(isWhiteKing)) {
      return false;
    }
    for (int i = 0; i < 8; i++) {
      for (int j = 0; j < 8; j++) {
        if (board[i][j] == null || board[i][j]!.isWhite != isWhiteKing) {
          continue;
        }
        List<List<int>> pieceValidMove =
            calculate_real_valid_moves(i, j, board[i][j], true);
        if (pieceValidMove.isNotEmpty) {
          return false;
        }
      }
    }
    return true;
  }

  // reset the game
  void resetGame() {
    _intializeBoard();
    checkStatus = false;
    blackDead.clear();
    whiteDead.clear();
    whiteKingPosition = [7, 4];
    blackKingPosition = [0, 4];
    isWhiteTurn = true;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: foregroundColor.withOpacity(0.9),
      body: SafeArea(
        top: true,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              children: [
                const Spacer(),
                Padding(
                  padding: const EdgeInsets.only(right: 5),
                  child: IconButton(
                      onPressed: resetGame,
                      icon: Icon(
                        Icons.refresh,
                        size: 40,
                        color: Colors.white.withOpacity(0.7),
                      )),
                ),
              ],
            ),
            Expanded(
              child: GridView.builder(
                  itemCount: whiteDead.length,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 8),
                  itemBuilder: (context, index) => DeadPieces(
                        imagePath: whiteDead[index].imagePath,
                        isWhite: true,
                      )),
            ),
            // game status
            Text(
              checkStatus ? 'CHECK!' : '',
              style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 15,
            ),
            Expanded(
              flex: 3,
              child: GridView.builder(
                  itemCount: 8 * 8,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 8),
                  itemBuilder: (context, index) {
                    // get the row and col
                    int row = index ~/ 8;
                    int col = index % 8;

                    // check is select
                    bool isSelected = selectRow == row && selectCol == col;

                    // check is valid move
                    bool isValidMove = false;
                    for (var position in validMoves) {
                      if (position[0] == row && position[1] == col) {
                        isValidMove = true;
                      }
                    }
                    return square(
                      isWhite: isWhite(index),
                      piece: board[row][col],
                      isSelected: isSelected,
                      isValidMove: isValidMove,
                      onTap: () => pieceSelect(row, col),
                    );
                  }),
            ),
            Expanded(
              child: GridView.builder(
                  itemCount: blackDead.length,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 8),
                  itemBuilder: (context, index) => DeadPieces(
                        imagePath: blackDead[index].imagePath,
                        isWhite: false,
                      )),
            ),
          ],
        ),
      ),
    );
  }
}
