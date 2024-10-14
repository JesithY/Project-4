// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:lesson6/controller/auth_controller.dart';
// import 'package:lesson6/view/home_screen.dart';
// import 'package:lesson6/view/signin_screen.dart';

// class Startdispatcher extends StatelessWidget {
//   const Startdispatcher({super.key});

//   static const routeName = '/startDispatcher';

//   @override
//   Widget build(BuildContext context) {
//     return StreamBuilder<User?>(
//       stream: FirebaseAuth.instance.authStateChanges(),
//       initialData: null,
//       builder: (BuildContext context, AsyncSnapshot snapshot){
//         currentUser = snapshot.data;
//         return currentUser == null ? const SignInScreen() : const HomeScreen();
//       },
//     );
//   }
// }
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
//import 'package:lesson6/controller/auth_controller.dart';
import 'package:lesson6/model/home_model.dart';
import 'package:lesson6/view/home_screen.dart';
import 'package:lesson6/view/signin_screen.dart';

class Startdispatcher extends StatelessWidget {
  const Startdispatcher({super.key});

  static const routeName = '/startDispatcher';

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      initialData: null,
      builder: (BuildContext context, AsyncSnapshot<User?> snapshot) {
        User? currentUser = snapshot.data;
        if (currentUser == null) {
          return const SignInScreen();
        } else {
          HomeModel homeModel = HomeModel(currentUser);
          return HomeScreen(model: homeModel);
        }
      },
    );
  }
}
