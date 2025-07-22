import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nepvent_waiter/Controller/LogoutFun.dart';
import 'package:nepvent_waiter/Controller/SocketService.dart';
import 'package:nepvent_waiter/Models/PaymentMethodModel.dart';
import 'package:nepvent_waiter/Ticket/Design/CounterButton.dart';
import 'package:nepvent_waiter/Ticket/Design/OtherPaymentMethodsDropdown.dart';
import 'package:nepvent_waiter/Ticket/Design/PaymentMethodCard.dart';
import 'package:nepvent_waiter/Ticket/Design/SectionHeader.dart';
import 'package:nepvent_waiter/Ticket/Design/TicketTypeCard.dart';
import 'package:nepvent_waiter/Ticket/Design/TicketingAppBarWidget.dart';
import 'package:nepvent_waiter/Ticket/Models/CouponType.dart';
import 'package:nepvent_waiter/UI/Design/AppTheme.dart';
import 'package:nepvent_waiter/UI/Design/ButtonWidget.dart';
import 'package:nepvent_waiter/UI/Design/LoadingWidget.dart';
import 'package:nepvent_waiter/UI/Design/LogoutDialog.dart';
import 'package:nepvent_waiter/Utils/Urls.dart';
import 'package:provider/provider.dart';

import '../Utils/Constant.dart' show dio, prefs;

class TicketGenerateWidget extends StatefulWidget {
  const TicketGenerateWidget({super.key});

  @override
  State<TicketGenerateWidget> createState() => _TicketGenerateWidgetState();
}

class _TicketGenerateWidgetState extends State<TicketGenerateWidget> {
  // final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _peopleController = TextEditingController();
  final _scrollController = ScrollController();
  late SocketService _socketService;

  int? _selectedPaymentMethodId;
  String? _selectedPaymentMethodName;
  int? _selectedCouponType;
  bool? _isIrdApproved;

  List<PaymentMethodModel> _paymentMethods = [];
  List<CouponType> _couponTypes = [];
  late Future<void> _dataLoadingFuture;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _peopleController.text = '1';
    _dataLoadingFuture = _loadInitialData();
  }

  Future<void> _loadInitialData() async {
    await Future.wait([_fetchPaymentMethods(), _fetchCouponTypes()]);
  }

  Future<void> _fetchCouponTypes() async {
    try {
      final response = await dio.get(urls['ticketType']!);
      if (response.data['success'] == true) {
        setState(() {
          _couponTypes = (response.data['message'] as List).map((item) {
            return CouponType()
              ..id = item['id']
              ..name = item['name']
              ..price = double.parse(item['price'].toStringAsFixed(2));
          }).toList();
        });
      }
    } catch (error) {
      debugPrint('Error fetching coupon types: $error');
      _showErrorSnackBar('Failed to load ticket types');
    }
  }

  Future<void> _fetchPaymentMethods() async {
    try {
      final response = await dio.get(urls['paymentMethod']!);
      setState(() {
        _paymentMethods = (response.data['message'] as List)
            .map(
              (method) => PaymentMethodModel()
                ..id = method['id']
                ..name = method['method_name'],
            )
            .toList();
      });
    } on DioException catch (e) {
      debugPrint('DioError fetching payment methods: ${e.message}');
      _showErrorSnackBar('Payment methods unavailable');
    } catch (error) {
      debugPrint('Error fetching payment methods: $error');
    }
  }

  Future _generateTicket() async {
    if (_selectedCouponType == null) {
      _showWarningSnackBar("Please select a ticket type");
      return;
    }

    if (_peopleController.text.isEmpty || _peopleController.text == '0') {
      _showWarningSnackBar("Please enter number of people");
      return;
    }

    if (_selectedPaymentMethodId == null) {
      _showWarningSnackBar("Please select a payment method");
      return;
    }

    try {
      final response = await dio.post(
        urls['coupon']!,
        data: {
          "otherChargeId": _selectedCouponType,
          "numberOfPeople": _peopleController.text,
          "paymentMethod": _selectedPaymentMethodId,
          "socketId": _socketService.socket.id,
        },
      );

      if (response.statusCode == 200) {
        _resetForm();
        _showSuccessSnackBar("Ticket generated successfully");
      }
    } on DioException catch (e) {
      _showErrorSnackBar(
        e.response?.data['message'] ?? 'Failed to generate ticket. Please try again.',
      );
    } catch (error) {
      debugPrint('Error generating ticket: $error');
      _showErrorSnackBar('An unexpected error occurred');
    }
  }

  void _resetForm() {
    setState(() {
      _peopleController.text = '1';
      _selectedPaymentMethodId = null;
      _selectedPaymentMethodName = null;
      _selectedCouponType = null;
    });
  }

  void _showWarningSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.orange,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  void _showSuccessSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _peopleController.dispose();
    _scrollController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _socketService = context.read<SocketService>();

    final theme = AppTheme.of(context);
    final screenSize = MediaQuery.sizeOf(context);
    final isMobile = screenSize.width < 700;
    _isIrdApproved = prefs.getBool('irdApproved');

    return Scaffold(
      appBar: TicketingAppBarWidget(
        title: 'Ticket Generate',
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: IconButton(
              icon: Icon(Icons.logout, color: AppTheme.of(context).chineseBlack, size: 30),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => Dialog(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                    elevation: 10,
                    backgroundColor: Colors.white,
                    child: LogoutDialog(onLogout: logout),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      body: RefreshIndicator(
        color: theme.primaryColor,
        onRefresh: _loadInitialData,
        child: FutureBuilder(
          future: _dataLoadingFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return LoadingWidget();
            }

            if (snapshot.hasError) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.error_outline, size: 48, color: theme.redSalsa),
                    const SizedBox(height: 16),
                    Text('Failed to load data', style: theme.title2),
                    const SizedBox(height: 8),
                    ElevatedButton(
                      onPressed: _loadInitialData,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: theme.primaryColor,
                        foregroundColor: theme.primaryBtnText,
                      ),
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              );
            }

            return SingleChildScrollView(
              controller: _scrollController,
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: Column(
                children: [
                  _buildTicketTypeSelector(isMobile, theme),
                  const SizedBox(height: 16),
                  _buildPeopleCounter(isMobile, theme),
                  const SizedBox(height: 16),
                  _buildPaymentMethodSelector(isMobile, theme),
                  const SizedBox(height: 24),
                  _buildGenerateButton(),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildPaymentMethodSelector(bool isMobile, AppTheme theme) {
    final cashMethod = _paymentMethods.firstWhere(
      (m) => m.name.replaceAll(' ', '').toUpperCase() == 'CASH',
      orElse: () => PaymentMethodModel()..id = -1,
    );

    final esewaMethod = _paymentMethods.firstWhere(
      (m) => m.name.replaceAll(' ', '').toUpperCase() == 'ESEWA',
      orElse: () => PaymentMethodModel()..id = -1,
    );

    final phonePayMethods = _paymentMethods.where((m) {
      final name = m.name.replaceAll(' ', '').toUpperCase();
      return name == 'PHONEPAY' || name == 'FONEPAY';
    }).toList();

    final otherMethods = _paymentMethods.where((m) {
      final name = m.name.replaceAll(' ', '').toUpperCase();
      return !['CASH', 'ESEWA', 'PHONEPAY', 'FONEPAY'].contains(name);
    }).toList();

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      elevation: 4,
      color: theme.secondaryBackground,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const SectionHeader(title: "Payment Method", isRequired: true),
            const SizedBox(height: 16),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              alignment: WrapAlignment.center,
              children: [
                if (cashMethod.id != -1)
                  PaymentMethodCard(
                    method: cashMethod,
                    iconPath: 'assets/PaymentMethodIcon/Cash.png',
                    isSelected: _selectedPaymentMethodId == cashMethod.id,
                    onSelect: () => setState(() {
                      _selectedPaymentMethodId = cashMethod.id;
                      _selectedPaymentMethodName = 'Cash';
                    }),
                    isMobile: isMobile,
                  ),

                if (esewaMethod.id != -1)
                  PaymentMethodCard(
                    method: esewaMethod,
                    iconPath: 'assets/PaymentMethodIcon/esewa.png',
                    isSelected: _selectedPaymentMethodId == esewaMethod.id,
                    onSelect: () => setState(() {
                      _selectedPaymentMethodId = esewaMethod.id;
                      _selectedPaymentMethodName = 'E-Sewa';
                    }),
                    isMobile: isMobile,
                  ),

                ...phonePayMethods.map(
                  (method) => PaymentMethodCard(
                    method: method,
                    iconPath: 'assets/PaymentMethodIcon/fonePay.png',
                    isSelected: _selectedPaymentMethodId == method.id,
                    onSelect: () => setState(() {
                      _selectedPaymentMethodId = method.id;
                      _selectedPaymentMethodName = method.name;
                    }),
                    isMobile: isMobile,
                  ),
                ),

                if (otherMethods.isNotEmpty)
                  OtherPaymentMethodsDropdown(
                    methods: otherMethods,
                    selectedId: _selectedPaymentMethodId,
                    isMobile: isMobile,
                    onSelect: (method) => setState(() {
                      _selectedPaymentMethodId = method.id;
                      _selectedPaymentMethodName = method.name;
                    }),
                  ),
              ],
            ),
            const SizedBox(height: 16),
            if (_selectedPaymentMethodName != null)
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: theme.secondaryBackground,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: theme.lineColor),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.check_circle, color: theme.mountainMeadowGreen, size: 20),
                    const SizedBox(width: 8),
                    Text(
                      'Selected: $_selectedPaymentMethodName',
                      style: theme.subtitle1.copyWith(fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildTicketTypeSelector(bool isMobile, AppTheme theme) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      elevation: 4,
      color: theme.secondaryBackground,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const SectionHeader(title: "Ticket Type", isRequired: true),
            const SizedBox(height: 12),
            SizedBox(
              height: isMobile ? 110 : 130,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 8),
                itemCount: _couponTypes.length,
                separatorBuilder: (_, __) => const SizedBox(width: 12),
                itemBuilder: (context, index) {
                  final ticket = _couponTypes[index];
                  return TicketTypeCard(
                    ticket: ticket,
                    isSelected: _selectedCouponType == ticket.id,
                    isMobile: isMobile,
                    onTap: () => setState(() => _selectedCouponType = ticket.id),
                    irdIncluded: _isIrdApproved ?? false,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPeopleCounter(bool isMobile, AppTheme theme) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      elevation: 4,
      color: theme.secondaryBackground,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const SectionHeader(title: "Number of People", isRequired: true),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CounterButton(
                  icon: Icons.remove,
                  onPressed: () {
                    final current = int.tryParse(_peopleController.text) ?? 1;
                    if (current > 1) {
                      setState(() => _peopleController.text = (current - 1).toString());
                    }
                  },
                ),
                const SizedBox(width: 16),
                SizedBox(
                  width: isMobile ? 80 : 120,
                  child: TextFormField(
                    controller: _peopleController,
                    textAlign: TextAlign.center,
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: theme.verdigrisGreen),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: theme.verdigrisGreen),
                      ),
                      contentPadding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    style: theme.subtitle1.copyWith(fontWeight: FontWeight.w500),
                  ),
                ),
                const SizedBox(width: 16),
                CounterButton(
                  icon: Icons.add,
                  onPressed: () {
                    final current = int.tryParse(_peopleController.text) ?? 0;
                    setState(() => _peopleController.text = (current + 1).toString());
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGenerateButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: ButtonWidget(
        onPressed: () async {
          await _generateTicket();
        },
        text: 'GENERATE TICKET',
        showLoadingIndicator: true,
        options: ButtonOptions(
          width: double.infinity,
          // height: 40,
          color: const Color(0xFF428FD2),
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
    );
  }
}
