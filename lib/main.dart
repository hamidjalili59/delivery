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
                    TelegramWebApp.instance.initData.user.username ?? 'NULL AST',
                  ),
                ],
              ),
            ),
          ),
        ));
  }
}
