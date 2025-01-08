import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Pacote para Clipboard

class ViewTextFieldForm extends StatelessWidget {
  final String label;
  final String initialValue;
  final bool isCopyable;

  const ViewTextFieldForm(
      {super.key,
      required this.label,
      required this.initialValue,
      this.isCopyable = false});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextFormField(
          enabled: true,
          readOnly: true,
          decoration: InputDecoration(
            label: Text(label),
            suffixIcon: Visibility(
              visible: isCopyable,
              child: IconButton(
                icon: const Icon(Icons.copy),
                onPressed: () {
                  Clipboard.setData(ClipboardData(
                      text: initialValue)); // Copia o texto para o clipboard
                  // Exibe o SnackBar confirmando a cópia
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content:
                          Text('$label copiado para a área de transferência'),
                      duration:
                          const Duration(seconds: 2), // Duração do SnackBar
                    ),
                  );
                },
              ),
            ),
          ),
          initialValue: initialValue,
        ),
        const SizedBox(
          height: 22,
        ),
      ],
    );
  }
}
