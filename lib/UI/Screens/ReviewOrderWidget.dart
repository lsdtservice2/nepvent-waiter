import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nepvent_waiter/Controller/SocketService.dart';
import 'package:nepvent_waiter/UI/Design/AppTheme.dart';
import 'package:nepvent_waiter/UI/Design/ButtonWidget.dart';
import 'package:nepvent_waiter/UI/Design/CustomCountController.dart';
import 'package:nepvent_waiter/UI/Design/CustomFloatingActionButton.dart';
import 'package:nepvent_waiter/UI/Screens/EstimateBillWidget.dart';
import 'package:nepvent_waiter/UI/Screens/TableSelectionWidget.dart';
import 'package:nepvent_waiter/Utils/Constant.dart';
import 'package:provider/provider.dart';

class ReviewOrderWidget extends StatefulWidget {
  final HashMap<int, int> selectedMenuItems;
  final HashMap<int, String> selectedMenuItemsName;
  final HashMap<int, String> selectedMenuItemsComments;
  final HashMap<int, int> maxSelectedMenuQuantity;

  final int tableId;
  final int tableLocation;
  final String tableName;
  final Map<int, List<dynamic>> menuOptions;

  const ReviewOrderWidget({
    super.key,
    required this.selectedMenuItems,
    required this.selectedMenuItemsName,
    required this.selectedMenuItemsComments,
    required this.maxSelectedMenuQuantity,
    required this.tableId,
    required this.tableLocation,
    required this.tableName,
    required this.menuOptions,
  });

  @override
  State<ReviewOrderWidget> createState() => _ReviewOrderWidgetState();
}

class _ReviewOrderWidgetState extends State<ReviewOrderWidget> {
  bool isOrderButtonDisabled = false;

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    return Scaffold(
      appBar: _buildAppBar(theme),
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(top: 12),
        child: Column(
          children: [
            ListView(
              padding: EdgeInsets.zero,
              primary: false,
              shrinkWrap: true,
              children: _buildOrderList(theme),
            ),
          ],
        ),
      ),
      floatingActionButton: const CustomFloatingActionButton(),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  AppBar _buildAppBar(AppTheme theme) {
    return AppBar(
      backgroundColor: theme.primaryBackground,
      automaticallyImplyLeading: false,
      leading: IconButton(
        icon: Icon(Icons.arrow_back_rounded, color: theme.primaryText, size: 30),
        onPressed: () => Navigator.pop(context, {
          'selectedItems': widget.selectedMenuItems,
          'selectedMenuItemsComments': widget.selectedMenuItemsComments,
        }),
      ),
      title: Text(
        'Review Order',
        style: theme.title2.override(
          fontFamily: theme.title2.fontFamily,
          color: theme.primaryText,
          fontSize: 22,
          useGoogleFonts: GoogleFonts.asMap().containsKey(theme.title2.fontFamily),
        ),
      ),
      actions: [
        IconButton(
          icon: Icon(Icons.receipt_long_sharp, color: theme.primaryText, size: 30),
          onPressed: () {
            Navigator.push(
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
      ],
      centerTitle: true,
      elevation: 2,
    );
  }

  Future<void> _orderItems() async {
    final socketService = context.read<SocketService>();

    try {
      setState(() => isOrderButtonDisabled = true);

      final items = widget.selectedMenuItems.entries
          .where((item) => item.value > 0)
          .map((item) {
            if (widget.menuOptions[item.key] != null) {
              return widget.menuOptions[item.key]!.map((element) {
                return {
                  'menu_id': item.key,
                  'remarks': element['comment'] ?? '',
                  'quantity': element['quantity'],
                  'options': element['opts'].map((e) {
                    return {
                      ...e,
                      'opts': e['opts']
                          .where((sel) => sel['selected'] == true)
                          .map(
                            (sel) => {
                              'opt': sel['optName'],
                              'price': sel['optPrice'],
                              'quantity': sel['count'],
                            },
                          )
                          .toList(),
                    };
                  }).toList(),
                };
              }).toList();
            } else {
              return {
                'menu_id': item.key,
                'quantity': item.value,
                'remarks': widget.selectedMenuItemsComments[item.key] ?? '',
              };
            }
          })
          .expand((i) => i is List ? i : [i])
          .toList();

      await dio.post(
        'table/${widget.tableId}/order',
        data: {"orders": items, "socketId": socketService.socket.id},
      );
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => TableSelectionWidget()),
      );

      widget.selectedMenuItems.updateAll((key, value) => 0);
      setState(() => isOrderButtonDisabled = false);
    } catch (e) {
      debugPrint('Order error: $e');
      setState(() => isOrderButtonDisabled = false);
    }
  }

  Future<String?> _showCommentDialog(BuildContext context, String message) async {
    final controller = TextEditingController(text: message);
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return showDialog<String>(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        elevation: 4,
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Add Comment',
                style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: controller,
                maxLines: 4,
                minLines: 3,
                decoration: InputDecoration(
                  hintText: 'Write your comment here...',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(
                      color: isDark ? Colors.grey.shade700 : Colors.grey.shade300,
                    ),
                  ),
                  filled: true,
                  fillColor: isDark ? Colors.grey.shade800 : Colors.grey.shade50,
                  contentPadding: const EdgeInsets.all(16),
                ),
                style: theme.textTheme.bodyMedium,
                autofocus: true,
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    style: TextButton.styleFrom(
                      foregroundColor: theme.colorScheme.onSurface.withOpacity(0.6),
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                    child: const Text('Cancel'),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: () => Navigator.pop(context, controller.text),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: theme.colorScheme.primary,
                      foregroundColor: theme.colorScheme.onPrimary,
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      elevation: 0,
                    ),
                    child: const Text('Submit'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> _buildOrderList(AppTheme theme) {
    final orders = <Widget>[];
    int index = 1;
    // selectedMenuItems isEmpty then Auto Back with Animations
    final hasValidItems = widget.selectedMenuItems.values.any((value) => value > 0);
    if (!hasValidItems) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _navigateBackWithAnimation(context);
      });
      return [];
    }
    widget.selectedMenuItems.entries.where((entry) => entry.value > 0).forEach((entry) {
      final isComplex = widget.menuOptions[entry.key] != null;
      orders.add(
        isComplex
            ? _buildComplexMenuItem(index, entry, theme)
            : _buildSimpleMenuItem(index, entry, theme),
      );
      index++;
    });

    if (orders.isNotEmpty) orders.add(_buildOrderButton(theme));
    return orders;
  }

  void _navigateBackWithAnimation(BuildContext context) {
    const animationDuration = Duration(milliseconds: 500); // Slightly longer for comfort
    const curve = Curves.easeInOutCubicEmphasized; // Smoother acceleration/deceleration

    Navigator.of(context).pop(
      PageRouteBuilder(
        transitionDuration: animationDuration,
        reverseTransitionDuration: animationDuration,
        pageBuilder: (_, __, ___) => const SizedBox.shrink(),
        opaque: false,
        // Makes the fade more natural
        transitionsBuilder: (_, animation, __, child) {
          return AnimatedBuilder(
            animation: animation,
            builder: (_, child) {
              // Gentle background dimming effect
              return Container(
                color: Colors.black.withOpacity(0.3 * (1 - animation.value)),
                child: child,
              );
            },
            child: FadeTransition(
              opacity: CurvedAnimation(parent: animation, curve: curve).drive(
                Tween<double>(
                  begin: 1.0,
                  end: 0.7, // Doesn't fully fade to maintain context
                ),
              ),
              child: SlideTransition(
                position: CurvedAnimation(parent: animation, curve: curve).drive(
                  Tween<Offset>(
                    begin: Offset.zero,
                    end: const Offset(-0.3, 0.0), // Less aggressive slide
                  ),
                ),
                child: Transform.scale(
                  scale: 0.9 + (0.1 * animation.value), // Slight zoom out
                  child: child,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildSimpleMenuItem(int index, MapEntry<int, int> entry, AppTheme theme) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Container(
        decoration: _itemBoxDecoration(),
        padding: const EdgeInsets.all(8),
        child: Row(
          children: [
            Text('$index.', style: _titleTextStyle(theme)),
            const SizedBox(width: 8),
            Expanded(
              child: Text(widget.selectedMenuItemsName[entry.key]!, style: _titleTextStyle(theme)),
            ),
            _buildCommentButton(entry.key, widget.selectedMenuItemsComments[entry.key]),
            _buildQuantityController(entry.key),
          ],
        ),
      ),
    );
  }

  Widget _buildComplexMenuItem(int index, MapEntry<int, int> entry, AppTheme theme) {
    final options = widget.menuOptions[entry.key]!
        .where((option) => option['quantity'] != 0)
        .toList();
    final widgets = options.asMap().entries.map((optionEntry) {
      final option = optionEntry.value;
      return Column(
        children: [
          Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(15, 0, 0, 0),
            child: Row(
              children: [
                Expanded(child: _buildOptionDetails(option, theme)),
                _buildCommentButton(optionEntry.key, option['comment']),
                _buildOptionQuantityController(option, entry.key),
              ],
            ),
          ),
          if (optionEntry.key != options.length - 1)
            Divider(thickness: 3, color: theme.blanchedAlmond),
        ],
      );
    }).toList();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Container(
        decoration: _itemBoxDecoration(),
        padding: const EdgeInsets.all(8),
        child: Column(
          children: [
            Row(
              children: [
                Text('$index.', style: _titleTextStyle(theme)),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    widget.selectedMenuItemsName[entry.key]!,
                    style: _titleTextStyle(theme),
                  ),
                ),
              ],
            ),
            ...widgets,
          ],
        ),
      ),
    );
  }

  Widget _buildCommentButton(dynamic key, String? comment) => IconButton(
    icon: Icon(
      comment != null ? Icons.mode_comment_rounded : Icons.mode_comment_outlined,
      color: AppTheme.of(context).primaryText,
      size: 16,
    ),
    onPressed: () async {
      final result = await _showCommentDialog(context, comment ?? '');
      if (result != null) {
        setState(() {
          if (result.isEmpty) {
            if (key is int) {
              widget.selectedMenuItemsComments.remove(key);
            } else {
              (key as Map)['comment'] = null;
            }
          } else {
            if (key is int) {
              widget.selectedMenuItemsComments[key] = result;
            } else {
              (key as Map)['comment'] = result;
            }
          }
        });
      }
    },
  );

  Widget _buildQuantityController(int itemKey) => Container(
    height: 40,
    decoration: _quantityControllerDecoration(),
    child: CustomCountController(
      count: widget.selectedMenuItems[itemKey]!,
      onChanged: (count) => setState(() => widget.selectedMenuItems[itemKey] = count),
      decrementIcon: _buildDecrementIcon(true),
      incrementIcon: _buildIncrementIcon(true),
      countStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      stepSize: 1,
      minimum: 0,
      maximum: widget.maxSelectedMenuQuantity[itemKey] == -1
          ? 20
          : widget.maxSelectedMenuQuantity[itemKey]!,
      buttonSize: 30,
      buttonColor: Colors.lightBlueAccent.withAlpha(179),
      disabledButtonColor: Colors.grey[300],
    ),
  );

  Widget _buildOptionQuantityController(Map option, int itemKey) => Container(
    // width: 115,
    height: 30,
    decoration: _quantityControllerDecoration(),
    child: CustomCountController(
      count: option['quantity'],
      onChanged: (count) => setState(() {
        option['quantity'] = count;
        widget.selectedMenuItems[itemKey] = widget.menuOptions[itemKey]!.fold(
          0,
          (sum, el) => sum + el['quantity'] as int,
        );
      }),
      decrementIcon: _buildDecrementIcon(true),
      incrementIcon: _buildIncrementIcon(true),
      countStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      stepSize: 1,
      minimum: 0,
      buttonSize: 36,
      buttonColor: Colors.lightBlueAccent.withAlpha(179),
      disabledButtonColor: Colors.grey[300],
    ),
  );

  Widget _buildOptionDetails(Map option, AppTheme theme) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Padding(
        padding: const EdgeInsetsDirectional.fromSTEB(5, 0, 0, 0),
        child: Text(
          'option ${option['opts'].map((group) => group['current'] + 1).toList()}',
          style: theme.subtitle2,
        ),
      ),
      ...option['opts'].map<Widget>((val) {
        final selected = val['opts'].where((v) => v['selected'] == true).toList();
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(10, 0, 0, 0),
              child: Text('${val['current'] + 1}. ${val['name']}', style: theme.subtitle2),
            ),
            ...selected.map(
              (opt) => Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(20, 0, 0, 0),
                child: Row(
                  children: [
                    Text(opt['optName'], style: theme.subtitle2),
                    if (opt['quantityEligible'] ?? false)
                      Text(' x ${opt['count']}', style: _quantityTextStyle(theme)),
                  ],
                ),
              ),
            ),
          ],
        );
      }).toList(),
    ],
  );

  Widget _buildOrderButton(AppTheme theme) => Padding(
    padding: const EdgeInsets.only(left: 24, bottom: 24, right: 24),
    child: ButtonWidget(
      onPressed: isOrderButtonDisabled || widget.selectedMenuItems.isEmpty ? null : _orderItems,
      text: 'Confirm Order',
      options: ButtonOptions(
        width: 130,
        height: 40,
        color: isOrderButtonDisabled ? theme.secondaryBackground : theme.verdigrisGreen,
        textStyle: theme.subtitle2.override(
          fontFamily: theme.subtitle2.fontFamily,
          color: isOrderButtonDisabled ? theme.grayDark : Colors.white,
          useGoogleFonts: GoogleFonts.asMap().containsKey(theme.subtitle2.fontFamily),
        ),
        borderSide: const BorderSide(color: Colors.transparent, width: 1),
        borderRadius: 12,
      ),
    ),
  );

  Widget _buildDecrementIcon(bool enabled) => Padding(
    padding: const EdgeInsets.all(5.0),
    child: Icon(
      Icons.remove,
      color: enabled ? const Color(0xDD000000) : const Color(0xFFEEEEEE),
      size: 16,
    ),
  );

  Widget _buildIncrementIcon(bool enabled) => Padding(
    padding: const EdgeInsets.all(5.0),
    child: Icon(
      Icons.add,
      color: enabled ? const Color(0xDD000000) : const Color(0xFFEEEEEE),
      size: 16,
    ),
  );

  TextStyle _titleTextStyle(AppTheme theme) => theme.subtitle1.override(
    fontFamily: 'Outfit',
    color: const Color(0xFF0F1113),
    fontSize: 20,
    fontWeight: FontWeight.w500,
    useGoogleFonts: GoogleFonts.asMap().containsKey('Outfit'),
  );

  TextStyle _quantityTextStyle(AppTheme theme) => theme.robotoMonoTitle1.override(
    color: theme.wageningenGreen,
    fontSize: 16,
    useGoogleFonts: GoogleFonts.asMap().containsKey(theme.robotoMonoTitle1.fontFamily),
  );

  BoxDecoration _itemBoxDecoration() => BoxDecoration(
    color: Colors.white,
    boxShadow: const [BoxShadow(blurRadius: 3, color: Color(0x411D2429), offset: Offset(0, 1))],
    borderRadius: BorderRadius.circular(8),
  );

  BoxDecoration _quantityControllerDecoration() => BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(25),
    border: Border.all(color: const Color(0x0ff9e9e9)),
  );
}
