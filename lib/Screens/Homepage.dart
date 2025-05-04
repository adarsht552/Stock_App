import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pnlclone/Provider/profitlossprovider.dart';
import 'package:pnlclone/Screens/monthsummerycard.dart';
import 'package:provider/provider.dart';
import 'package:pnlclone/Screens/Components/profLosscard.dart';
import 'package:pnlclone/Screens/Components/showbottomsheet.dart';
import 'package:pnlclone/constants/appbar.dart';
import 'package:pnlclone/constants/colorconstant.dart';
import 'package:pnlclone/models/saveprofitloss.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  void initState() {
    super.initState();
    // Load data when the page initializes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<ProfitLossProvider>(context, listen: false).loadData();
    });
  }

  @override
  Widget build(BuildContext context) {
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('dd MMM yy').format(now);
    String displayDate = DateFormat('dd MMM').format(now); // For comparing with saved data
    
    return Scaffold(
      backgroundColor: ColorConstant.scaffoldColor,
      floatingActionButton: FloatingActionButton(
        onPressed: () => showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
          ),
          builder: (context) => const CustomBottomSheet(),
        ),
        shape: const CircleBorder(),
        child: const Icon(Icons.add),
      ),
      body: SafeArea(
        child: Consumer<ProfitLossProvider>(
          builder: (ctx, provider, _) {
            // Get all unique dates from the saved data
            final List<String> allDates = _getUniqueDates(provider.items);
            
            // Get total profit and loss for today
            final double totalProfit = provider.getTotalProfitByDate(displayDate);
            final double totalLoss = provider.getTotalLossByDate(displayDate);
            
            // Calculate net amount (profit - loss)
            final double netAmount = totalProfit - totalLoss;
            final String amountText = "\$${netAmount.abs().toStringAsFixed(2)}";
            
            // Filter out past dates with zero transactions
            final List<String> filteredDates = allDates.where((date) {
              // If it's today's date, always include it
              if (date == displayDate) return true;
              
              // For past dates, only include if they have transactions
              final double dateTotalProfit = provider.getTotalProfitByDate(date);
              final double dateTotalLoss = provider.getTotalLossByDate(date);
              return dateTotalProfit > 0 || dateTotalLoss > 0;
            }).toList();
            
            return SingleChildScrollView(
              child: Column(
                children: [
                  CustomAppbar(title: "Home", subtitle: formattedDate),
                  const SizedBox(height: 10),
                   const MonthSummaryCard(),
                  // Today's card (always shown, even if empty)
                  CustomCard(
                    date: formattedDate,
                    amount: totalProfit == 0 && totalLoss == 0 ? "\$0.00" : amountText,
                    profit: totalProfit,
                    loss: totalLoss,
                    isToday: true,
                  ),
                  
                  // Cards for other dates (sorted by most recent first, filtered to remove empty past dates)
                  ...filteredDates.where((date) => date != displayDate).map((date) {
                    final double dateProfit = provider.getTotalProfitByDate(date);
                    final double dateLoss = provider.getTotalLossByDate(date);
                    final double dateNetAmount = dateProfit - dateLoss;
                    final String dateAmountText = "\$${dateNetAmount.abs().toStringAsFixed(2)}";
                    
                    // Convert date string to DateTime for proper formatting
                    final DateTime dateTime = _parseDateString(date);
                    final String fullDate = DateFormat('dd MMM yy').format(dateTime);
                    
                    return CustomCard(
                      date: fullDate,
                      amount: dateAmountText,
                      profit: dateProfit,
                      loss: dateLoss,
                    );
                  }).toList(),
                  
                  // Show message if no historical transactions (but today's card is still shown)
                  if (filteredDates.length <= 1 && (totalProfit == 0 && totalLoss == 0))
                    const Padding(
                      padding: EdgeInsets.all(32.0),
                      child: Center(
                        child: Text(
                          "Add your first profit or loss using the + button!",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
  
  // Helper method to get unique dates from all items
  List<String> _getUniqueDates(List<SaveProfitLoss> items) {
    final Set<String> uniqueDates = {};
    
    for (var item in items) {
      if (item.date != null && item.date!.isNotEmpty) {
        uniqueDates.add(item.date!);
      }
    }
    
    // Sort dates in descending order (most recent first)
    final sortedDates = uniqueDates.toList()
      ..sort((a, b) {
        final DateTime dateA = _parseDateString(a);
        final DateTime dateB = _parseDateString(b);
        return dateB.compareTo(dateA);
      });
    
    return sortedDates;
  }
  
  // Helper method to parse date string to DateTime
  DateTime _parseDateString(String dateStr) {
    try {
      // Parse "dd MMM" format
      final parts = dateStr.split(' ');
      if (parts.length >= 2) {
        final day = int.tryParse(parts[0]) ?? 1;
        final month = _getMonthNumber(parts[1]);
        final year = DateTime.now().year; // Default to current year
        return DateTime(year, month, day);
      }
    } catch (e) {
      print("Error parsing date: $e");
    }
    return DateTime.now();
  }
  
  // Helper method to convert month abbreviation to number
  int _getMonthNumber(String monthAbbr) {
    const months = {
      'Jan': 1, 'Feb': 2, 'Mar': 3, 'Apr': 4, 'May': 5, 'Jun': 6,
      'Jul': 7, 'Aug': 8, 'Sep': 9, 'Oct': 10, 'Nov': 11, 'Dec': 12
    };
    return months[monthAbbr] ?? 1;
  }
  
  // Helper method to check if there are transactions for a specific date
  bool _hasTransactionsForDate(ProfitLossProvider provider, String date) {
    return provider.getItemsByDate(date).isNotEmpty;
  }
}
