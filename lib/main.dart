import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:vibration/vibration.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

void main() {
  runApp(MyCounterApp());
}

class MyCounterApp extends StatefulWidget {
  @override
  _MyCounterAppState createState() => _MyCounterAppState();
}

class _MyCounterAppState extends State<MyCounterApp> {
  int counter = 0;
  double factor = 1;
  final player = AudioPlayer();
  late YoutubePlayerController _ytController;

  @override
  void initState() {
    super.initState();

    _ytController = YoutubePlayerController(
      initialVideoId: "dQw4w9WgXcQ",
      flags: const YoutubePlayerFlags(
        autoPlay: false,
        mute: false,
      ),
    );
  }

  void incrementCounter() async {
    setState(() {
      counter++;
    });

    // صوت
    await player.play(AssetSource("click.mp3"));

    // اهتزاز
    if (await Vibration.hasVibrator() ?? false) {
      Vibration.vibrate(duration: 100);
    }
  }

  @override
  Widget build(BuildContext context) {
    double result = (counter * factor) / 24;

    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text("My Counter App"),
          actions: [
            IconButton(
              icon: Icon(Icons.settings),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (_) => AlertDialog(
                    title: Text("Change Factor"),
                    content: TextField(
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(labelText: "Enter Factor"),
                      onChanged: (value) {
                        factor = double.tryParse(value) ?? 1;
                        setState(() {});
                      },
                    ),
                    actions: [
                      TextButton(
                        child: Text("Close"),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ],
                  ),
                );
              },
            )
          ],
        ),

        body: GestureDetector(
          onTap: incrementCounter,
          child: Container(
            color: Colors.black12,
            width: double.infinity,
            height: double.infinity,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Counter: $counter",
                    style: TextStyle(fontSize: 32)),
                SizedBox(height: 10),
                Text("Result: ${result.toStringAsFixed(2)}",
                    style: TextStyle(fontSize: 28, color: Colors.blue)),
                SizedBox(height: 40),
                ElevatedButton(
                  child: Text("Open YouTube Window"),
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (_) => YoutubePlayerBuilder(
                        player: YoutubePlayer(controller: _ytController),
                        builder: (_, __) => AlertDialog(
                          content: Container(
                            width: 300,
                            height: 200,
                            child: YoutubePlayer(controller: _ytController),
                          ),
                        ),
                      ),
                    );
                  },
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

