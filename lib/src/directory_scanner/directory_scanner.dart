import 'dart:async';
import 'dart:io';

class DirectoryScanner {
  final String path;

  DirectoryScanner({
    this.path = '.',
  });

  Future<List<File>> scanPath({String pattern = r'\.svg$'}) async {
    final FileSystemEntityType entityType = FileSystemEntity.typeSync(path);
    switch (entityType) {
      case FileSystemEntityType.directory:
        return scanDir(Directory(path), pattern);
      case FileSystemEntityType.file:
        return [
          File(path),
        ];
      default:
        return [];
    }
  }

  Future<List<File>> scanDir(Directory dir, String pattern) {
    final Completer<List<File>> completer = Completer<List<File>>();
    final Stream<FileSystemEntity> lister = dir.list(recursive: true);
    final RegExp filter = RegExp(
      pattern,
      caseSensitive: false,
    );
    final List<File> files = [];
    lister.listen(
      (FileSystemEntity file) {
        if (file is! File || !filter.hasMatch(file.path)) {
          return;
        }
        files.add(file);
      },
      onError: (error) => print(error),
      onDone: () => completer.complete(files),
    );
    return completer.future;
  }
}
