import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pnlclone/Provider/profitlossprovider.dart';
import 'package:provider/provider.dart';
import 'package:pnlclone/Screens/Components/customTextfield.dart';
import 'package:pnlclone/constants/colorconstant.dart';

class ProfitLosssheet extends StatefulWidget {
  final bool isProfit;

  const ProfitLosssheet({
    super.key,
    this.isProfit = true
  });

  @override
  State<ProfitLosssheet> createState() => _ProfitLosssheetState();
}

class _ProfitLosssheetState extends State<ProfitLosssheet> {
  late TextEditingController _dateController;
  DateTime selectedDate = DateTime.now();
  TextEditingController amountController = TextEditingController();

  @override
// In _ProfitLosssheetState class
void initState() {
  super.initState();
  _dateController = TextEditingController(
    // Use the same format as in Homepage
    text: DateFormat('dd MMM').format(selectedDate)
  );
}


  @override
  void dispose() {
    _dateController.dispose();
    amountController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
        _dateController.text = DateFormat('dd MMM').format(selectedDate);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final profitLossProvider = Provider.of<ProfitLossProvider>(context, listen: false);
    final Color iconColor = widget.isProfit ? Colors.green : Colors.red;
    final Color calendarcolor = widget.isProfit ? Colors.green : Colors.red;
    final IconData amountIcon = widget.isProfit ? Icons.trending_up : Icons.trending_down;
    final String title = widget.isProfit ? "Profit" : "Loss";

    return Container(
      height: MediaQuery.of(context).size.height * 0.26,
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Icon(amountIcon, color: iconColor),
              const SizedBox(width: 10),
              Expanded(
                child: CustomTextfield(
                  lable: "Amount",
                  controller: amountController,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Icon(Icons.calendar_month, color: calendarcolor),
              const SizedBox(width: 10),
              Expanded(
                child: GestureDetector(
                  onTap: () => _selectDate(context),
                  child: AbsorbPointer(
                    child: CustomTextfield(
                      lable: "Date",
                      controller: _dateController,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Align(
            alignment: Alignment.bottomRight,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: iconColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onPressed: () {
                // Save data using provider
                if (amountController.text.isNotEmpty) {
                  profitLossProvider.addProfitLoss(
                    widget.isProfit ? 'Profit' : 'Loss',
                    amountController.text,
                    _dateController.text,
                  );
                  Navigator.pop(context);
                } else {
                  // Show error or validation message
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Please enter an amount')),
                  );
                }
              },
              child: const Text('Save', style: TextStyle(color: Colors.white)),
            ),
          )
        ],
      ),
    );
  }
}
