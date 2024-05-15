import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:travel_app_admin/providers/app_preferences_provider.dart';
import 'package:travel_app_admin/providers/data_provider.dart';
import 'package:travel_app_admin/providers/user_data_provider.dart';
import 'package:travel_app_admin/screens/Auth/login_screen.dart';
import 'package:travel_app_admin/screens/Theme/themes.dart';
import 'package:travel_app_admin/utils/app_focus_helper.dart';

class RootApp extends StatefulWidget {
  const RootApp({Key? key}) : super(key: key);

  @override
  State<RootApp> createState() => _RootAppState();
}

class _RootAppState extends State<RootApp> {
  Future<bool>? _future;

  Future<bool> _getScreenDataAsync(
      AppPreferencesProvider appPreferencesProvider,
      UserDataProvider userDataProvider) async {
    await appPreferencesProvider.loadAsync();
    await userDataProvider.loadAsync();

    return true;
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => AppPreferencesProvider()),
        ChangeNotifierProvider(create: (context) => UserDataProvider()),
        ChangeNotifierProvider(create: (context) => DataProvider()),
      ],
      child: Builder(
        builder: (context) {
          return GestureDetector(
            onTap: () {
              // Tap anywhere to dismiss soft keyboard.
              AppFocusHelper.instance.requestUnfocus();
            },
            child: FutureBuilder<bool>(
              initialData: null,
              future: (_future ??= _getScreenDataAsync(
                  context.read<AppPreferencesProvider>(),
                  context.read<UserDataProvider>())),
              builder: (context, snapshot) {
                if (snapshot.hasData && snapshot.data!) {
                  return Consumer<AppPreferencesProvider>(
                    builder: (context, provider, child) {
                      return MaterialApp(
                        debugShowCheckedModeBanner: false,
                        home: const LoginScreen(),
                        onGenerateTitle: (context) => "Travel App Admin",
                        theme: AppThemeData.instance.light(),
                        darkTheme: AppThemeData.instance.dark(),
                        themeMode: provider.themeMode,
                      );
                    },
                  );
                }

                return const SizedBox.shrink();
              },
            ),
          );
        },
      ),
    );
  }
}
