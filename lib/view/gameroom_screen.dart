// import 'package:flutter/material.dart';
// import 'package:lesson6/controller/game_controller.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:lesson6/model/game_model.dart';
// import 'package:lesson6/view/startdispatcher.dart';

// // ignore: must_be_immutable
// class GameRoomScreen extends StatefulWidget {
//   GameModel model;

//   GameRoomScreen({super.key, required this.model});

//   @override
//   GameRoomState createState() => GameRoomState();
// }

// class GameRoomState extends State<GameRoomScreen> {
//   late GameController controller;

//   @override
//   void initState() {
//     super.initState();
//     controller = GameController(widget.model, _updateModel);
//     controller.newGame(); // Generate a new key for a new game.
//   }

//   void _updateModel(GameModel updatedModel) {
//     setState(() {
//       widget.model = updatedModel;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Game Room'),
//       ),
//       drawer: Drawer(
//         child: ListView(
//           padding: EdgeInsets.zero,
//           children: <Widget>[
//             UserAccountsDrawerHeader(
//               accountName: const Text('No Profile'),
//               accountEmail:
//                   Text(widget.model.user.email ?? 'No Email Available'),
//               decoration: const BoxDecoration(
//                 color: Color.fromARGB(255, 78, 132, 177),
//               ),
//             ),
//             ListTile(
//               leading: const Icon(Icons.logout),
//               title: const Text('Sign Out'),
//               onTap: () async {
//                 Navigator.pop(context); // Close the drawer
//                 await FirebaseAuth.instance.signOut().then((value) {
//                   if (mounted) {
//                     Navigator.pushNamedAndRemoveUntil(
//                       context,
//                       StartDispatcher.routeName,
//                       (route) => false,
//                     );
//                   }
//                 }); // Navigate to sign-in screen
//               },
//             ),
//           ],
//         ),
//       ),
//       // ignore: deprecated_member_use
//       body: WillPopScope(
//         onWillPop: () => Future.value(false), // Disable back button
//         child: Center(
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               Text(
//                 'Balance: \$${widget.model.balance}${widget.model.showKey ? ' (Key: ${widget.model.key})' : ''}',
//                 style: const TextStyle(fontSize: 20),
//               ),
//               const SizedBox(height: 20),
//               Container(
//                 width: 250,
//                 height: 250,
//                 decoration: BoxDecoration(
//                   color: Colors.blue,
//                   shape: BoxShape.circle,
//                   border: Border.all(color: Colors.black, width: 4),
//                 ),
//                 child: Center(
//                   child: Text(
//                     widget.model.result,
//                     style: const TextStyle(fontSize: 16, color: Colors.yellow),
//                     textAlign: TextAlign.center,
//                   ),
//                 ),
//               ),
//               const SizedBox(height: 8),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   const Text('Show Key:'),
//                   Switch(
//                     value: widget.model.showKey,
//                     onChanged: (value) => controller.toggleShowKey(value),
//                   ),
//                 ],
//               ),
//               const SizedBox(height: 10),
//               _buildBettingSection(),
//               const SizedBox(height: 20),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                 children: [
//                   ElevatedButton(
//                     onPressed:
//                         widget.model.isPlayEnabled ? controller.playGame : null,
//                     child: const Text('Play'),
//                   ),
//                   ElevatedButton(
//                     onPressed: widget.model.isNewGameEnabled
//                         ? () {
//                             controller.newGame();
//                           }
//                         : null,
//                     child: const Text('New Game'),
//                   ),
//                 ],
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildBettingSection() {
//     return Column(
//       children: [
//         const Text('Bet on even/odd: 2x winnings'),
//         Padding(
//           padding: const EdgeInsets.only(left: 0.0, right: 16.0),
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.start,
//             children: [
//               Row(
//                 children: [
//                   Radio(
//                     value: BetType.odd,
//                     groupValue: widget.model.selectedBetType,
//                     onChanged: widget.model.isBettingDisabled
//                         ? null
//                         : (value) => controller
//                             .selectBetType(widget.model.parseBetType(value)!),
//                   ),
//                   const Text('Odd'),
//                 ],
//               ),
//               Row(
//                 children: [
//                   Radio(
//                     value: BetType.even,
//                     groupValue: widget.model.selectedBetType,
//                     onChanged: widget.model.isBettingDisabled
//                         ? null
//                         : (value) => controller
//                             .selectBetType(widget.model.parseBetType(value)!),
//                   ),
//                   const Text('Even'),
//                   const SizedBox(width: 20),
//                 ],
//               ),
//               Container(
//                 color: Colors.lightBlueAccent,
//                 padding: const EdgeInsets.symmetric(horizontal: 8.0),
//                 child: DropdownButton<int>(
//                   value: widget.model.betAmount,
//                   items: const [
//                     DropdownMenuItem(value: 10, child: Text('\$10')),
//                     DropdownMenuItem(value: 20, child: Text('\$20')),
//                     DropdownMenuItem(value: 30, child: Text('\$30')),
//                   ],
//                   onChanged: widget.model.isBettingDisabled
//                       ? null
//                       : (value) => controller.selectBetAmount(value!),
//                   hint: const Text('Choose bet amount'),
//                 ),
//               ),
//             ],
//           ),
//         ),
//         const SizedBox(height: 10),
//         const Text('Bet on range: 3x winnings'),
//         Row(
//           mainAxisAlignment: MainAxisAlignment.start,
//           children: [
//             Radio(
//               value: BetRange.range1to2,
//               groupValue: widget.model.selectedBetRange,
//               onChanged: widget.model.isBettingDisabled
//                   ? null
//                   : (value) => controller
//                       .selectBetRange(widget.model.parseBetRange(value)!),
//             ),
//             const Text('1-2'),
//             Radio(
//               value: BetRange.range3to4,
//               groupValue: widget.model.selectedBetRange,
//               onChanged: widget.model.isBettingDisabled
//                   ? null
//                   : (value) => controller
//                       .selectBetRange(widget.model.parseBetRange(value)!),
//             ),
//             const Text('3-4'),
//             Radio(
//               value: BetRange.range5to6,
//               groupValue: widget.model.selectedBetRange,
//               onChanged: widget.model.isBettingDisabled
//                   ? null
//                   : (value) => controller
//                       .selectBetRange(widget.model.parseBetRange(value)!),
//             ),
//             const Text('5-6'),
//           ],
//         ),
//         const SizedBox(height: 10),
//         Container(
//           color: Colors.lightBlueAccent,
//           padding: const EdgeInsets.symmetric(horizontal: 8.0),
//           child: DropdownButton<int>(
//             value: widget.model.rangeBetAmount,
//             items: const [
//               DropdownMenuItem(value: 10, child: Text('\$10')),
//               DropdownMenuItem(value: 20, child: Text('\$20')),
//               DropdownMenuItem(value: 30, child: Text('\$30')),
//             ],
//             onChanged: widget.model.isBettingDisabled
//                 ? null
//                 : (value) => controller.selectRangeBetAmount(value!),
//             hint: const Text('Choose bet amount'),
//           ),
//         ),
//       ],
//     );
//   }
// }

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:lesson6/controller/game_controller.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:lesson6/model/game_model.dart';
import 'package:lesson6/view/startdispatcher.dart';

// ignore: must_be_immutable
class GameRoomScreen extends StatefulWidget {
  GameModel model;

  GameRoomScreen({super.key, required this.model});

  @override
  GameRoomState createState() => GameRoomState();
}

class GameRoomState extends State<GameRoomScreen> {
  late GameController controller;

  @override
  void initState() {
    super.initState();
    widget.model.key =
        Random().nextInt(6) + 1; // Set a random key between 1 and 6 initially
    controller = GameController(widget.model, _updateModel);
  }

  void _updateModel(GameModel updatedModel) {
    setState(() {
      widget.model = updatedModel;
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
              accountEmail:
                  Text(widget.model.user.email ?? 'No Email Available'),
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
                }); // Navigate to sign-in screen
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
                'Balance: \$${widget.model.balance}${widget.model.showKey ? ' (Key: ${widget.model.key})' : ''}',
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
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        widget.model.result.isEmpty
                            ? '?'
                            : '${widget.model.key}',
                        style: const TextStyle(fontSize: 150, color: Colors.red),
                        textAlign: TextAlign.center,
                      ),
                      if (widget.model.result.isNotEmpty)
                        Text(
                          widget.model.result,
                          style:
                              const TextStyle(fontSize: 20, color: Colors.red),
                          textAlign: TextAlign.center,
                        ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Show Key:'),
                  Switch(
                    value: widget.model.showKey,
                    onChanged: (value) => controller.toggleShowKey(value),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              _buildBettingSection(),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed:
                        widget.model.isPlayEnabled ? controller.playGame : null,
                    child: const Text('Play'),
                  ),
                  ElevatedButton(
                    onPressed: widget.model.isNewGameEnabled
                        ? () {
                            controller.newGame();
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

  Widget _buildBettingSection() {
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
                    groupValue: widget.model.selectedBetType,
                    onChanged: widget.model.isBettingDisabled
                        ? null
                        : (value) => controller
                            .selectBetType(widget.model.parseBetType(value)!),
                  ),
                  const Text('Odd'),
                ],
              ),
              Row(
                children: [
                  Radio(
                    value: BetType.even,
                    groupValue: widget.model.selectedBetType,
                    onChanged: widget.model.isBettingDisabled
                        ? null
                        : (value) => controller
                            .selectBetType(widget.model.parseBetType(value)!),
                  ),
                  const Text('Even'),
                  const SizedBox(width: 20),
                ],
              ),
              Container(
                color: Colors.lightBlueAccent,
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: DropdownButton<int>(
                  value: widget.model.betAmount,
                  items: const [
                    DropdownMenuItem(value: 10, child: Text('\$10')),
                    DropdownMenuItem(value: 20, child: Text('\$20')),
                    DropdownMenuItem(value: 30, child: Text('\$30')),
                  ],
                  onChanged: widget.model.isBettingDisabled
                      ? null
                      : (value) => controller.selectBetAmount(value!),
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
              groupValue: widget.model.selectedBetRange,
              onChanged: widget.model.isBettingDisabled
                  ? null
                  : (value) => controller
                      .selectBetRange(widget.model.parseBetRange(value)!),
            ),
            const Text('1-2'),
            Radio(
              value: BetRange.range3to4,
              groupValue: widget.model.selectedBetRange,
              onChanged: widget.model.isBettingDisabled
                  ? null
                  : (value) => controller
                      .selectBetRange(widget.model.parseBetRange(value)!),
            ),
            const Text('3-4'),
            Radio(
              value: BetRange.range5to6,
              groupValue: widget.model.selectedBetRange,
              onChanged: widget.model.isBettingDisabled
                  ? null
                  : (value) => controller
                      .selectBetRange(widget.model.parseBetRange(value)!),
            ),
            const Text('5-6'),
          ],
        ),
        const SizedBox(height: 10),
        Container(
          color: Colors.lightBlueAccent,
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: DropdownButton<int>(
            value: widget.model.rangeBetAmount,
            items: const [
              DropdownMenuItem(value: 10, child: Text('\$10')),
              DropdownMenuItem(value: 20, child: Text('\$20')),
              DropdownMenuItem(value: 30, child: Text('\$30')),
            ],
            onChanged: widget.model.isBettingDisabled
                ? null
                : (value) => controller.selectRangeBetAmount(value!),
            hint: const Text('Choose bet amount'),
          ),
        ),
      ],
    );
  }
}
