import 'package:ehr/Dashboard/Travel%20Request/travelrequest.dart';
import 'package:ehr/Dashboard/sessiontimout.dart';
import 'package:ehr/Dashboard/viewmore/Loan/applyforloan.dart';
import 'package:ehr/Dashboard/viewmore/Loan/checkapi.dart';
import 'package:ehr/Dashboard/viewmore/Loan/loan.dart';
import 'package:ehr/Dashboard/viewmore/Loan/uploaddoc.dart';
import 'package:ehr/Loginpage.dart';
import 'package:ehr/SplashScreen.dart';
import 'package:ehr/connectivity_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

void main() {
  runApp(MyApp());
}

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   // This widget is the root of your application.
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//        debugShowCheckedModeBanner: false,
//       title: 'Flutter Demo',
//       theme: ThemeData(

//         colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
//         useMaterial3: true,

//       ),
//       home: SplashScreen(),
//       builder: EasyLoading.init(),
//     );
//   }

// }

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late SessionTimeoutManager _sessionTimeoutManager;
  final GlobalKey<NavigatorState> _navigatorKey = GlobalKey<NavigatorState>();
  final ConnectivityService _connectivityService = ConnectivityService();

  @override
  void initState() {
    super.initState();

    _connectivityService.initialize(context);
    _sessionTimeoutManager = SessionTimeoutManager(
      timeoutDuration: 5, // set the timeout duration in minutes
      onSessionTimeout: _showSessionTimeoutAlert,
    );
    _sessionTimeoutManager.startTimer();
  }

  @override
  void dispose() {
    _connectivityService.dispose();
    super.dispose();
  }

  void _showSessionTimeoutAlert() {
    if (_navigatorKey.currentContext != null) {
      showDialog(
        barrierDismissible: false,
        context: _navigatorKey.currentContext!,
        builder: (context) => Builder(builder: (context) {
          return MediaQuery(
            data: MediaQuery.of(context)
                .copyWith(textScaler: const TextScaler.linear(1.1)),
            child: AlertDialog(
              title: const Text('Session Expired'),
              content:
                  const Text('Your session has expired due to inactivity.'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    _handleSessionTimeout();
                  },
                  child: const Text('OK'),
                ),
              ],
            ),
          );
        }),
      );
    } else {
      // Fallback alert using ScaffoldMessenger
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
              'You have been inactive for 1 minute. You will be logged out.'),
          duration: Duration(seconds: 5),
        ),
      );
      _handleSessionTimeout();
    }
  }

  void _handleSessionTimeout() {
    // Handle session timeout (e.g., navigate to login screen)
    //
    if (_navigatorKey.currentContext != null) {
      _navigatorKey.currentState!.pushReplacement(
        MaterialPageRoute(builder: (context) => const Login()),
      );
    } else {
      // Fallback redirection
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _navigatorKey.currentState!.pushReplacement(
          MaterialPageRoute(builder: (context) => const Login()),
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _sessionTimeoutManager.resetTimer,
      onPanDown: (_) => _sessionTimeoutManager.resetTimer(),
      child: MaterialApp(
        navigatorKey: _navigatorKey,
        title: 'eHR-NSCS',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: SplashScreen(),
        builder: EasyLoading.init(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
