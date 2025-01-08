import 'package:flutter/material.dart';
import 'package:flutter_getit/flutter_getit.dart';
import 'package:jlfastcred/src/modulos/client/list/list_client_controller.dart';
import 'package:jlfastcred_core/jlfastcred_core.dart';
import 'package:signals_flutter/signals_flutter.dart';

class ListClientPage extends StatefulWidget {
  const ListClientPage({super.key});

  @override
  State<ListClientPage> createState() => _ListClientPageState();
}

class _ListClientPageState extends State<ListClientPage>
    with MesssageViewMixin {
  List<SimulationModel> simulations = [];
  final controller = Injector.get<ListClientController>();

  @override
  void initState() {
    messageListener(controller);
    controller.searchClientForRegister();
    effect(() {
      simulations = controller.listClient;
      setState(() {
        controller.clearAllMessages();
      });
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
            return SingleChildScrollView(
              child: Container(
                constraints: BoxConstraints(minHeight: constrains.maxHeight),
                child: Center(
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    width: sizeOf.width,
                    height: sizeOf.height,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      children: [
                        Expanded(
                          child: SingleChildScrollView(
                            child: Column(
                              children: simulations.map(
                                (doc) {
                                  return ClientCardWidget(simulation: doc);
                                },
                              ).toList(),
                            ),
                          ),
                        ),
                      ],
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
