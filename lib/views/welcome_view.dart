// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, constant_identifier_names

import 'package:flutter/material.dart';
import 'package:gitshot/components/logins.dart';
import 'package:gitshot/utils/information_provider.dart';
import 'package:gitshot/views/dashboard.dart';

final GlobalKey<LoginButtonState> loginFromEnvironmentButtonKey = GlobalKey();
final GlobalKey<LoginButtonState> loginWithUsernameAndPasswordButtonKey = GlobalKey();
final GlobalKey<LoginButtonState> loginWithTokenButtonKey = GlobalKey();
final GlobalKey<MessagePaneState> messagePaneKey = GlobalKey();

const VIEW_STATE_WELCOME = 0;
const VIEW_STATE_USER_CREDENTIALS_INPUT = 1;
const VIEW_STATE_USER_TOKEN_INPUT = 2;

bool autoTriggeredLogin = false;

class WelcomeView extends StatefulWidget{
  const WelcomeView({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => WelcomeViewState();

}

class WelcomeViewState extends State<WelcomeView>{

  int viewState = VIEW_STATE_WELCOME;
  bool enterDashboardButtonVisible = false;

  @override
  @mustCallSuper
  @protected
  void initState(){
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      if(!autoTriggeredLogin) {
        autoTriggeredLogin = true;
        tryEnteringDashboard();
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.network("https://img.icons8.com/fluency/240/undefined/github.png"),
        Text(
          "GitHub Overviewer",
          style: TextStyle(
            color: Colors.grey.shade900,
            fontFamily: "JetBrainsMono",
            fontSize: 32,
          ),
        ),
        SizedBox(height: 10),
        Text(
          "Have a quick peek of your github account",
          style: TextStyle(
            color: Colors.black,
            fontFamily: "JetBrainsMono",
          ),
        ),
        SizedBox(height: 10),
        Text(
          "Prefer logging in through OAuth Tokens",
          style: TextStyle(
            color: Colors.black,
            fontSize: 12,
            fontFamily: "JetBrainsMono",
          ),
        ),
        SizedBox(height: 50),
        Container(
          width: 300,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                blurRadius: 4,
                spreadRadius: 4,
              ),
            ],
          ),
          child: getView(),
        ),
        SizedBox(height: 10),
        MessagePane(key: messagePaneKey, text: "Login to continue"),
        SizedBox(height: 20),
        Visibility(
          visible: enterDashboardButtonVisible,
          child: TextButton(
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => Dashboard()));
            },
            child: Text(
                "Enter Dashboard",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
            ),
          ),
        ),
      ],
    );
  }

  void tryEnteringDashboard(){
    messagePaneKey.currentState?.setText("Trying to login from your system environment ...");
    if(loginFromEnvironment()){
      initUser().then((completed) {
        if(completed){
          messagePaneKey.currentState?.setText("Hello ${user?.name}!");
          setState(() {
            enterDashboardButtonVisible = true;
          });

          Navigator.push(context, MaterialPageRoute(builder: (builder) => Dashboard()));
        }
        else{
          messagePaneKey.currentState?.setText("Automatic Login Failed! No login information present in your environment.");
        }
      });
    }
    else{
      messagePaneKey.currentState?.setText("Unable to Authenticate with GitHub!");
    }
  }

  void performAutoLogin(){
    messagePaneKey.currentState?.setText("Trying to login from your system environment ...");
    if(loginFromEnvironment()){
      initUser().then((completed) {
        if(completed){
          messagePaneKey.currentState?.setText("Hello ${user?.name}!");
          setState(() {
            enterDashboardButtonVisible = true;
          });
        }
        else{
          messagePaneKey.currentState?.setText("Automatic Login Failed! No login information present in your environment.");
        }
      });
    }
    else{
      messagePaneKey.currentState?.setText("Unable to Authenticate with GitHub!");
    }
  }

  Widget _buildBasicView(){
    return Center(
      child: Column(
        children: [
          LoginButton(
            key: loginFromEnvironmentButtonKey,
            buttonLabel: "Login (Auto)",
            iconUrl: "https://img.icons8.com/fluency/24/undefined/username.png",
            clickAction: () {
              performAutoLogin();
            },
          ),
          LoginButton(
            key: loginWithUsernameAndPasswordButtonKey,
            buttonLabel: "Login (Username & Password)",
            iconUrl: "https://img.icons8.com/fluency/24/undefined/lock.png",
            clickAction: () {
              setState(() => {
                viewState = VIEW_STATE_USER_CREDENTIALS_INPUT
              });
            },
          ),
          LoginButton(
            key: loginWithTokenButtonKey,
            buttonLabel: "Login (OAuth Token)",
            iconUrl: "https://img.icons8.com/external-flat-wichaiwi/24/undefined/external-token-gamefi-flat-wichaiwi.png",
            clickAction: () {
              setState(() => {
                viewState = VIEW_STATE_USER_TOKEN_INPUT
              });
            },
          ),
        ],
      ),
    );
  }

  Widget getView(){
    switch(viewState){
      case 0:
          return _buildBasicView();
      case 1:
          return UserCredentialsInputView();
      case 2:
          return UserTokenInputView();
    }
    // Unreachable forever
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Text(
          "Preparing UI ...",
        ),
      ),
    );
  }
}

