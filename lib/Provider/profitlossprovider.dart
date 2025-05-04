import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';
import 'package:pnlclone/models/saveprofitloss.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:uuid/uuid.dart';

class ProfitLossProvider with ChangeNotifier {
  List<SaveProfitLoss> _items = [];
  
  List<SaveProfitLoss> get items {
    return [..._items];
  }

  // Initialize by loading data from SharedPreferences
  Future<void> loadData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final data = prefs.getString('profit_loss_data');
      
      if (data != null && data.isNotEmpty) {
        final List<dynamic> jsonData = json.decode(data);
        _items = jsonData.map((item) => SaveProfitLoss.fromJson(item)).toList();
        notifyListeners();
      }
    } catch (e) {
      print("Error loading data: $e");
    }
  }

  // Save data to SharedPreferences
  Future<void> saveDataToPrefs() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final data = json.encode(_items.map((item) => item.toJson()).toList());
      await prefs.setString('profit_loss_data', data);
      print("Data saved to prefs: $data"); // Debug print
    } catch (e) {
      print("Error saving data: $e");
    }
  }

  // Add a new profit/loss entry
  Future<void> addProfitLoss(String profitLoss, String amount, String date) async {
    try {
      final newItem = SaveProfitLoss(
        id: const Uuid().v4(), // Generate a unique ID
        profitLoss: profitLoss,
        amount: amount,
        date: date,
      );
      
      _items.add(newItem);
      print("Added new item: ${newItem.toJson()}"); // Debug print
      notifyListeners();
      await saveDataToPrefs();
      print("Items after save: ${_items.length}"); // Debug print
    } catch (e) {
      print("Error adding profit/loss: $e");
    }
  }

  // Get items for a specific date
  List<SaveProfitLoss> getItemsByDate(String date) {
    return _items.where((item) => item.date == date).toList();
  }

  // Calculate total profit for a specific date
  double getTotalProfitByDate(String date) {
    final dateItems = getItemsByDate(date);
    double total = 0;
    
    for (var item in dateItems) {
      if (item.profitLoss == 'Profit') {
        total += double.tryParse(item.amount ?? '0') ?? 0;
      }
    }
    
    return total;
  }

  // Calculate total loss for a specific date
  double getTotalLossByDate(String date) {
    final dateItems = getItemsByDate(date);
    double total = 0;
    
    for (var item in dateItems) {
      if (item.profitLoss == 'Loss') {
        total += double.tryParse(item.amount ?? '0') ?? 0;
      }
    }
    
    return total;
  }

  // Add this method to the ProfitLossProvider class

// Get all unique months from the data
List<String> getUniqueMonths() {
  final Set<String> uniqueMonths = {};
  
  for (var item in _items) {
    if (item.date != null && item.date!.isNotEmpty) {
      final parts = item.date!.split(' ');
      if (parts.length >= 2) {
        final monthYear = parts[1]; // Month abbreviation
        uniqueMonths.add(monthYear);
      }
    }
  }
  
  return uniqueMonths.toList();
}

// Get items for a specific month
List<SaveProfitLoss> getItemsByMonth(String month) {
  return _items.where((item) {
    if (item.date != null && item.date!.isNotEmpty) {
      final parts = item.date!.split(' ');
      if (parts.length >= 2) {
        return parts[1] == month;
      }
    }
    return false;
  }).toList();
}

// Add this method to the ProfitLossProvider class

// Clear UI for new month but keep the data
void clearUIForNewMonth() {
  notifyListeners();
}

// Check if it's a new month compared to the last saved data
bool isNewMonth() {
  if (_items.isEmpty) return false;
  
  final currentMonth = DateFormat('MMM').format(DateTime.now());
  
  // Get the most recent entry
  final latestItem = _items.reduce((a, b) {
    final dateA = _parseDateString(a.date ?? '');
    final dateB = _parseDateString(b.date ?? '');
    return dateA.isAfter(dateB) ? a : b;
  });
  
  if (latestItem.date != null && latestItem.date!.isNotEmpty) {
    final parts = latestItem.date!.split(' ');
    if (parts.length >= 2) {
      final savedMonth = parts[1]; // Month abbreviation
      return savedMonth != currentMonth;
    }
  }
  
  return false;
}

// Helper method to parse date string
DateTime _parseDateString(String dateStr) {
  try {
    final parts = dateStr.split(' ');
    if (parts.length >= 2) {
      final day = int.tryParse(parts[0]) ?? 1;
      final monthAbbr = parts[1];
      final year = DateTime.now().year;
      
      const months = {
        'Jan': 1, 'Feb': 2, 'Mar': 3, 'Apr': 4, 'May': 5, 'Jun': 6,
        'Jul': 7, 'Aug': 8, 'Sep': 9, 'Oct': 10, 'Nov': 11, 'Dec': 12
      };
      
      final month = months[monthAbbr] ?? 1;
      return DateTime(year, month, day);
    }
  } catch (e) {
    print("Error parsing date: $e");
  }
  return DateTime.now();
}

// Add these methods to the ProfitLossProvider class

// Get items for the current month
List<SaveProfitLoss> getCurrentMonthItems() {
  final currentMonth = DateFormat('MMM').format(DateTime.now());
  final currentYear = DateTime.now().year;
  
  return _items.where((item) {
    if (item.date != null && item.date!.isNotEmpty) {
      final parts = item.date!.split(' ');
      if (parts.length >= 2) {
        final month = parts[1]; // Month abbreviation (e.g., "May")
        
        // If the date format includes year (e.g., "05 May 23")
        if (parts.length >= 3) {
          final year = "20${parts[2]}"; // Convert "23" to "2023"
          return month == currentMonth && year == currentYear.toString();
        }
        
        // If no year in the format, just match the month
        return month == currentMonth;
      }
    }
    return false;
  }).toList();
}

// Calculate total profit for the current month
double getCurrentMonthTotalProfit() {
  final monthItems = getCurrentMonthItems();
  double total = 0;
  
  for (var item in monthItems) {
    if (item.profitLoss == 'Profit') {
      total += double.tryParse(item.amount ?? '0') ?? 0;
    }
  }
  
  return total;
}

// Calculate total loss for the current month
double getCurrentMonthTotalLoss() {
  final monthItems = getCurrentMonthItems();
  double total = 0;
  
  for (var item in monthItems) {
    if (item.profitLoss == 'Loss') {
      total += double.tryParse(item.amount ?? '0') ?? 0;
    }
  }
  
  return total;
}

// Calculate net amount (profit - loss) for the current month
double getCurrentMonthNetAmount() {
  return getCurrentMonthTotalProfit() - getCurrentMonthTotalLoss();
}



}
