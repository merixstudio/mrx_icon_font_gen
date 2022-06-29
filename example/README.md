#mrx_icon_font_gen

This example project uses icon font generated from SVG files from the `assets/images` directory.
It renders a chessboard using chess piece icons from the FontAwesome project.

To generate all necessary files, the following command was used:

`mrx_icon_font_gen --from assets/images --class-name=ChessIcons`

It produced three files:
* `lib/config/font/chess_icons.dart` - a Dart file containing IconData objects used by the Icon
  widget
* `assets/fonts/config/config.json` - a FlutterIcon configuration file, which can be further
  used with a https://fluttericon.com tool
* `assets/fonts/ChessIcons.ttf` - a font file containing all glyphs found in an input directory,
  in this case `assets/images`.
