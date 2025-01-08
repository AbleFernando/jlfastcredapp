import 'package:flutter/material.dart';
import 'package:flutter_getit/flutter_getit.dart';
import 'package:jlfastcred/src/modulos/user/info/user_info_router.dart';

class UserModule extends FlutterGetItModule {
  @override
  List<Bind<Object>> get bindings => [
        // Bind.lazySingleton<UserService>(
        //     (i) => UserServiceImpl(userRepository: i())),
      ];

  @override
  String get moduleRouteName => '/user';

  @override
  Map<String, WidgetBuilder> get pages => {
        '/info': (_) => const UserInfoRouter(),
        // '/document': (_) => const RegisterRouter(),
      };
}
