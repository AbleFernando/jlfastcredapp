import 'package:flutter/material.dart';
import 'package:flutter_getit/flutter_getit.dart';
import 'package:jlfastcred/src/modulos/signup/sign_up_controller.dart';
import 'package:jlfastcred_core/jlfastcred_core.dart';
import 'package:signals_flutter/signals_flutter.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> with MesssageViewMixin {
  final controller = Injector.get<SignUpController>();
  @override
  void initState() {
    messageListener(controller);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.startProcess();
      effect(() {
        var baseRoute = '/signup/';
        final step = controller.step;

        switch (step) {
          case FormSteps.none:
            return;
          case FormSteps.whoIAm:
            baseRoute += 'whoIAm';
          case FormSteps.findConsultant:
            baseRoute += 'find-consultant';
          case FormSteps.consultant:
            baseRoute += 'consultant';
          case FormSteps.documents:
            baseRoute += 'documents';
          case FormSteps.done:
            baseRoute += 'done';

          case FormSteps.bankInfo:
          // TODO: Handle this case.
        }
        Navigator.of(context).pushNamed(baseRoute);
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
