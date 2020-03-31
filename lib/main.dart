import 'package:flutter/material.dart';
import 'package:helper_app_2/screens/usertype_overview_screen.dart';
import 'package:provider/provider.dart';
import 'package:custom_splash/custom_splash.dart';

import './screens/jobs_overview_screen.dart';
import './screens/jobtype_overview_screen.dart';
import './screens/job_detail_screen.dart';
import './screens/user_input_screen.dart';
import './screens/info_screen.dart';

import './providers/jobs.dart';
import './providers/jobtypes.dart';
import './providers/user.dart';
import './providers/local_jobs.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    // Use it without value if you neet the context
    // Provider builder provides "Instance" NOT Widget of Jobs to all the child Widgets
    // CAN ACCESS AND / OR LISTEN TO THAT PROVIDED INSTANCE
    // ONLY the listened one execute build() method if notifyListeners() is called in jobs instance
    // Use MultProvider for multiple Providers
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: Jobs()),
        ChangeNotifierProvider.value(value: Jobtypes()),
        ChangeNotifierProvider.value(value: User()),
        ChangeNotifierProvider.value(value: LocalJobs()),
      ],
      // builder: (ctx) => Jobs()
      child: MaterialApp(
          title: 'Jobs App',
          theme: ThemeData(
            primarySwatch: Colors.red,
            accentColor: Colors.deepOrange,
            fontFamily: 'Lato',
          ),
          home: CustomSplash(
            imagePath: 'assets/toe_logo.png',
            backGroundColor: Colors.red,
            animationEffect: 'top-down',
            logoSize: 100,
            home: UsertypeOverviewScreen(),
            // customFunction: duringSplash,
            duration: 2000,
            type: CustomSplashType.StaticDuration,
            // outputAndHome: op,
          ),
          routes: {
            JobDetailScreen.routeName: (ctx) => JobDetailScreen(),
            JobsOverviewScreen.routeName: (ctx) => JobsOverviewScreen(),
            JobtypeOverviewScreen.routeName: (ctx) => JobtypeOverviewScreen(),
            UserInputScreen.routeName: (ctx) => UserInputScreen(),
            InfoScreen.routeName: (ctx) => InfoScreen(),
          }),
    );
  }
}
