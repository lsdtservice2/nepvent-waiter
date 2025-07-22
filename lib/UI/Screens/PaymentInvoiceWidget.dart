import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:nepvent_waiter/UI/Design/AppTheme.dart';
import 'package:nepvent_waiter/UI/Design/CustomFloatingActionButton.dart';
import 'package:nepvent_waiter/UI/Design/FonePayPaymentDialog.dart';
import 'package:nepvent_waiter/UI/Screens/TableSelectionWidget.dart';
import 'package:nepvent_waiter/Utils/Constant.dart';
import 'package:nepvent_waiter/Utils/Urls.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class PaymentInvoiceWidget extends StatefulWidget {
  const PaymentInvoiceWidget({super.key, required this.invoiceId});

  final String invoiceId;

  @override
  State<PaymentInvoiceWidget> createState() => _PaymentInvoiceWidgetState();
}

class _PaymentInvoiceWidgetState extends State<PaymentInvoiceWidget> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  late Future _invoice;
  dynamic invoiceValue;
  List<Widget> items = [];
  late bool printerIntegrated;
  late String invoiceNumber;
  late double finalAmount;
  late double paidAmount;
  late double remainingAmount;
  List<dynamic> qrPayments = [];
  bool isLoadingQR = false;
  List<Widget> qrStack = [];

  @override
  void initState() {
    super.initState();
    _invoice = getInvoice();
  }

  @override
  void dispose() {
    super.dispose();
  }

  // Future<void> _showDQRDialog(dqr, Map<String, dynamic> requestData) async {
  //   // late StateSetter _setState;
  //   String status = 'AWAITING';
  //   if (dqr['merchantWebSocketUrl'] != null) {
  //     final wsUrl = Uri.parse(dqr['merchantWebSocketUrl']);
  //     final channel = WebSocketChannel.connect(wsUrl);
  //     String paymentReference = dqr['referenceNumber'];
  //
  //     setStatus(String val) async {
  //       if (val == 'RES000') {
  //         status = 'SUCCESS';
  //       } else {
  //         status = val.toUpperCase();
  //       }
  //       qrStack = [];
  //       qrStack.add(
  //         Container(
  //           decoration: BoxDecoration(
  //             borderRadius: BorderRadius.circular(12),
  //             border: Border.all(color: Colors.grey.shade300, width: 1),
  //           ),
  //           child: SizedBox(
  //             width: 220.0,
  //             height: 220.0,
  //             child: QrImageView(
  //               data: dqr['qrMessage'],
  //               version: QrVersions.auto,
  //               size: 220.0,
  //               backgroundColor: Colors.white,
  //               embeddedImage: const AssetImage('assets/images/fonepayLogo.png'),
  //               embeddedImageStyle: QrEmbeddedImageStyle(size: Size(40, 40)),
  //             ),
  //           ),
  //         ),
  //       );
  //       if (status == 'SUCCESS') {
  //         qrStack.add(
  //           Positioned.fill(
  //             child: Container(
  //               decoration: BoxDecoration(
  //                 color: Colors.black.withOpacity(0.5),
  //                 borderRadius: BorderRadius.circular(12),
  //               ),
  //               child: Center(
  //                 child: Lottie.asset(
  //                   'assets/lottie_animations/tick.json',
  //                   width: 100,
  //                   height: 100,
  //                   fit: BoxFit.cover,
  //                 ),
  //               ),
  //             ),
  //           ),
  //         );
  //       }
  //     }
  //
  //     setStatus(await checkPaymentStatus(paymentReference));
  //
  //     await channel.ready;
  //     channel.stream.listen((message) async {
  //       setState(() {
  //         final body = json.decode(message);
  //         setStatus(json.decode(body['transactionStatus'])['message'].toString().toUpperCase());
  //       });
  //       setStatus(await checkPaymentStatus(paymentReference));
  //     });
  //     return showDialog<void>(
  //       context: context,
  //       barrierDismissible: false,
  //       builder: (BuildContext context) {
  //         return StatefulBuilder(
  //           builder: (context, StateSetter setState) {
  //             setState = setState;
  //             return Dialog(
  //               shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
  //               elevation: 4,
  //               child: Container(
  //                 padding: const EdgeInsets.all(24),
  //                 decoration: BoxDecoration(
  //                   color: Colors.white,
  //                   borderRadius: BorderRadius.circular(24),
  //                 ),
  //                 child: Column(
  //                   mainAxisSize: MainAxisSize.min,
  //                   children: [
  //                     // Header with logo
  //                     Column(
  //                       children: [
  //                         Image.asset('assets/images/nepventLogo.png', width: 180, height: 55),
  //                         const SizedBox(height: 12),
  //                         Text(
  //                           'Scan to Pay',
  //                           style: GoogleFonts.poppins(
  //                             fontSize: 20,
  //                             fontWeight: FontWeight.w600,
  //                             color: Colors.blue.shade800,
  //                           ),
  //                         ),
  //                       ],
  //                     ),
  //
  //                     const SizedBox(height: 20),
  //
  //                     // Payment details card
  //                     Container(
  //                       padding: const EdgeInsets.all(16),
  //                       decoration: BoxDecoration(
  //                         color: Colors.grey.shade50,
  //                         borderRadius: BorderRadius.circular(12),
  //                         border: Border.all(color: Colors.grey.shade200),
  //                       ),
  //                       child: Column(
  //                         children: [
  //                           // Reference Number
  //                           Row(
  //                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                             children: [
  //                               Text(
  //                                 'Reference Number',
  //                                 style: GoogleFonts.poppins(
  //                                   fontSize: 13,
  //                                   color: Colors.grey.shade600,
  //                                 ),
  //                               ),
  //                               Text(
  //                                 paymentReference,
  //                                 style: GoogleFonts.poppins(
  //                                   fontSize: 14,
  //                                   fontWeight: FontWeight.w600,
  //                                   color: Colors.blue.shade800,
  //                                 ),
  //                               ),
  //                             ],
  //                           ),
  //
  //                           const SizedBox(height: 12),
  //
  //                           // Divider
  //                           Divider(color: Colors.grey.shade300, height: 1),
  //
  //                           const SizedBox(height: 12),
  //
  //                           // Amount
  //                           Column(
  //                             children: [
  //                               Text(
  //                                 'Amount to Pay',
  //                                 style: GoogleFonts.poppins(
  //                                   fontSize: 14,
  //                                   color: Colors.grey.shade600,
  //                                 ),
  //                               ),
  //                               const SizedBox(height: 4),
  //                               Text(
  //                                 'Rs. ${requestData['paymentAmount'].toString()}',
  //                                 style: GoogleFonts.poppins(
  //                                   fontSize: 28,
  //                                   fontWeight: FontWeight.bold,
  //                                   color: Colors.green.shade700,
  //                                 ),
  //                               ),
  //                             ],
  //                           ),
  //                         ],
  //                       ),
  //                     ),
  //
  //                     const SizedBox(height: 24),
  //
  //                     // QR Code Section
  //                     Container(
  //                       height: 250,
  //                       padding: const EdgeInsets.all(12),
  //                       decoration: BoxDecoration(
  //                         color: Colors.grey.shade50,
  //                         borderRadius: BorderRadius.circular(12),
  //                         border: Border.all(color: Colors.grey.shade200),
  //                       ),
  //                       child: Stack(alignment: Alignment.center, children: qrStack),
  //                     ),
  //
  //                     const SizedBox(height: 20),
  //
  //                     // Status badge
  //                     Container(
  //                       padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
  //                       decoration: BoxDecoration(
  //                         color: _getStatusColor(status).withOpacity(0.1),
  //                         borderRadius: BorderRadius.circular(24),
  //                         border: Border.all(
  //                           color: _getStatusColor(status).withOpacity(0.3),
  //                           width: 1,
  //                         ),
  //                       ),
  //                       child: Row(
  //                         mainAxisSize: MainAxisSize.min,
  //                         children: [
  //                           if (status == 'SUCCESS')
  //                             Icon(Icons.check_circle, color: _getStatusColor(status), size: 18),
  //                           if (status == 'PENDING')
  //                             Icon(Icons.access_time, color: _getStatusColor(status), size: 18),
  //                           const SizedBox(width: 8),
  //                           Text(
  //                             status,
  //                             style: GoogleFonts.poppins(
  //                               fontSize: 16,
  //                               fontWeight: FontWeight.w600,
  //                               color: _getStatusColor(status),
  //                             ),
  //                           ),
  //                         ],
  //                       ),
  //                     ),
  //
  //                     const SizedBox(height: 20),
  //
  //                     // Check Status Button
  //                     if (status != 'SUCCESS')
  //                       SizedBox(
  //                         width: double.infinity,
  //                         child: ElevatedButton(
  //                           onPressed: () async {
  //                             setState(() => isLoadingQR = true);
  //                             setStatus(await checkPaymentStatus(paymentReference));
  //                             setState(() => isLoadingQR = false);
  //                             setState(() {});
  //                           },
  //                           style: ElevatedButton.styleFrom(
  //                             backgroundColor: Colors.blue.shade700,
  //                             shape: RoundedRectangleBorder(
  //                               borderRadius: BorderRadius.circular(12),
  //                             ),
  //                             padding: const EdgeInsets.symmetric(vertical: 16),
  //                             elevation: 0,
  //                             shadowColor: Colors.transparent,
  //                           ),
  //                           child: isLoadingQR
  //                               ? const SizedBox(
  //                                   width: 20,
  //                                   height: 20,
  //                                   child: CircularProgressIndicator(
  //                                     color: Colors.white,
  //                                     strokeWidth: 2,
  //                                   ),
  //                                 )
  //                               : Text(
  //                                   'Check Payment Status',
  //                                   style: GoogleFonts.poppins(
  //                                     fontSize: 16,
  //                                     fontWeight: FontWeight.w500,
  //                                     color: Colors.white,
  //                                   ),
  //                                 ),
  //                         ),
  //                       ),
  //
  //                     const SizedBox(height: 16),
  //
  //                     // Footer logo
  //                     Image.asset('assets/images/fonepayLogo.png', width: 140, height: 42),
  //
  //                     const SizedBox(height: 8),
  //
  //                     // Close button
  //                     TextButton(
  //                       onPressed: () {
  //                         Navigator.pop(context);
  //                         setState(() => isLoadingQR = false);
  //                       },
  //                       child: Text(
  //                         'Close',
  //                         style: GoogleFonts.poppins(
  //                           color: Colors.blue.shade700,
  //                           fontWeight: FontWeight.w500,
  //                           fontSize: 16,
  //                         ),
  //                       ),
  //                     ),
  //                   ],
  //                 ),
  //               ),
  //             );
  //           },
  //         );
  //       },
  //     );
  //
  //     // return showDialog<void>(
  //     //   context: context,
  //     //   barrierDismissible: false,
  //     //   builder: (BuildContext context) {
  //     //     return StatefulBuilder(builder: (context, StateSetter setState) {
  //     //       _setState = setState;
  //     //       return AlertDialog(
  //     //           shape: RoundedRectangleBorder(
  //     //           borderRadius: BorderRadius.circular(16),
  //     //       title: Column(
  //     //       children: [
  //     //       Image.asset(
  //     //       'assets/images/nepventLogo.png',
  //     //       width: 150,
  //     //       height: 46,
  //     //       ),
  //     //       const SizedBox(height: 8),
  //     //       Text(
  //     //       'Scan to Pay',
  //     //       style: GoogleFonts.poppins(
  //     //       fontSize: 18,
  //     //       fontWeight: FontWeight.w600,
  //     //       ),
  //     //       ),
  //     //       ],
  //     //       ),
  //     //       content: SingleChildScrollView(
  //     //       child: Column(
  //     //       mainAxisSize: MainAxisSize.min,
  //     //       children: <Widget>[
  //     //       Container(
  //     //       padding: const EdgeInsets.all(12),
  //     //       decoration: BoxDecoration(
  //     //       color: Colors.grey.shade100,
  //     //       borderRadius: BorderRadius.circular(8),
  //     //       ),
  //     //       child: Column(
  //     //       children: [
  //     //       Text(
  //     //       'Reference Number',
  //     //       style: GoogleFonts.poppins(
  //     //       fontSize: 12,
  //     //       color: Colors.grey.shade600,
  //     //       ),
  //     //       ),
  //     //       Text(
  //     //       paymentReference,
  //     //       style: GoogleFonts.poppins(
  //     //       fontSize: 14,
  //     //       fontWeight: FontWeight.w600,
  //     //       ),
  //     //       ),
  //     //       ],
  //     //       ),
  //     //       ),
  //     //       const SizedBox(height: 16),
  //     //       Text(
  //     //       'Amount to Pay',
  //     //       style: GoogleFonts.poppins(
  //     //       fontSize: 14,
  //     //       color: Colors.grey.shade600,
  //     //       ),
  //     //       ),
  //     //       Text(
  //     //       'Rs. ${requestData['paymentAmount'].toString()}',
  //     //       style: GoogleFonts.poppins(
  //     //       fontSize: 24,
  //     //       fontWeight: FontWeight.bold,
  //     //       color: Colors.green.shade700,
  //     //       ),
  //     //       ),
  //     //       const SizedBox(height: 20),
  //     //       SizedBox(
  //     //       height: 250,
  //     //       child: Stack(
  //     //       alignment: Alignment.center,
  //     //       children: qrStack,
  //     //       ),
  //     //       ),
  //     //       const SizedBox(height: 16),
  //     //       Container(
  //     //       padding: const EdgeInsets.symmetric(
  //     //       horizontal: 16, vertical: 8),
  //     //       decoration: BoxDecoration(
  //     //       color: _getStatusColor(status).withOpacity(0.2),
  //     //       borderRadius: BorderRadius.circular(20),
  //     //       ),
  //     //       child: Text(
  //     //       status,
  //     //       style: GoogleFonts.poppins(
  //     //       fontSize: 16,
  //     //       fontWeight: FontWeight.w600,
  //     //       color: _getStatusColor(status),
  //     //       ),
  //     //       ),
  //     //       ),
  //     //       const SizedBox(height: 16),
  //     //       if (status != 'SUCCESS')
  //     //       ElevatedButton(
  //     //       onPressed: () async {
  //     //       setState(() => isLoadingQR = true);
  //     //       setStatus(await checkPaymentStatus(paymentReference));
  //     //       setState(() => isLoadingQR = false);
  //     //       _setState(() {});
  //     //       },
  //     //       style: ElevatedButton.styleFrom(
  //     //       backgroundColor: Colors.blue.shade700,
  //     //       shape: RoundedRectangleBorder(
  //     //       borderRadius: BorderRadius.circular(10),
  //     //       ),
  //     //       padding: const EdgeInsets.symmetric(
  //     //       horizontal: 24, vertical: 12),
  //     //       ),
  //     //       child: isLoadingQR
  //     //       ? const SizedBox(
  //     //       width: 20,
  //     //       height: 20,
  //     //       child: CircularProgressIndicator(
  //     //       color: Colors.white,
  //     //       strokeWidth: 2,
  //     //       ),
  //     //       )
  //     //           : Text(
  //     //       'Check Status',
  //     //       style: GoogleFonts.poppins(
  //     //       fontSize: 14,
  //     //       fontWeight: FontWeight.w500,
  //     //       color: Colors.white,
  //     //       ),
  //     //       ),
  //     //       ),
  //     //       const SizedBox(height: 16),
  //     //       Image.asset(
  //     //       'assets/images/fonepayLogo.png',
  //     //       width: 120,
  //     //       height: 36,
  //     //       ),
  //     //       ],
  //     //       ),
  //     //       ),
  //     //       actions: <Widget>[
  //     //       TextButton(
  //     //       child: Text(
  //     //       'Close',
  //     //       style: GoogleFonts.poppins(
  //     //       color: Colors.blue.shade700,
  //     //       fontWeight: FontWeight.w500,
  //     //       ),
  //     //       ),
  //     //       onPressed: () {
  //     //       Navigator.pop(context);
  //     //       setState(() => isLoadingQR = false);
  //     //       },
  //     //       ),
  //     //       ],
  //     //           ),
  //     //       );
  //     //     });
  //     //   },
  //     // );
  //   }
  // }
  Future<void> _showDQRDialog(dqr, Map<String, dynamic> requestData) async {
    if (dqr['merchantWebSocketUrl'] == null) return;

    final wsUrl = Uri.parse(dqr['merchantWebSocketUrl']);
    final channel = WebSocketChannel.connect(wsUrl);
    final paymentReference = dqr['referenceNumber'];

    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return FonePayPaymentDialog(
          channel: channel,
          paymentReference: paymentReference,
          requestData: requestData,
          qrMessage: dqr['qrMessage'],
          checkPaymentStatus: checkPaymentStatus,
        );
      },
    );
  }

  // Color _getStatusColor(String status) {
  //   switch (status) {
  //     case 'SUCCESS':
  //       return Colors.green.shade700;
  //     case 'AWAITING':
  //       return Colors.orange.shade700;
  //     case 'FAILED':
  //       return Colors.red.shade700;
  //     default:
  //       return Colors.grey.shade700;
  //   }
  // }

  Future<String> checkPaymentStatus(dynamic paymentReference) async {
    String encoded = '${urls['checkDQRStatus']!}${Uri.encodeComponent(paymentReference)}/status';
    var res = await dio.get(encoded);
    return res.data['message']['paymentStatus'].toString().toUpperCase();
  }

  Future<void> chkRemainingPayment(dynamic po) async {
    setState(() => isLoadingQR = true);

    if (remainingAmount == 0) {
      showDialog<String>(
        context: context,
        builder: (BuildContext context) => Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
          elevation: 0,
          backgroundColor: Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Success icon
                Icon(Icons.check_circle, color: Colors.green.shade600, size: 64),
                const SizedBox(height: 16),

                // Title
                Text(
                  'Payment Completed',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey.shade800,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 12),

                // Content
                Text(
                  'This invoice has already been fully paid.',
                  style: TextStyle(fontSize: 16, color: Colors.grey.shade600),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),

                // Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue.shade700,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      elevation: 0,
                    ),
                    onPressed: () {
                      Navigator.pop(context, 'OK');
                      setState(() => isLoadingQR = false);
                    },
                    child: const Text(
                      'OK',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
      return;
    }

    try {
      // Check for existing QR payments with same amount
      List chkPrevQrGenerate = qrPayments.where((i) => i['amount'] == remainingAmount).toList();

      var requestData = {
        'invoiceId': int.parse(widget.invoiceId),
        'paymentAmount': remainingAmount,
      };

      dynamic dqr;

      if (chkPrevQrGenerate.isNotEmpty) {
        requestData['paymentOptionId'] = chkPrevQrGenerate[0]['Payment_Option']['id'];
        dqr = chkPrevQrGenerate[0]['qrResponse'];
        dqr['referenceNumber'] = chkPrevQrGenerate[0]['referenceNumber'];
      } else {
        requestData['paymentOptionId'] = po['id'];
        var res = await dio.post(urls['generateDQR']!, data: requestData);
        dqr = res.data['message'];
      }

      await _showDQRDialog(dqr, requestData);
    } catch (e) {
      showDialog(
        context: context,
        builder: (context) => Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
          elevation: 0,
          backgroundColor: Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Error icon
                Icon(Icons.error_outline_rounded, color: Colors.red.shade600, size: 64),
                const SizedBox(height: 16),

                // Title
                Text(
                  'Error',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey.shade800,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 12),

                // Content
                Text(
                  'Failed to generate payment QR.\nPlease try again later.',
                  style: TextStyle(fontSize: 16, color: Colors.grey.shade600),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),

                // Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue.shade700,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      elevation: 0,
                    ),
                    onPressed: () => Navigator.pop(context),
                    child: const Text(
                      'OK',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    } finally {
      setState(() => isLoadingQR = false);
    }
  }

  Future getInvoice() async {
    try {
      final response = await dio.get(urls['getInvoice']! + widget.invoiceId);
      final invoiceData = response.data['message'];

      invoiceNumber = invoiceData["invoice_number"];
      List<dynamic> payments = invoiceData["Payments"];
      final paymentOptions = await dio.get(urls['paymentOptions']!);

      Iterable<dynamic>? pos = paymentOptions.data['message'] ?? [];
      pos = pos?.where((obj) => obj['qrDetails'] != null);

      paidAmount = payments.fold(0.0, (sum, payment) => sum + payment['amount']);
      invoiceValue = invoiceData;
      finalAmount = invoiceValue['final_amount'].toDouble();
      remainingAmount = finalAmount - paidAmount;
      qrPayments = invoiceValue['QrPayments'] ?? [];

      _buildInvoiceUI(pos);
      return invoiceValue;
    } on DioException catch (e) {
      _handleError(e);
    } catch (e) {
      _handleError(e);
    }
    return null;
  }

  void _buildInvoiceUI(Iterable<dynamic>? paymentOptions) {
    items = [
      _buildInvoiceHeader(),
      const SizedBox(height: 16),
      _buildAmountSummaryCard(),
      const SizedBox(height: 24),
      _buildPaymentOptionsSection(paymentOptions),
    ];
  }

  Widget _buildInvoiceHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Invoice #$invoiceNumber',
            style: GoogleFonts.poppins(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Payment Details',
            style: GoogleFonts.poppins(fontSize: 14, color: Colors.grey.shade600),
          ),
        ],
      ),
    );
  }

  Widget _buildAmountSummaryCard() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Total Amount',
                    style: GoogleFonts.poppins(fontSize: 16, color: Colors.grey.shade700),
                  ),
                  Text(
                    'Rs. $finalAmount',
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
              const Divider(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Paid Amount',
                    style: GoogleFonts.poppins(fontSize: 16, color: Colors.grey.shade700),
                  ),
                  Text(
                    'Rs. $paidAmount',
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.green.shade700,
                    ),
                  ),
                ],
              ),
              const Divider(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Remaining Amount',
                    style: GoogleFonts.poppins(fontSize: 16, color: Colors.grey.shade700),
                  ),
                  Text(
                    'Rs. $remainingAmount',
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: remainingAmount > 0 ? Colors.red.shade700 : Colors.green.shade700,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPaymentOptionsSection(Iterable<dynamic>? paymentOptions) {
    if (remainingAmount <= 0) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Card(
          color: Colors.green.shade50,
          elevation: 0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Icon(Icons.check_circle, color: Colors.green.shade700),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Payment completed for this invoice',
                    style: GoogleFonts.poppins(
                      color: Colors.green.shade700,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            'Payment Options',
            style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.w600),
          ),
        ),
        const SizedBox(height: 12),
        ...paymentOptions!.map((po) => _buildPaymentOptionCard(po)),
      ],
    );
  }

  Widget _buildPaymentOptionCard(dynamic po) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () => chkRemainingPayment(po),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Image.asset('assets/images/fonepayLogo.png', width: 100, height: 30),
                    Text(
                      po['method_name'],
                      style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w500),
                    ),
                    isLoadingQR
                        ? const SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : Icon(Icons.qr_code_2, color: Colors.blue.shade700, size: 24),
                  ],
                ),
                // const SizedBox(height: 12),
                // Text(
                //   po['method_name'],
                //   style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w500),
                // ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _handleError(dynamic e) {
    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Invoice not found. Please search again.'),
        backgroundColor: Colors.red.shade700,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      // backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        backgroundColor: AppTheme.of(context).primaryBackground,
        elevation: 3,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_rounded, color: AppTheme.of(context).primaryText, size: 24),
          onPressed: () => Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (c) => const TableSelectionWidget()),
          ),
        ),
        title: Text(
          'Table Selection',
          style: AppTheme.of(context).title1.override(
            fontFamily: AppTheme.of(context).title1.fontFamily,
            color: AppTheme.of(context).primaryText,
            useGoogleFonts: GoogleFonts.asMap().containsKey(AppTheme.of(context).title1.fontFamily),
          ),
        ),
        centerTitle: false,
      ),

      body: FutureBuilder(
        future: _invoice,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
            // return const LoadingPageWidget();
          } else if (snapshot.hasError) {
            return _buildErrorState();
          } else {
            return SingleChildScrollView(
              padding: const EdgeInsets.only(bottom: 24),
              child: Column(children: items),
            );
          }
        },
      ),
      floatingActionButton: const CustomFloatingActionButton(),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  Widget _buildErrorState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Lottie.asset('assets/lottie_animations/estimate_error.json', width: 200, height: 200),
          const SizedBox(height: 24),
          Text(
            'Invoice Not Found',
            style: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 8),
          Text(
            'Please check the invoice number and try again',
            style: GoogleFonts.poppins(color: Colors.grey.shade600),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue.shade700,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
            child: Text(
              'Go Back',
              style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }
}
