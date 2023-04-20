import 'dart:io';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
// import 'package:flutter/material.dart';
import 'package:media_kit/media_kit.dart';
import 'package:media_kit_video/media_kit_video.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  MediaKit.ensureInitialized();
  runApp(const QRaffleApp());
}

class QRaffleApp extends StatelessWidget {
  const QRaffleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const CupertinoApp(
      theme: CupertinoThemeData(
        brightness: Brightness.dark,
        primaryColor: CupertinoColors.darkBackgroundGray,
        barBackgroundColor: CupertinoColors.darkBackgroundGray,
        scaffoldBackgroundColor: CupertinoColors.darkBackgroundGray,
        textTheme: CupertinoTextThemeData(
          primaryColor: CupertinoColors.white,
          textStyle: TextStyle(color: CupertinoColors.white),
        ),
      ),
      home: QRaffleMenu(),
    );
  }
}

class  QRaffleMenu extends StatefulWidget {
  const QRaffleMenu({super.key});

  @override
  State<QRaffleMenu> createState() => _QRaffleMenuState();
}

class _QRaffleMenuState extends State<QRaffleMenu> {
  List<String> _raffleParticipants = [];
  final TextEditingController _raffleParticipantsController = TextEditingController();
  List<String> _raffleWinners = [];
  final Player player = Player();
  VideoController? controller;
  final List<String> assetNames = [
    'Albedo',
    'Alhaitham',
    'Amos\' Bow',
    'Aquila Favonia',
    'Arataki Itto',
    'Cyno',
    'Dehya',
    'Diluc',
    'Eula',
    'Ganyu',
    'Hu Tao',
    'Jean',
    'Kaedehara Kazuha',
    'Kamisato Ayaka',
    'Kamisato Ayato',
    'Keqing',
    'Klee',
    'Lost Prayer to the Sacred Winds',
    'Mona',
    'Nahida',
    'Nilou',
    'Primordial Jade Winged-Spear',
    'Qiqi',
    'Raiden Shogun',
    'Sangonomiya Kokomi',
    'Shenhe',
    'Skyward Atlas',
    'Skyward Blade',
    'Skyward Harp',
    'Tartaglia',
    'Tighnari',
    'Venti',
    'Wanderer',
    'Xiao',
    'Yae Miko',
    'Yelan',
    'Yoimiya',
    'Zhongli',
  ];
  bool _pullButtonEnabled = true;
  bool _backgroundVisible = true;

  @override
  void initState() {
    super.initState();
    Future.microtask(() async  {
      controller = await VideoController.create(player);
      setState(() {});
    });
  }

  @override
  void dispose() {
    Future.microtask(() async {
      await controller?.dispose();
      await player.dispose();
    });
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoTabScaffold(
      tabBar: CupertinoTabBar(
        activeColor: CupertinoColors.systemIndigo,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.house_fill),
            label: 'Load',
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.tickets_fill),
            label: 'Draw',
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.list_bullet),
            label: 'History',
          ),
        ],
      ),
      tabBuilder: (BuildContext context, int index) {
        return CupertinoTabView(
          builder: (BuildContext context) {
            return [
              CupertinoPageScaffold(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'qRaffle',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 35,
                        ),
                      ),
                      Text(
                        'by UNSW Gensoc',
                        style: TextStyle(
                          fontStyle: FontStyle.italic,
                          color: CupertinoColors.white.withOpacity(0.6),
                        ),
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      CupertinoButton(
                        color: CupertinoColors.systemIndigo,
                        onPressed: () {
                          _raffleParticipantsController.text = _raffleParticipants.join('\n');
                          showCupertinoModalPopup(
                            barrierDismissible: false,
                            context: context,
                            builder: (BuildContext context) {
                              return CupertinoAlertDialog(
                                title: const Text('Edit participants'),
                                content: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Text("Separate participants by starting a new line.\n"),
                                    CupertinoTextField(
                                      minLines: 10,
                                      maxLines: 15,
                                      keyboardType: TextInputType.multiline,
                                      cursorColor: CupertinoColors.systemIndigo,
                                      placeholder: "John Lee\nPlateTao\njordan\n...",
                                      decoration: const BoxDecoration(
                                        color: CupertinoColors.quaternaryLabel,
                                      ),
                                      controller: _raffleParticipantsController,
                                    ),
                                  ],
                                ),
                                actions: [
                                  CupertinoDialogAction(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child: const Text(
                                      "Cancel",
                                      style: TextStyle(
                                        color: CupertinoColors.destructiveRed
                                      ),
                                    ),
                                  ),
                                  CupertinoDialogAction(
                                    isDefaultAction: true,
                                    onPressed: () {
                                       List<String> participants = _raffleParticipantsController.text.isEmpty ? [] : _raffleParticipantsController.text.split('\n');
                                       for (int i = 0; participants.length > i; i++) {
                                         if (participants[i].trim().isEmpty) {
                                           participants.remove(participants[i]);
                                         } else {
                                           participants[i] = participants[i].trim();
                                         }
                                       }
                                       setState(() {
                                         _raffleParticipants = participants;
                                       });
                                      Navigator.pop(context);
                                    },
                                    child: const Text(
                                      "Save",
                                      style: TextStyle(
                                        color: CupertinoColors.systemIndigo
                                      ),
                                    ),
                                  ),
                                ],
                              );
                            },
                          );
                        },
                        child: const Text(
                          'Edit participants',
                          style: TextStyle(
                            color: CupertinoColors.white,
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Text(
                        'Loaded ${_raffleParticipants.length} participants.',
                        style: TextStyle(
                          fontSize: 15,
                          color: CupertinoColors.white.withOpacity(0.5),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Center(
                child: Stack(
                  children: [
                    Positioned(
                      child: Video(controller: controller),
                    ),
                    Visibility(
                      visible: _backgroundVisible,
                      child: Align(
                        alignment: Alignment.center,
                        child: Image.file(File('assets/Barbara.jpg')),
                      ),
                    ),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: CupertinoButton(
                          color: CupertinoColors.systemIndigo,
                          onPressed: !_pullButtonEnabled ? null :  () async {
                            setState(() {
                              _pullButtonEnabled = false;
                              _backgroundVisible = false;
                            });
                            player.open(Media('asset:///assets/${assetNames[Random().nextInt(assetNames.length)]}.mp4'));
                            await Future.delayed(const Duration(milliseconds: 8100));
                            String winner = '';
                            if (_raffleParticipants.isNotEmpty) {
                              winner = _raffleParticipants[Random().nextInt(_raffleParticipants.length)];
                              _raffleWinners.add(winner);
                            }
                            await player.pause();
                            if (context.mounted) {
                              await showCupertinoModalPopup(
                                barrierDismissible: false,
                                context: context,
                                builder: (BuildContext context) {
                                  return CupertinoAlertDialog(
                                    title: Text(_raffleParticipants.isEmpty ? 'Nobody won' : 'Winner'),
                                    content: Text(
                                      _raffleParticipants.isEmpty ? 'There are 0 participants' : winner,
                                      textScaleFactor: 1.5,
                                    ),
                                    actions: [
                                      CupertinoDialogAction(
                                        isDefaultAction: true,
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        child: const Text(
                                          "Ok",
                                          style: TextStyle(
                                              color: CupertinoColors.systemIndigo
                                          ),
                                        ),
                                      ),
                                    ],
                                  );
                                },
                              );
                            }
                            await player.play();
                            await Future.delayed(const Duration(milliseconds: 2500));
                            player.pause();
                            setState(() {
                              _pullButtonEnabled = true;
                            });
                          },
                          child: const Text('Draw (✿◡‿◡)',
                            style: TextStyle(
                              color: CupertinoColors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Center(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(50.0, 10.0, 50.0, 10.0),
                  child: CupertinoTextField(
                    readOnly: true,
                    minLines: 10,
                    maxLines: 15,
                    keyboardType: TextInputType.multiline,
                    placeholder: "History is empty...",
                    decoration: const BoxDecoration(
                      color: CupertinoColors.quaternaryLabel,
                    ),
                    controller: TextEditingController(text: _raffleWinners.isEmpty ? '' : _raffleWinners.join('\n')),
                  ),
                ),
              ),
            ][index];
          }
        );
      },
    );
  }
}