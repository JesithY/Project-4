import 'package:lesson6/model/game_model.dart';
import 'dart:math';

class GameController {
  final Function(GameModel) onUpdate;
  GameModel model;

  GameController(this.model, this.onUpdate) {
    model.selectedBetType = BetType.odd;
    model.selectedBetRange = BetRange.range1to2;
    _enablePlayButtonIfNeeded();
  }

  void toggleShowKey(bool value) {
    model.showKey = value;
    onUpdate(model);
  }

  void selectBetType(BetType betType) {
    model.selectedBetType = betType;
    _enablePlayButtonIfNeeded();
  }

  void selectBetRange(BetRange betRange) {
    model.selectedBetRange = betRange;
    _enablePlayButtonIfNeeded();
  }

  void selectBetAmount(int amount) {
    model.betAmount = amount;
    _enablePlayButtonIfNeeded();
  }

  void selectRangeBetAmount(int amount) {
    model.rangeBetAmount = amount;
    _enablePlayButtonIfNeeded();
  }

  void playGame() {
    String resultMessage = '';
    if (model.selectedBetType != null && model.betAmount != null) {
      if ((model.key % 2 == 0 && model.selectedBetType == BetType.even) ||
          (model.key % 2 != 0 && model.selectedBetType == BetType.odd)) {
        model.balance += model.betAmount! * 2;
        resultMessage += 'You won on ${model.selectedBetType == BetType.even ? 'even' : 'odd'}: +\$${model.betAmount! * 2}\n';
      } else {
        model.balance -= model.betAmount!;
        resultMessage += 'You lost on ${model.selectedBetType == BetType.even ? 'even' : 'odd'}: -\$${model.betAmount!}\n';
      }
    } else {
      resultMessage += 'No bet on even/odd\n';
    }

    if (model.selectedBetRange != null && model.rangeBetAmount != null) {
      if ((model.selectedBetRange == BetRange.range1to2 && model.key >= 1 && model.key <= 2) ||
          (model.selectedBetRange == BetRange.range3to4 && model.key >= 3 && model.key <= 4) ||
          (model.selectedBetRange == BetRange.range5to6 && model.key >= 5 && model.key <= 6)) {
        model.balance += model.rangeBetAmount! * 3;
        resultMessage += 'You won on ${model.selectedBetRange!.label}: +\$${model.rangeBetAmount! * 3}';
      } else {
        model.balance -= model.rangeBetAmount!;
        resultMessage += 'You lost on ${model.selectedBetRange!.label}: -\$${model.rangeBetAmount!}';
      }
    } else {
      resultMessage += 'No bet on range';
    }

    model.result = resultMessage;
    model.isNewGameEnabled = true;
    model.isBettingDisabled = true;
    model.isPlayEnabled = false;
    onUpdate(model);
  }

  void newGame() {
    bool previousShowKey = model.showKey; // Preserve showKey state
    model.reset();
    model.key = Random().nextInt(6) + 1; // Generate a new key between 1 and 6, inclusive
    model.selectedBetType = BetType.odd;
    model.selectedBetRange = BetRange.range1to2;
    model.showKey = previousShowKey; // Restore showKey state
    onUpdate(model);
  }

  void _enablePlayButtonIfNeeded() {
    if ((model.selectedBetType != null && model.betAmount != null) ||
        (model.selectedBetRange != null && model.rangeBetAmount != null)) {
      model.isPlayEnabled = true;
    } else {
      model.isPlayEnabled = false;
    }
    onUpdate(model);
  }
}

extension BetRangeLabel on BetRange {
  String get label {
    switch (this) {
      case BetRange.range1to2:
        return '1-2';
      case BetRange.range3to4:
        return '3-4';
      case BetRange.range5to6:
        return '5-6';
    }
  }
}
