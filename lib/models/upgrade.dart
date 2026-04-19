enum UpgradeType { pickaxe, shield, multiplier }

class UpgradeLevel {
  final int level;
  final String title;
  final String description;
  final int costDiamond;
  final int costIron;
  final int costCoal;

  const UpgradeLevel({
    required this.level,
    required this.title,
    required this.description,
    required this.costDiamond,
    required this.costIron,
    required this.costCoal,
  });
}

class Upgrade {
  final UpgradeType type;
  final String name;
  final List<UpgradeLevel> levels;

  const Upgrade({
    required this.type,
    required this.name,
    required this.levels,
  });
}

final shopUpgrades = [
  Upgrade(
    type: UpgradeType.pickaxe,
    name: 'Кирка',
    levels: [
      UpgradeLevel(
        level: 2,
        title: 'Железная кирка',
        description: '+10% шанс алмаза',
        costDiamond: 2,
        costIron: 5,
        costCoal: 10,
      ),
      UpgradeLevel(
        level: 3,
        title: 'Золотая кирка',
        description: '+20% шанс алмаза',
        costDiamond: 8,
        costIron: 15,
        costCoal: 20,
      ),
      UpgradeLevel(
        level: 4,
        title: 'Алмазная кирка',
        description: '+35% шанс алмаза',
        costDiamond: 20,
        costIron: 30,
        costCoal: 40,
      ),
      UpgradeLevel(
        level: 5,
        title: 'Мифическая кирка',
        description: '+50% шанс алмаза',
        costDiamond: 50,
        costIron: 60,
        costCoal: 80,
      ),
    ],
  ),
  Upgrade(
    type: UpgradeType.shield,
    name: 'Щит от мин',
    levels: [
      UpgradeLevel(
        level: 1,
        title: 'Заряд щита',
        description: '+1 защита от мины',
        costDiamond: 5,
        costIron: 8,
        costCoal: 15,
      ),
    ],
  ),
  Upgrade(
    type: UpgradeType.multiplier,
    name: 'Усиление наград',
    levels: [
      UpgradeLevel(
        level: 2,
        title: 'Буст x2',
        description: 'Все ресурсы x2',
        costDiamond: 10,
        costIron: 20,
        costCoal: 30,
      ),
      UpgradeLevel(
        level: 3,
        title: 'Буст x3',
        description: 'Все ресурсы x3',
        costDiamond: 30,
        costIron: 50,
        costCoal: 70,
      ),
    ],
  ),
];
