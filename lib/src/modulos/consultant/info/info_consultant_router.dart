import 'package:flutter/material.dart';
import 'package:flutter_getit/flutter_getit.dart';
import 'package:jlfastcred/src/modulos/user/info/user_info_page.dart';

class InfoConsultantRouter extends FlutterGetItModulePageRouter {
  const InfoConsultantRouter({super.key});

  @override
  List<Bind> get binds => [];

  @override
  WidgetBuilder get view => (_) => const UserInfoPage();
}
