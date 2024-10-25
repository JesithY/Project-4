import 'package:flutter/material.dart';
import 'package:lesson6/controller/game_controller.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:lesson6/model/game_model.dart';
import 'package:lesson6/view/startdispatcher.dart';

class GameRoomScreen extends StatefulWidget {
  final GameModel model;

  const GameRoomScreen({super.key, required this.model});

  @override
  GameRoomState createState() => GameRoomState();
}

class GameRoomState extends State<GameRoomScreen> {
  late GameController controller;
  late GameModel currentModel;

  @override
  void initState() {
    super.initState();
    currentModel = widget.model;
    controller = GameController(currentModel, updateModel);
    controller.startNewGame(); // Generate a new key for a new game.
  }

  void updateModel(GameModel updatedModel) {
    setState(() {
      currentModel = updatedModel;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Game Room'),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            UserAccountsDrawerHeader(
              accountName: const Text('No Profile'),
              accountEmail: Text(currentModel.user.email ?? 'No Email Available'),
              decoration: const BoxDecoration(
                color: Color.fromARGB(255, 78, 132, 177),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Sign Out'),
              onTap: () async {
                Navigator.pop(context); // Close the drawer
                await FirebaseAuth.instance.signOut().then((value) {
                  if (mounted) {
                    Navigator.pushNamedAndRemoveUntil(
                      context,
                      StartDispatcher.routeName,
                      (route) => false,
                    );
                  }
                });
              },
            ),
          ],
        ),
      ),
      // ignore: deprecated_member_use
      body: WillPopScope(
        onWillPop: () => Future.value(false), // Disable back button
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Balance: \$${currentModel.balance}${currentModel.showKey ? ' (Key: ${currentModel.key})' : ''}',
                style: const TextStyle(fontSize: 20),
              ),
              const SizedBox(height: 20),
              Container(
                width: 250,
                height: 250,
                decoration: BoxDecoration(
                  color: Colors.blue,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.black, width: 4),
                ),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Text(
                      currentModel.result.isNotEmpty
                          ? '${currentModel.key}'
                          : '?',
                      style: const TextStyle(
                        fontSize: 150,
                        color: Colors.red,
                      ),
                    ),
                    if (currentModel.result.isNotEmpty)
                      Positioned(
                        top: 100,
                        child: Column(
                          children: currentModel.result
                              .split('\n')
                              .map(
                                (sentence) => Container(
                                  margin:
                                      const EdgeInsets.symmetric(vertical: 2.0),
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8.0, vertical: 4.0),
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                        color: const Color.fromARGB(
                                            255, 215, 232, 38),
                                        width: 1.0),
                                    borderRadius: BorderRadius.circular(4.0),
                                  ),
                                  child: Text(
                                    sentence,
                                    style: const TextStyle(
                                      fontSize: 16,
                                      color: Color.fromARGB(255, 215, 232, 38),
                                    ),
                                    textAlign: TextAlign.start,
                                  ),
                                ),
                              )
                              .toList(),
                        ),
                      ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Show Key:'),
                  Switch(
                    value: currentModel.showKey,
                    onChanged: (value) => controller.toggleKeyVisibility(value),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              buildBettingSection(),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed:
                        currentModel.isPlayEnabled ? controller.startGame : null,
                    child: const Text('Play'),
                  ),
                  ElevatedButton(
                    onPressed: currentModel.isNewGameEnabled
                        ? () {
                            controller.startNewGame();
                          }
                        : null,
                    child: const Text('New Game'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildBettingSection() {
    return Column(
      children: [
        const Text('Bet on even/odd: 2x winnings'),
        Padding(
          padding: const EdgeInsets.only(left: 0.0, right: 16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Row(
                children: [
                  Radio(
                    value: BetType.odd,
                    groupValue: currentModel.selectedBetType,
                    onChanged: currentModel.isBettingDisabled
                        ? null
                        : (value) => controller
                            .chooseBetType(currentModel.parseBetType(value)!),
                  ),
                  const Text('Odd'),
                ],
              ),
              Row(
                children: [
                  Radio(
                    value: BetType.even,
                    groupValue: currentModel.selectedBetType,
                    onChanged: currentModel.isBettingDisabled
                        ? null
                        : (value) => controller
                            .chooseBetType(currentModel.parseBetType(value)!),
                  ),
                  const Text('Even'),
                  const SizedBox(width: 20),
                ],
              ),
              Container(
                color: const Color.fromARGB(255, 194, 227, 241),
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: DropdownButton<int?>(
                  value: currentModel.betAmount,
                  items: const [
                    DropdownMenuItem<int?>(
                        value: null, child: Text('Choose bet amount')),
                    DropdownMenuItem(value: 10, child: Text('\$10')),
                    DropdownMenuItem(value: 20, child: Text('\$20')),
                    DropdownMenuItem(value: 30, child: Text('\$30')),
                  ],
                  onChanged: currentModel.isBettingDisabled
                      ? null
                      : (value) {
                          setState(() {
                            currentModel.betAmount = value;
                            currentModel.isPlayEnabled =
                                currentModel.betAmount != null ||
                                    currentModel.rangeBetAmount != null;
                          });
                        },
                  hint: const Text('Choose bet amount'),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 10),
        const Text('Bet on range: 3x winnings'),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Radio(
              value: BetRange.range1to2,
              groupValue: currentModel.selectedBetRange,
              onChanged: currentModel.isBettingDisabled
                  ? null
                  : (value) => controller
                      .chooseBetRange(currentModel.parseBetRange(value)!),
            ),
            const Text('1-2'),
            Radio(
              value: BetRange.range3to4,
              groupValue: currentModel.selectedBetRange,
              onChanged: currentModel.isBettingDisabled
                  ? null
                  : (value) => controller
                      .chooseBetRange(currentModel.parseBetRange(value)!),
            ),
            const Text('3-4'),
            Radio(
              value: BetRange.range5to6,
              groupValue: currentModel.selectedBetRange,
              onChanged: currentModel.isBettingDisabled
                  ? null
                  : (value) => controller
                      .chooseBetRange(currentModel.parseBetRange(value)!),
            ),
            const Text('5-6'),
          ],
        ),
        const SizedBox(height: 10),
        Container(
          color: const Color.fromARGB(255, 194, 227, 241),
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: DropdownButton<int?>(
            value: currentModel.rangeBetAmount,
            items: const [
              DropdownMenuItem<int?>(
                  value: null, child: Text('Choose bet amount')),
              DropdownMenuItem(value: 10, child: Text('\$10')),
              DropdownMenuItem(value: 20, child: Text('\$20')),
              DropdownMenuItem(value: 30, child: Text('\$30')),
            ],
            onChanged: currentModel.isBettingDisabled
                ? null
                : (value) {
                    setState(() {
                      currentModel.rangeBetAmount = value;
                      currentModel.isPlayEnabled =
                          currentModel.betAmount != null ||
                              currentModel.rangeBetAmount != null;
                    });
                  },
            hint: const Text('Choose bet amount'),
          ),
        ),
      ],
    );
  }
}