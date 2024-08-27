import 'dart:async';

import 'package:flutter/material.dart';
import 'package:telegram_web_app/telegram_web_app.dart';

void main() async {
  try {
    if (TelegramWebApp.instance.isSupported) {
      await TelegramWebApp.instance.ready();
      await TelegramWebApp.instance.enableClosingConfirmation();
      await TelegramWebApp.instance.expand();
    }
  } catch (e) {
    await Future.delayed(const Duration(milliseconds: 200));
    main();
    return;
  }

  FlutterError.onError = (details) {};

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const AspectRatio(
      aspectRatio: 9 / 16,
      child: MaterialApp(
        home: HomePage(),
      ),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool isComplete = false;
  Timer? _timer;

  @override
  void initState() {
    super.initState();

    _timer = Timer.periodic(
      const Duration(seconds: 1),
      (tim) {
        setState(() {
          isComplete = !isComplete;
        });
      },
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    _timer = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: TelegramWebApp.instance.headerColor ?? Colors.pink,
        extendBody: true,
        body: AnimatedDefaultTextStyle(
          duration: Durations.medium4,
          style: TextStyle(
            fontSize: isComplete ? 36 : 48,
            color: isComplete ? Colors.black : Colors.white,
          ),
          child: Placeholder(
            child: Align(
              alignment: Alignment.bottomCenter,
              child: ColoredBox(
                color: Colors.red,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      TelegramWebApp.instance.initData.user.username ??
                          'NULL AST',
                    ),
                  ],
                ),
              ),
            ),
          ),
        ));
  }
}
