import 'package:alan_voice/alan_voice.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:music_ai/neubox.dart';
import 'package:velocity_x/velocity_x.dart';

class Homepage extends StatefulWidget {
  const Homepage({Key? key}) : super(key: key);

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  bool isplaying = false;
  double value = 0;
  bool dark = false;
  final player = AudioPlayer();
  Duration? duration = Duration(seconds: 0);

  void initplayer() async {
    await player.setSource(AssetSource('song.mp3'));
    duration = await player.getDuration();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initplayer();
    setUpAlan();
  }

  void setUpAlan() {
    AlanVoice.addButton(
        "e14bac753c880a2161b028098d8a1d642e956eca572e1d8b807a3e2338fdd0dc/stage",
        buttonAlign: AlanVoice.BUTTON_ALIGN_LEFT);
    AlanVoice.callbacks.add((command) => handleCommand(command.data));
  }

  playMusic() async {
    if (isplaying) {
      await player.pause();
      setState(() {
        isplaying = false;
      });
    } else {
      await player.resume();
      setState(() {
        isplaying = true;
      });

      player.onPositionChanged.listen(
        (position) {
          setState(() {
            value = position.inSeconds.toDouble();
          });
        },
      );
      setState(() async {
        duration = await player.getDuration();
      });
    }
  }

  handleCommand(Map<String, dynamic> response) {
    switch (response["command"]) {
      case "play":
        playMusic();

        break;
      default:
    }
  }

  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor:
            dark ? Color.fromARGB(255, 53, 53, 53) : Colors.grey[300],
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        height: 60,
                        width: 60,
                        child: NeuBox(
                          child: Icon(Icons.menu),
                          isDark: dark,
                        ),
                      ),
                      "J U S T   S A Y ".text.xl2.bold.make().shimmer(
                          primaryColor: Color.fromARGB(255, 77, 76, 76)),
                      InkWell(
                        onTap: () {
                          if (dark) {
                            setState(() {
                              dark = false;
                            });
                          } else {
                            dark = true;
                          }
                        },
                        child: SizedBox(
                          height: 60,
                          width: 60,
                          child: NeuBox(
                              isDark: dark,
                              child: Icon(
                                  dark ? Icons.dark_mode : Icons.light_mode)),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 50,
                ),
                SizedBox(
                    width: 350,
                    child: NeuBox(
                        isDark: dark,
                        child: Column(
                          children: [
                            ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: Image.asset("assets/cover.jpg")),
                            SizedBox(
                              height: 10,
                            ),
                            Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      "SUZUME NO TOJIMARI "
                                          .text
                                          .xl
                                          .extraBlack
                                          .make(),
                                      "Tazzy".text.make()
                                    ],
                                  ),
                                  Icon(
                                    Icons.favorite,
                                    color: Colors.red,
                                  )
                                ],
                              ),
                            )
                          ],
                        ))),
                SizedBox(height: 20),
                NeuBox(
                  isDark: dark,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Text("${(value / 60).floor()}:${(value % 60).floor()}"),
                      Slider.adaptive(
                          onChanged: (v) {
                            setState(() {
                              value = v;
                            });
                          },
                          min: 0.0,
                          max: duration!.inSeconds.toDouble(),
                          value: value,
                          onChangeEnd: (newValue) async {
                            setState(() {
                              value = newValue;
                              print(newValue);
                            });
                            player.pause();
                            await player
                                .seek(Duration(seconds: newValue.toInt()));
                            await player.resume();
                          }),
                      Text(
                          "${duration!.inMinutes} : ${duration!.inSeconds % 60}"),
                    ],
                  ),
                ),
                SizedBox(height: 20),
                InkWell(
                  onTap: () async {
                    if (isplaying) {
                      await player.pause();
                      setState(() {
                        isplaying = false;
                      });
                    } else {
                      await player.resume();
                      setState(() {
                        isplaying = true;
                      });

                      player.onPositionChanged.listen(
                        (position) {
                          setState(() {
                            value = position.inSeconds.toDouble();
                          });
                        },
                      );
                      setState(() async {
                        duration = await player.getDuration();
                      });
                    }
                  },
                  child: NeuBox(
                    isDark: dark,
                    child: Icon(
                      isplaying ? Icons.pause : Icons.play_arrow,
                    ),
                  ),
                )
              ],
            ),
          ),
        ));
  }
}
