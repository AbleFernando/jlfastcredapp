import 'package:brasil_fields/brasil_fields.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_getit/flutter_getit.dart';
import 'package:jlfastcred/src/modulos/signup/consultant/consultant_controller.dart';
import 'package:jlfastcred/src/modulos/signup/consultant/consultant_form_controller.dart';
import 'package:jlfastcred/src/modulos/signup/sign_up_controller.dart';
import 'package:jlfastcred_core/jlfastcred_core.dart';
import 'package:signals_flutter/signals_flutter.dart';
import 'package:validatorless/validatorless.dart';

import '../find_consultant/find_consultant_controller.dart';

class ConsultantPage extends StatefulWidget {
  const ConsultantPage({super.key});

  @override
  State<ConsultantPage> createState() => _ConsultantPageState();
}

class _ConsultantPageState extends State<ConsultantPage>
    with ConsultantFormController, MesssageViewMixin {
  final signUpController = Injector.get<SignUpController>();
  final controller = Injector.get<ConsultantController>();
  final findConsultantController = Injector.get<FindConsultantController>();

  late bool consultantFound;
  late bool enabledForm;

  @override
  void initState() {
    messageListener(controller);
    final Users users = signUpController.model;
    consultantFound = users.name != '';
    enabledForm = !consultantFound;
    controller.initializeBank();
    initializeForm(users);

    effect(() {
      if (controller.nextStep) {
        signUpController.updatePatientAndGoDocumento(controller.users);
      }
      if (!consultantFound) {
        initializeCep(controller.cepV1);
      }
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) {
        // selfServiceController.clearForm();
      },
      child: Scaffold(
        appBar: JlfastcredAppBar(),
        body: LayoutBuilder(
          builder: (_, constrains) {
            var sizeOf = MediaQuery.sizeOf(context);
            return SingleChildScrollView(
              child: Container(
                constraints: BoxConstraints(minHeight: constrains.maxHeight),
                child: Center(
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    width: sizeOf.width,
                    // height: sizeOf.height,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Form(
                      key: formKey,
                      child: Column(
                        children: [
                          // Image.asset('assets/images/check_icon.png'),
                          const SizedBox(
                            height: 24,
                          ),
                          const HeaderWidget(
                            texto: 'DADOS DO CONSULTOR',
                            image: 'assets/images/document.png',
                          ),
                          Visibility(
                            visible: enabledForm,
                            child: Watch(
                              (_) {
                                return TextFormField(
                                  // obscureText: controller.obscurePassword,
                                  controller: passwordEC,
                                  validator: Validatorless.required(
                                      'Senha obrigatória'),
                                  decoration: const InputDecoration(
                                    label: Text('Password'),
                                    // suffixIcon: IconButton(
                                    // onPressed: () {
                                    // controller.passwordToggle();
                                    // },
                                    // icon: controller.obscurePassword
                                    //     ? const Icon(Icons.visibility)
                                    //     : const Icon(Icons.visibility_off),
                                    // ),
                                  ),
                                );
                              },
                            ),
                          ),
                          const SizedBox(
                            height: 16,
                          ),

                          CustomTextField(
                            controller: nameEC,
                            label: 'Nome Consultor',
                            readOnly: !enabledForm,
                            validator:
                                Validatorless.required('Nome obrigatório'),
                          ),

                          const SizedBox(
                            height: 16,
                          ),

                          CustomTextField(
                            controller: emailEC,
                            label: 'E-mail',
                            readOnly: !enabledForm,
                            validator: Validatorless.multiple([
                              Validatorless.required('Email obrigatório'),
                              Validatorless.email('Email inválido'),
                            ]),
                          ),

                          const SizedBox(
                            height: 16,
                          ),

                          CustomTextField(
                            readOnly: !enabledForm,
                            controller: phoneEC,
                            label: 'Telefone de Contato',
                            validator: Validatorless.required(
                                'Telefone é obrigatório'),
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                              TelefoneInputFormatter()
                            ],
                            keyboardType: TextInputType.number,
                          ),

                          const SizedBox(
                            height: 16,
                          ),

                          TextFormField(
                            readOnly: !enabledForm,
                            controller: documentEC,
                            validator:
                                Validatorless.required('CPF é obrigatório'),
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                              CpfInputFormatter()
                            ],
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                                label: Text('Digite o seu CPF')),
                          ),

                          const SizedBox(
                            height: 16,
                          ),

                          TextFormField(
                            readOnly: !enabledForm,
                            controller: cepEC,
                            validator:
                                Validatorless.required('CEP é obrigatório'),
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                              CepInputFormatter()
                            ],
                            keyboardType: TextInputType.number,
                            decoration:
                                const InputDecoration(label: Text('CEP')),
                            onChanged: (cep) async {
                              if (cep.length == 10) {
                                // Confirme que o CEP tem 8 dígitos antes de buscar
                                await controller.fetchAddressByCep(cep);
                                // initializeCep(controller.cepV1);
                              }
                            },
                          ),
                          const SizedBox(
                            height: 16,
                          ),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Flexible(
                                flex: 3,
                                child: TextFormField(
                                  readOnly: !enabledForm,
                                  controller: addressEC,
                                  validator: Validatorless.required(
                                      'Endereço é obrigatório'),
                                  decoration: const InputDecoration(
                                      label: Text('Endereço')),
                                ),
                              ),
                              const SizedBox(
                                width: 16,
                              ),
                              Flexible(
                                flex: 1,
                                child: TextFormField(
                                  readOnly: !enabledForm,
                                  controller: numberEC,
                                  inputFormatters: [
                                    FilteringTextInputFormatter.digitsOnly,
                                  ],
                                  keyboardType: TextInputType.number,
                                  validator: Validatorless.required(
                                      'Número é obrigatório'),
                                  decoration: const InputDecoration(
                                      label: Text('Número')),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 16,
                          ),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Expanded(
                                child: TextFormField(
                                  controller: complementEC,
                                  decoration: const InputDecoration(
                                      label: Text('Complemento')),
                                ),
                              ),
                              const SizedBox(
                                width: 16,
                              ),
                              Expanded(
                                child: TextFormField(
                                  readOnly: !enabledForm,
                                  controller: stateEC,
                                  validator: Validatorless.required(
                                      'Estado é obrigatório'),
                                  decoration: const InputDecoration(
                                      label: Text('Estado')),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 16,
                          ),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Expanded(
                                child: TextFormField(
                                  readOnly: !enabledForm,
                                  controller: cityEC,
                                  validator: Validatorless.required(
                                      'Cidade é obrigatória'),
                                  decoration: const InputDecoration(
                                      label: Text('Cidade')),
                                ),
                              ),
                              const SizedBox(
                                width: 16,
                              ),
                              Expanded(
                                child: TextFormField(
                                  readOnly: !enabledForm,
                                  controller: districtEC,
                                  validator: Validatorless.required(
                                      'Bairro é obrigatório'),
                                  decoration: const InputDecoration(
                                      label: Text('Bairro')),
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(
                            height: 32,
                          ),

                          const HeaderWidget(
                            texto: 'DADOS BANCÁRIOS',
                            image: 'assets/images/id_card.png',
                          ),
                          Visibility(
                            visible: enabledForm,
                            replacement: TextFormField(
                              readOnly: true,
                              controller: bankEC,
                              validator:
                                  Validatorless.required('Banco é obrigatório'),
                              // inputFormatters: [
                              //   FilteringTextInputFormatter.digitsOnly,
                              // ],
                              decoration:
                                  const InputDecoration(label: Text('Banco')),
                            ),
                            child: DropdownButtonFormField<BankDetails>(
                              isExpanded: true,
                              value:
                                  selectedBank, // A variável que controla o banco selecionado
                              onChanged: (newValue) {
                                setState(
                                  () {
                                    if (newValue != null) {
                                      selectedBank = newValue;
                                      bankEC.text = selectedBank?.name ?? '';
                                    }
                                  },
                                );
                              },
                              items: controller.getDropdownItems(),
                              decoration: const InputDecoration(
                                labelText: 'Selecione o Banco',
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 16,
                          ),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Expanded(
                                child: TextFormField(
                                  readOnly: !enabledForm,
                                  controller: branchEC,
                                  validator: Validatorless.required(
                                      'Agencia é obrigatória'),
                                  decoration: const InputDecoration(
                                      label: Text('Agencia')),
                                ),
                              ),
                              const SizedBox(
                                width: 16,
                              ),
                              Expanded(
                                child: TextFormField(
                                  readOnly: !enabledForm,
                                  controller: accountEC,
                                  validator: Validatorless.required(
                                      'Conta é obrigatório'),
                                  decoration: const InputDecoration(
                                      label: Text('Conta')),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 16,
                          ),
                          TextFormField(
                            readOnly: !enabledForm,
                            controller: pixEC,
                            validator: Validatorless.required(
                                'Chave PIX é obrigatório'),
                            // inputFormatters: [
                            //   FilteringTextInputFormatter.digitsOnly,
                            // ],
                            decoration:
                                const InputDecoration(label: Text('Chave PIX')),
                          ),
                          const SizedBox(
                            height: 32,
                          ),
                          Visibility(
                            visible: !enabledForm,
                            replacement: SizedBox(
                              width: double.infinity,
                              height: 48,
                              child: ElevatedButton(
                                onPressed: () {
                                  final valid =
                                      formKey.currentState?.validate() ?? false;
                                  if (valid) {
                                    if (consultantFound) {
                                      controller
                                          .saveAndNext(signUpController.model);
                                      // controller.updateAndNext(updatePatient(
                                      //     selfServiceController.model.patient!));
                                    } else {
                                      controller
                                          .saveAndNext(createUsersRegister());
                                    }
                                  }
                                },
                                child: Visibility(
                                  replacement: const Text('SALVAR E CONTINUAR'),
                                  visible: !consultantFound,
                                  // child: const Text('CADASTRAR'),
                                  child: const Text('PRÓXIMO'),
                                ),
                              ),
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  child: SizedBox(
                                    height: 48,
                                    child: OutlinedButton(
                                        onPressed: () {
                                          setState(
                                            () {
                                              enabledForm = true;
                                            },
                                          );
                                        },
                                        child: const Text('EDITAR')),
                                  ),
                                ),
                                const SizedBox(
                                  width: 17,
                                ),
                                Expanded(
                                  child: SizedBox(
                                    height: 48,
                                    child: ElevatedButton(
                                        onPressed: () {
                                          controller.users =
                                              signUpController.model;
                                          controller.goNextStep();
                                        },
                                        child: const Text('CONTINUAR')),
                                  ),
                                )
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 14,
                          ),
                          SizedBox(
                            width: double.infinity,
                            height: 48,
                            child: OutlinedButton(
                              onPressed: () {
                                signUpController.clearForm();
                                findConsultantController.clearForm();
                                Navigator.of(context)
                                    .pushReplacementNamed('/auth/login');
                              },
                              child: const Text('CANCELAR'),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
