enum ResourceType { diamond, iron, coal, mine }

extension ResourceTypeExt on ResourceType {
  String get emoji {
    switch (this) {
      case ResourceType.diamond:
        return '💎';
      case ResourceType.iron:
        return '🪨';
      case ResourceType.coal:
        return '⬛';
      case ResourceType.mine:
        return '💣';
    }
  }

  String get label {
    switch (this) {
      case ResourceType.diamond:
        return 'Diamond';
      case ResourceType.iron:
        return 'Iron';
      case ResourceType.coal:
        return 'Coal';
      case ResourceType.mine:
        return 'Mine';
    }
  }

  int get baseValue {
    switch (this) {
      case ResourceType.diamond:
        return 10;
      case ResourceType.iron:
        return 3;
      case ResourceType.coal:
        return 1;
      case ResourceType.mine:
        return 0;
    }
  }
}
