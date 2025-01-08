// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:io';

import 'package:brasil_fields/brasil_fields.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_getit/flutter_getit.dart';
import 'package:jlfastcred/src/modulos/client/register/register_controller.dart';
import 'package:jlfastcred/src/modulos/client/register/register_form_controller.dart';
import 'package:signals_flutter/signals_flutter.dart';
import 'package:validatorless/validatorless.dart';

import 'package:jlfastcred_core/jlfastcred_core.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<RegisterPage>
    with MesssageViewMixin, RegisterFormController {
  final controller = Injector.get<RegisterController>();

  bool isLoading = false;

  @override
  void initState() {
    messageListener(controller);
    controller.initializeBank();

    effect(() {
      if (controller.created) {
        Navigator.of(context).pushReplacementNamed('/client/list');
      }
      initializeCep(controller.cepV1);
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final simulation = controller.simulationForm.watch(context)!;
    initializeForm(simulation);

    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) {},
      child: Scaffold(
        appBar: JlfastcredAppBar(
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back,
              color: JlfastcredTheme.greenColor,
              size: 40.0,
            ),
            onPressed: () {
              Navigator.of(context).pushReplacementNamed('/client/list');
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
        body: LayoutBuilder(
          builder: (_, constrains) {
            var sizeOf = MediaQuery.sizeOf(context);
            return Stack(
              children: [
                SingleChildScrollView(
                  child: Container(
                    constraints:
                        BoxConstraints(minHeight: constrains.maxHeight),
                    child: Center(
                      child: Container(
                        padding: const EdgeInsets.all(20),
                        width: sizeOf.width,
                        height: sizeOf.height * 3.4,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Form(
                          key: formKey,
                          child: Column(
                            children: [
                              const SizedBox(
                                height: 24,
                              ),
                              const HeaderWidget(
                                texto: 'DADOS DO CLIENTE',
                                image: 'assets/images/document.png',
                              ),
                              TextFormField(
                                readOnly: true,
                                controller: documentEC,
                                validator:
                                    Validatorless.required('CPF é obrigatório'),
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly,
                                  CpfInputFormatter()
                                ],
                                keyboardType: TextInputType.number,
                                decoration:
                                    const InputDecoration(label: Text('CPF')),
                              ),
                              const SizedBox(
                                height: 16,
                              ),
                              TextFormField(
                                readOnly: true,
                                controller: nameEC,
                                validator:
                                    Validatorless.required('Nome obrigatório'),
                                decoration: const InputDecoration(
                                    label: Text('Nome Cliente')),
                              ),
                              const SizedBox(
                                height: 16,
                              ),
                              TextFormField(
                                readOnly: true,
                                controller: birthDateEC,
                                validator: Validatorless.required(
                                    'Data de nascimento é obrigatória'),
                                decoration: const InputDecoration(
                                    label: Text('Data de Nascimento')),
                              ),
                              const SizedBox(
                                height: 16,
                              ),
                              TextFormField(
                                readOnly: !enabledForm,
                                controller: emailEC,
                                validator: Validatorless.multiple([
                                  Validatorless.required('Email obrigatório'),
                                  Validatorless.email('Email inválido')
                                ]),
                                decoration: const InputDecoration(
                                    label: Text('E-mail')),
                              ),
                              const SizedBox(
                                height: 16,
                              ),
                              TextFormField(
                                readOnly: !enabledForm,
                                controller: phoneEC,
                                validator: Validatorless.required(
                                    'Telefone é obrigatório'),
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly,
                                  TelefoneInputFormatter()
                                ],
                                decoration: const InputDecoration(
                                    label: Text('Telefone de Contato')),
                              ),
                              const SizedBox(
                                height: 16,
                              ),
                              // TextFormField(
                              //   readOnly: !enabledForm,
                              //   controller: cepEC,
                              //   validator:
                              //       Validatorless.required('CEP é obrigatório'),
                              //   inputFormatters: [
                              //     FilteringTextInputFormatter.digitsOnly,
                              //     CepInputFormatter()
                              //   ],
                              //   decoration:
                              //       const InputDecoration(label: Text('CEP')),
                              // ),
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
                              TextFormField(
                                readOnly: !enabledForm,
                                controller: addressEC,
                                validator: Validatorless.required(
                                    'Endereço é obrigatório'),
                                decoration: const InputDecoration(
                                    label: Text('Endereço')),
                              ),
                              const SizedBox(
                                height: 16,
                              ),
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
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
                                  const SizedBox(
                                    width: 16,
                                  ),
                                  Flexible(
                                    flex: 2,
                                    child: TextFormField(
                                      controller: complementEC,
                                      decoration: const InputDecoration(
                                          label: Text('Complemento')),
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
                                      controller: neighborhoodEC,
                                      validator: Validatorless.required(
                                          'Bairro é obrigatório'),
                                      decoration: const InputDecoration(
                                        label: Text('Bairro'),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 16,
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 16,
                              ),
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Flexible(
                                    flex: 2,
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
                                  Flexible(
                                    flex: 1,
                                    child: TextFormField(
                                      readOnly: !enabledForm,
                                      controller: stateEC,
                                      validator: Validatorless.required(
                                          'Estado é obrigatório'),
                                      decoration: const InputDecoration(
                                        label: Text('Estado'),
                                      ),
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

                              // TextFormField(
                              //   readOnly: !enabledForm,
                              //   controller: bankEC,
                              //   validator: Validatorless.required(
                              //       'Banco é obrigatório'),
                              //   // inputFormatters: [
                              //   //   FilteringTextInputFormatter.digitsOnly,
                              //   // ],
                              //   decoration:
                              //       const InputDecoration(label: Text('Banco')),
                              // ),
                              DropdownButtonFormField<BankDetails>(
                                isExpanded: true,
                                value:
                                    selectedBank, // A variável que controla o banco selecionado
                                onChanged: (newValue) {
                                  // setState(
                                  //   () {
                                  if (newValue != null) {
                                    selectedBank = newValue;
                                    bankEC.text = selectedBank?.name ?? '';
                                  }
                                  //   },
                                  // );
                                },
                                items: controller.getDropdownItems(),
                                decoration: const InputDecoration(
                                  labelText: 'Selecione o Banco',
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
                                      // readOnly: !enabledForm,
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
                                height: 22,
                              ),
                              DropdownButtonFormField(
                                value: selectedOptionTipoConta,
                                items: optionsTipoConta
                                    .map((option) => DropdownMenuItem(
                                          value: option,
                                          child: Text(option),
                                        ))
                                    .toList(),
                                onChanged: (value) {
                                  accountTypeEC.text = value!;
                                },
                                decoration: const InputDecoration(
                                  labelText: 'Tipo conta',
                                  border: OutlineInputBorder(),
                                ),
                                validator: (value) {
                                  if (value == null ||
                                      value.isEmpty ||
                                      value == 'Selecione') {
                                    return 'Tipo conta é obrigatório';
                                  }
                                  return null;
                                },
                              ),

                              const SizedBox(
                                height: 16,
                              ),
                              TextFormField(
                                // readOnly: !enabledForm,
                                controller: pixEC,
                                validator: Validatorless.required(
                                    'Chave PIX é obrigatório'),
                                // inputFormatters: [
                                //   FilteringTextInputFormatter
                                //       .singleLineFormatter,
                                // ],
                                decoration: const InputDecoration(
                                    label: Text('Chave PIX')),
                              ),

                              //Documents
                              const SizedBox(
                                height: 24,
                              ),
                              const HeaderWidget(
                                  image: 'assets/images/folder.png',
                                  texto: 'DOCUMENTOS'),

                              const Text(
                                'Selecione o documento que deseja inserir',
                                style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                    color: JlfastcredTheme.blueColor),
                              ),
                              const SizedBox(
                                height: 24,
                              ),
                              SizedBox(
                                width: sizeOf.width * .8,
                                height: sizeOf.height,
                                child: Column(children: [
                                  DocumentBoxWidget(
                                    icon: Image.asset(
                                        'assets/images/id_card.png'),
                                    label:
                                        'Frente do documento de identificação',
                                    allowedExtensions: const [
                                      'jpg',
                                      'jpeg',
                                      'png',
                                      'pdf'
                                    ],
                                    onFileSelected: (File file) {
                                      anexoFrenteDocumento = file;
                                    },
                                  ),
                                  const SizedBox(
                                    height: 32,
                                  ),
                                  DocumentBoxWidget(
                                    icon: Image.asset(
                                        'assets/images/id_card.png'),
                                    label:
                                        'Verso do documento de identificação',
                                    allowedExtensions: const [
                                      'jpg',
                                      'jpeg',
                                      'png',
                                      'pdf'
                                    ],
                                    onFileSelected: (File file) {
                                      anexoVersoDocumento = file;
                                    },
                                  ),
                                ]),
                              ),
                              //
                              const SizedBox(
                                height: 32,
                              ),
                              Row(
                                children: [
                                  Expanded(
                                    child: SizedBox(
                                      height: 48,
                                      child: OutlinedButton(
                                          onPressed: () {
                                            Navigator.of(context)
                                                .pushReplacementNamed(
                                                    '/client/list');
                                          },
                                          child: const Text('CANCELAR')),
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 17,
                                  ),
                                  Expanded(
                                    child: SizedBox(
                                      height: 48,
                                      child: ElevatedButton(
                                          onPressed: () async {
                                            final valid = formKey.currentState
                                                    ?.validate() ??
                                                false;

                                            if (valid) {
                                              setState(() {
                                                isLoading = true;
                                              });
                                              controller.cadastrarClient(
                                                  anexoFrenteDocumento,
                                                  anexoVersoDocumento,
                                                  createClientRegister(
                                                      simulation));
                                            }
                                          },
                                          child: const Text('SALVAR')),
                                    ),
                                  )
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Visibility(
                  visible: isLoading,
                  child: Container(
                    color: Colors.black.withOpacity(0.5),
                    child: const Center(
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(
                            JlfastcredTheme.greenColor),
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
