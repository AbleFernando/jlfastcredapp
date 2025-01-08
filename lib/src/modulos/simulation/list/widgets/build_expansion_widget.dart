import 'dart:math' as math;
import 'package:expansion_widget/expansion_widget.dart';
import 'package:flutter/material.dart';
import 'package:jlfastcred_core/jlfastcred_core.dart';

class BuildExpansionWidget extends StatelessWidget {
  const BuildExpansionWidget({
    super.key,
    required this.status,
    required this.simulations,
  });
  final String status;
  final List<SimulationModel> simulations;

  @override
  Widget build(BuildContext context) {
    final listSimulations =
        simulations.where((simulation) => simulation.status == status).toList();

    return SingleChildScrollView(
      child: ExpansionWidget(
        initiallyExpanded: false,
        titleBuilder:
            (double animationValue, _, bool isExpaned, toogleFunction) {
          return InkWell(
              onTap: () => toogleFunction(animated: true),
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                        child: Text(
                      '$status (${listSimulations.length.toString()})',
                      style: JlfastcredTheme.titleSmallStyle
                          .copyWith(fontWeight: FontWeight.w500),
                    )),
                    Transform.rotate(
                      alignment: Alignment.center,
                      angle: math.pi * animationValue / 2,
                      child: const Icon(
                        Icons.arrow_right,
                        size: 40,
                      ),
                    )
                  ],
                ),
              ));
        },
        content: Column(
          children: listSimulations.map((doc) {
            return SimulationCardWidget(simulation: doc);
          }).toList(),
        ),
      ),
    );
  }
}
