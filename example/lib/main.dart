import 'package:flutter/material.dart';
import 'package:mrx_icon_font_gen_example/config/font/chess_icons.dart';

/// This example project uses icon font generated from SVG files from the `assets/images` directory.
/// It renders a chessboard using chess piece icons from the FontAwesome project.
///
/// To generate all necessary files, the following command was used:
///
/// `mrx_icon_font_gen --from assets/images --class-name=ChessIcons`
///
/// It produced three files:
/// * `lib/config/font/chess_icons.dart` - a Dart file containing IconData objects used by the Icon
///   widget
/// * `assets/fonts/config/config.json` - a FlutterIcon configuration file, which can be further
///   used with a https://fluttericon.com tool
/// * `assets/fonts/ChessIcons.ttf` - a font file containing all glyphs found in an input directory,
///   in this case `assets/images`.

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'mrx_icon_font_gen Demo',
      theme: ThemeData(
        primarySwatch: Colors.orange,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage();

  static const lightTileColor = Colors.orange;
  static const darkTileColor = Colors.brown;
  static const blackPieceColor = Colors.black;
  static const whitePieceColor = Colors.white;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('mrx_icon_font_gen Demo'),
        leading: Icon(ChessIcons.chess_solid),
      ),
      body: Center(
        child: Table(
          children: [
            _buildBackPiecesRow(isEven: true, color: blackPieceColor),
            _buildPawnsRow(isEven: false, color: blackPieceColor),
            ...List<TableRow>.generate(
                4, (i) => _buildEmptyRow(isEven: i.isEven)),
            _buildPawnsRow(isEven: true, color: whitePieceColor),
            _buildBackPiecesRow(isEven: false, color: whitePieceColor),
          ],
        ),
      ),
    );
  }

  TableRow _buildBackPiecesRow({
    required bool isEven,
    required Color color,
  }) {
    return TableRow(
      children: [
        TableCell(
          child: AspectRatio(
            aspectRatio: 1.0,
            child: Container(
              color: isEven ? lightTileColor : darkTileColor,
              child: Center(
                child: Icon(
                  ChessIcons.pieces_chess_rook_solid,
                  color: color,
                ),
              ),
            ),
          ),
        ),
        TableCell(
          child: AspectRatio(
            aspectRatio: 1.0,
            child: Container(
              color: isEven ? darkTileColor : lightTileColor,
              child: Icon(
                ChessIcons.pieces_chess_knight_solid,
                color: color,
              ),
            ),
          ),
        ),
        TableCell(
          child: AspectRatio(
            aspectRatio: 1.0,
            child: Container(
              color: isEven ? lightTileColor : darkTileColor,
              child: Icon(
                ChessIcons.pieces_chess_bishop_solid,
                color: color,
              ),
            ),
          ),
        ),
        TableCell(
          child: AspectRatio(
            aspectRatio: 1.0,
            child: Container(
              color: isEven ? darkTileColor : lightTileColor,
              child: Icon(
                ChessIcons.pieces_chess_queen_solid,
                color: color,
              ),
            ),
          ),
        ),
        TableCell(
          child: AspectRatio(
            aspectRatio: 1.0,
            child: Container(
              color: isEven ? lightTileColor : darkTileColor,
              child: Icon(
                ChessIcons.pieces_chess_king_solid,
                color: color,
              ),
            ),
          ),
        ),
        TableCell(
          child: AspectRatio(
            aspectRatio: 1.0,
            child: Container(
              color: isEven ? darkTileColor : lightTileColor,
              child: Icon(
                ChessIcons.pieces_chess_bishop_solid,
                color: color,
              ),
            ),
          ),
        ),
        TableCell(
          child: AspectRatio(
            aspectRatio: 1.0,
            child: Container(
              color: isEven ? lightTileColor : darkTileColor,
              child: Icon(
                ChessIcons.pieces_chess_knight_solid,
                color: color,
              ),
            ),
          ),
        ),
        TableCell(
          child: AspectRatio(
            aspectRatio: 1.0,
            child: Container(
              color: isEven ? darkTileColor : lightTileColor,
              child: Icon(
                ChessIcons.pieces_chess_rook_solid,
                color: color,
              ),
            ),
          ),
        ),
      ],
    );
  }

  TableRow _buildPawnsRow({
    required bool isEven,
    required Color color,
  }) {
    return TableRow(
      children: List<TableCell>.generate(
          8,
          (i) => TableCell(
                child: AspectRatio(
                  aspectRatio: 1.0,
                  child: Container(
                    color:
                        (isEven == i.isEven) ? lightTileColor : darkTileColor,
                    child: Icon(
                      ChessIcons.pieces_chess_pawn_solid,
                      color: color,
                    ),
                  ),
                ),
              )),
    );
  }

  TableRow _buildEmptyRow({
    required bool isEven,
  }) {
    return TableRow(
      children: List<TableCell>.generate(
          8,
          (i) => TableCell(
                child: AspectRatio(
                  aspectRatio: 1.0,
                  child: Container(
                    color:
                        (isEven == i.isEven) ? lightTileColor : darkTileColor,
                  ),
                ),
              )),
    );
  }
}
