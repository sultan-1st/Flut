import 'package:bot_toast/bot_toast.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:login_signup/firebase_options.dart';
import 'package:login_signup/providers/add_favorite.dart';
import 'package:login_signup/providers/profile_provider.dart';
import 'package:provider/provider.dart';

import 'routes/routes.dart';

Future<void> main() async {
WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp( 
options: DefaultFirebaseOptions.currentPlatform,
);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ProfileProvider()),
        ChangeNotifierProvider(create: (_) => FavoriteProvider()),
      ],
      child: MaterialApp.router(
        debugShowCheckedModeBanner: false,
        builder: BotToastInit(),
        routerConfig: router,
        title: 'LoginSignUp',
      ),
    );
  }
}

