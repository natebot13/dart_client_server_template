import 'package:auto_route/auto_route.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_auth/firebase_auth.dart' hide EmailAuthProvider;
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_ui_auth/firebase_ui_auth.dart' hide AuthState;
import 'package:firebase_ui_localizations/firebase_ui_localizations.dart';
import 'package:firebase_ui_oauth_google/firebase_ui_oauth_google.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:injectable/injectable.dart';

import 'bloc/auth_bloc.dart';
import 'router.dart';
import 'router.gr.dart';
import 'src/injection.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  configureInjection(kDebugMode ? Environment.dev : Environment.prod);

  // Use emulators if in debug mode.
  if (kDebugMode) {
    var emulatorHost = 'localhost';
    if (!kIsWeb && defaultTargetPlatform == TargetPlatform.android) {
      // Use LAN address for android physical device
      final androidInfo = await DeviceInfoPlugin().androidInfo;
      if (androidInfo.isPhysicalDevice) {
        emulatorHost = '192.168.86.195';
      }
    }
    await FirebaseAuth.instance.useAuthEmulator(emulatorHost, 9099);
    await FirebaseStorage.instance.useStorageEmulator(emulatorHost, 9199);
    FirebaseFirestore.instance.useFirestoreEmulator(emulatorHost, 8080);
  }

  FirebaseUIAuth.configureProviders([
    GoogleProvider(clientId: 'GOOGLE_CLIENT_ID'),
    // AppleProvider(),
    EmailAuthProvider(),
  ]);

  runApp(ClientTemplate());
}

// Overrides a label for en locale
// To add localization for a custom language follow the guide here:
// https://flutter.dev/docs/development/accessibility-and-localization/internationalization#an-alternative-class-for-the-apps-localized-resources
class LabelOverrides extends DefaultLocalizations {
  const LabelOverrides();

  @override
  String get emailInputLabel => 'Enter your email';
}

class ClientTemplate extends StatelessWidget {
  ClientTemplate({super.key});

  final _appRouter = AppRouter();

  @override
  Widget build(BuildContext context) {
    final buttonStyle = ButtonStyle(
      padding: MaterialStateProperty.all(const EdgeInsets.all(12)),
      shape: MaterialStateProperty.all(
        RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );

    return RepositoryProvider(
      create: (context) => FirebaseAuth.instance,
      child: BlocProvider(
        create: (context) => AuthBloc(
          RepositoryProvider.of<FirebaseAuth>(context),
        ),
        child: BlocBuilder<AuthBloc, AuthState>(
          builder: (context, authState) {
            return MaterialApp.router(
              theme: ThemeData(
                brightness: Brightness.dark,
                visualDensity: VisualDensity.standard,
                useMaterial3: true,
                inputDecorationTheme: const InputDecorationTheme(
                  border: OutlineInputBorder(),
                ),
                elevatedButtonTheme:
                    ElevatedButtonThemeData(style: buttonStyle),
                textButtonTheme: TextButtonThemeData(style: buttonStyle),
                outlinedButtonTheme:
                    OutlinedButtonThemeData(style: buttonStyle),
              ),
              routerDelegate: AutoRouterDelegate.declarative(
                _appRouter,
                routes: (_) => [
                  if (authState is AuthLoggedIn)
                    const HomeRoute()
                  else
                    const LoginRoute()
                ],
              ),
              title: 'Client Template',
              debugShowCheckedModeBanner: false,
              locale: const Locale('en'),
              localizationsDelegates: [
                FirebaseUILocalizations.withDefaultOverrides(
                    const LabelOverrides()),
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
                FirebaseUILocalizations.delegate,
              ],
            );
          },
        ),
      ),
    );
  }
}
