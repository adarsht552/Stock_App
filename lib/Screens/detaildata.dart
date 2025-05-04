import 'package:flutter/material.dart';
import 'package:pnlclone/Provider/profitlossprovider.dart';
import 'package:provider/provider.dart';
import 'package:pnlclone/constants/colorconstant.dart';
import 'package:pnlclone/models/saveprofitloss.dart';

class DetailedTransactionsScreen extends StatelessWidget {
  final String date;
  final String fullDate;
  final double profit;
  final double loss;

  const DetailedTransactionsScreen({
    Key? key,
    required this.date,
    required this.fullDate,
    required this.profit,
    required this.loss,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final double netAmount = profit - loss;
    final String amountText = "\$${netAmount.abs().toStringAsFixed(2)}";

    return Scaffold(
      backgroundColor: ColorConstant.scaffoldColor,
      appBar: AppBar(
        backgroundColor: ColorConstant.scaffoldColor,
        title: Text(fullDate),
        elevation: 0,
      ),
      body: Consumer<ProfitLossProvider>(
        builder: (ctx, provider, _) {
          final List<SaveProfitLoss> dayItems = provider.getItemsByDate(date);
          
          return SingleChildScrollView(
            child: Column(
              children: [
                // Summary Card
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.white,
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
                            "Summary",
                            style: TextStyle(
                              fontSize: ColorConstant.appbartitle,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          subtitle: Text(
                            amountText,
                            style: TextStyle(
                              color: profit > loss ? Colors.green : (loss > profit ? Colors.red : Colors.grey[600]),
                              fontSize: ColorConstant.appbarsubtitle,
                              fontWeight: FontWeight.bold,
                            ),
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
                                      "Profit",
                                      style: TextStyle(
                                        color: Colors.green[800],
                                        fontSize: ColorConstant.appbarsubtitle,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      "\$${profit.toStringAsFixed(2)}",
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
                                      "Loss",
                                      style: TextStyle(
                                        color: Colors.red[800],
                                        fontSize: ColorConstant.appbarsubtitle,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      "\$${loss.toStringAsFixed(2)}",
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
                ),
                
                // Transactions List
                if (dayItems.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.white,
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
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Padding(
                            padding: EdgeInsets.all(16.0),
                            child: Text(
                              "Trade History",
                              style: TextStyle(
                                fontSize: ColorConstant.appbartitle,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          ListView.separated(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: dayItems.length,
                            separatorBuilder: (context, index) => const Divider(height: 1),
                            itemBuilder: (ctx, index) {
                              final item = dayItems[index];
                              return ListTile(
                                leading: CircleAvatar(
                                  backgroundColor: item.profitLoss == 'Profit' 
                                      ? Colors.green[100] 
                                      : Colors.red[100],
                                  child: Icon(
                                    item.profitLoss == 'Profit' 
                                        ? Icons.trending_up 
                                        : Icons.trending_down,
                                    color: item.profitLoss == 'Profit' 
                                        ? Colors.green 
                                        : Colors.red,
                                  ),
                                ),
                                title: Text(
                                  item.profitLoss ?? '',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: item.profitLoss == 'Profit' 
                                        ? Colors.green[800] 
                                        : Colors.red[800],
                                  ),
                                ),
                                trailing: Text(
                                  '\$${item.amount}',
                                  style: TextStyle(
                                    color: item.profitLoss == 'Profit' 
                                        ? Colors.green[800] 
                                        : Colors.red[800],
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                
                             if (dayItems.isEmpty)
                  const Center(
                    child: Padding(
                      padding: EdgeInsets.all(32.0),
                      child: Text(
                        "No transactions found for this day",
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
    );
  }
}
