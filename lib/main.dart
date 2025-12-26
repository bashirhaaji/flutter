import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'favorites_data.dart';
import 'pages/home_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await FavoritesData.init();
  runApp(const ClassicBlueDictionary());
}

class ClassicBlueDictionary extends StatelessWidget {
  const ClassicBlueDictionary({super.key});

  @override
  Widget build(BuildContext context) {
    const black = Color(0xFF000000);
    const blue = Color(0xFF5682B1);
    const lightBlue = Color(0xFF739EC9);
    const cream = Color(0xFFFFE8DB);

    final theme = ThemeData(
      colorScheme: ColorScheme.fromSeed(
        seedColor: blue,
        primary: blue,
        secondary: lightBlue,
        background: cream,
      ),
      scaffoldBackgroundColor: cream,
      appBarTheme: const AppBarTheme(
        backgroundColor: blue,
        foregroundColor: Colors.white,
        centerTitle: true,
      ),
      textTheme: GoogleFonts.latoTextTheme().apply(
        bodyColor: black,
        displayColor: black,
      ),
      useMaterial3: true,
    );

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Word Dictionary',
      theme: theme,
      home: const HomePage(),
    );
  }
}
