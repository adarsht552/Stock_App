import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pnlclone/Provider/profitlossprovider.dart';
import 'package:provider/provider.dart';
import 'package:pnlclone/constants/colorconstant.dart';

class MonthSummaryCard extends StatelessWidget {
  const MonthSummaryCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final currentMonth = DateFormat('MMMM yyyy').format(DateTime.now());
    
    return Consumer<ProfitLossProvider>(
      builder: (ctx, provider, _) {
        final double totalProfit = provider.getCurrentMonthTotalProfit();
        final double totalLoss = provider.getCurrentMonthTotalLoss();
        final double netAmount = provider.getCurrentMonthNetAmount();
        
        final String netAmountText = "\$${netAmount.abs().toStringAsFixed(2)}";
        final bool isPositive = netAmount >= 0;
        
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.white,
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  isPositive ? Colors.green.withOpacity(0.1) : Colors.red.withOpacity(0.1),
                  Colors.white,
                ],
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.3),
                  spreadRadius: 1,
                  blurRadius: 5,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Column(
              children: [
                ListTile(
                  title: const Text(
                    "Monthly Summary",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: ColorConstant.appbartitle,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  subtitle: Text(
                    currentMonth,
                    style: const TextStyle(
                      color: Colors.grey,
                      fontSize: 14,
                    ),
                  ),
                  trailing: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        "Net",
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 14,
                        ),
                      ),
                      Text(
                        netAmountText,
                        style: TextStyle(
                          color: isPositive ? Colors.green : Colors.red,
                          fontSize: ColorConstant.appbarsubtitle,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    // Profit Container
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.green),
                          color: Colors.green[50],
                          borderRadius: BorderRadius.circular(8),
                        ),
                        margin: const EdgeInsets.symmetric(horizontal: 8),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const Icon(Icons.trending_up, color: Colors.green, size: 30),
                            const SizedBox(height: 5),
                            Text(
                              "Total Profit",
                              style: TextStyle(
                                color: Colors.green[800],
                                fontSize: 14,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              "\$${totalProfit.toStringAsFixed(2)}",
                              style: TextStyle(
                                color: Colors.green[800],
                                fontSize: ColorConstant.appbarsubtitle,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    // Loss Container
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.red),
                          color: Colors.red[50],
                          borderRadius: BorderRadius.circular(8),
                        ),
                        margin: const EdgeInsets.symmetric(horizontal: 8),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const Icon(Icons.trending_down, color: Colors.red, size: 30),
                            const SizedBox(height: 5),
                            Text(
                              "Total Loss",
                              style: TextStyle(
                                color: Colors.red[800],
                                fontSize: 14,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              "\$${totalLoss.toStringAsFixed(2)}",
                              style: TextStyle(
                                color: Colors.red[800],
                                fontSize: ColorConstant.appbarsubtitle,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        );
      },
    );
  }
}
