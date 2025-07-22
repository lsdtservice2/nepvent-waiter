import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nepvent_waiter/UI/Design/AppTheme.dart';
import 'package:nepvent_waiter/UI/Design/CustomFloatingActionButton.dart';

class StepperMenuWidget extends StatefulWidget {
  const StepperMenuWidget({
    super.key,
    required this.options,
    required this.itemName,
    this.primaryColor = const Color(0xFF4B39EF),
    this.secondaryColor = const Color(0xFFF8B400),
  });

  final List<dynamic> options;
  final String itemName;
  final Color primaryColor;
  final Color secondaryColor;

  @override
  State<StepperMenuWidget> createState() => _StepperMenuWidgetState();
}

class _StepperMenuWidgetState extends State<StepperMenuWidget> {
  int _currentStep = 0;
  int _quantity = 1;
  late List<dynamic> _optionsList;
  final _scrollController = ScrollController();
  final double _stepHeight = 300.0;

  @override
  void initState() {
    super.initState();
    _optionsList = jsonDecode(jsonEncode(widget.options));
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  List<dynamic> _getSelectedItems(List<dynamic> options) {
    return options.where((item) => item['selected'] == true).toList();
  }

  bool _validateCurrentStep() {
    final currentOptions = _optionsList[_currentStep]['opts'];
    final selectedCount = _getSelectedItems(currentOptions).length;
    final min = _optionsList[_currentStep]['min'];
    final max = _optionsList[_currentStep]['max'];

    return selectedCount >= min && selectedCount <= max;
  }

  bool _validateAllSteps() {
    for (var step in _optionsList) {
      final selectedCount = _getSelectedItems(step['opts']).length;
      if (selectedCount < step['min'] || selectedCount > step['max']) {
        return false;
      }
    }
    return true;
  }

  void _handleOptionTap(int stepIndex, int optionIndex) {
    setState(() {
      final option = _optionsList[stepIndex]['opts'][optionIndex];
      final selectedItems = _getSelectedItems(_optionsList[stepIndex]['opts']);
      final max = _optionsList[stepIndex]['max'];

      if (option['quantityEligible']) {
        if (option['selected'] || selectedItems.length < max) {
          option['count'] = (option['count'] ?? 0) + 1;
          option['selected'] = true;
        }
      } else {
        if (option['selected']) {
          option['selected'] = false;
        } else if (selectedItems.length < max) {
          option['selected'] = true;
        }
      }
    });
  }

  void _handleOptionLongPress(int stepIndex, int optionIndex) {
    setState(() {
      final option = _optionsList[stepIndex]['opts'][optionIndex];
      if (option['quantityEligible'] && (option['count'] ?? 0) > 0) {
        option['count'] = option['count'] - 1;
        if (option['count'] == 0) {
          option['selected'] = false;
        }
      }
    });
  }

  void _nextStep() {
    if (_validateCurrentStep()) {
      setState(() {
        _currentStep = (_currentStep + 1).clamp(0, _optionsList.length - 1);
      });

      WidgetsBinding.instance.addPostFrameCallback((_) {
        _scrollController.animateTo(
          _currentStep * _stepHeight,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOutQuint,
        );
      });
    } else {
      _showValidationError();
    }
  }

  void _previousStep() {
    setState(() {
      _currentStep = (_currentStep - 1).clamp(0, _optionsList.length - 1);
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollController.animateTo(
        _currentStep * _stepHeight,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOutQuint,
      );
    });
  }

  void _showReviewDialog() {
    showDialog(
      context: context,
      builder: (context) {
        // Calculate total price
        double totalPrice = 0;
        for (var option in _optionsList) {
          for (var opt in option['opts']) {
            if (opt['selected'] == true) {
              int count = opt['quantityEligible'] ? (opt['count'] ?? 1) : 1;
              totalPrice += (opt['optPrice'] * count);
            }
          }
        }

        return Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          elevation: 3,
          backgroundColor: Colors.transparent,
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Theme.of(context).dialogBackgroundColor,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 30,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Order Summary',
                      style: Theme.of(
                        context,
                      ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold, fontSize: 22),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Container(
                  constraints: const BoxConstraints(maxHeight: 500),
                  child: SingleChildScrollView(
                    child: Column(
                      children: _optionsList.map((option) {
                        final selected = (option['opts'] as List)
                            .where((opt) => opt['selected'] == true)
                            .toList();

                        if (selected.isEmpty) return const SizedBox.shrink();

                        return Container(
                          margin: const EdgeInsets.only(bottom: 8),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey[200]!, width: 1.5),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          padding: const EdgeInsets.all(12),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                option['name'],
                                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                              ),
                              const SizedBox(height: 2),
                              ...selected.map((item) {
                                int count = item['quantityEligible'] ? (item['count'] ?? 1) : 1;
                                double itemTotal =
                                    (double.tryParse(item['optPrice'].toString()) ?? 0) * count;

                                return Padding(
                                  padding: const EdgeInsets.only(bottom: 6),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        child: Row(
                                          children: [
                                            Icon(
                                              Icons.circle,
                                              size: 8,
                                              color: Theme.of(context).primaryColor,
                                            ),
                                            const SizedBox(width: 8),
                                            Text(
                                              '${item['optName']}${count > 1 ? ' ×$count' : ''}',
                                              style: const TextStyle(fontSize: 14),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Text(
                                        'Rs.${itemTotal.toStringAsFixed(2)}',
                                        style: const TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              }),
                            ],
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Total:',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        'Rs.${totalPrice.toStringAsFixed(2)}',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          side: BorderSide(color: Theme.of(context).primaryColor),
                        ),
                        onPressed: () => Navigator.pop(context),
                        child: Text(
                          'Edit Order',
                          style: TextStyle(
                            color: Theme.of(context).primaryColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          backgroundColor: Theme.of(context).primaryColor,
                          elevation: 3,
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                          // Proceed with order confirmation
                        },
                        child: const Text(
                          'Confirm',
                          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showValidationError() {
    final snackBar = SnackBar(
      content: Row(
        children: [
          Icon(Icons.error_outline, color: Colors.white),
          SizedBox(width: 8),
          Expanded(
            child: Text(
              'Please select between ${_optionsList[_currentStep]['min']} '
              'and ${_optionsList[_currentStep]['max']} options',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
      backgroundColor: Colors.red[700],
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      margin: const EdgeInsets.all(20),
      duration: const Duration(seconds: 2),
      action: SnackBarAction(label: 'OK', textColor: Colors.white, onPressed: () {}),
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  Widget _buildStepIndicator(int index) {
    final isCompleted = index < _currentStep;
    final isCurrent = index == _currentStep;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      width: isCurrent ? 40 : 32,
      height: isCurrent ? 40 : 32,
      decoration: BoxDecoration(
        color: isCompleted
            ? widget.primaryColor
            : isCurrent
            ? Colors.white
            : Colors.grey[200],
        shape: BoxShape.circle,
        border: Border.all(
          color: isCurrent ? widget.primaryColor : Colors.grey[300]!,
          width: isCurrent ? 3 : 2,
        ),
        boxShadow: [
          if (isCurrent)
            BoxShadow(color: widget.primaryColor.withOpacity(0.4), blurRadius: 8, spreadRadius: 2),
        ],
      ),
      child: Center(
        child: isCompleted
            ? Icon(Icons.verified, size: 18, color: Colors.white)
            : Text(
                (index + 1).toString(),
                style: TextStyle(
                  color: isCurrent ? widget.primaryColor : Colors.grey[700],
                  fontWeight: FontWeight.bold,
                  fontSize: isCurrent ? 16 : 14,
                ),
              ),
      ),
    );
  }

  Widget _buildOptionItem(int stepIndex, int optionIndex) {
    final option = _optionsList[stepIndex]['opts'][optionIndex];
    final isSelected = option['selected'] == true;

    return AnimatedScale(
      duration: const Duration(milliseconds: 200),
      scale: isSelected ? 1.03 : 1.0,
      child: Card(
        elevation: 5,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(
            color: isSelected ? widget.primaryColor : Colors.grey.shade200,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () => _handleOptionTap(stepIndex, optionIndex),
          onLongPress: () => _handleOptionLongPress(stepIndex, optionIndex),
          child: Stack(
            children: [
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center, // Already centered vertically
                    crossAxisAlignment: CrossAxisAlignment.center, // Added to center horizontally
                    mainAxisSize: MainAxisSize.min, // Added to prevent column from expanding
                    children: [
                      Text(
                        option['optName'],
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 15,
                          color: isSelected ? widget.primaryColor : Colors.grey[800],
                        ),
                      ),
                      const SizedBox(height: 4),
                      Center(
                        // Wrapped price container in Center
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? widget.primaryColor.withOpacity(0.1)
                                : Colors.grey[100],
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            'Rs. ${option['optPrice']}',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: isSelected ? widget.primaryColor : Colors.grey[700],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              if (option['count'] != null && option['count'] > 0)
                Positioned(
                  top: 4,
                  right: 4,
                  child: Badge(
                    largeSize: 20,
                    label: Text(
                      option['count'].toString(),
                      style: AppTheme.of(context).bodyText1.override(
                        fontFamily: AppTheme.of(context).bodyText1.fontFamily,
                        color: Colors.white,
                        useGoogleFonts: GoogleFonts.asMap().containsKey(
                          AppTheme.of(context).bodyText1.fontFamily,
                        ),
                      ),
                    ),
                    backgroundColor: AppTheme.of(context).retroDullOrangeOfWhite,
                    child: null,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStepHeader(int index) {
    final step = _optionsList[index];
    final isCurrent = index == _currentStep;
    final isCompleted = index < _currentStep;
    final selectedItems = _getSelectedItems(step['opts']);
    final hasSelection = selectedItems.isNotEmpty;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: isCurrent ? 2 : 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: isCurrent ? widget.primaryColor.withOpacity(0.3) : Colors.grey.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {
          if (index <= _currentStep) {
            setState(() => _currentStep = index);
            // Auto-scroll to the step when tapped
            _scrollController.animateTo(
              index * _stepHeight,
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
            );
          }
        },
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  // Step indicator with animation
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      color: isCurrent
                          ? widget.primaryColor
                          : isCompleted
                          ? widget.primaryColor.withOpacity(0.8)
                          : Colors.grey.withOpacity(0.3),
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(
                        '${index + 1}',
                        style: TextStyle(
                          color: isCurrent || isCompleted ? Colors.white : Colors.grey[700],
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      step['name'],
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                        color: isCurrent ? widget.primaryColor : Colors.grey[800],
                      ),
                    ),
                  ),
                  // Icon(
                  //   isCurrent ? Icons.keyboard_arrow_down : Icons.keyboard_arrow_right,
                  //   color: isCurrent ? widget.primaryColor : Colors.grey,
                  // ),
                ],
              ),
              if (isCurrent || (isCompleted && hasSelection))
                Padding(
                  padding: const EdgeInsets.only(left: 36, top: 4),
                  child: Text(
                    isCompleted
                        ? selectedItems.map((i) => i['optName']).join(', ')
                        : 'Select ${step['min']}-${step['max']} options',
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: isCompleted ? widget.primaryColor.withOpacity(0.8) : Colors.grey[600],
                      fontSize: 14,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCurrentStepContent(int index) {
    if (index != _currentStep) return const SizedBox.shrink();
    final step = _optionsList[index];
    final selectedCount = _getSelectedItems(step['opts']).length;
    final isValid = selectedCount >= step['min'] && selectedCount <= step['max'];

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(color: Colors.grey[50], borderRadius: BorderRadius.circular(12)),
      child: Column(
        children: [
          // Grid view of options
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              childAspectRatio: 1,
            ),
            itemCount: step['opts'].length,
            itemBuilder: (context, i) => _buildOptionItem(index, i),
          ),

          // Selection validation message
          if (!isValid && selectedCount > 0)
            Padding(
              padding: const EdgeInsets.only(top: 12),
              child: Text(
                selectedCount < step['min']
                    ? 'Select at least ${step['min']} more'
                    : 'Maximum ${step['max']} selections allowed',
                style: TextStyle(color: Colors.orange[700], fontSize: 13),
              ),
            ),

          // Navigation buttons
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              if (_currentStep > 0)
                TextButton(
                  onPressed: _previousStep,
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.chevron_left, color: widget.primaryColor),
                      const SizedBox(width: 4),
                      Text(
                        'Back',
                        style: TextStyle(color: widget.primaryColor, fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                ),

              const Spacer(),

              AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: isValid
                      ? [
                          BoxShadow(
                            color: widget.primaryColor.withOpacity(0.2),
                            blurRadius: 8,
                            spreadRadius: 1,
                          ),
                        ]
                      : null,
                ),
                child: ElevatedButton(
                  onPressed: isValid
                      ? () {
                          if (_currentStep == _optionsList.length - 1) {
                            _showReviewDialog();
                          } else {
                            _nextStep();
                          }
                        }
                      : null,

                  style: ElevatedButton.styleFrom(
                    backgroundColor: isValid ? widget.primaryColor : Colors.grey[400],
                    padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    elevation: 0,
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        _currentStep == _optionsList.length - 1 ? 'Review Order' : 'Next',
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                      if (_currentStep < _optionsList.length - 1) const SizedBox(width: 4),
                      if (_currentStep < _optionsList.length - 1)
                        Icon(Icons.chevron_right, size: 20, color: Colors.white),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildQuantitySelector() {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Quantity:',
              style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600, color: Colors.grey[800]),
            ),
            Row(
              children: [
                IconButton(
                  icon: Icon(Icons.remove_circle_outline, color: widget.primaryColor, size: 32),
                  onPressed: () {
                    setState(() {
                      _quantity = (_quantity - 1).clamp(1, 20);
                    });
                  },
                ),
                Container(
                  width: 60,
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade200),
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.grey[50],
                  ),
                  child: Text(
                    _quantity.toString(),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: widget.primaryColor,
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.add_circle_outline, color: widget.primaryColor, size: 32),
                  onPressed: () {
                    setState(() {
                      _quantity = (_quantity + 1).clamp(1, 20);
                    });
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSubmitButton() {
    final isValid = _validateAllSteps();
    final isLastStep = _currentStep == _optionsList.length - 1;

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          boxShadow: isValid && isLastStep
              ? [
                  BoxShadow(
                    color: widget.primaryColor.withOpacity(0.3),
                    blurRadius: 12,
                    spreadRadius: 3,
                  ),
                ]
              : null,
        ),
        child: SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: isValid && isLastStep ? widget.primaryColor : Colors.grey[400],
              padding: const EdgeInsets.symmetric(vertical: 20),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            ),
            onPressed: isValid && isLastStep
                ? () {
                    Navigator.pop(context, {'quantity': _quantity, 'opts': _optionsList});
                  }
                : null,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.shopping_bag_outlined, color: Colors.white),
                const SizedBox(width: 10),
                const Text(
                  'Confirm Order',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Colors.white),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text(
          widget.itemName,
          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 20),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () => Navigator.pop(context),
        ),
        backgroundColor: widget.primaryColor,
        foregroundColor: Colors.white,
        elevation: 0,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Center(
              child: Text(
                'Step ${_currentStep + 1}/${_optionsList.length}',
                style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // Step indicators
          Container(
            height: 85,
            padding: const EdgeInsets.symmetric(vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.08),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: _optionsList.length,
              itemBuilder: (context, index) => InkWell(
                onTap: () {
                  if (index <= _currentStep) {
                    setState(() => _currentStep = index);
                    // Auto-scroll to the step when tapped
                    _scrollController.animateTo(
                      index * _stepHeight,
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                    );
                  }
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildStepIndicator(index),
                      const SizedBox(height: 2),
                      Text(
                        _optionsList[index]['name'],
                        style: TextStyle(
                          fontWeight: index == _currentStep ? FontWeight.w600 : FontWeight.normal,
                          color: index == _currentStep ? widget.primaryColor : Colors.grey,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          // Main content
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              physics: const AlwaysScrollableScrollPhysics(),
              itemCount: _optionsList.length,
              itemBuilder: (context, index) => Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [_buildStepHeader(index), _buildCurrentStepContent(index)],
              ),
            ),
          ),

          // Quantity selector and submit button
          _buildQuantitySelector(),
          _buildSubmitButton(),
        ],
      ),
      floatingActionButton: const CustomFloatingActionButton(),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
