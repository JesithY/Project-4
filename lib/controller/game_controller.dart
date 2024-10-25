import 'package:lesson6/model/game_model.dart';
import 'dart:math';

class GameController {
  final Function(GameModel) updateModel;
  GameModel gameModel;

  GameController(this.gameModel, this.updateModel) {
    gameModel.selectedBetType = BetType.odd;
    gameModel.selectedBetRange = BetRange.range1to2;
    checkPlayButtonStatus();
  }

  void toggleKeyVisibility(bool value) {
    gameModel.showKey = value;
    updateModel(gameModel);
  }

  void chooseBetType(BetType betType) {
    gameModel.selectedBetType = betType;
    checkPlayButtonStatus();
    updateModel(gameModel);
  }

  void chooseBetRange(BetRange betRange) {
    gameModel.selectedBetRange = betRange;
    checkPlayButtonStatus();
    updateModel(gameModel);
  }

  void setBetAmount(int amount) {
    gameModel.betAmount = amount;
    checkPlayButtonStatus();
    updateModel(gameModel);
  }

  void setRangeBetAmount(int amount) {
    gameModel.rangeBetAmount = amount;
    checkPlayButtonStatus();
    updateModel(gameModel);
  }

  void startGame() {
    String message = '';
    if (gameModel.selectedBetType != null && gameModel.betAmount != null) {
      if ((gameModel.key % 2 == 0 &&
              gameModel.selectedBetType == BetType.even) ||
          (gameModel.key % 2 != 0 &&
              gameModel.selectedBetType == BetType.odd)) {
        gameModel.balance += gameModel.betAmount! * 2;
        message +=
            'You won on ${gameModel.selectedBetType == BetType.even ? 'even' : 'odd'}: +\$${gameModel.betAmount! * 2}\n';
      } else {
        gameModel.balance -= gameModel.betAmount!;
        message +=
            'You lost on ${gameModel.selectedBetType == BetType.even ? 'even' : 'odd'}: -\$${gameModel.betAmount!}\n';
      }
    } else {
      message += 'No bet on even/odd\n';
    }

    if (gameModel.selectedBetRange != null &&
        gameModel.rangeBetAmount != null) {
      if ((gameModel.selectedBetRange == BetRange.range1to2 &&
              gameModel.key >= 1 &&
              gameModel.key <= 2) ||
          (gameModel.selectedBetRange == BetRange.range3to4 &&
              gameModel.key >= 3 &&
              gameModel.key <= 4) ||
          (gameModel.selectedBetRange == BetRange.range5to6 &&
              gameModel.key >= 5 &&
              gameModel.key <= 6)) {
        gameModel.balance += gameModel.rangeBetAmount! * 3;
        message +=
            'You won on ${gameModel.selectedBetRange!.label}: +\$${gameModel.rangeBetAmount! * 3}';
      } else {
        gameModel.balance -= gameModel.rangeBetAmount!;
        message +=
            'You lost on ${gameModel.selectedBetRange!.label}: -\$${gameModel.rangeBetAmount!}';
      }
    } else {
      message += 'No bet on range';
    }

    gameModel.result = message;
    gameModel.isNewGameEnabled = true;
    gameModel.isBettingDisabled = true;
    gameModel.isPlayEnabled = false;
    updateModel(gameModel);
  }

  void startNewGame() {
    bool keepKeyVisible = gameModel.showKey;
    int previousKey = gameModel.key;

    int newKey;
    do {
      newKey = Random().nextInt(6) + 1;
    } while (newKey == previousKey);

    gameModel.reset();
    gameModel.key = newKey;
    gameModel.selectedBetType = BetType.odd;
    gameModel.selectedBetRange = BetRange.range1to2;
    gameModel.showKey = keepKeyVisible;
    updateModel(gameModel);
  }

  void checkPlayButtonStatus() {
    if ((gameModel.selectedBetType != null && gameModel.betAmount != null) ||
        (gameModel.selectedBetRange != null &&
            gameModel.rangeBetAmount != null)) {
      gameModel.isPlayEnabled = true;
    } else {
      gameModel.isPlayEnabled = false;
    }
  }
}
