import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import 'package:lottie/lottie.dart';
import 'package:nepvent_waiter/Controller/NepventProvider.dart';
import 'package:nepvent_waiter/Controller/NotificationService.dart';
import 'package:nepvent_waiter/Models/TableData.dart';
import 'package:nepvent_waiter/UI/HomeWidget.dart';
import 'package:nepvent_waiter/UI/Screens/TableSelectionWidget.dart';
import 'package:nepvent_waiter/Utils/Constant.dart';
import 'package:provider/provider.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class SocketService {
  // Constants
  static const String mergeSuccess = 'MERGE_success';
  static const String changeSuccess = 'CHANGE_success';
  static const String joinSuccess = 'JOIN_success';
  static const Color primaryColor = Color(0xFF303068);
  static const List<String> roomsToJoin = ['ORDERS', 'TABLES'];

  final NotificationService _notificationService;
  late IO.Socket socket;
  bool _isConnected = false;

  SocketService(this._notificationService);

  // Public API
  Future<void> connectSocket(String url, String token) async {
    try {
      _initializeSocket(url, token);
      _setupSocketEventHandlers(token);
      socket.connect();
    } catch (e) {
      log('Socket connection error: $e');
      rethrow;
    }
  }

  void disconnect() {
    if (_isConnected) {
      socket.disconnect();
      socket.dispose();
      _isConnected = false;
    }
  }

  bool get isConnected => _isConnected;

  void checkConnection() {
    log('Socket connected: ${socket.connected}');
  }

  void requestInvoice(int locationId, int tableId) {
    if (!_isConnected) return;

    socket.emit('invoiceRequest', {'location_id': locationId, 'table_id': tableId});
  }

  // Socket Initialization
  void _initializeSocket(String url, String token) {
    socket = IO.io(
      url,
      IO.OptionBuilder()
          .setTransports(['websocket', 'polling'])
          .disableAutoConnect()
          .setExtraHeaders({
            'Connection': 'upgrade',
            'Upgrade': 'websocket',
            'authentication': token,
            'path': '443',
          })
          .setQuery({'token': token})
          .build(),
    );
  }

  // Event Handlers Setup
  void _setupSocketEventHandlers(String token) {
    _setupConnectionHandlers(token);
    _setupErrorHandlers();
    _setupNotificationHandlers();
    _setupTableHandlers();
    _setupOrderHandlers();
  }

  void _setupConnectionHandlers(String token) {
    socket.onConnect((_) {
      _isConnected = true;
      log('Socket connected: ${socket.id}');

      // Emit initial connection events
      socket.emit('userConnected', {'socketId': socket.id, 'token': token});

      // Join required rooms
      for (final room in roomsToJoin) {
        socket.emit('joinRoom', room);
      }

      socket.emit('checkOccupied');
    });

    socket.onDisconnect((_) {
      _isConnected = false;
      log('Socket disconnected');
    });
  }

  void _setupErrorHandlers() {
    socket.onConnectError((error) => log('Connect Error: $error'));
    socket.onError((error) => log('Socket Error: $error'));
    socket.on('connect_error', (error) => log('Connection Error: $error'));
  }

  void _setupNotificationHandlers() {
    socket.on('WAITER_CALL_success', (data) {
      _notificationService.showWaiterCallNotification(data);
    });

    socket.on('connectionSuccess', (data) => log('Connection Success: $data'));
  }

  // for call function only 1 time with in a second
  Timer? _refreshDebounce;

  void _debouncedRefresh(dynamic data) {
    // Cancel the previous timer if it's still active
    if (_refreshDebounce?.isActive ?? false) _refreshDebounce!.cancel();

    // Start a new debounce timer
    _refreshDebounce = Timer(const Duration(seconds: 1), () {
      _handleRefreshRequest(data);
    });
  }

  void _setupTableHandlers() {
    socket.on('REFRESH_APP', _debouncedRefresh);
    socket.on('UNOCCUPIED', _handleUnoccupiedTables);
    socket.on('TABLE_OCCUPIED', _handleTableOccupied);
  }

  void _setupOrderHandlers() {
    socket.on('ORDERS_error', _handleOrderError);
    socket.on('ORDERS_success', _handleOrderSuccess);
  }

  // Table Operation Handlers
  void setupTableOperationListeners(BuildContext context) {
    socket.on(changeSuccess, (data) => _handleTableChange(data, context));
    socket.on(mergeSuccess, (data) => _handleTableMerge(data, context));
    socket.on(joinSuccess, (data) => _handleTableJoin(data, context));
  }

  Future<void> _handleRefreshRequest(dynamic data) async {
    debugPrint('🔜🔜🔜🔜 Chose to refresh later');
    final context = navigatorKey.currentContext;
    if (context == null) {
      debugPrint('⚠️ navigatorKey context is null — cannot show dialog.');
      return;
    }

    await _showRefreshDialog(
      title: 'Update Available',
      message: "We've made some improvements! Refresh to see the latest changes.",
      confirmText: 'Refresh Now',
      onConfirm: () {
        // Reset the refresh flag
        context.read<NepventProvider>().isNeedRefresh = false;

        // Navigate with a fade transition
        Navigator.pushReplacement(
          context,
          PageRouteBuilder(
            pageBuilder: (_, __, ___) => const HomeWidget(),
            transitionsBuilder: (_, animation, __, child) =>
                FadeTransition(opacity: animation, child: child),
            transitionDuration: const Duration(milliseconds: 250),
          ),
        );
      },
    );
  }

  Future<void> _handleUnoccupiedTables(dynamic data) async {
    log('Void Menu: ${data['message']}');
    final voidData = data['message'][1];

    await _performDatabaseOperation(() async {
      for (var record in voidData) {
        final tableRecord = await isar.tableDatas.filter().idEqualTo(record['id']).findFirst();

        if (tableRecord != null) {
          tableRecord.occupied = record['occupied'];
          tableRecord.joinedTable = [];
          tableRecord.sourceTable = [];
          await isar.tableDatas.put(tableRecord);
        }
      }
    });
  }

  Future<void> _handleTableOccupied(dynamic data) async {
    log('Table Occupied: $data');
    final tableUpdateId = data['table']['id'] as int;

    await _performDatabaseOperation(() async {
      final table = await isar.tableDatas.filter().idEqualTo(tableUpdateId).findFirst();

      if (table != null) {
        table.occupied = data['table']['occupied'];
        await isar.tableDatas.put(table);
      }
    });
  }

  // Order Handlers
  Future<void> _handleOrderError(dynamic data) async {
    if (socket.id == data['socketId']) {
      await _showAlertDialog(
        title: 'Order Failed',
        message: 'Failed to place order.',
        buttonText: 'OK',
      );
    }
  }

  Future<void> _handleOrderSuccess(dynamic data) async {
    if (data['message']['tableUpdate'] != null) {
      await _updateTableStatus(data['message']['tableUpdate']);

      if (socket.id == data['socketId']) {
        final kotNumber = data['message']['newOrder'][0]['order']['kot_number'];
        await _showAlertDialog(
          title: 'Order Placed',
          message: 'KOT number: $kotNumber',
          buttonText: 'OK',
          onPressed: () => Navigator.pushReplacement(
            navigatorKey.currentContext!,
            MaterialPageRoute(builder: (context) => const TableSelectionWidget()),
          ),
        );
      }
    }
  }

  // Table Operation Implementations
  Future<void> _handleTableChange(dynamic data, BuildContext context) async {
    debugPrint(' ©️©️©️©️©️😅😅😅😅 $data');
    await _updateTablePairStatus(data['message']['fromTable'], data['message']['toTable']);

    await _showOperationSuccessDialog(
      context: navigatorKey.currentContext!,
      title: 'Table Changed',
      message:
          "From: ${data['message']['fromTable']['table_name']}\n"
          "To: ${data['message']['toTable']['table_name']}",
    );
  }

  Future<void> _handleTableMerge(dynamic data, BuildContext context) async {
    await _updateTablePairStatus(
      data['message']['sourceTable'],
      data['message']['destinationTable'],
    );

    await _showOperationSuccessDialog(
      context: navigatorKey.currentContext!,
      title: 'Tables Merged',
      message:
          "Source: ${data['message']['sourceTable']['table_name']}\n"
          "Destination: ${data['message']['destinationTable']['table_name']}",
    );
  }

  Future<void> _handleTableJoin(dynamic data, BuildContext context) async {
    await _joinDataStore(data);

    final joinedTables = data['message']['tablesToOccupy']
        .map<String>((t) => t['table_name'] as String)
        .join(', ');

    await _showOperationSuccessDialog(
      context: navigatorKey.currentContext!,
      title: 'Tables Joined',
      message: joinedTables,
    );
  }

  // Database Operations
  Future<void> _performDatabaseOperation(Function operation) async {
    try {
      await isar.writeTxn(() async => await operation());
    } catch (e) {
      log('Database operation failed: $e');
    }
  }

  Future<void> _updateTableStatus(dynamic tableData) async {
    await _performDatabaseOperation(() async {
      final tableId = tableData['id'] as int;
      final table = await isar.tableDatas.filter().idEqualTo(tableId).findFirst();

      if (table != null) {
        table.occupied = tableData['occupied'];
        await isar.tableDatas.put(table);
      }
    });
  }

  Future<void> _updateTablePairStatus(dynamic table1, dynamic table2) async {
    await _performDatabaseOperation(() async {
      final tbl1 = await isar.tableDatas.filter().idEqualTo(table1['id']).findFirst();
      final tbl2 = await isar.tableDatas.filter().idEqualTo(table2['id']).findFirst();

      if (tbl1 != null) {
        tbl1.occupied = table1['occupied'];
        await isar.tableDatas.put(tbl1);
      }
      if (tbl2 != null) {
        tbl2.occupied = table2['occupied'];
        await isar.tableDatas.put(tbl2);
      }
    });
  }

  Future<void> _joinDataStore(dynamic data) async {
    await _performDatabaseOperation(() async {
      final pId = data['message']['primaryTable']['id'];
      final pTbl = await isar.tableDatas.filter().idEqualTo(pId).findFirst();

      if (pTbl != null) {
        for (var joinSe in data['message']['joinSuccess']) {
          if (joinSe['table'] == pTbl.id) {
            final secTable = _findSecondaryTable(
              data['message']['tablesToOccupy'],
              joinSe['joinedTable'],
            );

            if (secTable != null) {
              final sourceTable = SourceTable()
                ..id = joinSe['id']
                ..table = joinSe['table']
                ..joinTable = joinSe['joinedTable']
                ..secondaryTable = secTable;

              pTbl.occupied = true;
              pTbl.sourceTable = [...pTbl.sourceTable, sourceTable];
              await isar.tableDatas.put(pTbl);
            }
          }

          final childTable = await isar.tableDatas
              .filter()
              .idEqualTo(joinSe['joinedTable'])
              .findFirst();

          if (childTable != null) {
            final primaryJoin = PrimaryJoin()
              ..id = data['message']['primaryTable']['id']
              ..table_name = data['message']['primaryTable']['table_name'];

            final joinedTable = JoinedTable()
              ..id = 0
              ..table = pTbl.id
              ..joinTable = joinSe['joinedTable']
              ..primaryJoin = primaryJoin;

            childTable.occupied = true;
            childTable.joinedTable = [...childTable.joinedTable, joinedTable];
            await isar.tableDatas.put(childTable);
          }
        }
      }
    });
  }

  SecondaryTable? _findSecondaryTable(List tablesToOccupy, int joinedTableId) {
    for (var tbl in tablesToOccupy) {
      if (tbl['id'] == joinedTableId) {
        return SecondaryTable()
          ..id = tbl['id']
          ..table_name = tbl['table_name'];
      }
    }
    return null;
  }

  Future<void> _showAlertDialog({
    required String title,
    required String message,
    required String buttonText,
    String? secondaryButtonText,
    VoidCallback? onPressed,
    VoidCallback? onSecondaryPressed,
    IconData? icon,
    Color? iconColor,
    Color? buttonColor,
  }) async {
    final theme = Theme.of(navigatorKey.currentContext!);
    final isDarkMode = theme.brightness == Brightness.dark;

    await showDialog(
      context: navigatorKey.currentContext!,
      barrierDismissible: false,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
        elevation: 0,
        backgroundColor: Colors.transparent,
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: isDarkMode ? Colors.grey[900] : Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(color: Colors.black.withOpacity(0.2), blurRadius: 10, spreadRadius: 2),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (icon != null)
                Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: Icon(icon, size: 48, color: iconColor ?? theme.primaryColor),
                ),
              Text(
                title,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: isDarkMode ? Colors.white : Colors.grey[800],
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              Text(
                message,
                style: TextStyle(
                  fontSize: 16,
                  color: isDarkMode ? Colors.grey[300] : Colors.grey[700],
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (secondaryButtonText != null)
                    Expanded(
                      child: OutlinedButton(
                        onPressed: onSecondaryPressed ?? () => Navigator.pop(context),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          side: BorderSide(
                            color: isDarkMode ? Colors.grey[700]! : Colors.grey[300]!,
                          ),
                        ),
                        child: Text(
                          secondaryButtonText,
                          style: TextStyle(color: isDarkMode ? Colors.white : Colors.grey[800]),
                        ),
                      ),
                    ),
                  if (secondaryButtonText != null) const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: onPressed ?? () => Navigator.pop(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: buttonColor ?? theme.primaryColor,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        elevation: 0,
                      ),
                      child: Text(
                        buttonText,
                        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                      ),
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

  Future<void> _showOperationSuccessDialog({
    required BuildContext context,
    required String title,
    required String message,
  }) async {
    await showDialog(
      context: context, // Using the passed context instead of navigatorKey
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
        elevation: 0,
        backgroundColor: Colors.transparent,
        child: Container(
          padding: const EdgeInsets.all(24.0),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(16.0),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 24,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.verified, color: Theme.of(context).colorScheme.primary, size: 64),
              const SizedBox(height: 16),
              Text(
                title,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              Text(
                message,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onSurface.withOpacity(0.8),
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  style: FilledButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    backgroundColor: Theme.of(context).colorScheme.primary,
                  ),
                  onPressed: () => Navigator.pushReplacement(
                    navigatorKey.currentContext!,
                    MaterialPageRoute(builder: (context) => const TableSelectionWidget()),
                  ),

                  child: Text(
                    'OK',
                    style: Theme.of(context).textTheme.labelLarge?.copyWith(
                      color: Theme.of(context).colorScheme.onPrimary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _showRefreshDialog({
    required String title,
    required String message,
    required String confirmText,
    required VoidCallback onConfirm,
  }) async {
    await showDialog(
      context: navigatorKey.currentContext!,
      barrierDismissible: false,
      barrierColor: Colors.black54,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
        elevation: 8,
        insetPadding: const EdgeInsets.symmetric(horizontal: 24),
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Animated icon
              Lottie.asset(
                'assets/lottie_animations/refresh.json',
                width: 150,
                height: 150,
                repeat: true,
              ),
              const SizedBox(height: 8),

              // Title
              Text(
                title,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.blueGrey,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),

              // Message
              Text(
                message,
                style: const TextStyle(fontSize: 16, color: Colors.grey),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),

              // Buttons row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  // Later button
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                        context.read<NepventProvider>().isNeedRefresh = true;
                      },
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        side: const BorderSide(color: Colors.blueGrey),
                      ),
                      child: const Text(
                        'Later',
                        style: TextStyle(color: Colors.blueGrey, fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),

                  // Refresh button
                  Expanded(
                    child: ElevatedButton(
                      onPressed: onConfirm,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        backgroundColor: Theme.of(context).primaryColor,
                        elevation: 2,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.refresh, size: 20, color: Colors.white),
                          const SizedBox(width: 8),
                          Text(
                            confirmText,
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
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
    );
  }
}
