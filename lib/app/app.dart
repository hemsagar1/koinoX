import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/services/app_state_provider.dart';
import 'routes/app_routes.dart';
import 'theme/app_theme.dart';

class KoinoXApp extends StatelessWidget {
  const KoinoXApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AppStateProvider(),
      child: Consumer<AppStateProvider>(
        builder: (context, appState, child) {
          return MaterialApp(
            title: 'KoinoX',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: appState.isDarkMode ? ThemeMode.dark : ThemeMode.light,
            initialRoute: AppRoutes.splash,
            routes: AppRoutes.routes,
          );
        },
      ),
    );
  }
}
