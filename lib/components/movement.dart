class Movement {
  int from;
  int to;
  int blockId;

  Movement({required this.blockId, required this.from, required this.to});

  @override
  String toString() {
    return "Move $blockId From $from To $to";
  }
}

extension StepPrint on List<Movement> {
  String steps() {
    final r = reversed;
    return r.join("\n");
  }
}
