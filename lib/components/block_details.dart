class BlockDetails {
  int blockId;
  double left;
  double top;
  double width;
  double height;
  int towerPosition;
  BlockDetails(
      {required this.height,
      required this.left,
      required this.top,
      required this.width,
      required this.blockId,
      this.towerPosition = 0});
}
