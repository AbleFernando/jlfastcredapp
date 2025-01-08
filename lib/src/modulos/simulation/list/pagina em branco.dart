// import 'package:flutter/material.dart';
// import 'package:jlfastcred_core/jlfastcred_core.dart';

// class ListSimulationPage extends StatelessWidget {
//   const ListSimulationPage({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return PopScope(
//       canPop: false,
//       onPopInvoked: (didPop) {
//         // selfServiceController.clearForm();
//       },
//       child: Scaffold(
//         appBar: JlfastcredAppBar(
//           actions: [
//             PopupMenuButton(
//               child: const IconPopupMenuWidget(),
//               itemBuilder: (context) {
//                 return const [
//                   PopupMenuItem(
//                     value: 2,
//                     child: Row(
//                       children: [Icon(Icons.settings), Text('Configurações')],
//                     ),
//                   ),
//                   PopupMenuItem(
//                     value: 1,
//                     child: Row(
//                       children: [
//                         Icon(Icons.exit_to_app),
//                         Text('Finalizar Aplicativo')
//                       ],
//                     ),
//                   ),
//                 ];
//               },
//               onSelected: (value) async {
//                 if (value == 1) {
//                   final nav = Navigator.of(context);
//                   // await SharedPreferences.getInstance()
//                   // .then((sp) => sp.clear());
//                   nav.pushNamedAndRemoveUntil('/', (route) => false);
//                 }
//               },
//             )
//           ],
//         ),
//         body: LayoutBuilder(
//           builder: (_, constrains) {
//             var sizeOf = MediaQuery.sizeOf(context);
//             return SingleChildScrollView(
//               child: Container(
//                 constraints: BoxConstraints(minHeight: constrains.maxHeight),
//                 child: Center(
//                   child: Container(
//                     padding: const EdgeInsets.all(20),
//                     width: sizeOf.width,
//                     height: sizeOf.height,
//                     decoration: BoxDecoration(
//                       color: Colors.white,
//                       borderRadius: BorderRadius.circular(16),
//                     ),
//                     child: Container(),
//                   ),
//                 ),
//               ),
//             );
//           },
//         ),
//       ),
//     );
//   }
// }
