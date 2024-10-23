import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:lesson6/view/startdispatcher.dart';
import 'package:lesson6/view/createaccount_screen.dart';
import 'package:lesson6/view/gameroom_screen.dart';
import 'package:lesson6/model/game_model.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const FirebaseTemplateApp());
}

class FirebaseTemplateApp extends StatelessWidget {
  const FirebaseTemplateApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.blue,
      ),
      initialRoute: StartDispatcher.routeName,
      routes: {
        StartDispatcher.routeName: (context) => const StartDispatcher(),
        CreateAccountScreen.routName: (context) => const CreateAccountScreen(),
        '/gameRoom': (context) {
          User currentUser = FirebaseAuth.instance.currentUser!;
          return GameRoomScreen(model: GameModel(user: currentUser));
        },
      },
    );
  }
}
