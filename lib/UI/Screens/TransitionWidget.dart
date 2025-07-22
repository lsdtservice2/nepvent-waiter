import 'package:flutter/material.dart';
import 'package:nepvent_waiter/Models/CategoryMenus.dart';
import 'package:nepvent_waiter/Models/Menus.dart';
import 'package:nepvent_waiter/Models/PrimaryCategoryMenu.dart';
import 'package:nepvent_waiter/Models/TableData.dart';
import 'package:nepvent_waiter/Models/Table_Location.dart';
import 'package:nepvent_waiter/UI/Design/LoadingWidget.dart';
import 'package:nepvent_waiter/UI/Screens/TableSelectionWidget.dart';
import 'package:nepvent_waiter/Utils/Constant.dart';
import 'package:nepvent_waiter/Utils/Urls.dart';

class TransitionWidget extends StatefulWidget {
  const TransitionWidget({super.key});

  @override
  State<TransitionWidget> createState() => _TransitionWidgetState();
}

class _TransitionWidgetState extends State<TransitionWidget> {
  late Future<void> _initialLoad;

  @override
  void initState() {
    super.initState();
    // socketService.tableOptionsSocket(navigatorKey.currentContext!);
    // socketService.orderListenSockets();
    _initialLoad = _loadAndStoreData();
  }

  Future<void> _loadAndStoreData() async {
    try {
      final responses = await Future.wait([
        dio.get(urls['tableLocation']!),
        dio.get(urls['menuPrimaryCategory']!),
        dio.get(urls['tables']!),
      ]);

      final locationData = responses[0].data['message'] ?? [];
      final menuData = responses[1].data['message'] ?? [];
      final tableData = responses[2].data['message'] ?? [];

      final filteredLocations = locationData.where((e) => e['OrderSource']?['name'] == 'TABLE').toList();

      await isar.writeTxn(() async {
        await Future.wait([
          isar.tableLocations.clear(),
          isar.primaryCategoryMenus.clear(),
          isar.categoryMenus.clear(),
          isar.menus.clear(),
          isar.tableDatas.clear(),
        ]);

        await _storeLocations(filteredLocations);
        await _storeMenus(menuData);
        await _storeTables(tableData);
      });
    } catch (e) {
      debugPrint('Error during data load: $e');
    }
  }

  Future<void> _storeLocations(List<dynamic> locations) async {
    final locationObjs = locations
        .map(
          (loc) => TableLocation()
            ..id = loc['id']
            ..name = loc['name'],
        )
        .toList();
    await isar.tableLocations.putAll(locationObjs);
  }

  Future<void> _storeMenus(List<dynamic> menuData) async {
    final List<Menus> menuList = [];
    final List<PrimaryCategoryMenu> primaryList = [];
    final List<CategoryMenus> categoryList = [];

    for (final menus in menuData) {
      final primary = PrimaryCategoryMenu()
        ..id = menus['id']
        ..name = menus['name'];
      primaryList.add(primary);

      for (final cat in menus['MenuCategories'] ?? []) {
        final category = CategoryMenus()
          ..id = cat['id']
          ..primaryCategoryId = menus['id']
          ..name = cat['name']
          ..disableDiscount = cat['disableDiscount'];
        categoryList.add(category);

        for (final m in cat['Menus'] ?? []) {
          final discounts = (m['discount'] as List? ?? [])
              .map(
                (d) => Discount()
                  ..name = d['name']
                  ..toDate = DateTime.parse(d['toDate'])
                  ..toTime = DateTime.parse(d['toTime'])
                  ..percent = d['percent'] ?? false
                  ..discount = d['discount']
                  ..flatRate = d['flatRate']
                  ..fromDate = DateTime.parse(d['fromDate'])
                  ..fromTime = DateTime.parse(d['fromTime']),
              )
              .toList();

          final optioned = (m['options'] as List? ?? [])
              .map(
                (o) => Optioned()
                  ..name = o['name']
                  ..type = o['type']
                  ..min = o['min']
                  ..max = o['max']
                  ..current = o['current']
                  ..opts = (o['opts'] as List)
                      .map(
                        (op) => Opts()
                          ..optName = op['opt']
                          ..optPrice = op['price']
                          ..selected = false
                          ..count = 0
                          ..quantityEligible = op['quantityEligible'] ?? false,
                      )
                      .toList(),
              )
              .toList();

          final menu = Menus()
            ..id = m['id']
            ..name = m['name']
            ..price = double.tryParse(m['price'].toString()) ?? 0.0
            ..vatInc = m['vat_inc'] ?? false
            ..discount = discounts
            ..optioned = optioned
            ..isWeighted = m['isWeighted'] ?? false
            ..categoryMenuId = cat['id']
            ..itemAvailable = m['item_available'] ?? -1;

          menuList.add(menu);
        }
      }
    }

    await isar.primaryCategoryMenus.putAll(primaryList);
    await isar.categoryMenus.putAll(categoryList);
    await isar.menus.putAll(menuList);
  }

  Future<void> _storeTables(List<dynamic> tableData) async {
    final List<TableData> tables = [];

    for (final table in tableData) {
      for (final tbl in table['Tables']) {
        final sources = (tbl['sourceTable'] as List? ?? [])
            .map(
              (st) => SourceTable()
                ..id = st['id']
                ..table = st['table']
                ..joinTable = st['joinedTable']
                ..secondaryTable = (SecondaryTable()
                  ..id = st['secondaryJoin']['id']
                  ..table_name = st['secondaryJoin']['table_name']),
            )
            .toList();

        final joins = (tbl['joinedTable'] as List? ?? [])
            .map(
              (jt) => JoinedTable()
                ..id = jt['id']
                ..table = jt['table']
                ..joinTable = jt['joinedTable']
                ..primaryJoin = (PrimaryJoin()
                  ..id = jt['primaryJoin']['id']
                  ..table_name = jt['primaryJoin']['table_name']),
            )
            .toList();

        final tData = TableData()
          ..id = tbl['id']
          ..table_name = tbl['table_name']
          ..locationId = tbl['location_id']
          ..occupied = tbl['occupied'] ?? false
          ..sourceTable = sources
          ..joinedTable = joins;

        tables.add(tData);
      }
    }

    await isar.tableDatas.putAll(tables);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _initialLoad,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return LoadingWidget();
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: \${snapshot.error}'));
        } else {
          return const TableSelectionWidget();
        }
      },
    );
  }
}
