import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nepvent_waiter/UI/Design/AppTheme.dart';

class PrimaryMenuWidget extends StatelessWidget {
  const PrimaryMenuWidget({
    super.key,
    required this.primaryMenuList,
    required this.valueChange,
    required this.selectedItem,
  });

  final List<dynamic> primaryMenuList;
  final ValueChanged<dynamic> valueChange;
  final String selectedItem;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 50),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Main Menu', style: AppTheme.of(context).title3),
              IconButton(
                icon: Icon(Icons.arrow_back_ios, color: AppTheme.of(context).primaryText, size: 30),
                onPressed: () {
                  if (Scaffold.of(context).isDrawerOpen || Scaffold.of(context).isEndDrawerOpen) {
                    Navigator.pop(context);
                  }
                },
              ),
            ],
          ),
        ),
        Divider(thickness: 1, color: AppTheme.of(context).secondaryText),
        const SizedBox(height: 8),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: primaryMenuList.length,
            itemBuilder: (context, index) {
              final element = primaryMenuList[index];
              // final isSelected = element['id'] == selectedItem;
              final isSelected = element['name'] == selectedItem;
              return Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: InkWell(
                  onTap: () {
                    valueChange(element);
                    Navigator.pop(context);
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: isSelected ? const Color(0xFFE0E0FF) : Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: isSelected ? const Color(0xFF303068) : const Color(0xFFF1F4F8),
                        width: 2,
                      ),
                    ),
                    padding: const EdgeInsets.all(8),
                    child: Row(
                      children: [
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(left: 12),
                            child: Text(
                              // element['name'],
                              element['name'].split(' ').map((word) =>
                              word.isNotEmpty
                                  ? word[0].toUpperCase() + word.substring(1).toLowerCase()
                                  : ''
                              ).join(' '),
                              style: AppTheme.of(context).subtitle1.override(
                                fontFamily: 'Outfit',
                                color: const Color(0xFF101213),
                                fontSize: 18,
                                fontWeight: FontWeight.normal,
                                useGoogleFonts: GoogleFonts.asMap().containsKey(
                                  AppTheme.of(context).subtitle2.fontFamily,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
