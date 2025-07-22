import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:nepali_date_picker/nepali_date_picker.dart';
import 'package:nepvent_waiter/Ticket/Design/TicketingAppBarWidget.dart';
import 'package:nepvent_waiter/Ticket/Models/TokenModel.dart';
import 'package:nepvent_waiter/UI/Design/AppTheme.dart';
import 'package:nepvent_waiter/UI/Design/ButtonWidget.dart';
import 'package:nepvent_waiter/Utils/Constant.dart';
import 'package:nepvent_waiter/Utils/Urls.dart';

class TicketHistoryWidget extends StatefulWidget {
  const TicketHistoryWidget({super.key});

  @override
  State<TicketHistoryWidget> createState() => _TicketHistoryWidgetState();
}

class _TicketHistoryWidgetState extends State<TicketHistoryWidget> {
  late Future _futureToken;
  final TextEditingController _startDateController = TextEditingController();
  final TextEditingController _endDateController = TextEditingController();
  List<TokenModel> ticketData = [];
  bool _isLoading = false;

  // Colors
  final Color _primaryColor = const Color(0xFF428FD2);
  final Color _secondaryColor = const Color(0xFF303068);
  final Color _successColor = const Color(0xFF34EABF);
  final Color _infoColor = const Color(0xFF1488D1);
  final Color _errorColor = const Color(0xFFDD143D);
  final Color _cardBackground = Colors.white;
  final Color _textColor = Colors.black;
  final Color _hintColor = Colors.black54;

  @override
  void initState() {
    super.initState();
    _futureToken = _getToken();
  }

  @override
  void dispose() {
    _endDateController.dispose();
    _startDateController.dispose();
    super.dispose();
  }

  Future<void> _getToken() async {
    setState(() => _isLoading = true);
    try {
      final Response response = await dio.get(urls['ticketHistory']!);
      List<TokenModel> newTokenData = [];
      for (var receipt in response.data['message']) {
        newTokenData.add(
          TokenModel(
            tokenId: receipt['id'],
            date: receipt['paymentDate'],
            tokenNumber: receipt['paymentReceiptNumber'],
            numberOfPeople: receipt['Coupon']['number_of_people'].toString() ?? 'N/A',
            amount: receipt['debit'].toDouble(),
            isClaimable: receipt['Coupon']['isClaimable'],
            type: receipt['Coupon']['Other_Charge']['name'] ?? 'N/A',
          ),
        );
      }

      setState(() => ticketData = newTokenData);
    } catch (error) {
      debugPrint('Error Getting Invoice $error');
      _showSnackBar('Failed to load ticket history', isError: true);
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _rePrintToken(int tokenId) async {
    try {
      final Response response = await dio.get('${urls['ReprintCoupon']!}/$tokenId/print-copy');
      if (response.data['success'] == true) {
        _showSnackBar(response.data['message']['message']);
      }
    } catch (error) {
      _showSnackBar('Failed to reprint ticket', isError: true);
    }
  }

  Future<void> _filterData() async {
    if (_startDateController.text.isEmpty || _endDateController.text.isEmpty) {
      _showSnackBar('Please select both start and end dates', isError: true);
      return;
    }

    setState(() => _isLoading = true);
    try {
      DateTime parsedDate = DateFormat("yyyy-MM-dd").parse(_startDateController.text);
      String formattedDate = DateFormat("yyyy/MM/dd").format(parsedDate);

      DateTime endDate = DateFormat("yyyy-MM-dd").parse(_endDateController.text);
      String formattedEndDate = DateFormat("yyyy/MM/dd").format(endDate);

      Map<String, dynamic> queryParams = {
        'type': 'R',
        'fromDate': formattedDate,
        'toDate': formattedEndDate,
        'dateFormat': 'YYYY/MM/DD',
        'npDate': true,
      };

      final Response response = await dio.get(urls['RangeFilter']!, queryParameters: queryParams);
      List<TokenModel> newTokenData = [];

      for (var receipt in response.data['message']) {
        newTokenData.add(
          TokenModel(
            tokenId: receipt['id'],
            date: receipt['paymentDate'],
            tokenNumber: receipt['paymentReceiptNumber'],
            numberOfPeople: receipt['Coupon']['number_of_people'].toString() ?? 'N/A',
            amount: receipt['debit'].toDouble(),
            isClaimable: receipt['Coupon']['isClaimable'],
            type: receipt['Coupon']['Other_Charge']['name'] ?? 'N/A',
          ),
        );
      }
      setState(() => ticketData = newTokenData);
    } catch (error) {
      debugPrint('Filter error: $error');
      _showSnackBar('Failed to filter tickets', isError: true);
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final screen = MediaQuery.sizeOf(context);
    // Calculate totals
    double totalAmount = ticketData.fold(0.0, (sum, item) => sum + item.amount);
    int totalPax = ticketData.fold(
      0,
      (sum, item) => sum + (int.tryParse(item.numberOfPeople) ?? 0),
    );
    // Group by type
    Map<String, double> totalAmountByType = {};
    Map<String, int> totalPaxByType = {};
    for (var item in ticketData) {
      totalAmountByType[item.type] = (totalAmountByType[item.type] ?? 0.0) + item.amount;
      totalPaxByType[item.type] =
          (totalPaxByType[item.type] ?? 0) + (int.tryParse(item.numberOfPeople) ?? 0);
    }

    return PopScope(
      canPop: false,
      child: Scaffold(
        appBar: TicketingAppBarWidget(
          title: 'Ticket History',
          actions: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: IconButton(
                icon: Icon(
                  Icons.filter_alt_outlined,
                  color: AppTheme.of(context).chineseBlack,
                  size: 30,
                ),
                onPressed: _showDateRangeFilter,
              ),
            ),
          ],
        ),
        body: SafeArea(
          child: _isLoading
              ? const Center(child: CircularProgressIndicator(color: Color(0xFF428FD2)))
              : ticketData.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.error_sharp, color: _errorColor, size: 48),
                      const SizedBox(height: 16),
                      Text(
                        "No Tickets Found",
                        style: TextStyle(
                          fontSize: 22,
                          color: _errorColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        "Try adjusting your filters",
                        style: TextStyle(fontSize: 16, color: _hintColor),
                      ),
                      const SizedBox(height: 20),
                      ButtonWidget(
                        onPressed: _getToken,
                        text: 'Refresh',
                        options: ButtonOptions(
                          width: 120,
                          height: 40,
                          color: _primaryColor,
                          textStyle: AppTheme.of(context).subtitle2.override(
                            fontFamily: AppTheme.of(context).subtitle2.fontFamily,
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            useGoogleFonts: GoogleFonts.asMap().containsKey(
                              AppTheme.of(context).subtitle2.fontFamily,
                            ),
                          ),
                          elevation: 2,
                          borderRadius: 8,
                        ),
                      ),
                    ],
                  ),
                )
              : RefreshIndicator(
                  onRefresh: _getToken,
                  color: _primaryColor,
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            _buildStatsCard(
                              icon: Icons.money,
                              title: 'Total Amount',
                              value: totalAmount.toStringAsFixed(2),
                              color: _successColor,
                              onTap: () => showDialog(
                                context: context,
                                builder: (context) => _buildSummaryDialog(
                                  title: 'Total Amount by Type',
                                  data: totalAmountByType,
                                ),
                              ),
                            ),
                            _buildStatsCard(
                              icon: Icons.people,
                              title: 'Total PAX',
                              value: totalPax.toString(),
                              color: _infoColor,
                              onTap: () => showDialog(
                                context: context,
                                builder: (context) => _buildSummaryDialog(
                                  title: 'Total PAX by Type',
                                  data: totalPaxByType,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: ListView.builder(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          itemCount: ticketData.length,
                          itemBuilder: (context, index) {
                            final token = ticketData[index];
                            return _buildTicketCard(token, screen);
                          },
                        ),
                      ),
                    ],
                  ),
                ),
        ),
      ),
    );
  }

  Widget _buildTicketCard(TokenModel token, Size screen) {
    DateTime dateTime = DateTime.parse(token.date);
    final nepaliDate = dateTime.toNepaliDateTime();
    String formattedDate = NepaliDateFormat("yyyy/MM/dd").format(nepaliDate);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Card(
        elevation: 3,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () => _showRePrintDialog(context, token.tokenNumber, token.tokenId),
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      formattedDate,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: _textColor,
                      ),
                    ),
                    Text(
                      token.type,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: _hintColor,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildInfoRow('Receipt No.:', token.tokenNumber),
                          _buildInfoRow('Amount:', token.amount.toStringAsFixed(2)),
                        ],
                      ),
                    ),
                    Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: _primaryColor,
                        boxShadow: const [
                          BoxShadow(color: Colors.black12, blurRadius: 8, offset: Offset(0, 4)),
                        ],
                      ),
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              'PAX',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            Text(
                              token.numberOfPeople,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSummaryDialog({required String title, required Map<String, dynamic> data}) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
      child: Container(
        padding: const EdgeInsets.all(20.0),
        decoration: BoxDecoration(
          color: _cardBackground,
          borderRadius: BorderRadius.circular(15.0),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: _textColor),
                ),
                IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(Icons.close, color: Colors.red),
                ),
              ],
            ),
            const SizedBox(height: 20),
            ...data.entries.map((entry) {
              return Column(
                children: [
                  Text(
                    entry.key,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: _primaryColor,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    entry.value.toString(),
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: _hintColor),
                  ),
                  const SizedBox(height: 20),
                ],
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Text(
            title,
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500, color: _hintColor),
          ),
          const SizedBox(width: 5),
          Text(
            value,
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: _textColor),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsCard({
    required IconData icon,
    required String title,
    required String value,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: MediaQuery.sizeOf(context).width / 2.15,
        decoration: BoxDecoration(
          color: color,
          border: Border.all(color: const Color(0xFFD2D7DE)),
          borderRadius: BorderRadius.circular(12),
          boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 8, offset: Offset(0, 4))],
        ),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            children: [
              Icon(icon, size: 30, color: Colors.white),
              const SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    value,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
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

  void _showDateRangeFilter() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: false,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
      ),
      // ✅ Fixed: closing this parenthesis
      builder: (context) {
        return SizedBox(
          width: MediaQuery.sizeOf(context).width,
          height: 280,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'Filter by Date Range',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: _textColor),
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: _buildDatePickerField(
                        controller: _startDateController,
                        label: 'Start Date',
                        onTap: () async {
                          NepaliDateTime? selectedStartDate = await showNepaliDatePicker(
                            context: context,
                            initialDate: NepaliDateTime.now(),
                            firstDate: NepaliDateTime(2000),
                            lastDate: NepaliDateTime(2200),
                            initialDatePickerMode: DatePickerMode.day,
                          );
                          if (selectedStartDate != null) {
                            setState(() {
                              _startDateController.text = DateFormat(
                                'yyyy-MM-dd',
                              ).format(selectedStartDate);
                            });
                          }
                        },
                      ),
                    ),
                    const SizedBox(width: 10),
                    const Text('TO'),
                    const SizedBox(width: 10),
                    Expanded(
                      child: _buildDatePickerField(
                        controller: _endDateController,
                        label: 'End Date',
                        onTap: () async {
                          if (_startDateController.text.isEmpty) {
                            _showSnackBar('Please select start date first', isError: true);
                            return;
                          }
                          NepaliDateTime? selectedEndDate = await showNepaliDatePicker(
                            context: context,
                            initialDate:
                                NepaliDateTime.tryParse(_startDateController.text) ??
                                NepaliDateTime.now(),
                            firstDate: NepaliDateTime.tryParse(_startDateController.text)!,
                            lastDate: NepaliDateTime(2200),
                          );
                          if (selectedEndDate != null) {
                            setState(() {
                              _endDateController.text = DateFormat(
                                'yyyy-MM-dd',
                              ).format(selectedEndDate);
                            });
                          }
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                ButtonWidget(
                  onPressed: () async {
                    Navigator.pop(context);
                    await _filterData();
                  },
                  text: 'Apply Filter',
                  options: ButtonOptions(
                    width: double.infinity,
                    height: 50,
                    color: _primaryColor,
                    textStyle: AppTheme.of(context).subtitle2.override(
                      fontFamily: AppTheme.of(context).subtitle2.fontFamily,
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      useGoogleFonts: GoogleFonts.asMap().containsKey(
                        AppTheme.of(context).subtitle2.fontFamily,
                      ),
                    ),
                    elevation: 2,
                    borderSide: const BorderSide(color: Colors.transparent, width: 1),
                    borderRadius: 8,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildDatePickerField({
    required TextEditingController controller,
    required String label,
    required VoidCallback onTap,
  }) {
    return TextFormField(
      controller: controller,
      readOnly: true,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: _primaryColor),
        hintText: 'Select date',
        hintStyle: TextStyle(color: _hintColor),
        suffixIcon: IconButton(
          onPressed: onTap,
          icon: Icon(Icons.calendar_month_sharp, color: _primaryColor),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: _primaryColor, width: 2.0),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: BorderSide(color: _primaryColor, width: 2.0),
        ),
        filled: true,
        fillColor: Colors.blue.shade50,
      ),
    );
  }

  void _showRePrintDialog(BuildContext context, String invoiceId, int id) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          title: Row(
            children: [
              Icon(Icons.receipt_long, color: _secondaryColor),
              const SizedBox(width: 10),
              Text(
                'Re-Print Ticket',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: _secondaryColor),
              ),
            ],
          ),
          content: RichText(
            text: TextSpan(
              style: const TextStyle(fontSize: 16, color: Color(0xFF1C1C1C)),
              children: [
                const TextSpan(text: 'Are you sure you want to re-print this ticket '),
                TextSpan(
                  text: invoiceId,
                  style: TextStyle(fontWeight: FontWeight.bold, color: _primaryColor),
                ),
                const TextSpan(text: '?'),
              ],
            ),
          ),
          actions: [
            TextButton(
              child: Text(
                'Close',
                style: TextStyle(fontSize: 14, color: _errorColor, fontWeight: FontWeight.bold),
              ),
              onPressed: () => Navigator.of(context).pop(),
            ),
            ButtonWidget(
              onPressed: () async {
                Navigator.of(context).pop();
                await _rePrintToken(id);
              },
              text: 'Re-Print',
              options: ButtonOptions(
                width: 110,
                height: 40,
                color: _secondaryColor,
                textStyle: AppTheme.of(context).subtitle2.override(
                  fontFamily: AppTheme.of(context).subtitle2.fontFamily,
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  useGoogleFonts: GoogleFonts.asMap().containsKey(
                    AppTheme.of(context).subtitle2.fontFamily,
                  ),
                ),
                elevation: 2,
                borderSide: const BorderSide(color: Colors.transparent, width: 1),
                borderRadius: 8,
              ),
            ),
          ],
        );
      },
    );
  }

  void _showSnackBar(String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? _errorColor : Colors.green,
        duration: const Duration(seconds: 2),
      ),
    );
  }
}
