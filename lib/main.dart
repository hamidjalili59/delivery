import 'dart:async';

import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:telegram_web_app/telegram_web_app.dart';

const _musicLink = 'https://hamid.storage.iran.liara.space/music.mp3';

void main() async {
  try {
    if (TelegramWebApp.instance.isSupported) {
      await TelegramWebApp.instance.ready();
      await TelegramWebApp.instance.enableClosingConfirmation();
      // await TelegramWebApp.instance.expand();
      // await TelegramWebApp.instance.backButton.show();
      // await TelegramWebApp.instance.mainButton.show();
      // await TelegramWebApp.instance.settingButton.show();
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
    return const MaterialApp(home: HomePage());
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool isComplete = false;
  bool isLoading = false;
  Timer? _timer;
  bool isPause = false;

  final player = AudioPlayer();

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
    // TelegramWebApp.instance.mainButton.onClick(
    //   () async => await player.play(),
    // );
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
      backgroundColor:
          TelegramWebApp.instance.colorScheme == TelegramColorScheme.light
              ? Colors.white
              : Colors.blueGrey,
      extendBody: true,
      body: AnimatedDefaultTextStyle(
        duration: Durations.medium2,
        curve: Curves.elasticInOut,
        style: TextStyle(
          fontSize: isComplete ? 28 : 48,
          color: isComplete ? Colors.purpleAccent : Colors.green,
          fontWeight: isComplete ? FontWeight.w400 : FontWeight.w900,
        ),
        child: SizedBox(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              InkWell(
                onTap: () async {
                  if (isLoading) return;
                  if (!player.playing && !isPause) {
                    setState(() {
                      isLoading = true;
                    });
                    await player.setUrl(_musicLink);
                    player.play();
                    setState(() {
                      isLoading = false;
                    });
                  } else {
                    if (isPause) {
                      await player.play();
                    } else {
                      await player.pause();
                    }
                  }
                },
                child: isLoading
                    ? const CircularProgressIndicator()
                    : Text(player.playing
                        ? isPause
                            ? 'Pause'
                            : 'Playing'
                        : 'Stop'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
