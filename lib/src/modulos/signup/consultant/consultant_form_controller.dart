import 'package:flutter/material.dart';
import 'package:jlfastcred/src/modulos/signup/consultant/consultant_page.dart';
import 'package:jlfastcred_core/jlfastcred_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

mixin ConsultantFormController on State<ConsultantPage> {
  final formKey = GlobalKey<FormState>();

  final passwordEC = TextEditingController();

  final nameEC = TextEditingController();
  final emailEC = TextEditingController();
  final phoneEC = TextEditingController();

  final documentEC = TextEditingController();

  final addressEC = TextEditingController();
  final numberEC = TextEditingController();
  final complementEC = TextEditingController();
  final cepEC = TextEditingController();
  final neighborhoodEC = TextEditingController();
  final cityEC = TextEditingController();
  final stateEC = TextEditingController();
  final districtEC = TextEditingController();

  final bankEC = TextEditingController();
  final accountEC = TextEditingController();
  final pixEC = TextEditingController();
  final branchEC = TextEditingController();

  // Variável que mantém o banco selecionado
  BankDetails? selectedBank;

  @override
  void dispose() {
    passwordEC.dispose();
    nameEC.dispose();
    emailEC.dispose();
    phoneEC.dispose();
    documentEC.dispose();
    addressEC.dispose();
    numberEC.dispose();
    complementEC.dispose();
    cepEC.dispose();
    neighborhoodEC.dispose();
    cityEC.dispose();
    stateEC.dispose();
    districtEC.dispose();
    bankEC.dispose();
    accountEC.dispose();
    pixEC.dispose();
    branchEC.dispose();
    super.dispose();
  }

  void initializeForm(final Users? model) {
    if (model != null) {
      nameEC.text = model.name;
      emailEC.text = model.email;
      phoneEC.text = model.contato;
      documentEC.text = model.cpf;
      cepEC.text = model.cep;
      addressEC.text = model.endereco;
      numberEC.text = model.numero;
      complementEC.text = model.complemento;
      stateEC.text = model.uf;
      cityEC.text = model.cidade;
      districtEC.text = model.bairro;
      bankEC.text = model.dadosBancarios.bankName;
      accountEC.text = model.dadosBancarios.accountNumber;
      pixEC.text = model.dadosBancarios.pixKey;
      branchEC.text = model.dadosBancarios.branchNumber;
    }
  }

  Users createUsersRegister() {
    return Users(
      id: '',
      passWord: passwordEC.text,
      bairro: districtEC.text,
      cep: cepEC.text,
      cidade: cityEC.text,
      complemento: complementEC.text,
      contato: phoneEC.text,
      cpf: documentEC.text,
      email: emailEC.text,
      endereco: addressEC.text,
      name: nameEC.text,
      numero: numberEC.text,
      perfil: UsersPerfil.consultor.name,
      status: UsersStatus.cadastrando.name,
      uf: stateEC.text,
      dadosBancarios: BankingInformation(
        accountNumber: accountEC.text,
        bankName: bankEC.text,
        branchNumber: branchEC.text,
        pixKey: pixEC.text,
        tipoConta: '',
      ),
      urls: Urls.empty(),
      isReferral: false,
      referral: Referral.empty(),
      motivoPendencia: '',
      dataCadastro: Timestamp.fromDate(DateTime.now()),
    );
  }

  void initializeCep(final CepV1 cepV1) {
    addressEC.text = cepV1.street;
    cityEC.text = cepV1.city;
    stateEC.text = cepV1.state;
    districtEC.text = cepV1.neighborhood;
  }
}
