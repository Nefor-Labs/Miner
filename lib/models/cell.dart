import 'resource_type.dart';

class Cell {
  final int index;
  final ResourceType type;
  bool isRevealed;
  bool isAnimating;

  Cell({
    required this.index,
    required this.type,
    this.isRevealed = false,
    this.isAnimating = false,
  });

  Cell copyWith({
    bool? isRevealed,
    bool? isAnimating,
  }) {
    return Cell(
      index: index,
      type: type,
      isRevealed: isRevealed ?? this.isRevealed,
      isAnimating: isAnimating ?? this.isAnimating,
    );
  }
}
