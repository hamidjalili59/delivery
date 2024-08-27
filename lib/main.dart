import 'dart:async';

import 'package:flutter/material.dart';
import 'package:telegram_web_app/telegram_web_app.dart';

void main() async {
  try {
    if (TelegramWebApp.instance.isSupported) {
      await TelegramWebApp.instance.ready();
      await TelegramWebApp.instance.enableClosingConfirmation();
      Future.delayed(
          const Duration(seconds: 1), TelegramWebApp.instance.expand);
    }
  } catch (e) {
    await Future.delayed(const Duration(milliseconds: 200));
    main();
    return;
  }

  FlutterError.onError = (details) {};

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool isComplete = false;
  Timer? _timer;

  @override
  void initState() {
    super.initState();

    _timer = Timer(
      const Duration(seconds: 3),
      () {
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
    return AspectRatio(
      aspectRatio: 9 / 16,
      child: MaterialApp(
        home: AnimatedDefaultTextStyle(
          duration: Durations.extralong4,
          style: TextStyle(
            fontSize: isComplete ? 36 : 48,
            color: isComplete ? Colors.pinkAccent : Colors.white,
          ),
          child: const HomePage(),
        ),
      ),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: TelegramWebApp.instance.backgroundColor,
        extendBody: true,
        body: Placeholder(
          child: Align(
            alignment: Alignment.bottomCenter,
            child: ColoredBox(
              color: TelegramWebApp.instance.headerColor ?? Colors.red,
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
        ));
  }
}
