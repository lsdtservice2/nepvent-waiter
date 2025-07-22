import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class FonePayPaymentDialog extends StatefulWidget {
  const FonePayPaymentDialog({
    super.key,
    required this.paymentReference,
    required this.channel,
    required this.requestData,
    required this.qrMessage,
    required this.checkPaymentStatus,
  });

  final WebSocketChannel channel;
  final String paymentReference;
  final Map<String, dynamic> requestData;
  final String qrMessage;
  final Future<String> Function(String) checkPaymentStatus;

  @override
  State<FonePayPaymentDialog> createState() => _FonePayPaymentDialogState();
}

class _FonePayPaymentDialogState extends State<FonePayPaymentDialog> {
  String _status = 'AWAITING';
  bool _isLoading = false;
  bool _isWebSocketConnected = false;
  late StreamSubscription _webSocketSubscription;

  @override
  void initState() {
    super.initState();
    _initializeWebSocket();
    _checkInitialStatus();
  }

  @override
  void dispose() {
    _webSocketSubscription.cancel(); // Safe cancel with null check
    try {
      widget.channel.sink.close(); // Safely close the sink
    } catch (e) {
      debugPrint('Error closing WebSocket: $e');
    }
    super.dispose();
  }

  Future<void> _checkInitialStatus() async {
    if (!mounted) return;

    try {
      setState(() => _isLoading = true);
      await _verifyStatusWithApi(); // Use our robust verification method

      // If we still don't have a status after initial check
      if (mounted && _status.isEmpty) {
        setState(() => _status = 'STATUS_CHECKED');
      }
    } catch (e) {
      if (mounted) {
        setState(() => _status = 'INITIAL_CHECK_ERROR');
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _initializeWebSocket() async {
    try {
      await widget.channel.ready;
      if (mounted) {
        setState(() => _isWebSocketConnected = true);
      }

      _webSocketSubscription = widget.channel.stream.listen((message) async {
        try {
          final body = json.decode(message);
          final statusMessage = json
              .decode(body['transactionStatus'])['message']
              .toString()
              .toUpperCase();

          // Only process if mounted and status isn't already SUCCESS
          if (mounted && _status != 'SUCCESS') {
            await _handleStatusUpdate(statusMessage);
          }
        } catch (e) {
          if (mounted) {
            setState(() => _status = 'DECODING_ERROR');
          }
        }
      });
    } catch (e) {
      if (mounted) {
        setState(() => _status = 'CONNECTION_ERROR');
      }
    }
  }

  Future<void> _handleStatusUpdate(String newStatus) async {
    // Update immediately with the WebSocket status
    setState(() {
      final socketStatus = newStatus == 'RES000' ? 'SUCCESS' : newStatus.toUpperCase();
      _status = socketStatus;
    });

    // Skip API verification if status came from WebSocket
    if (newStatus.toUpperCase() == "VERIFIED") return;

    // Then verify with the API
    await _verifyStatusWithApi();
  }

  Future<void> _verifyStatusWithApi() async {
    try {
      if (!mounted) return;

      setState(() => _isLoading = true);
      final apiStatus = await widget.checkPaymentStatus(widget.paymentReference);
      final normalizedApiStatus = apiStatus == 'RES000' ? 'SUCCESS' : apiStatus.toUpperCase();
      // Only update if:
      // 1. We don't already have SUCCESS, AND
      // 2. The API status is different from current status
      if (mounted && _status != 'SUCCESS' && normalizedApiStatus != _status) {
        setState(() => _status = normalizedApiStatus);
      }

      // If API confirms success, ensure we keep it
      if (mounted && normalizedApiStatus == 'SUCCESS') {
        setState(() => _status = 'SUCCESS');
      }
    } catch (e) {
      if (mounted) {
        setState(() => _status = 'VERIFICATION_ERROR');
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'SUCCESS':
        return Colors.green;
      case 'PENDING':
      case 'AWAITING':
        return Colors.orangeAccent;
      case 'FAILED':
      case 'ERROR':
      case 'CONNECTION_ERROR':
        return Colors.red;
      case 'VERIFIED':
        return Colors.deepOrangeAccent; // or whatever fits your theme
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    debugPrint("➡️➡️➡️➡️➡️➡️ Status 💚💚💚💚💚💚  ==> $_status");
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      elevation: 4,
      insetPadding: const EdgeInsets.symmetric(horizontal: 20),
      child: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(24)),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Header with logo
              Image.asset('assets/images/nepventLogo.png', width: 180, height: 55),
              const SizedBox(height: 12),
              Text(
                'Scan to Pay',
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.blue.shade800,
                ),
              ),

              const SizedBox(height: 12),

              // Payment details card
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.grey.shade50,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey.shade200),
                ),
                child: Column(
                  children: [
                    // Reference Number
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: RichText(
                        text: TextSpan(
                          style: GoogleFonts.poppins(fontSize: 13, color: Colors.grey.shade800),
                          children: [
                            TextSpan(
                              text: 'Reference Number : ',
                              style: GoogleFonts.poppins(fontSize: 13, color: Colors.grey.shade600),
                            ),
                            TextSpan(
                              text: widget.paymentReference,
                              style: GoogleFonts.poppins(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: Colors.blue.shade800,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    // Divider
                    Divider(color: Colors.grey.shade300, height: 1),
                    const SizedBox(height: 8),
                    // Amount
                    Column(
                      children: [
                        Text(
                          'Amount to Pay',
                          style: GoogleFonts.poppins(fontSize: 14, color: Colors.grey.shade600),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Rs. ${widget.requestData['paymentAmount'].toString()}',
                          style: GoogleFonts.poppins(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: Colors.green.shade700,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // QR Code Section
              Container(
                height: 250,
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.grey.shade50,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey.shade200),
                ),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.grey.shade300, width: 1),
                      ),
                      child: SizedBox(
                        width: 220.0,
                        height: 220.0,
                        child: QrImageView(
                          data: widget.qrMessage,
                          version: QrVersions.auto,
                          size: 220.0,
                          backgroundColor: Colors.white,
                          // embeddedImage: const AssetImage('assets/images/fonepayLogo.png'),
                          embeddedImageStyle: const QrEmbeddedImageStyle(size: Size(40, 40)),
                        ),
                      ),
                    ),
                    if (_status == 'SUCCESS')
                      Positioned.fill(
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.5),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Center(
                            child: Lottie.asset(
                              'assets/lottie_animations/tick.json',
                              width: 100,
                              height: 100,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                    if (_isLoading) const Center(child: CircularProgressIndicator()),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // Status and connection indicator
              Column(
                children: [
                  // Connection status
                  if (!_isWebSocketConnected)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.wifi_off, size: 16, color: Colors.orange),
                          const SizedBox(width: 4),
                          Text(
                            'Reconnecting...',
                            style: GoogleFonts.poppins(fontSize: 12, color: Colors.orange),
                          ),
                        ],
                      ),
                    ),

                  // Status badge
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
                    decoration: BoxDecoration(
                      color: _getStatusColor(_status).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(
                        color: _getStatusColor(_status).withOpacity(0.3),
                        width: 1,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (_status == 'SUCCESS')
                          Icon(Icons.verified, color: _getStatusColor(_status), size: 18),
                        if (_status == 'PENDING' || _status == 'AWAITING')
                          Icon(Icons.access_time, color: _getStatusColor(_status), size: 18),
                        if (_status == 'FAILED' || _status == 'ERROR')
                          Icon(Icons.error_outline, color: _getStatusColor(_status), size: 18),
                        if (_status == 'VERIFIED')
                          Icon(Icons.check_circle, color: _getStatusColor(_status), size: 18),
                        const SizedBox(width: 8),
                        Text(
                          _status,
                          style: GoogleFonts.poppins(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: _getStatusColor(_status),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              // Check Status Button
              if (_status != 'SUCCESS')
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _isLoading
                        ? null
                        : () async {
                            setState(() => _isLoading = true);
                            await _verifyStatusWithApi();
                            setState(() => _isLoading = false);
                          },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue.shade700,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      elevation: 0,
                    ),
                    child: _isLoading
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                          )
                        : Text(
                            'Check Payment Status',
                            style: GoogleFonts.poppins(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: Colors.white,
                            ),
                          ),
                  ),
                ),

              const SizedBox(height: 16),

              // Footer logo
              Image.asset('assets/images/fonepayLogo.png', width: 140, height: 42),

              const SizedBox(height: 8),

              // Close button
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text(
                  'Close',
                  style: GoogleFonts.poppins(
                    color: Colors.blue.shade700,
                    fontWeight: FontWeight.w500,
                    fontSize: 16,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
