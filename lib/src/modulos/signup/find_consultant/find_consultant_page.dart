import 'package:brasil_fields/brasil_fields.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_getit/flutter_getit.dart';
import 'package:jlfastcred/src/modulos/signup/find_consultant/find_consultant_controller.dart';
import 'package:jlfastcred/src/modulos/signup/sign_up_controller.dart';
import 'package:jlfastcred_core/jlfastcred_core.dart';
import 'package:signals_flutter/signals_flutter.dart';
import 'package:validatorless/validatorless.dart';

class FindConsultantPage extends StatefulWidget {
  const FindConsultantPage({super.key});

  @override
  State<FindConsultantPage> createState() => _FindConsultantPageState();
}

class _FindConsultantPageState extends State<FindConsultantPage>
    with MesssageViewMixin {
  final formKey = GlobalKey<FormState>();
  final documentEC = TextEditingController();
  final controller = Injector.get<FindConsultantController>();

  @override
  void dispose() {
    documentEC.dispose();
    super.dispose();
  }

  @override
  void initState() {
    messageListener(controller);
    effect(() {
      final FindConsultantController(:users, :consultantNotFound) = controller;

      if (users != null || !consultantNotFound) {
        Injector.get<SignUpController>().goToFormConsultant(users);
        controller.clearForm();
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) {
        documentEC.text = '';
        // signUpController.clearForm();
      },
      child: Scaffold(
        appBar: JlfastcredAppBar(),
        body: LayoutBuilder(builder: (_, constrains) {
          var sizeOf = MediaQuery.sizeOf(context);
          return SingleChildScrollView(
            child: Container(
              constraints: BoxConstraints(minHeight: constrains.maxHeight),
              // decoration: const BoxDecoration(
              //   image: DecorationImage(
              //     image: AssetImage('assets/images/background_login.png'),
              //     fit: BoxFit.cover,
              //   ),
              // ),
              child: Center(
                child: Container(
                  padding: const EdgeInsets.all(40),
                  width: sizeOf.width * .8,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Form(
                    key: formKey,
                    child: Column(
                      children: [
                        // Image.asset('assets/images/logo_vertical.png'),
                        const SizedBox(
                          height: 48,
                        ),
                        const Text(
                          'Bem-vindo',
                          style: JlfastcredTheme.titleStyle,
                        ),
                        const SizedBox(
                          height: 48,
                        ),
                        TextFormField(
                          keyboardType: TextInputType.number,
                          controller: documentEC,
                          validator: Validatorless.required('CPF obrigatório'),
                          decoration: const InputDecoration(
                            label: Text('Digite seu CPF'),
                          ),
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                            CpfInputFormatter()
                          ],
                        ),
                        const SizedBox(
                          height: 24,
                        ),
                        SizedBox(
                          width: sizeOf.width * .8,
                          height: 48,
                          child: ElevatedButton(
                            onPressed: () {
                              final valid =
                                  formKey.currentState?.validate() ?? false;
                              if (valid) {
                                controller
                                    .findConsultantByDocument(documentEC.text);
                              }
                            },
                            child: const Text('CONTINUAR'),
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
          );
        }),
      ),
    );
  }
}
