import 'package:bicjr_app/data/providers/fire_base_auth_provider.dart';
import 'package:bicjr_app/routes/app_routes.dart';
import 'package:bicjr_app/views/pages/home/index.dart';
import 'package:bicjr_app/views/pages/tela_inicial/index.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    return MultiProvider(
      providers: [
        Provider<FireBaseAuthProvider>(
          create: (_) => FireBaseAuthProvider(),
        ),
        StreamProvider(
          create: (context) => context.read<FireBaseAuthProvider>().authState,
        )
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Bic App',
        theme: ThemeData(
          primarySwatch: Colors.pink,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: Authenticate(),
        routes: AppRoutes.routes,
      )
    );
  }
}

class Authenticate extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final firebaseUser = context.watch<User>();
    print('******** MAIN ********');
    firebaseUser == null ? print(null) : print(firebaseUser.uid);

    if (firebaseUser != null) {
      return HomePage();
    }
    return TelaInicial();
  }
}