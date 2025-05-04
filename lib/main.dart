import 'package:flutter/material.dart';
import 'package:pnlclone/constants/bottomnavbar.dart';
import 'package:provider/provider.dart';
import 'package:pnlclone/Provider/profitlossprovider.dart';
// Import your app component
import 'package:pnlclone/Screens/Homepage.dart'; // Adjust this import as needed

void main() async {
  // This line is crucial - it ensures Flutter is initialized before using plugins
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize your provider
  final profitLossProvider = ProfitLossProvider();
  // Load data after Flutter is initialized
  await profitLossProvider.loadData();
  
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: profitLossProvider),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'PNL Tracker',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const BottomNavigation(),
    );
  }
}
