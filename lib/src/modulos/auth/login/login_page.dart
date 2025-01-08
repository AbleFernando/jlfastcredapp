import 'package:flutter/material.dart';
import 'package:flutter_getit/flutter_getit.dart';
import 'package:jlfastcred/src/modulos/auth/login/login_controller.dart';
import 'package:jlfastcred_core/jlfastcred_core.dart';
import 'package:signals_flutter/signals_flutter.dart';
import 'package:validatorless/validatorless.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> with MesssageViewMixin {
  final formKey = GlobalKey<FormState>();
  final emailEC = TextEditingController();
  final passwordEC = TextEditingController();
  final controller = Injector.get<LoginController>();

  @override
  void initState() {
    emailEC.text = 'ana1@teste.com';
    passwordEC.text = 'teste123';
    messageListener(controller);
    effect(() {
      if (controller.logged) {
        Navigator.of(context).pushReplacementNamed('/home');
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    emailEC.dispose();
    passwordEC.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final sizeOf = MediaQuery.sizeOf(context);
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          constraints: BoxConstraints(minHeight: sizeOf.height),
          // decoration: const BoxDecoration(
          //   image: DecorationImage(
          //       image: AssetImage('assets/images/background_login.png'),
          //       fit: BoxFit.cover),
          // ),
          child: Center(
            child: Container(
              padding: const EdgeInsets.all(40),
              // constraints: BoxConstraints(maxWidth: sizeOf.width * .8),
              constraints: BoxConstraints(
                  maxWidth: sizeOf.width, maxHeight: sizeOf.height),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Form(
                key: formKey,
                child: Column(
                  children: [
                    // const Text(
                    //   'Login',
                    //   style: JlfastcredTheme.titleStyle,
                    // ),
                    Image.asset('assets/images/logo_vertical.png', height: 180),
                    const SizedBox(
                      height: 32,
                    ),
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
                    Watch(
                      (_) {
                        return TextFormField(
                          obscureText: controller.obscurePassword,
                          controller: passwordEC,
                          validator:
                              Validatorless.required('Senha obrigatória'),
                          decoration: InputDecoration(
                            label: const Text('Password'),
                            suffixIcon: IconButton(
                              onPressed: () {
                                controller.passwordToggle();
                              },
                              icon: controller.obscurePassword
                                  ? const Icon(Icons.visibility)
                                  : const Icon(Icons.visibility_off),
                            ),
                          ),
                        );
                      },
                    ),
                    Align(
                      alignment: Alignment.bottomRight,
                      child: TextButton(
                        onPressed: () {
                          Navigator.of(context)
                              .pushReplacementNamed('/auth/forgotPassword');
                        },
                        child: const Text('Esqueci minha senha'),
                      ),
                    ),
                    const SizedBox(
                      height: 32,
                    ),
                    SizedBox(
                      width: sizeOf.width * .8,
                      height: 48,
                      child: ElevatedButton(
                        onPressed: () {
                          final valid =
                              formKey.currentState?.validate() ?? false;

                          if (valid) {
                            controller.login(emailEC.text, passwordEC.text);
                          }
                        },
                        child: const Text('ENTRAR'),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: TextButton(
                        onPressed: () {
                          Navigator.of(context).pushReplacementNamed('/signup');
                        },
                        child: const Text('Criar minha conta'),
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
