import 'package:flutter/material.dart';
import 'package:pnlclone/Provider/profitlossprovider.dart';
import 'package:pnlclone/Screens/detaildata.dart';
import 'package:provider/provider.dart';
import 'package:pnlclone/constants/colorconstant.dart';
import 'package:pnlclone/models/saveprofitloss.dart';

class CustomCard extends StatelessWidget {
  final String date;
  final String amount;
  final double profit;
  final double loss;
  final bool isToday;

  const CustomCard({
    super.key,
    required this.date,
    required this.amount,
    required this.profit,
    required this.loss,
    this.isToday = false,
  });

  @override
  Widget build(BuildContext context) {
    // Extract just the day and month for comparison with saved data
    final dateParts = date.split(' ');
    final String displayDate = dateParts.length >= 2 ? "${dateParts[0]} ${dateParts[1]}" : date;
    
    return Consumer<ProfitLossProvider>(
      builder: (ctx, provider, _) {
        final List<SaveProfitLoss> todayItems = provider.getItemsByDate(displayDate);
        
        return GestureDetector(
          onTap: () {
            // Navigate to detailed transactions screen when card is tapped
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => DetailedTransactionsScreen(
                  date: displayDate,
                  fullDate: date,
                  profit: profit,
                  loss: loss,
                ),
              ),
            );
          },
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.white,
                // border: isToday ? Border.all(color: Colors.blue, width: 2) : null,
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
                    title: Row(
                      children: [
                        Text(
                          date,
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: ColorConstant.appbartitle,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        if (isToday) 
                          Container(
                            margin: const EdgeInsets.only(left: 8),
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color: Colors.blue,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Text(
                              "Today",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                      ],
                    ),
                    subtitle: Text(
                      amount,
                      style: TextStyle(
                        color: profit > loss ? Colors.green : (loss > profit ? Colors.red : Colors.grey[600]),
                        fontSize: ColorConstant.appbarsubtitle,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    trailing: const Icon(Icons.arrow_forward_ios, size: 16),
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
        );
      },
    );
  }
}
