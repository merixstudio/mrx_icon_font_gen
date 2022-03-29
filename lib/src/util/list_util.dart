extension ListUtil on List {
  Iterable flatten() => _flatten(this);

  Iterable _flatten(Iterable iterable) =>
      iterable.expand((e) => e is List ? _flatten(e) : [e]);
}
