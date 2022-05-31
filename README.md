The `mrx_icon_font_gen` package can be used to generate an icon font from a directory of SVG files.
The font is created using a [FlutterIcon][] tool, and thus, it requires
an Internet connection to work. Generated files can be used to further customize the font file using
the FlutterIcon web tool.

* [Installation](#installation)
* [Usage](#usage)
    * [Command Line Options](#command-line-options)
    * [Outputs](#outputs)

## Installation

This package is intended to create an icon font and associated Dart class with
[IconData][] objects ready to use in an
application. 

You can install it using the command below:

```shell
dart pub global activate mrx_icon_font_gen
```

## Usage

The `mrx_icon_font_gen` package provides a binary by the same name, which can generate all required files
using `create` command: `dart pub global run mrx_icon_font_gen create`. It will generate three files, one of which
will be the icon font in the TTF format. The font itself needs to be added to application fonts in
[`pubspec.yaml`][pubspec]. Using default values, it would be:

```yaml
flutter:
  fonts:
    - family: AppIcons # Use the same name as the "--class-name" option value
      fonts:
        - asset: assets/fonts/AppIcons.ttf
```

---
**WARNING**

Subsequent executions of `mrx_icon_font_gen create` will discard previously created files. Currently, you
can modify your icon font only using [FlutterIcon][] web interface.

---

### Command Line Options

The command supports the following options:

- `--help`
  
  Print usage information for the command.

- `--from`
  
  Path to a directory containing SVG files that should be enclosed in the generated font
  file. The directory will be scanned recursively and all files with an `*.svg` extension will be
  added to the result. By default, the current directory will be searched.
  
  Each file is expected to have at least one `<path>` element containing the glyph description. In
  case of multiple `<path>` elements, only the first one appearing in the file will be processed.

- `--class-name`
  
  The name of the Dart class that will contain
  [IconData][] objects ready to be used
  in [Icon][] widgets. It should be a valid
  Dart class name. It is also used as a name of generated font file. The default value is
  `AppIcons`.

- `--out-font`
  
  The path to a directory, where the font file will be saved. The `--class-name`
  option value will be used as the name of the file. Remember, to add the generated font to your
  app's fonts in [`pubspec.yaml`][pubspec]. Defaults to `assets/fonts/`.

- `--out-flutter`
  
  The path to a directory, where the class containing
  [IconData][] objects will be stored.
  Each SVG will have a corresponding field with a name derived from the file path.

- `--out-config`
  
  The location, where the FlutterIcon-compatible configuration file will be stored.
  The file can be used to further customize the font. Defaults to `lib/config/font/`.

### Outputs

For the following file structure:

```
project_root_directory
└───assets
    └───images
        └───logo.svg
        └───bottom_bar
            └───home.svg
```

Running the command with default options will result in creation of following files:

- `project_root_directory/assets/fonts/AppIcons.ttf`

  A TTF font generated by [FlutterIcon][].

- `project_root_directory/assets/fonts/config/config.json`

  A configuration file containing normalized glyph information. It can be uploaded to
  [FlutterIcon][] for further customization.

- `project_root_directory/lib/config/font/app_icons.dart`

  A Dart class with all glyph definitions. It contains a field for each SVG file. The field name is
  derived from the file's path relative to the `--from` option path. Slight modifications to the
  name are made to remove illegal characters, and replace spaces and directory separators with
  underscores. Names starting with a digit or an underscore are prefixed with letter `i`. If a name
  consists only of illegal characters, it will be replaced with`icon`. An incremental number is
  appended to duplicated names, or names equal to any of the reserved keywords.
  
  The generated class will look like this:
  
```dart
import 'package:flutter/widgets.dart';

class AppIcons {
  AppIcons._();

  static const _kFontFam = 'AppIcons';
  static const String? _kFontPkg = null;

  //                     Notice, how "home" icon name is affected by being
  //                     placed inside a "bottom_bar" directory.
  static const IconData bottom_bar_home = IconData(0xe800, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData logo = IconData(0xe801, fontFamily: _kFontFam, fontPackage: _kFontPkg); 
}
```

[dev_dependencies]: https://dart.dev/tools/pub/dependencies#dev-dependencies
[pubspec]: https://dart.dev/tools/pub/pubspec

[Icon]: https://api.flutter.dev/flutter/widgets/Icon-class.html
[IconData]: https://api.flutter.dev/flutter/widgets/IconData-class.html

[FlutterIcon]: https://www.fluttericon.com/