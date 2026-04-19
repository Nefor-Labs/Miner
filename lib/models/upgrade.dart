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
  final String emoji;
  final List<UpgradeLevel> levels;

  const Upgrade({
    required this.type,
    required this.name,
    required this.emoji,
    required this.levels,
  });
}

final shopUpgrades = [
  Upgrade(
    type: UpgradeType.pickaxe,
    name: 'Pickaxe',
    emoji: '⛏',
    levels: [
      UpgradeLevel(
        level: 2,
        title: 'Iron Pickaxe',
        description: '+10% diamond chance',
        costDiamond: 2,
        costIron: 5,
        costCoal: 10,
      ),
      UpgradeLevel(
        level: 3,
        title: 'Gold Pickaxe',
        description: '+20% diamond chance',
        costDiamond: 8,
        costIron: 15,
        costCoal: 20,
      ),
      UpgradeLevel(
        level: 4,
        title: 'Diamond Pickaxe',
        description: '+35% diamond chance',
        costDiamond: 20,
        costIron: 30,
        costCoal: 40,
      ),
      UpgradeLevel(
        level: 5,
        title: 'Mythic Pickaxe',
        description: '+50% diamond chance',
        costDiamond: 50,
        costIron: 60,
        costCoal: 80,
      ),
    ],
  ),
  Upgrade(
    type: UpgradeType.shield,
    name: 'Mine Shield',
    emoji: '🛡',
    levels: [
      UpgradeLevel(
        level: 1,
        title: 'Shield Charge',
        description: '+1 mine protection charge',
        costDiamond: 5,
        costIron: 8,
        costCoal: 15,
      ),
    ],
  ),
  Upgrade(
    type: UpgradeType.multiplier,
    name: 'Reward Boost',
    emoji: '⚡',
    levels: [
      UpgradeLevel(
        level: 2,
        title: 'Boost x2',
        description: 'All resources x2',
        costDiamond: 10,
        costIron: 20,
        costCoal: 30,
      ),
      UpgradeLevel(
        level: 3,
        title: 'Boost x3',
        description: 'All resources x3',
        costDiamond: 30,
        costIron: 50,
        costCoal: 70,
      ),
    ],
  ),
];
