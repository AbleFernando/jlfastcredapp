import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_getit/flutter_getit.dart';
import 'package:jlfastcred/src/modulos/simulation/create/create_simulation_controller.dart';
import 'package:jlfastcred/src/modulos/simulation/create/create_simulation_form_controller.dart';
import 'package:jlfastcred_core/jlfastcred_core.dart';
import 'package:signals_flutter/signals_flutter.dart';
import 'package:validatorless/validatorless.dart';
import 'package:brasil_fields/brasil_fields.dart';

class CreateSimulationPage extends StatefulWidget {
  const CreateSimulationPage({super.key});

  @override
  State<CreateSimulationPage> createState() => _CreateSimulationPageState();
}

class _CreateSimulationPageState extends State<CreateSimulationPage>
    with MesssageViewMixin, CreateSimulationFormController {
  final controller = Injector.get<CreateSimulationController>();

  bool isLoading = false;

  @override
  void initState() {
    messageListener(controller);
    effect(() {
      if (controller.created) {
        Navigator.of(context).pushReplacementNamed('/home');
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    disposeForm();
    super.dispose();
  }

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
                        height: sizeOf.height + 200,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Form(
                          key: formKey,
                          child: Column(
                            children: [
                              const SizedBox(
                                height: 22,
                              ),
                              DropdownButtonFormField(
                                value: selectedOptionProduto,
                                items: optionsProduto
                                    .map((option) => DropdownMenuItem(
                                          value: option,
                                          child: Text(option),
                                        ))
                                    .toList(),
                                onChanged: (value) {
                                  setState(
                                    () {
                                      selectedOptionProduto = value!;
                                      if (selectedOptionProduto != 'INSS') {
                                        selectedOptionContrato = 'Geral';
                                      } else {
                                        selectedOptionContrato = 'Selecione';
                                      }
                                    },
                                  );
                                },
                                decoration: const InputDecoration(
                                  labelText: 'Produto',
                                  border: OutlineInputBorder(),
                                ),
                                validator: (value) {
                                  if (value == null ||
                                      value.isEmpty ||
                                      value == 'Selecione') {
                                    return 'Produto é obrigatório';
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(
                                height: 22,
                              ),
                              //
                              Visibility(
                                visible: selectedOptionProduto != 'FGTS' &&
                                    selectedOptionProduto != 'Selecione',
                                child: Column(
                                  children: [
                                    DropdownButtonFormField(
                                      value: selectedOptionContrato,
                                      items: selectedOptionProduto != 'INSS'
                                          ? ['Selecione', 'Geral']
                                              .map((option) => DropdownMenuItem(
                                                    value: option,
                                                    child: Text(option),
                                                  ))
                                              .toList()
                                          : optionsContrato
                                              .map((option) => DropdownMenuItem(
                                                    value: option,
                                                    child: Text(option),
                                                  ))
                                              .toList(),
                                      onChanged: selectedOptionProduto != 'INSS'
                                          ? null
                                          : (value) {
                                              setState(() {
                                                // selectedOptionContrato = value!;
                                              });
                                            },
                                      decoration: const InputDecoration(
                                        labelText: 'Contrato',
                                        border: OutlineInputBorder(),
                                      ),
                                      validator: (value) {
                                        if (value == null ||
                                            value.isEmpty ||
                                            value == 'Selecione') {
                                          return 'Contrato é obrigatório';
                                        }
                                        return null;
                                      },
                                    ),
                                    const SizedBox(
                                      height: 22,
                                    ),
                                  ],
                                ),
                              ),
                              //
                              TextFormField(
                                controller: nameEC,
                                validator:
                                    Validatorless.required('Nome obrigatório'),
                                decoration: const InputDecoration(
                                  label: Text('Digite o nome'),
                                ),
                              ),
                              const SizedBox(
                                height: 22,
                              ),
                              TextFormField(
                                controller: cpfOrBenefitNumberEC,
                                validator: Validatorless.multiple(
                                  [
                                    Validatorless.required(
                                        'CPF ou Número do benefício obrigatório'),
                                  ],
                                ),
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly,
                                  CpfInputFormatter(),
                                ],
                                decoration: const InputDecoration(
                                  label: Text(
                                      'Digite o CPF ou Número do benefício'),
                                ),
                                keyboardType:
                                    const TextInputType.numberWithOptions(),
                              ),
                              const SizedBox(
                                height: 22,
                              ),
                              TextFormField(
                                controller: birthDateEC,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Data de nascimento obrigatório';
                                  }
                                  return dateValidator(value);
                                },
                                // validator: Validatorless.multiple([
                                //   Validatorless.required(
                                //       'Data de nascimento obrigatório'),
                                // Validatorless.date(
                                //     'A data informada é inválida'),
                                // ]),
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly,
                                  DataInputFormatter(),
                                ],
                                decoration: const InputDecoration(
                                  label: Text('Digite a data de nascimento'),
                                ),
                                keyboardType:
                                    const TextInputType.numberWithOptions(),
                              ), //
                              // TextFormField(
                              //   controller: birthDateEC,
                              //   validator: Validatorless.multiple([
                              //     Validatorless.required(
                              //         'Data de nascimento obrigatório'),
                              //     // Validatorless.date('A data informada é inválida'),
                              //   ]),
                              //   decoration: const InputDecoration(
                              //     label: Text('Digite a data de nascimento'),
                              //   ),
                              //   keyboardType: TextInputType.datetime,
                              //   onTap: () {
                              //     selectDate(context);
                              //   },
                              // ),
                              //
                              const SizedBox(
                                height: 22,
                              ),
                              Visibility(
                                visible: selectedOptionProduto != 'FGTS' &&
                                    selectedOptionProduto != 'Selecione',
                                child: Column(
                                  children: [
                                    TextFormField(
                                      controller: margemEC,
                                      validator: Validatorless.required(
                                          'Margem é obrigatória'),
                                      decoration: const InputDecoration(
                                        label: Text('Digite a margem'),
                                      ),
                                      keyboardType: TextInputType.number,
                                    ),
                                    const SizedBox(
                                      height: 22,
                                    ),
                                  ],
                                ),
                              ),

                              Visibility(
                                visible: selectedOptionProduto != 'FGTS' &&
                                    selectedOptionProduto != 'Selecione',
                                child: Column(
                                  children: [
                                    FileSelector(
                                      onFileSelected: (File file) {
                                        anexo = file;
                                      },
                                      allowedExtensions: const [
                                        'jpg',
                                        'jpeg',
                                        'png',
                                        'pdf'
                                      ], // Permitir upload de imagens e PDFs
                                      buttonText: 'Selecionar Imagem ou PDF',
                                    ),
                                    const SizedBox(
                                      height: 22,
                                    ),
                                  ],
                                ),
                              ),

                              SizedBox(
                                width: sizeOf.width * .8,
                                height: 48,
                                child: ElevatedButton(
                                  onPressed: () async {
                                    final valid =
                                        formKey.currentState?.validate() ??
                                            false;
                                    if (valid) {
                                      setState(() {
                                        isLoading = true;
                                      });
                                      controller.cadastrarSimulacao(
                                          await createSimulationRegister());
                                    }
                                  },
                                  child: const Text('SIMULAR'),
                                ),
                              )
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
