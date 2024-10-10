import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hotspot_hosts/view_models/experience_selection_vm.dart';
import 'package:hotspot_hosts/view_models/onboarding_question_vm.dart';
import 'package:hotspot_hosts/views/experience_selection.dart';
import 'package:hotspot_hosts/views/onboarding_question.dart';
import 'package:provider/provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => ExperienceSelectionViewModel()),
      ChangeNotifierProvider(create: (_) => OnboardingQuestionViewModel())
    ],
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
        debugShowCheckedModeBanner: false, home: ExperienceSelection());
  }
}
