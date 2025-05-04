import 'package:flutter/material.dart';
import 'package:pnlclone/Screens/Components/proflossbottomsheet.dart';
import 'package:pnlclone/constants/colorconstant.dart';

class CustomBottomSheet extends StatefulWidget {
  const CustomBottomSheet({super.key});

  @override
  State<CustomBottomSheet> createState() => _CustomBottomSheetState();
}

class _CustomBottomSheetState extends State<CustomBottomSheet> {
  String selectedOption = '';

  void _selectOption(String option) {
    setState(() {
      selectedOption = option;
    });
    Navigator.pop(context, option);
    if (option == 'Profit') {
      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
        ),
        builder: (context) => Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: const ProfitLosssheet(isProfit: true),
        ),
      );
    } else if (option == 'Loss') {
      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
        ),
        builder: (context) => Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: const ProfitLosssheet(isProfit: false),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.26,
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Select Option',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          Container(
            decoration: BoxDecoration(
              color: ColorConstant.profitColor,
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(8),
            ),
            child: ListTile(
              leading: const Icon(Icons.trending_up, color: Colors.green),
              title: const Text("Profit"),
              trailing: const Icon(
                Icons.arrow_forward_ios,
                color: Colors.grey,
                grade: 20,
              ),
              selected: selectedOption == 'Profit',
              selectedTileColor: Colors.green[50],
              onTap: () => _selectOption('Profit'),
            ),
          ),
          const SizedBox(height: 8),
          Container(
            decoration: BoxDecoration(
              color: ColorConstant.lossColor,
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(8),
            ),
            child: ListTile(
              leading: const Icon(Icons.trending_down, color: Colors.red),
              title: const Text("Loss"),
              trailing: const Icon(
                Icons.arrow_forward_ios,
                color: Colors.grey,
                grade: 20,
              ),
              selected: selectedOption == 'Loss',
              selectedTileColor: Colors.red[50],
              onTap: () => _selectOption('Loss'),
            ),
          ),
        ],
      ),
    );
  }
}
