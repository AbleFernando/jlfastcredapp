import 'package:flutter/material.dart';
import 'package:flutter_getit/flutter_getit.dart';
import 'package:intl/intl.dart';
import 'package:jlfastcred/src/modulos/home/advance/advance_page.dart';
import 'package:jlfastcred/src/modulos/home/home_controller.dart';
import 'package:jlfastcred_core/jlfastcred_core.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:signals_flutter/signals_flutter.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with MesssageViewMixin {
  // final formKey = GlobalKey<FormState>();
  final controller = Injector.get<HomoController>();

  late String tipoCalculo;

  double valorRecever = 0.0;
  late String valorMensal;
  late String valorAnual;
  late String totalClientes;

  @override
  void initState() {
    messageListener(controller);
    controller.obterTotalComissaoConsultor();
    controller.obterValotTotalComissaoPaga();
    controller.obterTotalClientes();
    effect(() {
      valorRecever = controller.totalComissaoConsultor;
      tipoCalculo = controller.tipoCalculo;
      totalClientes = controller.totalClientes.toString();

      if (tipoCalculo == 'comissao') {
        valorAnual = NumberFormat.currency(locale: 'pt_br', symbol: 'R\$')
            .format(controller.valorTotalNoAno);
        valorMensal = NumberFormat.currency(locale: 'pt_br', symbol: 'R\$')
            .format(controller.valorTotalNoMes);
      } else if (tipoCalculo != 'Aguardando') {
        valorAnual = controller.valorTotalNoAno.truncate().toString();
        valorMensal = controller.valorTotalNoMes.truncate().toString();
      } else {
        valorAnual = '0';
        valorMensal = '0';
      }

      if (controller.createdAdvance) {
        Navigator.of(context).pop();
        controller.createdAdvance = false;
      }

      setState(() {});
    });
    super.initState();
  }

  @override
  void dispose() {
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
                  //       Text(AppLabels.menuPerfilUsuario)
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
                  nav.pushNamedAndRemoveUntil('/', (route) => false);
                }
                if (value == 2) {
                  final nav = Navigator.of(context);
                  // final sp = await SharedPreferences.getInstance();

                  // controller.showInfo(
                  //     sp.getString(LocalStorageConstants.userUid).toString());

                  nav.pushReplacementNamed(
                    '/user/info',
                  );
                }
              },
            )
          ],
        ),
        body: LayoutBuilder(builder: (_, constrains) {
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
                      // Top Card
                      Card(
                        // color: JlfastcredTheme.lightGreyColor,
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              const Text(
                                'Valor a receber',
                                style: JlfastcredTheme.subTitleSmallStyle,
                              ),
                              Text(
                                NumberFormat.currency(
                                        locale: 'pt_br', symbol: 'R\$')
                                    .format(valorRecever),
                                style: JlfastcredTheme.subTitleSmallStyleGreen,
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),

                      //Icons Buttons
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          IconButtonWidget(
                            texto: 'Comissão',
                            icon: Icons.calculate,
                            isClick: tipoCalculo == 'comissao',
                            onPressed: () async {
                              controller.obterValotTotalComissaoPaga();
                            },
                          ),
                          IconButtonWidget(
                            texto: 'Simulações',
                            icon: Icons.document_scanner,
                            isClick: tipoCalculo == 'simulacao',
                            onPressed: () async {
                              await controller.obterValoresSimulacao();
                            },
                          ),
                          IconButtonWidget(
                            texto: 'Digitações',
                            icon: Icons.keyboard,
                            isClick: tipoCalculo == 'digitacao',
                            onPressed: () async {
                              await controller.obterValoresDigitacao();
                            },
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 20,
                      ),

                      //Quadro de valores ganhos
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          CardValores(descricao: 'Mensal', valor: valorMensal),
                          CardValores(descricao: 'Anual', valor: valorAnual),
                        ],
                      ),

                      const SizedBox(
                        height: 20,
                      ),

                      SizedBox(
                        width: sizeOf.width * .8,
                        height: 48,
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.of(context)
                                .pushReplacementNamed('/simulation/create');
                          },
                          child: const Text('CRIAR SIMULAÇÃO'),
                        ),
                      ),

                      const SizedBox(
                        height: 40,
                      ),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          SizedBox(
                            width: sizeOf.width * .2,
                            height: 48,
                            child: ElevatedButton(
                              onPressed: () {
                                Navigator.of(context)
                                    .pushReplacementNamed('/simulation/list');
                              },
                              child: const Icon(Icons.edit_document),
                            ),
                          ),

                          // SizedBox(
                          //   width: sizeOf.width * .2,
                          //   height: 48,
                          //   child: ElevatedButton(
                          //       onPressed: () {},
                          //       child:
                          //           const Icon(CupertinoIcons.bag_badge_plus)),
                          // ),
                          // SizedBox(
                          //   width: sizeOf.width * .2,
                          //   height: 48,
                          //   child: ElevatedButton(
                          //     onPressed: () {
                          //       Navigator.of(context)
                          //           .pushReplacementNamed('/client/list');
                          //     },
                          //     child: const Icon(Icons.person),
                          //   ),
                          // ),
                          SizedBox(
                            width: sizeOf.width * .2,
                            height: 48,
                            child: ElevatedButton(
                              onPressed: () {
                                Navigator.of(context)
                                    .pushReplacementNamed('/client/list');
                              },
                              child: Stack(
                                alignment: Alignment.center,
                                clipBehavior: Clip.none,
                                children: [
                                  const Icon(Icons.person),
                                  Positioned(
                                    right: -18,
                                    top: -5,
                                    child: Visibility(
                                      visible: totalClientes != '0',
                                      child: CircleAvatar(
                                        radius: 10,
                                        backgroundColor: Colors.red,
                                        child: Text(
                                          totalClientes,
                                          style: const TextStyle(
                                            fontSize: 12,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),

                          const AdvancePage(),
                        ],
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      SizedBox(
                        width: sizeOf.width * .8,
                        height: 48,
                        child: OutlinedButton(
                          style: OutlinedButton.styleFrom(
                            fixedSize: const Size.fromHeight(48),
                          ),
                          onPressed: () async {
                            final sp = await SharedPreferences.getInstance();
                            String link =
                                'https://webappteste.jlfastcred.com.br/#referral?id=${sp.getString(LocalStorageConstants.userUid)}';

                            final result = await Share.shareWithResult(
                                'Confira este aplicativo incrível: $link');

                            if (result.status == ShareResultStatus.success) {
                              controller
                                  .showSuccess('Obrigado por compartilhar');
                            } else {
                              controller
                                  .showInfo('Que pena, fica para a próxima');
                            }
                          },
                          child: const Text('INDIQUE NOSSO APP'),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      const Text('Desenvolvido por ABLE TECNOLOGIA BRASIL')
                    ],
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}

class CardValores extends StatelessWidget {
  final String descricao;
  final String valor;
  const CardValores({
    super.key,
    required this.descricao,
    required this.valor,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(30),
        child: Column(
          children: <Widget>[
            Text(
              valor,
              style: JlfastcredTheme.subTitleSmallStyleGreen,
            ),
            Text(
              descricao,
              textAlign: TextAlign.center,
              style: JlfastcredTheme.titleSmallStyle,
            ),
          ],
        ),
      ),
    );
  }
}
