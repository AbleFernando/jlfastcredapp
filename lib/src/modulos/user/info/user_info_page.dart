import 'package:flutter/material.dart';
import 'package:jlfastcred_core/jlfastcred_core.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
        ),
        body: const Text('Oi'),
      ),
    );
  }
}
