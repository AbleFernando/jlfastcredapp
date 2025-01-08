import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_getit/flutter_getit.dart';
import 'package:jlfastcred/src/modulos/signup/sign_up_controller.dart';
import 'package:jlfastcred_core/jlfastcred_core.dart';
import 'package:signals_flutter/signals_flutter.dart';

import '../consultant/consultant_controller.dart';
import '../find_consultant/find_consultant_controller.dart';
import 'documents_page_controller.dart';

class DocumentsPage extends StatefulWidget {
  const DocumentsPage({super.key});

  @override
  State<DocumentsPage> createState() => _DocumentsPageState();
}

class _DocumentsPageState extends State<DocumentsPage> with MesssageViewMixin {
  final SignUpController signUpController = Injector.get<SignUpController>();
  final findConsultantController = Injector.get<FindConsultantController>();
  final consultantController = Injector.get<ConsultantController>();
  final documentsPageController = Injector.get<DocumentsPageController>();

  bool isLoading = false;

  @override
  void initState() {
    messageListener(signUpController);
    effect(() {
      if (documentsPageController.created) {
        Navigator.of(context).pushReplacementNamed('/auth/login');
      }
    });
    super.initState();
  }

  // late File anexoFrenteDocumento;
  // late File anexoVersoDocumento;
  // late File anexoAntecedenteCriminal;
  // late File anexoSelf;

  File anexoFrenteDocumento = File('');
  File anexoVersoDocumento = File('');
  File anexoAntecedenteCriminal = File('');
  File anexoSelf = File('');

  @override
  Widget build(BuildContext context) {
    var sizeOf = MediaQuery.sizeOf(context);
    return Scaffold(
      appBar: JlfastcredAppBar(),
      body: Align(
        alignment: Alignment.topCenter,
        child: Stack(
          children: [
            SingleChildScrollView(
              child: Container(
                width: sizeOf.width * .85,
                margin: const EdgeInsets.only(top: 18),
                padding: const EdgeInsets.all(32),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: JlfastcredTheme.blueColor),
                ),
                child: Column(
                  children: [
                    Image.asset('assets/images/folder.png'),
                    const SizedBox(
                      height: 24,
                    ),
                    const Text(
                      'ADICIONAR DOCUMENTOS',
                      style: JlfastcredTheme.titleSmallStyle,
                    ),
                    const SizedBox(
                      height: 32,
                    ),
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
                      child: Column(
                        children: [
                          DocumentBoxWidget(
                            icon: Image.asset('assets/images/id_card.png'),
                            label: 'Frente do documento de identificação',
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
                            icon: Image.asset('assets/images/id_card.png'),
                            label: 'Verso do documento de identificação',
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
                          const SizedBox(
                            height: 32,
                          ),
                          DocumentBoxWidget(
                            icon: Image.asset('assets/images/document.png'),
                            label: 'Antecedente criminal',
                            allowedExtensions: const [
                              'jpg',
                              'jpeg',
                              'png',
                              'pdf'
                            ],
                            onFileSelected: (File file) {
                              anexoAntecedenteCriminal = file;
                            },
                          ),
                          const SizedBox(
                            height: 32,
                          ),
                          DocumentBoxWidget(
                            icon: Image.asset(
                                'assets/images/foto_confirm_icon.png'),
                            label: 'Selfie',
                            allowedExtensions: const [
                              'jpg',
                              'jpeg',
                              'png',
                              'pdf'
                            ],
                            onFileSelected: (File file) {
                              anexoSelf = file;
                            },
                          ),
                          const SizedBox(
                            height: 32,
                          ),
                          SizedBox(
                            width: double.infinity,
                            height: 48,
                            child: ElevatedButton(
                                onPressed: () {
                                  setState(() {
                                    isLoading = true;
                                  });
                                  // consultantController.users;
                                  // consultantController.users =
                                  //     signUpController.model;
                                  // controller.goNextStep();
                                  documentsPageController.saveAndNext(
                                      signUpController.model,
                                      anexoFrenteDocumento,
                                      anexoVersoDocumento,
                                      anexoAntecedenteCriminal,
                                      anexoSelf);
                                },
                                child: const Text('FINALIZAR')),
                          ),
                          const SizedBox(
                            height: 24,
                          ),
                          SizedBox(
                            width: double.infinity,
                            height: 48,
                            child: OutlinedButton(
                              onPressed: () {
                                signUpController.clearForm();
                                findConsultantController.clearForm();
                                consultantController.clearForm();
                                Navigator.of(context)
                                    .pushReplacementNamed('/auth/login');
                              },
                              child: const Text('CANCELAR'),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      width: 24,
                    ),
                  ],
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
        ),
      ),
    );
  }
}
