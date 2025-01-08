import 'package:flutter/material.dart';
import 'package:jlfastcred_core/jlfastcred_core.dart';

class UserInfoPage extends StatefulWidget {
  const UserInfoPage({super.key});

  @override
  State<UserInfoPage> createState() => _UserInfoPageState();
}

class _UserInfoPageState extends State<UserInfoPage> {
  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) {
        // selfServiceController.clearForm();
      },
      child: Scaffold(
        appBar: JlfastcredAppBar(
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back,
              color: JlfastcredTheme.greenColor,
              size: 40.0,
            ),
            onPressed: () {
              Navigator.of(context).pushReplacementNamed('/home');
            },
          ),
          actions: [
            PopupMenuButton(
              child: const IconPopupMenuWidget(),
              itemBuilder: (context) {
                return const [
                  PopupMenuItem(
                    value: 2,
                    child: Row(
                      children: [
                        Icon(Icons.account_circle),
                        Text(AppLabels.menuPerfilUsuario),
                      ],
                    ),
                  ),
                  PopupMenuItem(
                    value: 1,
                    child: Row(
                      children: [
                        Icon(Icons.exit_to_app),
                        Text('Finalizar Aplicativo')
                      ],
                    ),
                  ),
                ];
              },
              onSelected: (value) async {
                if (value == 1) {
                  final nav = Navigator.of(context);
                  // await SharedPreferences.getInstance()
                  // .then((sp) => sp.clear());
                  nav.pushNamedAndRemoveUntil('/', (route) => false);
                }
              },
            )
          ],
        ),
        body: Container(),
      ),
    );
  }
}
