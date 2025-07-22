import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:nepvent_waiter/UI/Design/AppTheme.dart';
import 'package:nepvent_waiter/UI/Design/CustomFloatingActionButton.dart';
import 'package:nepvent_waiter/UI/Screens/PaymentQrGenerateWidget.dart';
import 'package:nepvent_waiter/Utils/Constant.dart';
import 'package:nepvent_waiter/Utils/Urls.dart';

class EstimateBillWidget extends StatefulWidget {
  const EstimateBillWidget({
    super.key,
    required this.tableId,
    required this.tableLocation,
    required this.tableName,
  });

  final int tableId;
  final int tableLocation;
  final String tableName;

  @override
  State<EstimateBillWidget> createState() => _EstimateBillWidgetState();
}

class _EstimateBillWidgetState extends State<EstimateBillWidget> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  late Future _estimate;
  dynamic estimateValue;
  late List<Widget> items;
  late bool printerIntegrated;
  late double width;
  late double idxSize;
  late double itemSize;
  late double quantitySize;
  late double rateSize;
  late double amountSize;

  @override
  void initState() {
    super.initState();
    _estimate = getEstimate();
    _initializePrinterStatus();
    items = [];
  }

  Future<void> _initializePrinterStatus() async {
    printerIntegrated = prefs.getBool('integratedPrinter') ?? false;
  }

  Future getEstimate() async {
    try {
      final url = '${urls['getEstimate']!}/${widget.tableId}';
      final response = await dio.get(url);
      estimateValue = response.data['message'];

      // Check if estimate is empty or invalid
      if (estimateValue == null ||
          estimateValue['billInformation'] == null ||
          estimateValue['billInformation']['final_amount'] == null ||
          estimateValue['billInformation']['final_amount'].toString() == '0.00') {
        _buildEmptyTableUI(); // Call this directly
        return Future.value(); // Return an empty future
      }

      _buildEstimateItems();
      return estimateValue;
    } catch (e) {
      log('Error fetching estimate: $e');
      _buildEmptyTableUI(); // Also show empty UI on error
      return Future.error(e);
    }
  }

  // Update the _buildEmptyTableUI method to directly modify items list
  void _buildEmptyTableUI() {
    items = [
      Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Lottie.asset('assets/lottie_animations/estimate_error.json', fit: BoxFit.contain),
            const SizedBox(height: 24),
            Text(
              'Empty Table',
              style: AppTheme.of(
                context,
              ).title2.copyWith(fontSize: 28, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            Text(
              'No items ordered yet',
              style: AppTheme.of(context).bodyText1.copyWith(color: Colors.grey.shade600),
            ),
          ],
        ),
      ),
    ];
  }

  void _buildEstimateItems() {
    // Initialize sizes based on screen width
    width = MediaQuery.of(context).size.width;
    idxSize = 20;
    rateSize = width * 0.2;
    quantitySize = 25;
    amountSize = width * 0.2;
    itemSize = width - idxSize - rateSize - quantitySize - amountSize - 20;

    // Total Amount Header
    items.add(_buildTotalAmountHeader());

    // Table Headers
    items.add(_buildTableHeaders());

    // Order Items
    _buildOrderItems();

    // Other Charges
    _buildOtherCharges();

    // Summary Section
    items.add(_buildSummarySection());

    // Add spacing
    items.add(const SizedBox(height: 16));
  }

  Widget _buildTotalAmountHeader() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppTheme.of(context).retroRedYellow,
        borderRadius: BorderRadius.circular(8),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Total Amount',
            style: AppTheme.of(context).title2.copyWith(
              color: AppTheme.of(context).retroRedYellowFont,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            'Rs. ${estimateValue['billInformation']['final_amount']}',
            style: AppTheme.of(context).robotoMonoTitle1.copyWith(
              color: AppTheme.of(context).retroRedYellowFont,
              fontSize: 22,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTableHeaders() {
    return Container(
      width: double.infinity,
      color: Colors.black,
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
      child: Row(
        children: [
          SizedBox(width: idxSize, child: const Text(' ')),
          SizedBox(
            width: itemSize,
            child: const Text('Item', style: TextStyle(color: Colors.white)),
          ),
          SizedBox(
            width: quantitySize,
            child: const Text(
              'Qty',
              style: TextStyle(color: Colors.white),
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(
            width: rateSize,
            child: const Text(
              'Rate',
              style: TextStyle(color: Colors.white),
              textAlign: TextAlign.end,
            ),
          ),
          SizedBox(
            width: amountSize,
            child: const Text(
              'Amount',
              style: TextStyle(color: Colors.white),
              textAlign: TextAlign.end,
            ),
          ),
        ],
      ),
    );
  }

  void _buildOrderItems() {
    int idx = 0;
    for (var orderDetail in estimateValue['orderDetails']) {
      if (orderDetail.containsKey('otherCharge')) continue;

      idx++;
      items.add(
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
          decoration: BoxDecoration(
            border: Border(bottom: BorderSide(color: Colors.grey.shade200)),
          ),
          child: Row(
            children: [
              SizedBox(
                width: idxSize,
                child: Text('$idx.', style: _itemTextStyle()),
              ),
              SizedBox(
                width: itemSize,
                child: RichText(
                  text: TextSpan(
                    text: '${orderDetail['item_name']}',
                    style: _itemTextStyle(),
                    children: [
                      if (orderDetail['disableDiscount'])
                        TextSpan(
                          text: ' **',
                          style: _itemTextStyle().copyWith(color: Colors.red),
                        ),
                      if (orderDetail['complimentary'])
                        TextSpan(
                          text: ' *',
                          style: _itemTextStyle().copyWith(color: Colors.blue),
                        ),
                      if (orderDetail['menuDiscounts'] != null)
                        TextSpan(
                          text: ' @Special Discount-${orderDetail['menuDiscounts']['name']}',
                          style: _itemTextStyle().copyWith(
                            color: AppTheme.of(context).retroRedYellow,
                            fontSize: 12,
                          ),
                        ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                width: quantitySize,
                child: Text(
                  '${orderDetail['quantity']}',
                  style: _itemTextStyle(),
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(
                width: rateSize,
                child: Text(
                  '${orderDetail['rate'].toStringAsFixed(2)}',
                  style: _itemTextStyle(),
                  textAlign: TextAlign.end,
                ),
              ),
              SizedBox(
                width: amountSize,
                child: Text(
                  '${orderDetail['total'].toStringAsFixed(2)}',
                  style: _itemTextStyle(),
                  textAlign: TextAlign.end,
                ),
              ),
            ],
          ),
        ),
      );
    }
  }

  void _buildOtherCharges() {
    if (estimateValue['otherCharges'] == null) return;

    final otherChargeWidgets = <Widget>[
      const Padding(
        padding: EdgeInsets.only(top: 16, bottom: 8),
        child: Text('Extra Charges', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
      ),
    ];

    int idx = 0;
    for (var charge in estimateValue['otherCharges']) {
      idx++;
      otherChargeWidgets.add(
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
          decoration: BoxDecoration(
            border: Border(bottom: BorderSide(color: Colors.grey.shade200)),
          ),
          child: Row(
            children: [
              SizedBox(
                width: idxSize,
                child: Text(' $idx.', style: _itemTextStyle()),
              ),
              SizedBox(
                width: itemSize,
                child: Text('${charge['otherChargeDetail']['name']}', style: _itemTextStyle()),
              ),
              SizedBox(
                width: quantitySize,
                child: Text(
                  '${charge['quantity']}',
                  style: _itemTextStyle(),
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(
                width: rateSize,
                child: Text('${charge['rate']}', style: _itemTextStyle(), textAlign: TextAlign.end),
              ),
              SizedBox(
                width: amountSize,
                child: Text(
                  ((double.parse(charge['quantity'].toString())) *
                          (double.parse(charge['rate'].toString())))
                      .toStringAsFixed(2),
                  style: _itemTextStyle(),
                  textAlign: TextAlign.end,
                ),
              ),
            ],
          ),
        ),
      );
    }

    items.addAll(otherChargeWidgets);
  }

  Widget _buildSummarySection() {
    final billInfo = estimateValue['billInformation'];
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Table Summary', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          const SizedBox(height: 12),
          _buildSummaryRow('Subtotal', 'Rs. ${billInfo['amount']}'),
          _buildSummaryRow('Discount', 'Rs. ${billInfo['discount']}'),
          _buildSummaryRow('VAT', 'Rs. ${billInfo['vat']}'),
          const Divider(height: 24, thickness: 1),
          _buildSummaryRow('Grand Total', 'Rs. ${billInfo['final_amount']}', isTotal: true),
          const SizedBox(height: 16),
          const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('* → Complementary Discount', style: TextStyle(fontSize: 12)),
              SizedBox(height: 4),
              Text('** → Disabled Discount', style: TextStyle(fontSize: 12)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryRow(String label, String value, {bool isTotal = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(fontWeight: isTotal ? FontWeight.bold : FontWeight.normal)),
          Text(
            value,
            style: TextStyle(
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
              fontFamily: 'RobotoMono',
            ),
          ),
        ],
      ),
    );
  }

  // Future<void> _buildEmptyTableUI() {
  //   items = [
  //     Column(
  //       mainAxisAlignment: MainAxisAlignment.center,
  //       children: [
  //         Lottie.asset('assets/lottie_animations/estimate_error.json', width: 200, height: 200, fit: BoxFit.contain),
  //         const SizedBox(height: 24),
  //         Text('Empty Table', style: AppTheme.of(context).title2.copyWith(fontSize: 28, fontWeight: FontWeight.w600)),
  //         const SizedBox(height: 8),
  //         Text('No items ordered yet', style: AppTheme.of(context).bodyText1.copyWith(color: Colors.grey.shade600)),
  //       ],
  //     ),
  //   ];
  //   return Future.value();
  // }

  TextStyle _itemTextStyle() {
    return AppTheme.of(
      context,
    ).bodyText1.copyWith(color: AppTheme.of(context).retroOrangeBlackFont);
  }

  @override
  Widget build(BuildContext context) {
    // final dataProvider = Provider.of<DataProvider>(context).isData;

    return FutureBuilder(
      future: _estimate,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // return const LoadingPageWidget();
          return Center(child: CircularProgressIndicator());
        }

        return Scaffold(
          key: scaffoldKey,
          backgroundColor: AppTheme.of(context).primaryBackground,
          appBar: AppBar(
            backgroundColor: AppTheme.of(context).primaryBackground,
            automaticallyImplyLeading: false,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_rounded, size: 24),
              onPressed: () => Navigator.pop(context),
            ),
            title: Text(
              'Estimate - ${widget.tableName}',
              style: AppTheme.of(context).title1.override(
                fontFamily: AppTheme.of(context).title1.fontFamily,
                color: AppTheme.of(context).chineseBlack,
                useGoogleFonts: GoogleFonts.asMap().containsKey(
                  AppTheme.of(context).title1.fontFamily,
                ),
              ),
            ),
            actions: _buildAppBarActions(snapshot.hasError),
            centerTitle: false,
            elevation: 3,
          ),
          body: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.only(bottom: 100),
                  child: Column(children: items),
                ),
              ),
              if (!snapshot.hasError && printerIntegrated) _buildPrintButton(),
            ],
          ),
          floatingActionButton: const CustomFloatingActionButton(),
          floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
        );
      },
    );
  }

  List<Widget> _buildAppBarActions(bool hasError) {
    if (hasError) return [];

    return [
      IconButton(
        icon: Icon(Icons.description_outlined, color: AppTheme.of(context).primaryText, size: 24),
        onPressed: _requestInvoice,
      ),
      const SizedBox(width: 8),
      IconButton(
        icon: Icon(Icons.qr_code, color: AppTheme.of(context).primaryText, size: 24),
        onPressed: _showQRCode,
      ),
      const SizedBox(width: 8),
    ];
  }

  Widget _buildPrintButton() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF4B39EF),
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
          // onPressed: () => estimatePrint(estimateValue),
          onPressed: () {},
          child: Text(
            'Print Estimate',
            style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w600),
          ),
        ),
      ),
    );
  }

  void _requestInvoice() {
    // socketService.requestInvoice(widget.tableLocation, widget.tableId);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Invoice requested for table ${widget.tableName}'),
        backgroundColor: Colors.green,
      ),
    );
  }

  void _showQRCode() {
    showModalBottomSheet(
      context: context,
      builder: (context) => SizedBox(
        height: 200,
        child: PaymentQrGenerateWidget(
          totalPayment: estimateValue['billInformation']['final_amount'],
        ),
      ),
    );
  }

  // void _syncDataLater() {
  //   Navigator.push(context, MaterialPageRoute(builder: (context) => Home()));
  //   Provider.of<DataProvider>(navigatorKey.currentContext!, listen: false).isData = false;
  // }
}
