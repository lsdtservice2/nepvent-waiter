import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nepvent_waiter/Controller/SocketService.dart';
import 'package:nepvent_waiter/Models/TableData.dart';
import 'package:nepvent_waiter/Object/ChipData.dart';
import 'package:nepvent_waiter/Object/TableState.dart';
import 'package:nepvent_waiter/UI/Design/AppTheme.dart';
import 'package:nepvent_waiter/UI/Design/CustomFloatingActionButton.dart';
import 'package:nepvent_waiter/Utils/Constant.dart';
import 'package:nepvent_waiter/Utils/Urls.dart';
import 'package:provider/provider.dart';

class TableOptionsWidget extends StatefulWidget {
  const TableOptionsWidget({
    super.key,
    required this.tableName,
    required this.tableId,
    required this.locations,
    this.allTables,
    required this.occupied,
    this.join,
    this.link,
  });

  final String tableName;
  final int tableId;
  final List<dynamic> locations;
  final List<TableData>? allTables;
  final bool occupied;
  final int? join;
  final int? link;

  @override
  State<TableOptionsWidget> createState() => _TableOptionsWidgetState();
}

class _TableOptionsWidgetState extends State<TableOptionsWidget> {
  String? _selectedAction;
  final scaffoldKey = GlobalKey<ScaffoldState>();
  String _selectedLocationId = '';

  List<int> _selectedTables = [];
  bool _enableSubmit = false;
  String _displayMessage = '';
  String _footMessage = '';
  late SocketService socketService;

  List<Map<String, dynamic>> _locationOptions = [];
  List<Widget> _tablesToDisplay = [];

  @override
  void initState() {
    super.initState();
    socketService = context.read<SocketService>();
    socketService.setupTableOperationListeners(context);
    _initializeLocationOptions();
  }

  void _initializeLocationOptions() {
    _locationOptions = widget.locations.map((location) {
      return {'name': location.name, 'id': location.id.toString()};
    }).toList();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _handleLocationSelection() {
    if (_selectedLocationId.isEmpty) {
      _tablesToDisplay = [];
      setState(() {});
      return;
    }

    final locationTables =
        widget.allTables
            ?.where((table) => table.locationId == int.parse(_selectedLocationId))
            .toList() ??
        [];

    _tablesToDisplay = locationTables.map((table) {
      final isCurrentTable = widget.tableId == table.id;
      final isJoinedTable = table.sourceTable.isNotEmpty || table.joinedTable.isNotEmpty;
      final isSelected = _selectedTables.contains(table.id);

      // Determine table state and styling
      final tableState = _getTableState(table, isCurrentTable, isJoinedTable);

      return GestureDetector(
        onTap: tableState.enabled ? () => _handleTableTap(table.id) : null,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeInOut,
          margin: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: isSelected ? Colors.green : tableState.backgroundColor,
            borderRadius: BorderRadius.circular(16),
            border: isSelected
                ? Border.all(color: AppTheme.of(context).primaryColor.withOpacity(0.8), width: 2)
                : null,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 6,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Stack(
            children: [
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        table.table_name,
                        style: AppTheme.of(context).title1.override(
                          fontFamily: AppTheme.of(context).title1.fontFamily,
                          color: tableState.textColor,
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          overflow: TextOverflow.ellipsis,
                          useGoogleFonts: GoogleFonts.asMap().containsKey(
                            AppTheme.of(context).title1.fontFamily,
                          ),
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
                              Tooltip(
                                message: [
                                  if (table.sourceTable.isNotEmpty)
                                    'Anchored to: ${table.sourceTable.map((st) => st.secondaryTable.table_name).join(', ')}',
                                  if (table.joinedTable.isNotEmpty)
                                    'Joined with: ${table.joinedTable.map((jt) => jt.primaryJoin.table_name).join(', ')}',
                                ].join('\n'),
                                child: Container(
                                  constraints: const BoxConstraints(maxWidth: 120),

                                  // optionally limit width
                                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: tableState.backgroundColor.withOpacity(0.2),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Wrap(
                                    alignment: WrapAlignment.center,
                                    children: [
                                      if (table.sourceTable.isNotEmpty)
                                        Icon(
                                          Icons.anchor,
                                          size: 14,
                                          color: tableState.textColor.withOpacity(0.8),
                                        ),
                                      if (table.joinedTable.isNotEmpty)
                                        Icon(
                                          Icons.link,
                                          size: 14,
                                          color: tableState.textColor.withOpacity(0.8),
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
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                          color: tableState.textColor.withOpacity(0.8),
                                          useGoogleFonts: GoogleFonts.asMap().containsKey(
                                            AppTheme.of(context).subtitle2.fontFamily,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
              if (!tableState.enabled)
                Positioned.fill(
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      color: Colors.black.withOpacity(0.3),
                    ),
                    child: Center(
                      child: Icon(Icons.block, color: Colors.white.withOpacity(0.7), size: 24),
                    ),
                  ),
                ),
            ],
          ),
        ),
      );
    }).toList();

    _updateSubmitButtonState();
    setState(() {});
  }

  TableState _getTableState(TableData table, bool isCurrentTable, bool isJoinedTable) {
    final theme = AppTheme.of(context);

    // Disable the current table
    if (isCurrentTable) {
      return TableState(
        enabled: false,
        backgroundColor: theme.primaryColor.withOpacity(0.2),
        textColor: theme.primaryColor,
      );
    }

    // 🛑 Specifically handle Join case: disable tables that are already joined
    if (_selectedAction == 'Join') {
      final isAlreadyJoined = table.sourceTable.isNotEmpty || table.joinedTable.isNotEmpty;
      if (isAlreadyJoined) {
        return TableState(
          enabled: false,
          backgroundColor: theme.retroRedYellow.withOpacity(0.2),
          textColor: theme.retroRedYellow,
        );
      }
    }

    // Highlight selected tables
    if (_selectedTables.contains(table.id)) {
      return TableState(
        enabled: true,
        backgroundColor: theme.primaryColor.withOpacity(0.8),
        textColor: Colors.white,
      );
    }

    // Merge and Join rules when table is occupied
    if (table.occupied) {
      if (_selectedAction == 'Merge') {
        return TableState(
          enabled: true,
          backgroundColor: theme.retroLgBlackLgGrGr,
          textColor: theme.retroLgBlackLgGrGrFont,
        );
      }

      if (_selectedAction == 'Join') {
        // ✅ Allow only unjoined occupied tables
        final isAlreadyJoined = table.sourceTable.isNotEmpty || table.joinedTable.isNotEmpty;
        if (!isAlreadyJoined) {
          return TableState(
            enabled: true,
            backgroundColor: theme.retroLgBlackLgGrGr,
            textColor: theme.retroLgBlackLgGrGrFont,
          );
        }
      }

      // default for occupied tables
      return TableState(
        enabled: false,
        backgroundColor: theme.retroRedYellow.withOpacity(0.2),
        textColor: theme.retroRedYellow,
      );
    }

    // Default available table
    return TableState(
      enabled: true,
      backgroundColor: theme.retroLgBlackLgGrGr,
      textColor: theme.retroLgBlackLgGrGrFont,
    );
  }

  void _handleTableTap(int id) {
    setState(() {
      if (_selectedAction == 'Change' || _selectedAction == 'Merge') {
        _selectedTables = [id];
      } else {
        if (_selectedTables.contains(id)) {
          _selectedTables.remove(id);
        } else {
          _selectedTables.add(id);
        }
      }

      _handleLocationSelection();
      _updateSubmitButtonState();
    });
  }

  void _updateSubmitButtonState() {
    if (_selectedTables.isEmpty || _selectedAction == null) {
      setState(() {
        _enableSubmit = false;
        _footMessage = '';
      });
      return;
    }

    final selectedTableNames = _selectedTables.map((id) {
      return widget.allTables?.firstWhere((t) => t.id == id).table_name ?? '';
    }).toList();

    String message = '';
    switch (_selectedAction) {
      case 'Change':
        message = 'Change ${widget.tableName} to ${selectedTableNames.join(', ')}';
        break;
      case 'Merge':
        message = 'Merge ${selectedTableNames.join(', ')} with ${widget.tableName}';
        break;
      case 'Join':
        message = 'Join ${selectedTableNames.join(', ')} with ${widget.tableName}';
        break;
    }

    setState(() {
      _footMessage = message;
      _enableSubmit = true;
    });
  }

  void _handleActionSelection(String? value) {
    if (value == null) return;

    setState(() {
      _selectedAction = value;
      _selectedTables.clear();
      _selectedLocationId = '';
      _tablesToDisplay = [];
      _footMessage = '';
      _enableSubmit = false;
      debugPrint('🎯 Selected Action: $_selectedAction');
    });

    switch (_selectedAction) {
      case 'Change':
        _displayMessage = 'Select 1 table to change to ${widget.tableName}';
        break;
      case 'Merge':
        _displayMessage = 'Select 1 table to merge with ${widget.tableName}';
        break;
      case 'Join':
        _displayMessage = 'Select 1 or more tables to join with ${widget.tableName}';
        break;
    }
  }

  Future<void> _confirmAction() async {
    try {
      late String? url;
      late Map<String, dynamic> requestData;
      late Response request;

      switch (_selectedAction) {
        case 'Change':
          url = urls['changeTable'];
          requestData = {'from': widget.tableId, 'to': _selectedTables.first};
          request = await dio.put(url!, data: requestData);
          debugPrint("🔄 Change Table Response: $request");
          break;

        case 'Merge':
          url = urls['mergeTable'];
          requestData = {'tableToMergeWith': widget.tableId, 'tableToMerge': _selectedTables.first};
          request = await dio.put(url!, data: requestData);
          debugPrint("🔀 Merge Table Response: $request");
          break;

        case 'Join':
          url = urls['joinTable'];
          requestData = {'table': widget.tableId, 'tablesToJoin': _selectedTables};
          request = await dio.post(url!, data: requestData);
          debugPrint("🔗 Join Table Response: $request");
          break;
      }

      if (request.statusCode != null && request.statusCode! >= 200 && request.statusCode! < 300) {
        _selectedTables.clear();
        _selectedLocationId = '';
        _footMessage = '';
        _enableSubmit = false;
      } else {
        debugPrint("⚠️ Unexpected status code: ${request.statusCode}");
      }
    } catch (e, stack) {
      debugPrint("❌ Error during $_selectedAction: $e");
      debugPrint("📌 Stack Trace: $stack");
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    final availableActions = widget.join! > 0 || widget.link! > 0
        ? [const ChipData('Join', Icons.link)]
        : widget.occupied
        ? [
            const ChipData('Change', Icons.swap_horiz),
            const ChipData('Merge', Icons.merge),
            const ChipData('Join', Icons.link),
          ]
        : [const ChipData('Join', Icons.link)];
    debugPrint('➡️➡️➡️➡️➡️➡️➡️  foot massage: $_footMessage and  Enable Submit => $_enableSubmit');

    return Scaffold(
      key: scaffoldKey,
      backgroundColor: theme.primaryBackground,
      appBar: AppBar(
        backgroundColor: theme.primaryBackground,
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_rounded, color: theme.primaryText, size: 30),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Table Options',
          style: theme.title1.override(
            fontFamily: theme.title1.fontFamily,
            color: theme.chineseBlack,
            fontSize: 22,
            fontWeight: FontWeight.w600,
            useGoogleFonts: GoogleFonts.asMap().containsKey(theme.title1.fontFamily),
          ),
        ),
        centerTitle: false,
        elevation: 0,
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Header Section
            _buildHeaderSection(theme, widget.tableName),
            // Main Content
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Action Selection
                    Text(
                      'Select Action',
                      style: theme.subtitle1.override(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: theme.primaryText.withOpacity(0.8),
                        useGoogleFonts: GoogleFonts.asMap().containsKey(theme.subtitle1.fontFamily),
                      ),
                    ),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: availableActions.map((option) {
                        final isSelected = _selectedAction == option.label;
                        return ActionChip(
                          label: Text(option.label),
                          avatar: Icon(option.icon, size: 18),
                          onPressed: () => _handleActionSelection(option.label),
                          backgroundColor: isSelected
                              ? theme.primaryColor.withOpacity(0.2)
                              : theme.primaryBackground,
                          labelStyle: theme.bodyText1.override(
                            color: isSelected ? theme.primaryColor : theme.primaryText,
                            fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                            useGoogleFonts: GoogleFonts.asMap().containsKey(
                              theme.bodyText1.fontFamily,
                            ),
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                            side: BorderSide(
                              color: isSelected ? theme.primaryColor : Colors.grey.shade300,
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 8),

                    // Location Dropdown
                    if (_selectedAction != null) ...[
                      Text(
                        'Select Location',
                        style: theme.subtitle1.override(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: theme.primaryText.withOpacity(0.8),
                          useGoogleFonts: GoogleFonts.asMap().containsKey(
                            theme.subtitle1.fontFamily,
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 6,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: DropdownButtonFormField<String>(
                          value: _selectedLocationId.isNotEmpty ? _selectedLocationId : null,
                          items: _locationOptions.map((location) {
                            return DropdownMenuItem<String>(
                              value: location['id'],
                              child: Text(
                                location['name'],
                                style: theme.bodyText1.override(
                                  color: Colors.black,
                                  useGoogleFonts: GoogleFonts.asMap().containsKey(
                                    theme.bodyText1.fontFamily,
                                  ),
                                ),
                              ),
                            );
                          }).toList(),
                          onChanged: (val) {
                            setState(() => _selectedLocationId = val ?? '');
                            _handleLocationSelection();
                          },
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.transparent,
                            hintText: 'Choose a location',
                            hintStyle: theme.bodyText1.override(
                              color: Colors.black.withOpacity(0.4),
                              useGoogleFonts: GoogleFonts.asMap().containsKey(
                                theme.bodyText1.fontFamily,
                              ),
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 12,
                            ),
                            border: InputBorder.none,
                          ),
                          icon: const Icon(Icons.keyboard_arrow_down),
                          elevation: 2,
                          dropdownColor: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ],

                    // Instruction Message
                    if (_displayMessage.isNotEmpty && _selectedLocationId.isEmpty)
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: theme.primaryColor.withAlpha(13),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            children: [
                              Icon(Icons.info_outline, color: theme.primaryColor, size: 20),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  _displayMessage,
                                  style: theme.bodyText1.override(
                                    color: theme.primaryColor,
                                    fontSize: 14,
                                    useGoogleFonts: GoogleFonts.asMap().containsKey(
                                      theme.bodyText1.fontFamily,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                    // Tables Grid
                    if (_tablesToDisplay.isNotEmpty) ...[
                      const SizedBox(height: 8),
                      Text(
                        'Available Tables',
                        style: theme.subtitle1.override(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: theme.primaryText.withOpacity(0.8),
                          useGoogleFonts: GoogleFonts.asMap().containsKey(
                            theme.subtitle1.fontFamily,
                          ),
                        ),
                      ),
                      const SizedBox(height: 4),
                      GridView.count(
                        crossAxisCount: 3,
                        mainAxisSpacing: 2,
                        crossAxisSpacing: 2,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        padding: const EdgeInsets.only(bottom: 8),
                        children: _tablesToDisplay,
                      ),
                    ],
                  ],
                ),
              ),
            ),

            // Confirmation Section
            if (_footMessage.isNotEmpty || _enableSubmit)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 10,
                      offset: const Offset(0, -5),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    if (_footMessage.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: Text(
                          _footMessage,
                          textAlign: TextAlign.center,
                          style: theme.subtitle2.override(
                            color: theme.primaryColor,
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                            useGoogleFonts: GoogleFonts.asMap().containsKey(
                              theme.subtitle2.fontFamily,
                            ),
                          ),
                        ),
                      ),
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: _enableSubmit ? _confirmAction : null,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _enableSubmit
                              ? theme.primaryColor
                              : Colors.grey.shade300,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          elevation: 0,
                          shadowColor: Colors.transparent,
                        ),
                        child: Text(
                          'Confirm ${_selectedAction ?? ''}',
                          style: theme.subtitle2.override(
                            color: _enableSubmit ? Colors.white : Colors.grey.shade600,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            useGoogleFonts: GoogleFonts.asMap().containsKey(
                              theme.subtitle2.fontFamily,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
      floatingActionButton: const CustomFloatingActionButton(),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  Widget _buildHeaderSection(AppTheme theme, String tableName) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
      decoration: BoxDecoration(
        color: theme.primaryColor.withOpacity(0.05),
        border: Border(bottom: BorderSide(color: theme.primaryText.withOpacity(0.1), width: 1)),
      ),
      child: Row(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: theme.primaryColor.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.table_restaurant, color: theme.primaryColor, size: 28),
          ),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Managing Table',
                style: theme.bodyText1.override(
                  color: theme.primaryText.withOpacity(0.6),
                  fontSize: 16,
                  useGoogleFonts: GoogleFonts.asMap().containsKey(theme.bodyText1.fontFamily),
                ),
              ),
              Text(
                tableName,
                style: theme.title1.override(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: theme.primaryColor,
                  useGoogleFonts: GoogleFonts.asMap().containsKey(theme.title1.fontFamily),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
