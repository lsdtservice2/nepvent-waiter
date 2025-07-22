import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:nepvent_waiter/Utils/Constant.dart';
import 'package:nepvent_waiter/Utils/Urls.dart';
import 'package:qr_flutter/qr_flutter.dart';

class PaymentQrGenerateWidget extends StatefulWidget {
  const PaymentQrGenerateWidget({super.key, required this.totalPayment});

  final String totalPayment;

  @override
  State<PaymentQrGenerateWidget> createState() => _PaymentQrGenerateWidgetState();
}

class _PaymentQrGenerateWidgetState extends State<PaymentQrGenerateWidget> {
  String? selectedServiceName;
  List<dynamic> qrDetail = [];
  late Future _future;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _future = _fetchData();
  }

  Future<void> _fetchData() async {
    setState(() => _isLoading = true);
    try {
      final Response response = await dio.get(urls['qr']!);
      final body = response.data['message']['qrDetails'];

      setState(() {
        qrDetail = body != false ? body : [];
      });
    } catch (e) {
      print("Error Fetching qr: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load QR options: ${e.toString()}'), backgroundColor: Colors.red),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _showQrCodeDialog() {
    final selectedService = qrDetail.firstWhere(
      (item) => item['serviceName'] == selectedServiceName,
      orElse: () => null,
    );

    if (selectedService == null) return;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        final qrData = jsonEncode(selectedService['payload']);
        return Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          elevation: 0,
          backgroundColor: Colors.transparent,
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 10, spreadRadius: 5)],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  selectedServiceName!,
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.blueGrey),
                ),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.blue.shade100, width: 2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: QrImageView(
                    data: qrData,
                    version: QrVersions.auto,
                    size: 220.0,
                    eyeStyle: const QrEyeStyle(eyeShape: QrEyeShape.square, color: Colors.black87),
                    dataModuleStyle: const QrDataModuleStyle(
                      dataModuleShape: QrDataModuleShape.square,
                      // color: Colors.blueGrey,
                      color: Colors.black87,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                  decoration: BoxDecoration(color: Colors.blue.shade50, borderRadius: BorderRadius.circular(8)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.payment, color: Colors.blueAccent),
                      const SizedBox(width: 8),
                      Text(
                        "Total: ${widget.totalPayment}",
                        style: const TextStyle(color: Colors.blueAccent, fontSize: 18, fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueAccent,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    child: const Text('Close', style: TextStyle(fontSize: 16)),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _future,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (_isLoading) {
          return const Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(strokeWidth: 2, valueColor: AlwaysStoppedAnimation<Color>(Colors.blueAccent)),
                SizedBox(height: 8),
                Text('Loading payment options...', style: TextStyle(color: Colors.blueGrey)),
              ],
            ),
          );
        } else if (snapshot.hasError) {
          return Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.error_outline, color: Colors.red, size: 40),
                const SizedBox(height: 8),
                Text('Failed to load payment options', style: TextStyle(color: Colors.red.shade700, fontSize: 16)),
                const SizedBox(height: 8),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  onPressed: _fetchData,
                  child: const Text('Retry'),
                ),
              ],
            ),
          );
        } else if (qrDetail.isNotEmpty) {
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Center(
                  child: Text(
                    'Select Payment Method',
                    style: TextStyle(fontSize: 16, color: Colors.grey.shade700, fontWeight: FontWeight.w500),
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.blueGrey.withOpacity(0.3), width: 1.5),
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.white,
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      key: const Key('dropdown'),
                      value: selectedServiceName,
                      isExpanded: true,
                      icon: const Icon(Icons.keyboard_arrow_down_rounded, color: Colors.blueGrey),
                      hint: const Text('Choose payment service', style: TextStyle(color: Colors.grey)),
                      items: qrDetail.map((item) {
                        final serviceName = item['serviceName'] as String?;
                        return DropdownMenuItem<String>(
                          value: serviceName,
                          child: Text(serviceName ?? 'Unknown', style: const TextStyle(color: Colors.blueGrey)),
                        );
                      }).toList(),
                      onChanged: (String? value) {
                        setState(() => selectedServiceName = value);
                        if (value != null) {
                          _showQrCodeDialog();
                        }
                      },
                    ),
                  ),
                ),
                if (selectedServiceName != null) ...[
                  const SizedBox(height: 12),
                  Text(
                    'Selected: $selectedServiceName',
                    style: TextStyle(color: Colors.blue.shade700, fontStyle: FontStyle.italic),
                  ),
                ],
              ],
            ),
          );
        } else {
          return Container(
            padding: const EdgeInsets.all(16),
            margin: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.payment_outlined, size: 40, color: Colors.grey.shade500),
                const SizedBox(height: 12),
                const Text(
                  'No Payment Methods Available',
                  style: TextStyle(color: Colors.black87, fontWeight: FontWeight.w600, fontSize: 16),
                ),
                const SizedBox(height: 8),
                Text(
                  'Please add payment methods to generate QR codes',
                  style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 12),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  onPressed: _fetchData,
                  child: const Text('Refresh'),
                ),
              ],
            ),
          );
        }
      },
    );
  }
}
