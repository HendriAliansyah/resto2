import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:resto2/utils/app_theme.dart';
import 'package:firebase_app_check/firebase_app_check.dart'; // Import App Check
import 'utils/app_router.dart';
import 'firebase_options.dart';
import 'utils/constants.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // **THE FIX IS HERE:**
  // Activate App Check for your project.
  await FirebaseAppCheck.instance.activate(
    // You can also use a web-specific provider here.
    webProvider: ReCaptchaV3Provider('recaptcha-v3-site-key'),
    // Your Android provider is set up automatically.
    androidProvider: AndroidProvider.playIntegrity,
  );

  FirebaseFirestore.instance.settings = const Settings(
    persistenceEnabled: true,
  );

  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);
    return MaterialApp.router(
      title: UIStrings.appTitle,
      theme: appTheme,
      routerConfig: router,
    );
  }
}
