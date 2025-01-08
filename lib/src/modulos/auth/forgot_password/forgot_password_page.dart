import 'package:flutter/material.dart';
import 'package:flutter_getit/flutter_getit.dart';
import 'package:jlfastcred_core/jlfastcred_core.dart';
import 'package:signals_flutter/signals_flutter.dart';
import 'package:validatorless/validatorless.dart';

import 'forgot_password_controller.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage>
    with MesssageViewMixin {
  final formKey = GlobalKey<FormState>();
  final emailEC = TextEditingController();
  final controller = Injector.get<ForgotPasswordController>();

  @override
  void initState() {
    messageListener(controller);
    effect(() {
      if (controller.resetDone) {
        Navigator.of(context).pushReplacementNamed('/auth/login');
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    emailEC.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final sizeOf = MediaQuery.sizeOf(context);
    return Scaffold(
      appBar: JlfastcredAppBar(),
      body: SingleChildScrollView(
        child: Container(
          constraints: BoxConstraints(minHeight: sizeOf.height * 0.8),
          child: Center(
            child: Container(
              padding: const EdgeInsets.all(40),
              constraints: BoxConstraints(maxWidth: sizeOf.width * .8),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Form(
                key: formKey,
                child: Column(
                  children: [
                    TextFormField(
                      controller: emailEC,
                      validator: Validatorless.multiple(
                        [
                          Validatorless.required('Email Obrigatório'),
                          Validatorless.email('Email inválido'),
                        ],
                      ),
                      decoration: const InputDecoration(label: Text('Email')),
                    ),
                    const SizedBox(
                      height: 24,
                    ),
                    SizedBox(
                      width: sizeOf.width * .8,
                      height: 48,
                      child: ElevatedButton(
                        onPressed: () async {
                          final valid =
                              formKey.currentState?.validate() ?? false;

                          if (valid) {
                            await controller.resetPassWord(emailEC.text);
                          }
                        },
                        child: const Text('REDEFINIR SENHA'),
                      ),
                    ),
                    const SizedBox(
                      height: 24,
                    ),
                    SizedBox(
                      width: sizeOf.width * .8,
                      height: 48,
                      child: OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          fixedSize: const Size.fromHeight(48),
                        ),
                        onPressed: () {
                          Navigator.of(context)
                              .pushReplacementNamed('/auth/login');
                        },
                        child: const Text('VOLTAR'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
