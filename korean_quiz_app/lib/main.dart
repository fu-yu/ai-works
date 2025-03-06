import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'screens/home_screen.dart';
import 'utils/constants.dart';
import 'providers/score_provider.dart';
import 'providers/quiz_provider.dart';
import 'repositories/score_repository.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const KoreanQuizApp());
}

class KoreanQuizApp extends StatelessWidget {
  const KoreanQuizApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => ScoreProvider(repository: ScoreRepository()),
        ),
        ChangeNotifierProvider(create: (_) => QuizProvider()),
      ],
      child: MaterialApp(
        title: Strings.appTitle,
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [Locale('ja', ''), Locale('en', '')],
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: AppColors.primary,
            primary: AppColors.primary,
            secondary: AppColors.secondary,
          ),
          appBarTheme: const AppBarTheme(
            backgroundColor: AppColors.primary,
            foregroundColor: Colors.white,
          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
            ),
          ),
        ),
        home: const HomeScreen(),
      ),
    );
  }
}
