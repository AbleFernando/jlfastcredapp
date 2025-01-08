import 'package:flutter/material.dart';
import 'package:flutter_getit/flutter_getit.dart';
import 'package:jlfastcred/src/modulos/simulation/list/list_simulation_controller.dart';
import 'package:jlfastcred_core/jlfastcred_core.dart';

class BuildIconsButtonsSecionWidget extends StatelessWidget {
  final String clickName;

  BuildIconsButtonsSecionWidget({
    required this.clickName,
    super.key,
  });

  final controller = Injector.get<ListSimulationController>();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        IconButtonWidget(
          texto: 'FGTS',
          icon: Icons.search,
          isClick: clickName == 'FGTS',
          onPressed: () async {
            await controller.obterSimulacaoPorTipo('FGTS');
            controller.showSuccess('Filtro aplicado com sucesso');
          },
        ),
        IconButtonWidget(
          texto: 'INSS',
          isClick: clickName == 'INSS',
          icon: Icons.search,
          onPressed: () async {
            await controller.obterSimulacaoPorTipo('INSS');
            controller.showSuccess('Filtro aplicado com sucesso');
          },
        ),
        IconButtonWidget(
          texto: 'SIAPE',
          isClick: clickName == 'SIAPE',
          icon: Icons.search,
          onPressed: () async {
            await controller.obterSimulacaoPorTipo('SIAPE');
            controller.showSuccess('Filtro aplicado com sucesso');
          },
        ),
        IconButtonWidget(
          texto: 'FORÇAS',
          icon: Icons.search,
          isClick: clickName == 'FORÇAS/GOV',
          onPressed: () async {
            await controller.obterSimulacaoPorTipo('FORÇAS/GOV');
            controller.showSuccess('Filtro aplicado com sucesso');
          },
        ),
      ],
    );
  }
}
