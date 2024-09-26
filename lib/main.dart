import 'package:better_player/better_player.dart';
import 'package:flutter/material.dart';
import 'package:testvideo/custom_player_control.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Better Player Custom Theme',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueAccent),
        useMaterial3: true,
      ),
      home: const BetterPlayerPage(title: 'Better Player Custom Theme'),
    );
  }
}

class BetterPlayerPage extends StatefulWidget {
  const BetterPlayerPage({super.key, required this.title});
  final String title;

  @override
  State<BetterPlayerPage> createState() => _BetterPlayerPageState();
}

class _BetterPlayerPageState extends State<BetterPlayerPage> {
  late BetterPlayerController _videoController;

  @override
  void initState() {
    super.initState();
    GlobalKey _betterPlayerKey = GlobalKey();
    _videoController = BetterPlayerController(
      BetterPlayerConfiguration(
          autoDispose: true,
          controlsConfiguration: BetterPlayerControlsConfiguration(
            controlsHideTime: const Duration(seconds: 1),
            playerTheme: BetterPlayerTheme.custom,
            customControlsBuilder:
                (videoController, onPlayerVisibilityChanged) =>
                CustomPlayerControl(controller: videoController , videoKey: _betterPlayerKey,),
          ),
          aspectRatio: 16 / 9,
          looping: true,
          autoPlay: true),
      betterPlayerDataSource: BetterPlayerDataSource(
          BetterPlayerDataSourceType.network,
          'https://flutter.github.io/assets-for-api-docs/assets/videos/butterfly.mp4'),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: AspectRatio(
          aspectRatio: 16 / 9,
          child: BetterPlayer(controller: _videoController),
        ),
      ),
    );
  }
}