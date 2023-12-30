import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../Views/add_sale_screen.dart';
import '../Views/dashboard_screen.dart';
import '../Views/sales_history_screen.dart';

Widget buildStyledContainer(Widget child) {
  return Container(
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(10.0),
      boxShadow: [
        BoxShadow(
          color: Colors.grey.withOpacity(0.5),
          spreadRadius: 2,
          blurRadius: 5,
          offset: Offset(0, 3),
        ),
      ],
    ),
    padding: EdgeInsets.all(16.0),
    margin: EdgeInsets.all(8.0),
    child: child,
  );
}

Widget buildNumericInput(String labelText, String hintText,
    {TextEditingController? controller,
    bool isEnabled = true,
    ValueChanged<String>? onChanged}) {
  return buildTextInput(
    labelText,
    hintText,
    keyboardType: TextInputType.number,
    inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[0-9]'))],
    controller: controller,
    onChanged: onChanged,
    enabled: isEnabled,
  );
}

Widget buildTextInput(String labelText, String hintText,
    {TextInputType keyboardType = TextInputType.text,
    int? maxLength,
    List<TextInputFormatter>? inputFormatters,
    bool obscureText = false,
    String? Function(String?)? validator,
    TextEditingController? controller,
    ValueChanged<String>? onChanged,
    bool enabled = true}) {
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: labelText,
        hintText: hintText,
        labelStyle: InputFieldStyle.labelStyle,
        enabledBorder: InputFieldStyle.inputBorder,
        focusedBorder: InputFieldStyle.inputBorder,
      ),
      maxLength: maxLength,
      keyboardType: keyboardType,
      inputFormatters: inputFormatters,
      obscureText: obscureText,
      validator: validator,
      onChanged: onChanged,
      enabled: enabled,
    ),
  );
}

Widget buildHeader(String text) {
  return Text(
    text,
    style: TextStyle(
      fontSize: 20.0,
      fontWeight: FontWeight.bold,
    ),
  );
}



class InputFieldStyle {
  static TextStyle labelStyle = TextStyle(
    color: Color(0xFFafa4c3),
  );

  static OutlineInputBorder inputBorder = OutlineInputBorder(
    borderSide: BorderSide(color: Color(0xFFafa4c3)),
    borderRadius: BorderRadius.circular(10.0),
  );
}

class NumberSelectionWidget extends StatelessWidget {
  final String labelText;
  final String hintText;
  final int selectedNumber;
  final ValueSetter<int?>? onChanged;

  NumberSelectionWidget({
    required this.labelText,
    required this.hintText,
    required this.selectedNumber,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: labelText,
          hintText: hintText,
          labelStyle: TextStyle(color: Colors.grey),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
        ),
        child: DropdownButtonHideUnderline(
          child: DropdownButton<int>(
            value: selectedNumber,
            isDense: true,
            onChanged: onChanged,
            items: [6, 12, 18, 24].map((int value) {
              return DropdownMenuItem<int>(
                value: value,
                child: Text(value.toString()),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}

BottomNavigationBar buildBottomNavigationBar(BuildContext context) {
  return BottomNavigationBar(
    items: [
      BottomNavigationBarItem(
        icon: Image.asset(
          'assets/dashboard.png',
          width: 24,
          height: 24,
          color: null,
        ),
        label: 'Home',
      ),
      BottomNavigationBarItem(
        icon: Image.asset(
          'assets/add.png',
          width: 24,
          height: 24,
          color: null,
        ),
        label: 'Add Record',
      ),
      BottomNavigationBarItem(
        icon: Image.asset(
          'assets/folder.png',
          width: 24,
          height: 24,
          color: null,
        ),
        label: 'Sales History',
      ),
    ],
    currentIndex: 1,
    onTap: (index) {
      // Handle navigation here
      if (index == 0) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => DashboardScreen()),
        );
      } else if (index == 2) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => SalesHistoryScreen()),
        );
      }
    },
  );
}


