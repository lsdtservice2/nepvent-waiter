import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:isar/isar.dart';
import 'package:nepvent_waiter/Models/TableData.dart';
import 'package:nepvent_waiter/Models/Table_Location.dart';
import 'package:nepvent_waiter/UI/Design/AppTheme.dart';
import 'package:nepvent_waiter/UI/Design/CustomFloatingActionButton.dart';
import 'package:nepvent_waiter/UI/Design/LoadingWidget.dart';
import 'package:nepvent_waiter/UI/Design/PopupMenuWidget.dart';
import 'package:nepvent_waiter/UI/Screens/MenuSelectionWidget.dart';
import 'package:nepvent_waiter/UI/Screens/TableOptionsWidget.dart';
import 'package:nepvent_waiter/UI/Screens/TransitionWidget.dart';
import 'package:nepvent_waiter/Utils/Constant.dart';

class TableSelectionWidget extends StatefulWidget {
  const TableSelectionWidget({super.key});

  @override
  State<TableSelectionWidget> createState() => _TableSelectionWidgetState();
}

class _TableSelectionWidgetState extends State<TableSelectionWidget> {
  final scaffoldKey = GlobalKey<ScaffoldState>();

  List<TableLocation> locations = [];
  List<TableData> allTables = [];
  List<TableData> filteredTables = [];

  TableLocation? selectedLocation;

  late Future<void> _initialFetch;

  late Stream<List<TableData>> _tableWatchStream;

  @override
  void initState() {
    super.initState();
    _initialFetch = _fetchInitialData();
    _tableWatchStream = isar.tableDatas.where().watch(fireImmediately: true);
  }

  Future<void> _fetchInitialData() async {
    locations = await isar.tableLocations.where().findAll();
    allTables = await isar.tableDatas.where().findAll();
    if (locations.isNotEmpty) {
      selectedLocation = locations.first;
      _filterTables();
    }
  }

  void _filterTables() {
    if (selectedLocation != null) {
      filteredTables = allTables
          .where((table) => table.locationId == selectedLocation!.id)
          .toList();
    } else {
      filteredTables = [];
    }
  }

  Future<void> _onLocationChanged(int? locationId) async {
    if (locationId == null) return;

    setState(() {
      selectedLocation = locations.firstWhere((loc) => loc.id == locationId);
      _filterTables();
    });
  }

  Future<void> _refresh() async {
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => TransitionWidget()));
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<void>(
      future: _initialFetch,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return LoadingWidget();
        }
        return StreamBuilder<List<TableData>>(
          stream: _tableWatchStream,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              allTables = snapshot.data!;
              _filterTables();
            }
            return Scaffold(
              key: scaffoldKey,
              appBar: AppBar(
                backgroundColor: AppTheme.of(context).primaryBackground,
                automaticallyImplyLeading: false,
                title: Text(
                  'Table Selection',
                  style: AppTheme.of(context).title1.override(
                    fontFamily: AppTheme.of(context).title1.fontFamily,
                    color: AppTheme.of(context).primaryText,
                    useGoogleFonts: GoogleFonts.asMap().containsKey(
                      AppTheme.of(context).title1.fontFamily,
                    ),
                  ),
                ),
                actions: [PopupMenuWidget()],
              ),
              body: SafeArea(
                child: RefreshIndicator(
                  displacement: 100,
                  onRefresh: _refresh,
                  child: Column(
                    children: [
                      _buildDropdown(),
                      Expanded(
                        child: GridView.builder(
                          padding: const EdgeInsets.all(10),
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                            childAspectRatio: 1,
                            crossAxisSpacing: 10,
                            mainAxisSpacing: 10,
                          ),
                          itemCount: filteredTables.length,
                          itemBuilder: (context, index) {
                            final table = filteredTables[index];
                            return _buildTableCard(table);
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              floatingActionButton: const CustomFloatingActionButton(),
              floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
            );
          },
        );
      },
    );
  }

  Widget _buildDropdown() {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.grey.shade400),
        ),
        child: DropdownButtonHideUnderline(
          child: DropdownButton<int>(
            isExpanded: true,
            value: selectedLocation?.id,
            hint: const Text("Select Location"),
            items: locations.map((loc) {
              final tablesAtLoc = allTables.where((t) => t.locationId == loc.id);
              final occupied = tablesAtLoc.where((t) => t.occupied).length;
              final free = tablesAtLoc.length - occupied;

              return DropdownMenuItem<int>(
                value: loc.id,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(child: Text(loc.name, overflow: TextOverflow.ellipsis)),
                    Row(
                      children: [
                        _statusDot(Colors.red),
                        Text('$occupied', style: const TextStyle(fontSize: 12)),
                        const SizedBox(width: 6),
                        _statusDot(Colors.green),
                        Text('$free', style: const TextStyle(fontSize: 12)),
                      ],
                    ),
                  ],
                ),
              );
            }).toList(),
            onChanged: _onLocationChanged,
          ),
        ),
      ),
    );
  }

  Widget _statusDot(Color color) {
    return Container(
      width: 10,
      height: 10,
      margin: const EdgeInsets.symmetric(horizontal: 4),
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
    );
  }

  Widget _buildTableCard(TableData table) {
    return GestureDetector(
      onTap: () async {
        await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MenuSelectionWidget(
              tableName: table.table_name,
              tableId: table.id,
              tableLocation: table.locationId,
            ),
          ),
        );
      },
      onLongPress: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => TableOptionsWidget(
              tableName: table.table_name,
              tableId: table.id,
              locations: locations,
              allTables: allTables,
              occupied: table.occupied,
              join: table.joinedTable.length,
              link: table.sourceTable.length,
            ),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: table.occupied
              ? AppTheme.of(context).retroRedYellow
              : AppTheme.of(context).retroMintBlue,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: Text(
                table.table_name,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: table.occupied
                      ? AppTheme.of(context).retroRedYellowFont
                      : AppTheme.of(context).retroMintBlueFont,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            if (table.sourceTable.isNotEmpty || table.joinedTable.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    if (table.sourceTable.isNotEmpty || table.joinedTable.isNotEmpty)
                      Container(
                        constraints: const BoxConstraints(maxWidth: 120), // optionally limit width
                        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppTheme.of(context).retroRedYellowFont.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Wrap(
                          alignment: WrapAlignment.center,
                          children: [
                            if (table.sourceTable.isNotEmpty)
                              Icon(
                                Icons.anchor,
                                size: 18,
                                color: AppTheme.of(context).chineseBlack.withOpacity(0.8),
                              ),
                            if (table.joinedTable.isNotEmpty)
                              Icon(
                                Icons.link,
                                size: 18,
                                color: AppTheme.of(context).chineseBlack.withOpacity(0.8),
                              ),
                            const SizedBox(width: 4),
                            Text(
                              [
                                if (table.sourceTable.isNotEmpty)
                                  table.sourceTable
                                      .map((st) => st.secondaryTable.table_name)
                                      .join(', '),
                                if (table.joinedTable.isNotEmpty)
                                  table.joinedTable
                                      .map((jt) => jt.primaryJoin.table_name)
                                      .join(', '),
                              ].join('\n'),
                              style: AppTheme.of(context).subtitle2.override(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: AppTheme.of(context).chineseBlack.withOpacity(0.8),
                                useGoogleFonts: GoogleFonts.asMap().containsKey(
                                  AppTheme.of(context).subtitle2.fontFamily,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
