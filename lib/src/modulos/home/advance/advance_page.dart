import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_getit/flutter_getit.dart';
import 'package:jlfastcred_core/jlfastcred_core.dart';

import '../home_controller.dart';

class AdvancePage extends StatefulWidget {
  const AdvancePage({super.key});

  @override
  State<AdvancePage> createState() => _AdvancePageState();
}

class _AdvancePageState extends State<AdvancePage> {
  final controller = Injector.get<HomoController>();

  @override
  Widget build(BuildContext context) {
    // Tamanho da tela
    final sizeOf = MediaQuery.of(context).size;
    return SizedBox(
      width: sizeOf.width * .2,
      height: 48,
      child: ElevatedButton(
        onPressed: () {
          //validar se não existe uma solicitação já realizada.
          //validar se o usuário pode fazer a solicitação.

          // Função para abrir o diálogo
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text(
                  'Atenção !',
                  style: JlfastcredTheme.titleSmallStyle,
                ),
                content: const Text(
                  'O adiantamento da sua comissão será realizado em até 48 horas e descontado 10%. \n \n Deseja prosseguir?',
                  style: JlfastcredTheme.subTitleSmallStyle,
                ),
                actions: <Widget>[
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text(
                      'Cancelar',
                      style: JlfastcredTheme.subTitleSmallStyleRed,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      controller.requestAdvance();
                    },
                    child: const Text(
                      'Confirmar',
                      style: JlfastcredTheme.subTitleSmallStyleGreen,
                    ),
                  )
                ],
              );
            },
          );
        },
        child: const Icon(CupertinoIcons.bag_badge_plus),
      ),
    );
  }
}
