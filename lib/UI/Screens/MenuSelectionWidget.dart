import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:isar/isar.dart';
import 'package:nepvent_waiter/Models/CategoryMenus.dart';
import 'package:nepvent_waiter/Models/Menus.dart';
import 'package:nepvent_waiter/Models/PrimaryCategoryMenu.dart';
import 'package:nepvent_waiter/UI/Design/AppTheme.dart';
import 'package:nepvent_waiter/UI/Design/ButtonWidget.dart';
import 'package:nepvent_waiter/UI/Design/CustomFloatingActionButton.dart';
import 'package:nepvent_waiter/UI/Design/LoadingWidget.dart';
import 'package:nepvent_waiter/UI/Design/PrimaryMenuWidget.dart';
import 'package:nepvent_waiter/UI/Screens/EstimateBillWidget.dart';
import 'package:nepvent_waiter/UI/Screens/ReviewOrderWidget.dart';
import 'package:nepvent_waiter/UI/Screens/StepperMenuWidget.dart';
import 'package:nepvent_waiter/UI/Screens/TableQrWidget.dart';
import 'package:nepvent_waiter/UI/Screens/TableSelectionWidget.dart';
import 'package:nepvent_waiter/Utils/Constant.dart';

class MenuSelectionWidget extends StatefulWidget {
  const MenuSelectionWidget({
    super.key,
    required this.tableName,
    required this.tableId,
    required this.tableLocation,
  });

  final String tableName;
  final int tableId;
  final int tableLocation;

  @override
  State<MenuSelectionWidget> createState() => _MenuSelectionWidgetState();
}

class _MenuSelectionWidgetState extends State<MenuSelectionWidget> {
  late Future _menuFuture;
  final TextEditingController _searchController = TextEditingController();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  HashMap<int, int> selectedMenuItems = HashMap();
  HashMap<int, String> selectedMenuItemsName = HashMap();
  Map<int, List<dynamic>> selectedMenuStepperOptions = {};
  HashMap<int, String> selectedMenuItemsComments = HashMap();
  HashMap<int, int> maxSelectedMenuQuantity = HashMap();

  String _primaryCategoryButtonText = "All";
  int _primaryCategoryId = 0;
  int _secondaryCategoryId = 0;

  List<PrimaryCategoryMenu> _menuPrimaryCategory = [];
  List<CategoryMenus> _categoryMenus = [];
  List<Menus> _menus = [];
  List<Widget> _menuWidgets = [];
  List<Map<String, dynamic>> _primaryCategories = [];
  List<Map<String, dynamic>> _secondaryCategories = [];

  bool _customerOrderQR = false;
  final int _maxQuantity = 20;

  String get tableName => widget.tableName;

  int get tableId => widget.tableId;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _menuFuture = _fetchMenuData();

    // _customerOrderQR = prefs.getBool('customerOrderQR') ?? false; // Trigger data fetching
    _customerOrderQR = true; // Trigger data fetching
  }

  Future<void> _fetchMenuData() async {
    await _readPrimaryData();
    await _readCategoryMenus();
    await _readMenus();

    if (_menuPrimaryCategory.isNotEmpty) {
      setState(() {
        _primaryCategoryId = _menuPrimaryCategory.first.id;
        _primaryCategoryButtonText = _menuPrimaryCategory.first.name;
        _populatePrimaryCategories();
        _secondaryCategoryId = 0;
        _renderCategoryChanges(_primaryCategoryId, _secondaryCategoryId);
      });
    }
  }

  Future<void> _readPrimaryData() async {
    final primaryMenu = isar.primaryCategoryMenus;
    final results = await primaryMenu.where().findAll();
    setState(() {
      _menuPrimaryCategory = results;
      _populatePrimaryCategories();
    });
  }

  Future<void> _readCategoryMenus() async {
    final categoryMenu = isar.categoryMenus;
    final results = await categoryMenu.where().findAll();

    setState(() {
      _categoryMenus = results;
      _populateSecondaryCategories();
    });
  }

  Future<void> _readMenus() async {
    final menu = isar.menus;
    final results = await menu.where().findAll();

    setState(() {
      _menus = results;
    });
  }

  void _populatePrimaryCategories() {
    _primaryCategories = [
      {'name': 'All', 'id': 0},
    ];
    for (var primaryMenu in _menuPrimaryCategory) {
      _primaryCategories.add({'name': primaryMenu.name, 'id': primaryMenu.id});
    }
  }

  void _populateSecondaryCategories() {
    _secondaryCategories = [
      {'name': 'All', 'id': 0},
    ];
    for (var cat in _categoryMenus) {
      _secondaryCategories.add({'name': cat.name, 'id': cat.id});
    }
  }

  void _updateSecondaryCategoriesForPrimary(int primaryCatId) {
    List<CategoryMenus> filteredSecondary = primaryCatId == 0
        ? _categoryMenus
        : _categoryMenus.where((element) => element.primaryCategoryId == primaryCatId).toList();

    _secondaryCategories = [
      {'name': 'All', 'id': 0},
      ...filteredSecondary.map((e) => {'name': e.name, 'id': e.id}),
    ];

    if (!_secondaryCategories.any((element) => element['id'] == _secondaryCategoryId)) {
      _secondaryCategoryId = 0;
    }
  }

  void _renderCategoryChanges(int primaryCatId, int secondaryCatId) {
    _updateSecondaryCategoriesForPrimary(primaryCatId);

    List<CategoryMenus> filteredSecondaryCategories = secondaryCatId == 0
        ? (_categoryMenus
              .where((e) => primaryCatId == 0 || e.primaryCategoryId == primaryCatId)
              .toList())
        : _categoryMenus.where((e) => e.id == secondaryCatId).toList();

    List<Menus> filteredMenu;

    String filterText = _searchController.text.trim().toLowerCase();
    if (filterText.isNotEmpty) {
      filteredMenu = _menus.where((menu) => menu.name.toLowerCase().contains(filterText)).toList();
    } else {
      if (secondaryCatId == 0) {
        filteredMenu = _menus
            .where(
              (menu) =>
                  filteredSecondaryCategories.any((category) => category.id == menu.categoryMenuId),
            )
            .toList();
      } else {
        filteredMenu = _menus.where((menu) => menu.categoryMenuId == secondaryCatId).toList();
      }
    }

    _menuWidgets = filteredMenu.map(_buildMenuItemWidget).toList();
    setState(() {});
  }

  Widget _buildMenuItemWidget(Menus menu) {
    // Card background color depending on availability
    final bool isAvailable = menu.itemAvailable == null || menu.itemAvailable != 0;

    Color backgroundColor = isAvailable
        ? AppTheme.of(context).retroClassicGreyBlack
        : AppTheme.of(context).retroRedYellow;

    Color textColor = isAvailable
        ? AppTheme.of(context).retroClassicGreyBlackFont
        : AppTheme.of(context).retroRedYellowFont;

    List<Widget> stackChildren = [
      Container(
        decoration: BoxDecoration(color: backgroundColor, borderRadius: BorderRadius.circular(12)),
        alignment: Alignment.center,
        padding: const EdgeInsets.symmetric(horizontal: 4),
        child: Text(
          menu.name,
          textAlign: TextAlign.center,
          maxLines: 3,
          overflow: TextOverflow.ellipsis,
          style: AppTheme.of(context).subtitle2.override(
            fontFamily: AppTheme.of(context).subtitle2.fontFamily,
            color: textColor,
            useGoogleFonts: GoogleFonts.asMap().containsKey(
              AppTheme.of(context).subtitle2.fontFamily,
            ),
          ),
        ),
      ),
    ];

    int? selectedQuantity = selectedMenuItems[menu.id];
    int maxQuantityForItem = maxSelectedMenuQuantity[menu.id] ?? (_maxQuantity);

    if (selectedQuantity != null && selectedQuantity > 0) {
      stackChildren.add(
        Positioned(
          top: 5,
          right: 10,
          child: Badge(
            largeSize: 29,
            label: Text(
              selectedQuantity.toString(),
              style: AppTheme.of(context).bodyText1.override(
                fontFamily: AppTheme.of(context).bodyText1.fontFamily,
                color: Colors.white,
                useGoogleFonts: GoogleFonts.asMap().containsKey(
                  AppTheme.of(context).bodyText1.fontFamily,
                ),
              ),
            ),
            backgroundColor: (selectedQuantity == maxQuantityForItem)
                ? AppTheme.of(context).paradisePink
                : AppTheme.of(context).retroGreenPink,
            child: null,
          ),
        ),
      );
    }

    return InkWell(
      onTap: () => _handleMenuItemTap(menu),
      onLongPress: () => _handleMenuItemLongPress(menu),
      child: Stack(children: stackChildren),
    );
  }

  void _handleMenuItemTap(Menus menu) async {
    if (menu.optioned.isNotEmpty) {
      var returnedValues = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => StepperMenuWidget(
            itemName: menu.name,
            options: menu.optioned.map((item) => item).toList(),
          ),
        ),
      );
      debugPrint('➡️➡️➡️➡️➡️➡️➡️ ${returnedValues['quantity']}');

      if (returnedValues != null) {
        int quantity = returnedValues['quantity'] as int? ?? 0;

        if (selectedMenuItems.containsKey(menu.id)) {
          selectedMenuItems[menu.id] = selectedMenuItems[menu.id]! + quantity;
        } else {
          selectedMenuItems[menu.id] = quantity;
          selectedMenuItemsName[menu.id] = menu.name;
        }

        selectedMenuStepperOptions.putIfAbsent(menu.id, () => []);
        selectedMenuStepperOptions[menu.id]!.add(returnedValues);
      }
    } else {
      _incrementMenuItemQuantity(menu);
    }

    _renderCategoryChanges(_primaryCategoryId, _secondaryCategoryId);
  }

  void _incrementMenuItemQuantity(Menus menu) {
    int currentSelected = selectedMenuItems[menu.id] ?? 0;
    int maxAvailable = menu.itemAvailable ?? -1;

    if ((maxAvailable == -1 || maxAvailable == null) && currentSelected < _maxQuantity) {
      selectedMenuItems[menu.id] = currentSelected + 1;
      maxSelectedMenuQuantity[menu.id] = _maxQuantity;
      selectedMenuItemsName[menu.id] = menu.name;
    } else if (maxAvailable >= 0 && currentSelected < maxAvailable) {
      selectedMenuItems[menu.id] = currentSelected + 1;
      maxSelectedMenuQuantity[menu.id] = maxAvailable;
      selectedMenuItemsName[menu.id] = menu.name;
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            maxAvailable < _maxQuantity
                ? 'Not enough stock for more quantity'
                : 'Maximum $_maxQuantity quantity per item allowed.',
          ),
          backgroundColor: maxAvailable < _maxQuantity
              ? AppTheme.of(context).redSalsa
              : AppTheme.of(context).amberYellow,
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  void _handleMenuItemLongPress(Menus menu) {
    if (selectedMenuItems.containsKey(menu.id) && selectedMenuItems[menu.id]! > 0) {
      int newQty = selectedMenuItems[menu.id]! - 1;
      setState(() {
        if (newQty > 0) {
          selectedMenuItems[menu.id] = newQty;
        } else {
          selectedMenuItems.remove(menu.id);
          selectedMenuItemsName.remove(menu.id);
          selectedMenuStepperOptions.remove(menu.id);
          maxSelectedMenuQuantity.remove(menu.id);
        }
      });
      _renderCategoryChanges(_primaryCategoryId, _secondaryCategoryId);
    }
  }

  Future<void> _checkOrders() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ReviewOrderWidget(
          selectedMenuItems: selectedMenuItems,
          tableLocation: widget.tableLocation,
          selectedMenuItemsName: selectedMenuItemsName,
          tableId: widget.tableId,
          tableName: widget.tableName,
          menuOptions: selectedMenuStepperOptions,
          selectedMenuItemsComments: selectedMenuItemsComments,
          maxSelectedMenuQuantity: maxSelectedMenuQuantity,
        ),
      ),
    );
    if (result == true) {
      setState(() {
        selectedMenuItems.clear();
        selectedMenuItemsName.clear();
        selectedMenuStepperOptions.clear();
        selectedMenuItemsComments.clear();
        maxSelectedMenuQuantity.clear();
      });
    }
    _renderCategoryChanges(_primaryCategoryId, _secondaryCategoryId);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    // final dataProvider = Provider.of<DataProvider>(context).isData;

    return FutureBuilder(
      future: _menuFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const LoadingWidget();
        }
        if (snapshot.hasError) {
          return const LoadingWidget();
        }

        return Scaffold(
          key: _scaffoldKey,
          backgroundColor: theme.primaryBackground,
          drawer: SizedBox(
            width: 200,
            child: Drawer(
              elevation: 16,
              child: PrimaryMenuWidget(
                primaryMenuList: _primaryCategories,
                valueChange: (val) {
                  setState(() {
                    _primaryCategoryButtonText = val['name'];
                    _primaryCategoryId = val['id'];
                    _secondaryCategoryId = 0;
                    _renderCategoryChanges(_primaryCategoryId, _secondaryCategoryId);
                  });
                },
                selectedItem: _primaryCategoryButtonText,
              ),
            ),
          ),
          // endDrawer: const SizedBox(width: 200, child: Drawer(elevation: 16, child: EndDrawerWidget())),
          appBar: AppBar(
            backgroundColor: theme.primaryBackground,
            automaticallyImplyLeading: false,
            leading: IconButton(
              icon: Icon(Icons.arrow_back_rounded, color: theme.chineseBlack, size: 30),
              onPressed: () async {
                await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const TableSelectionWidget()),
                );
              },
            ),
            title: Text(
              widget.tableName,
              style: theme.title1.override(
                fontFamily: theme.title1.fontFamily,
                color: theme.chineseBlack,
                useGoogleFonts: GoogleFonts.asMap().containsKey(theme.title1.fontFamily),
              ),
            ),
            actions: [
              if (_customerOrderQR == true)
                IconButton(
                  icon: Icon(Icons.qr_code_rounded, color: theme.chineseBlack, size: 30),
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) => Dialog(
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
                        backgroundColor: Colors.white,
                        insetPadding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 24.0),
                        child: ConstrainedBox(
                          constraints: const BoxConstraints(maxWidth: 350, minHeight: 350),
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: TableQrWidget(
                              tableId: widget.tableId,
                              tableName: widget.tableName,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              Padding(
                padding: const EdgeInsets.only(right: 25),
                child: IconButton(
                  icon: Icon(Icons.receipt_long_sharp, color: theme.chineseBlack, size: 30),
                  onPressed: () async {
                    await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => EstimateBillWidget(
                          tableId: widget.tableId,
                          tableName: widget.tableName,
                          tableLocation: widget.tableLocation,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
            elevation: 0,
            centerTitle: false,
          ),
          body: SafeArea(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 8),
                  child: Row(
                    children: [
                      ButtonWidget(
                        onPressed: () => _scaffoldKey.currentState?.openDrawer(),
                        text: _primaryCategoryButtonText,
                        options: ButtonOptions(
                          width: 100,
                          height: 40,
                          color: theme.retroPurplePink,
                          textStyle: theme.subtitle2.override(
                            fontFamily: theme.subtitle2.fontFamily,
                            color: theme.retroPurplePinkFont,
                            useGoogleFonts: GoogleFonts.asMap().containsKey(
                              theme.subtitle2.fontFamily,
                            ),
                          ),
                          borderRadius: 8,
                          borderSide: const BorderSide(color: Colors.transparent, width: 1),
                        ),
                      ),
                      const SizedBox(width: 20),
                      Expanded(
                        child: DropdownButtonFormField<int>(
                          value: _secondaryCategoryId,
                          items: _secondaryCategories.map<DropdownMenuItem<int>>((item) {
                            return DropdownMenuItem<int>(
                              value: item['id'],
                              child: Text(
                                item['name'],
                                style: TextStyle(color: Colors.black87, fontSize: 14),
                              ),
                            );
                          }).toList(),
                          onChanged: (val) {
                            setState(() {
                              _secondaryCategoryId = val!;
                              _renderCategoryChanges(_primaryCategoryId, _secondaryCategoryId);
                            });
                          },
                          decoration: InputDecoration(
                            hintText: 'Select Category',
                            hintStyle: TextStyle(color: Colors.grey.shade600, fontSize: 14),
                            filled: true,
                            fillColor: Colors.white,
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 10,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide.none,
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide.none,
                            ),
                          ),
                          style: theme.bodyText1.copyWith(
                            color: Colors.black,
                            fontSize: 14,
                            fontFamily: theme.bodyText1.fontFamily,
                          ),
                          dropdownColor: Colors.white,
                          icon: const Icon(Icons.keyboard_arrow_down_rounded),
                          elevation: 4,
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 4),
                  child: TextFormField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      hintText: 'Search menu items...',
                      prefixIcon: Icon(Icons.search, color: theme.chineseBlack),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: theme.chineseBlack, width: 1),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: theme.chineseBlack, width: 2),
                      ),
                      contentPadding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
                    ),
                    style: theme.bodyText1,
                    onChanged: (value) =>
                        _renderCategoryChanges(_primaryCategoryId, _secondaryCategoryId),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    child: _menuWidgets.isEmpty
                        ? Center(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.warning_amber_rounded,
                                  size: 50,
                                  color: Colors.grey[400],
                                ),
                                const SizedBox(height: 12),
                                Text(
                                  'Sorry, no matching food items.',
                                  style: theme.title1.override(
                                    fontFamily: theme.title1.fontFamily,
                                    color: Colors.grey[600],
                                    useGoogleFonts: GoogleFonts.asMap().containsKey(
                                      theme.title1.fontFamily,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          )
                        : GridView.builder(
                            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 3,
                              crossAxisSpacing: 10,
                              mainAxisSpacing: 10,
                              childAspectRatio: 1,
                            ),
                            itemCount: _menuWidgets.length,
                            itemBuilder: (context, index) => _menuWidgets[index],
                          ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 4),
                  child: ButtonWidget(
                    onPressed: selectedMenuItems.isNotEmpty ? _checkOrders : null,
                    text: 'Check / Confirm Order',
                    options: ButtonOptions(
                      width: double.infinity,
                      height: 50,
                      color: selectedMenuItems.isNotEmpty
                          ? theme.retroDullOrangeOfWhite
                          : theme.secondaryBackground,
                      textStyle: theme.subtitle2.override(
                        fontFamily: theme.subtitle2.fontFamily,
                        color: selectedMenuItems.isNotEmpty
                            ? theme.retroDullOrangeOfWhiteFont
                            : theme.grayDark,
                        useGoogleFonts: GoogleFonts.asMap().containsKey(theme.subtitle2.fontFamily),
                      ),
                      borderRadius: 8,
                      borderSide: const BorderSide(color: Colors.transparent, width: 1),
                    ),
                  ),
                ),
              ],
            ),
          ),
          floatingActionButton: const CustomFloatingActionButton(),
          floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
        );
      },
    );
  }
}
