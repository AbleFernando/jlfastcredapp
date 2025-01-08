import 'package:flutter/material.dart';
import 'package:flutter_getit/flutter_getit.dart';
import 'package:jlfastcred/src/modulos/client/list/list_client_router.dart';
import 'package:jlfastcred/src/modulos/client/register/register_router.dart';

class ClientModule extends FlutterGetItModule {
  @override
  List<Bind<Object>> get bindings => [
        // Bind.lazySingleton<ClientService>(
        //     (i) => ClientServiceImpl(clientRepository: i()))
        // Bind.lazySingleton<ClientRepository>((i) => ClientRepositoryImpl()),
      ];

  @override
  String get moduleRouteName => '/client';

  @override
  Map<String, WidgetBuilder> get pages => {
        '/list': (_) => const ListClientRouter(),
        '/register': (_) => const RegisterRouter(),
      };
}
