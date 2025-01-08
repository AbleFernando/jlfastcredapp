import 'package:flutter/material.dart';
import 'package:jlfastcred_core/jlfastcred_core.dart';

class ViewImageFieldForm extends StatelessWidget {
  final String label;
  final String margemUrl;

  const ViewImageFieldForm({
    super.key,
    required this.label,
    required this.margemUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (margemUrl.isNotEmpty)
          Stack(
            children: [
              Image.network(
                margemUrl,
                errorBuilder: (context, error, stackTrace) {
                  return const Text('Imagem não disponível');
                },
              ),
              Positioned(
                top: 10,
                left: 10,
                child: Container(
                  color: Colors.black.withOpacity(0.5),
                  padding: const EdgeInsets.all(5),
                  child: Text(
                    label,
                    style: JlfastcredTheme.subTitleSmallStyleWhite,
                  ),
                ),
              ),
            ],
          )
        else
          const Text('Nenhuma imagem disponível'),
        const SizedBox(
          height: 32,
        ),
      ],
    );
  }
}
