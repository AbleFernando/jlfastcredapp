import 'dart:async';
import 'dart:developer';

import 'package:camera/camera.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_getit/flutter_getit.dart';
import 'package:jlfastcred/src/binding/jlfastcred_application_binding.dart';
import 'package:jlfastcred/src/modulos/auth/auth_module.dart';
import 'package:jlfastcred/src/modulos/client/client_module.dart';
import 'package:jlfastcred/src/modulos/home/home_module.dart';
import 'package:jlfastcred/src/modulos/signup/sign_up_module.dart';
import 'package:jlfastcred/src/modulos/simulation/simulation_module.dart';
import 'package:jlfastcred/src/modulos/user/user_module.dart';
import 'package:jlfastcred_core/jlfastcred_core.dart';

import 'src/pages/splash_page/splash_page.dart';

late List<CameraDescription> _cameras;

void main() {
  runZonedGuarded(() async {
    WidgetsFlutterBinding.ensureInitialized();
    _cameras = await availableCameras();

    await Firebase.initializeApp(
      options: const FirebaseOptions(
        apiKey: 'AIzaSyAnj4qH-f7_keItuXP8M-c22OzB9jGQL_c',
        appId: '1:575397310493:web:cbf4514fb285f815f556f4',
        messagingSenderId: '575397310493',
        projectId: 'jlfastcred-d5d8a',
        authDomain: 'jlfastcred-d5d8a.firebaseapp.com',
        databaseURL: 'https://jlfastcred-d5d8a-default-rtdb.firebaseio.com',
        storageBucket: 'jlfastcred-d5d8a.appspot.com',
        measurementId: 'G-ZY381NE9SB',
      ),
    );

    runApp(const JlFastcredConsultorApp());
  }, (error, stack) {
    log('Error não tratado', error: error, stackTrace: stack);
    throw error;
  });
}

class JlFastcredConsultorApp extends StatelessWidget {
  const JlFastcredConsultorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return JlfastcredCoreConfig(
      title: 'JL FASTCRED',
      bindings: JlfastcredApplicationBinding(),
      pagesBuilders: [
        FlutterGetItPageBuilder(
          page: (_) => const SplashPage(),
          path: '/',
        )
      ],
      modules: [
        AuthModule(),
        SignUpModule(),
        HomeModule(),
        SimulationModule(),
        ClientModule(),
        UserModule(),
      ],
      didStart: () {
        FlutterGetItBindingRegister.registerPermanentBinding('CAMERAS', [
          Bind.lazySingleton((i) => _cameras),
        ]);
      },
    );
  }
}
