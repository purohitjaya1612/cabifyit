import 'package:cabifyit/reusability/theme/app_textstyle.dart';
import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

class CommonDropdown extends StatefulWidget {
  ValueChanged<String?> onChanged;
  CommonDropdown({super.key, required this.onChanged});

  @override
  _CommonDropdownState createState() => _CommonDropdownState();
}

class _CommonDropdownState extends State<CommonDropdown> {
  String selected = "Cash";

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(
          color: AppColors.lightBlue,
          width: 1,
        ),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: selected,
          icon: Icon(Icons.keyboard_arrow_down, color: Colors.grey),
          style: TextStyle(
            fontSize: 20,
            color: Colors.blue.shade700,
            fontWeight: FontWeight.w500,
          ),
          onChanged: (value) {
            selected = value ?? "";
            widget.onChanged(value);
            setState(() {});
          },
          items: [
            DropdownMenuItem(
              value: "Cash",
              child: Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: Colors.green.shade100,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(Icons.money, color: Colors.green, size: 18),
                  ),
                  SizedBox(width: 10),
                  Text("Cash", style: AppTextStyle.size14MediumAppBlackText.copyWith(color: AppColors.appPrimaryColor)),
                ],
              ),
            ),
            DropdownMenuItem(
              value: "Online",
              child: Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: Colors.blue.shade100,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(Icons.credit_card, color: Colors.blue, size: 18),
                  ),
                  SizedBox(width: 10),
                  Text("Online", style: AppTextStyle.size14MediumAppBlackText.copyWith(color: AppColors.appPrimaryColor)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
