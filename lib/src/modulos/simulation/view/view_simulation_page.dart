import 'package:flutter/material.dart';
import 'package:flutter_getit/flutter_getit.dart';
import 'package:jlfastcred/src/modulos/simulation/view/view_simulation_controller.dart';
import 'package:jlfastcred/src/modulos/simulation/view/widgets/view_image_field_form.dart';
import 'package:jlfastcred/src/modulos/simulation/view/widgets/view_text_field_form.dart';
import 'package:jlfastcred_core/jlfastcred_core.dart';
import 'package:signals_flutter/signals_flutter.dart';

class ViewSimulationPage extends StatefulWidget {
  const ViewSimulationPage({super.key});

  @override
  State<ViewSimulationPage> createState() => _ViewSimulationPageState();
}

class _ViewSimulationPageState extends State<ViewSimulationPage>
    with MesssageViewMixin {
  final controller = Injector.get<ViewSimulationController>();

  bool isLoading = false;

  @override
  void initState() {
    messageListener(controller);
    effect(() {
      if (controller.created) {
        Navigator.of(context).pushReplacementNamed('/simulation/list');
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // final SimulationModel(
    //   :name,
    //   :cpfOrBenefitNumber,
    //   :birthDate,
    //   :operationType,
    //   :id,
    //   :numeroProposta,
    //   :pontosFastCred,
    //   :comissao,
    //   :link,
    //   :dataDigitacao,
    //   :banco,
    //   :consultant,
    //   :imageUrls,
    //   :statusDigitacao,
    //   :status,
    //   :margemUrl,
    //   :motivoPendencia,
    // ) = controller.simulationForm.watch(context)!;

    final simulation = controller.simulationForm.watch(context)!;

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
              Navigator.of(context).pushReplacementNamed('/simulation/list');
            },
          ),
          actions: [
            PopupMenuButton(
              child: const IconPopupMenuWidget(),
              itemBuilder: (context) {
                return const [
                  // PopupMenuItem(
                  //   value: 2,
                  //   child: Row(
                  //     children: [
                  //       Icon(Icons.account_circle),
                  //       Text(AppLabels.menuPerfilUsuario),
                  //     ],
                  //   ),
                  // ),
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
                        height: sizeOf.height * 5.2,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Form(
                          child: Column(
                            children: [
                              const HeaderWidget(
                                  image: 'assets/images/document.png',
                                  texto: 'Dados da Simulação'),

                              ViewTextFieldForm(
                                  label: 'ID', initialValue: simulation.id),
                              ViewTextFieldForm(
                                  label: 'Nome', initialValue: simulation.name),
                              ViewTextFieldForm(
                                  label: 'Tipo de Operação',
                                  initialValue: simulation.operationType),
                              ViewTextFieldForm(
                                  label: 'CPF ou Número do Benefício',
                                  initialValue: simulation.cpfOrBenefitNumber),
                              ViewTextFieldForm(
                                label: 'Data de Nascimento',
                                initialValue: controller.formatarData(
                                    simulation.birthDate, "dd/MM/yyyy"),
                              ),
                              ViewTextFieldForm(
                                label: 'Margem',
                                initialValue:
                                    simulation.margem.toStringAsFixed(2),
                              ),
                              //IMG MARGEM
                              ViewImageFieldForm(
                                label: 'Margem',
                                margemUrl: simulation.margemUrl,
                              ),
                              ViewTextFieldForm(
                                label: 'Consultor',
                                initialValue: simulation.consultant.name,
                              ),
                              ViewTextFieldForm(
                                label: 'Contato',
                                initialValue: simulation.consultant.contato,
                              ),
                              const SizedBox(
                                height: 10,
                              ),

                              Visibility(
                                visible: simulation.status != 'Nova',
                                child: const HeaderWidget(
                                    image: 'assets/images/stroke_check.png',
                                    texto: 'Resultado'),
                              ),

                              Visibility(
                                visible: simulation.status == 'Devolvida',
                                child: Column(
                                  children: [
                                    ViewTextFieldForm(
                                        label: 'Motivo devoluçao',
                                        initialValue:
                                            simulation.motivoPendencia),
                                  ],
                                ),
                              ),

                              Visibility(
                                visible: simulation.status != 'Nova',
                                child: Image.network(
                                    simulation.imageUrls.isNotEmpty
                                        ? simulation.imageUrls[0]
                                        : ''),
                              ),
                              Visibility(
                                visible: (simulation.statusDigitacao ==
                                        'Em andamento') ||
                                    // (simulation.statusDigitacao == 'Paga') ||
                                    // (simulation.statusDigitacao ==
                                    //     'Reprovada') ||
                                    // (simulation.statusDigitacao == 'Integrada'),
                                    (simulation.statusDigitacao !=
                                        'Aguardando Digitação'),
                                child: Column(
                                  children: [
                                    ViewTextFieldForm(
                                      label: 'Número da Proposta',
                                      initialValue: simulation.numeroProposta,
                                    ),
                                    ViewTextFieldForm(
                                      label: 'Pontos FastCred',
                                      initialValue:
                                          simulation.pontosFastCred.toString(),
                                    ),
                                    ViewTextFieldForm(
                                      label: 'Pontos do Consultor',
                                      initialValue:
                                          simulation.comissao.toString(),
                                    ),
                                    ViewTextFieldForm(
                                      label: 'Link',
                                      initialValue: simulation.link,
                                      isCopyable: true,
                                    ),
                                    ViewTextFieldForm(
                                      label: 'Data da Digitação',
                                      initialValue: simulation.dataDigitacao,
                                    ),
                                    ViewTextFieldForm(
                                      label: 'Banco',
                                      initialValue: simulation.banco,
                                    ),
                                  ],
                                ),
                              ),

                              const SizedBox(
                                height: 32,
                              ),

                              Visibility(
                                visible: simulation.status == 'Devolvida',
                                child: SizedBox(
                                  width: sizeOf.width * .8,
                                  height: 48,
                                  child: ElevatedButton(
                                    onPressed: () async {
                                      setState(() {
                                        isLoading = true;
                                      });
                                      controller.reenviarSimulacao(
                                        simulation.copyWith(
                                            status: 'Nova',
                                            statusDigitacao:
                                                'Aguardando Aprovação'),
                                      );
                                    },
                                    child: const Text('REENVIAR'),
                                  ),
                                ),
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
