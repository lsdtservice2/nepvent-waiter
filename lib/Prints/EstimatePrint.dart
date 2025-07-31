// import 'package:intl/intl.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:sunmi_printer_plus/core/enums/enums.dart';
// import 'package:sunmi_printer_plus/core/sunmi/sunmi_printer.dart';
//
// Future estimatePrint(dynamic estimate) async {
//   var currentDate = DateTime.now();
//   var dateFormat = DateFormat("dd-MM-yyyy");
//   var timeFormat = DateFormat('jms');
//   int charPerLine = 32;
//   num totalQty = 0;
//   num total = 0;
//   SharedPreferences.getInstance().then((prefs) async {
//     await SunmiPrinter.initPrinter();
//     await SunmiPrinter.startTransactionPrint(true);
//     await SunmiPrinter.setAlignment(SunmiPrintAlign.CENTER); // Center align
//     await SunmiPrinter.setFontSize(SunmiFontSize.XL); // Set font to very large
//     await SunmiPrinter.printText('PROFORMA INVOICE');
//     await SunmiPrinter.resetFontSize(); // Reset font to medium size
//     await SunmiPrinter.lineWrap(1);
//     await SunmiPrinter.setAlignment(SunmiPrintAlign.LEFT); // Center align
//     await SunmiPrinter.printText('Table No: ${estimate['table']}');
//     await SunmiPrinter.printText('Date(AD): ${dateFormat.format(currentDate)}');
//     await SunmiPrinter.printText('Date(BS): ${estimate['npDate']}');
//     await SunmiPrinter.printText('Time: ${timeFormat.format(currentDate)}');
//     await SunmiPrinter.printText('-' * charPerLine);
//     await SunmiPrinter.printRow(
//       cols: [
//         ColumnMaker(text: 'Items', width: 13, align: SunmiPrintAlign.LEFT),
//         ColumnMaker(text: 'Qty', width: 3, align: SunmiPrintAlign.RIGHT),
//         ColumnMaker(text: 'Rate', width: 6, align: SunmiPrintAlign.RIGHT),
//         ColumnMaker(text: 'Total', width: 8, align: SunmiPrintAlign.RIGHT),
//       ],
//     );
//     await SunmiPrinter.printText('-' * charPerLine);
//     for (var k in estimate['orderDetails']) {
//       totalQty =
//           totalQty +
//           // (k.containsKey('otherCharge')
//           //     ? ((k['vat'] > 0 || k['service_charge'] > 0) ? k['quantity'] : 0)
//           //     : k['quantity']);
//           k['quantity'];
//       total =
//           total +
//           (k['total'] + k['service_charge'] + k['vat']) -
//           (k.containsKey('otherCharge')
//               ? ((k['vat'] == 0 && k['service_charge'] == 0) ? k['total'] : 0)
//               : 0);
//
//       // print(k);
//       await SunmiPrinter.printRow(
//         cols: [
//           ColumnMaker(text: k['item_name'], width: 13, align: SunmiPrintAlign.LEFT),
//           ColumnMaker(text: k['quantity'].toString(), width: 3, align: SunmiPrintAlign.RIGHT),
//           ColumnMaker(text: k['rate'].toString(), width: 6, align: SunmiPrintAlign.RIGHT),
//           ColumnMaker(
//             text: (k['total'] + k['service_charge'] + k['vat']).toStringAsFixed(2),
//             width: 8,
//             align: SunmiPrintAlign.RIGHT,
//           ),
//         ],
//       );
//     }
//     await SunmiPrinter.printText('-' * charPerLine);
//     await SunmiPrinter.printRow(
//       cols: [
//         ColumnMaker(text: 'Total', width: 13, align: SunmiPrintAlign.RIGHT),
//         ColumnMaker(text: totalQty.toString(), width: 3, align: SunmiPrintAlign.RIGHT),
//         ColumnMaker(
//           // text: total.toStringAsFixed(2), width: 14, align: SunmiPrintAlign.RIGHT),
//           text: estimate['billInformation']['final_amount'],
//           width: 15,
//           align: SunmiPrintAlign.RIGHT,
//         ),
//       ],
//     );
//     if (estimate['billInformation']['complimentaryDiscount'] > 0) {
//       await SunmiPrinter.printRow(
//         cols: [
//           ColumnMaker(text: 'Complementary', width: 22, align: SunmiPrintAlign.RIGHT),
//           ColumnMaker(
//             text: estimate['billInformation']['complimentaryDiscount'].toStringAsFixed(2),
//             width: 9,
//             align: SunmiPrintAlign.RIGHT,
//           ),
//         ],
//       );
//     }
//     if (estimate['billInformation']['totalDiscount'] > 0) {
//       await SunmiPrinter.printRow(
//         cols: [
//           ColumnMaker(text: 'Discount', width: 22, align: SunmiPrintAlign.RIGHT),
//           ColumnMaker(
//             text: estimate['billInformation']['totalDiscount'].toStringAsFixed(2),
//             width: 9,
//             align: SunmiPrintAlign.RIGHT,
//           ),
//         ],
//       );
//     }
//     await SunmiPrinter.printText('-' * charPerLine);
//     await SunmiPrinter.lineWrap(1);
//     await SunmiPrinter.printRow(
//       cols: [
//         ColumnMaker(text: 'Payable', width: 16, align: SunmiPrintAlign.RIGHT),
//         ColumnMaker(
//           text: estimate['billInformation']['final_amount'],
//           width: 15,
//           align: SunmiPrintAlign.RIGHT,
//         ),
//       ],
//     );
//     await SunmiPrinter.setAlignment(SunmiPrintAlign.CENTER); // Center align
//     await SunmiPrinter.lineWrap(1);
//     await SunmiPrinter.printText('THIS IS NOT A TAX INVOICE!');
//     await SunmiPrinter.setAlignment(SunmiPrintAlign.CENTER); // Center align
//     await SunmiPrinter.printText('Only for reference.');
//     await SunmiPrinter.lineWrap(3);
//     // await SunmiPrinter.setAlignment(SunmiPrintAlign.LEFT);// Center align
//     await SunmiPrinter.submitTransactionPrint(); // SUBMIT and cut paper
//     await SunmiPrinter.exitTransactionPrint(true);
//   });
//   print(dateFormat.format(currentDate));
//   print(timeFormat.format(currentDate));
// }
