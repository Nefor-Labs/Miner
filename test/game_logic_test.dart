import 'package:flutter_test/flutter_test.dart';
import 'package:miner_game/models/resource_type.dart';

void main() {
  group('ResourceType', () {
    test('diamond has highest base value', () {
      expect(ResourceType.diamond.baseValue,
          greaterThan(ResourceType.iron.baseValue));
      expect(ResourceType.iron.baseValue,
          greaterThan(ResourceType.coal.baseValue));
      expect(ResourceType.mine.baseValue, equals(0));
    });

    test('all types have emoji', () {
      for (final type in ResourceType.values) {
        expect(type.emoji.isNotEmpty, isTrue);
      }
    });
  });
}
