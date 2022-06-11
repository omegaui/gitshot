// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:gitshot/views/welcome_view.dart';

final GlobalKey<WelcomeViewState> welcomeViewKey = GlobalKey();

final gradient = LinearGradient(colors: const [Colors.grey, Colors.white, Colors.grey], stops: const [0, 0.5, 1]);

void main() {
  runApp(App());
}

class App extends StatelessWidget{
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: ContentPane(),
    );
  }
}

class ContentPane extends StatelessWidget{
  const ContentPane({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: LayoutBuilder(
        builder: (context, constraints) {
          return Center(
            child: WelcomeView(key: welcomeViewKey),
          );
        },
      ),
    );
  }
}

class NoNetworkView extends StatelessWidget {
  const NoNetworkView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ShaderMask(
            blendMode: BlendMode.srcIn,
            shaderCallback: (bounds)=> gradient.createShader(Rect.fromLTWH(0, 0, bounds.width, bounds.height)),
            child: Text(
              "No Network",
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

}

