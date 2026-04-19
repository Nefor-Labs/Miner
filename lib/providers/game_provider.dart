import 'dart:math';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/cell.dart';
import '../models/resource_type.dart';
import 'player_provider.dart';

enum GameStatus { idle, playing, won, lost }

class GameState {
  final List<Cell> cells;
  final GameStatus status;
  final int roundDiamonds;
  final int roundIron;
  final int roundCoal;
  final bool shieldUsedThisRound;
  final String? message;

  const GameState({
    required this.cells,
    this.status = GameStatus.idle,
    this.roundDiamonds = 0,
    this.roundIron = 0,
    this.roundCoal = 0,
    this.shieldUsedThisRound = false,
    this.message,
  });

  int get roundScore =>
      roundDiamonds * 10 + roundIron * 3 + roundCoal * 1;

  bool get isActive => status == GameStatus.playing;

  GameState copyWith({
    List<Cell>? cells,
    GameStatus? status,
    int? roundDiamonds,
    int? roundIron,
    int? roundCoal,
    bool? shieldUsedThisRound,
    String? message,
  }) {
    return GameState(
      cells: cells ?? this.cells,
      status: status ?? this.status,
      roundDiamonds: roundDiamonds ?? this.roundDiamonds,
      roundIron: roundIron ?? this.roundIron,
      roundCoal: roundCoal ?? this.roundCoal,
      shieldUsedThisRound: shieldUsedThisRound ?? this.shieldUsedThisRound,
      message: message,
    );
  }
}

class GameNotifier extends Notifier<GameState> {
  static const int gridSize = 25;
  final _rng = Random();

  @override
  GameState build() => GameState(cells: _generateCells(1));

  List<Cell> _generateCells(int pickaxeLevel) {
    // Base weights: coal=40, iron=30, diamond=10, mine=20
    // Each pickaxe level shifts 5% from coal to diamond
    final int extraDiamond = (pickaxeLevel - 1) * 5;
    final int diamondWeight = 10 + extraDiamond;
    final int coalWeight = max(10, 40 - extraDiamond);

    final weights = <ResourceType, int>{
      ResourceType.coal: coalWeight,
      ResourceType.iron: 30,
      ResourceType.diamond: diamondWeight,
      ResourceType.mine: 20,
    };

    final pool = <ResourceType>[];
    weights.forEach((type, weight) {
      for (var i = 0; i < weight; i++) {
        pool.add(type);
      }
    });

    final picked = <ResourceType>[];
    for (var i = 0; i < gridSize; i++) {
      picked.add(pool[_rng.nextInt(pool.length)]);
    }

    return List.generate(
      gridSize,
      (i) => Cell(index: i, type: picked[i]),
    );
  }

  void startNewGame() {
    final pickaxeLevel =
        ref.read(playerProvider).pickaxeLevel;
    state = GameState(
      cells: _generateCells(pickaxeLevel),
      status: GameStatus.playing,
    );
  }

  void revealCell(int index) {
    if (state.status != GameStatus.playing) return;
    final cell = state.cells[index];
    if (cell.isRevealed) return;

    final updatedCells = List<Cell>.from(state.cells);
    updatedCells[index] = cell.copyWith(isRevealed: true);

    if (cell.type == ResourceType.mine) {
      final player = ref.read(playerProvider);
      // Try to use shield
      if (player.shieldCharges > 0 && !state.shieldUsedThisRound) {
        ref.read(playerProvider.notifier).useShieldCharge();
        state = state.copyWith(
          cells: updatedCells,
          shieldUsedThisRound: true,
          message: '🛡 Shield activated! Mine defused!',
        );
        return;
      }
      // Game lost — reveal all cells
      final revealedAll = updatedCells
          .map((c) => c.copyWith(isRevealed: true))
          .toList();
      ref.read(playerProvider.notifier).recordGame(roundScore: 0);
      state = state.copyWith(
        cells: revealedAll,
        status: GameStatus.lost,
        message: '💥 BOOM! You hit a mine!',
      );
      return;
    }

    int d = state.roundDiamonds;
    int ir = state.roundIron;
    int co = state.roundCoal;

    switch (cell.type) {
      case ResourceType.diamond:
        d++;
        break;
      case ResourceType.iron:
        ir++;
        break;
      case ResourceType.coal:
        co++;
        break;
      default:
        break;
    }

    // Check if all non-mine cells revealed
    final nonMines =
        updatedCells.where((c) => c.type != ResourceType.mine);
    final allRevealed = nonMines.every((c) => c.isRevealed);

    if (allRevealed) {
      ref.read(playerProvider.notifier).addResources(
            diamonds: d,
            iron: ir,
            coal: co,
          );
      final score = d * 10 + ir * 3 + co * 1;
      ref.read(playerProvider.notifier).recordGame(roundScore: score);
      final revealedAll = updatedCells
          .map((c) => c.copyWith(isRevealed: true))
          .toList();
      state = state.copyWith(
        cells: revealedAll,
        status: GameStatus.won,
        roundDiamonds: d,
        roundIron: ir,
        roundCoal: co,
        message: '🏆 Field cleared! Awesome!',
      );
      return;
    }

    state = state.copyWith(
      cells: updatedCells,
      roundDiamonds: d,
      roundIron: ir,
      roundCoal: co,
      message: null,
    );
  }

  void cashOut() {
    if (state.status != GameStatus.playing) return;
    final d = state.roundDiamonds;
    final ir = state.roundIron;
    final co = state.roundCoal;

    if (d + ir + co == 0) return;

    ref.read(playerProvider.notifier).addResources(
          diamonds: d,
          iron: ir,
          coal: co,
        );
    final score = d * 10 + ir * 3 + co * 1;
    ref.read(playerProvider.notifier).recordGame(roundScore: score);

    final revealedAll =
        state.cells.map((c) => c.copyWith(isRevealed: true)).toList();
    state = state.copyWith(
      cells: revealedAll,
      status: GameStatus.won,
      message: '💰 Cashed out!',
    );
  }
}

final gameProvider = NotifierProvider<GameNotifier, GameState>(
  GameNotifier.new,
);
