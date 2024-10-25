import 'package:firebase_auth/firebase_auth.dart';

enum BetType { odd, even }

enum BetRange { range1to2, range3to4, range5to6 }

class GameModel {
  int balance;
  int key;
  bool showKey;
  BetType? selectedBetType;
  BetRange? selectedBetRange;
  int? betAmount;
  int? rangeBetAmount;
  bool isPlayEnabled;
  bool isNewGameEnabled;
  bool isBettingDisabled;
  String result;
  User user;

  GameModel({
    required this.user,
    this.balance = 100,
    this.key = 0,
    this.showKey = false,
    this.selectedBetType,
    this.selectedBetRange,
    this.betAmount,
    this.rangeBetAmount,
    this.isPlayEnabled = false,
    this.isNewGameEnabled = false,
    this.isBettingDisabled = false,
    this.result = '',
  });

  void reset() {
    key = 0;
    showKey = false;
    selectedBetType = null;
    selectedBetRange = null;
    betAmount = null;
    rangeBetAmount = null;
    isPlayEnabled = false;
    isNewGameEnabled = false;
    isBettingDisabled = false;
    result = '';
  }

  BetType? parseBetType(Object? value) {
    if (value is BetType) {
      return value;
    }
    return null;
  }

  BetRange? parseBetRange(Object? value) {
    if (value is BetRange) {
      return value;
    }
    return null;
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
