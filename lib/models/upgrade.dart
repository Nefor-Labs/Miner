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
      UpgradeLevel(
        level: 6,
        title: 'Рунная кирка',
        description: '+65% шанс алмаза',
        costDiamond: 100,
        costIron: 120,
        costCoal: 160,
      ),
      UpgradeLevel(
        level: 7,
        title: 'Кирка Духа',
        description: '+80% шанс алмаза',
        costDiamond: 200,
        costIron: 240,
        costCoal: 320,
      ),
      UpgradeLevel(
        level: 8,
        title: 'Небесная кирка',
        description: 'Алмазов почти вдвое больше',
        costDiamond: 350,
        costIron: 400,
        costCoal: 550,
      ),
      UpgradeLevel(
        level: 9,
        title: 'Кирка Грома',
        description: 'Редкие руды открываются чаще',
        costDiamond: 600,
        costIron: 700,
        costCoal: 900,
      ),
      UpgradeLevel(
        level: 10,
        title: 'Легендарная кирка',
        description: 'Мастер горного дела',
        costDiamond: 1000,
        costIron: 1200,
        costCoal: 1500,
      ),
      UpgradeLevel(
        level: 11,
        title: 'Кирка Вечности',
        description: 'Алмазы как уголь',
        costDiamond: 1800,
        costIron: 2000,
        costCoal: 2500,
      ),
      UpgradeLevel(
        level: 12,
        title: 'Кирка Хаоса',
        description: 'Хаос обращается в богатство',
        costDiamond: 3000,
        costIron: 3500,
        costCoal: 4500,
      ),
      UpgradeLevel(
        level: 13,
        title: 'Кирка Дракона',
        description: 'Каждый удар — алмаз',
        costDiamond: 5000,
        costIron: 6000,
        costCoal: 7500,
      ),
      UpgradeLevel(
        level: 14,
        title: 'Кирка Богов',
        description: 'Боги завидуют вашей добыче',
        costDiamond: 8000,
        costIron: 10000,
        costCoal: 13000,
      ),
      UpgradeLevel(
        level: 15,
        title: 'Кирка Абсолюта',
        description: 'Абсолютный контроль над шахтой',
        costDiamond: 15000,
        costIron: 18000,
        costCoal: 25000,
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
