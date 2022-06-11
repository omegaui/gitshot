
// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, invalid_use_of_protected_member


import 'package:flutter/material.dart';
import 'package:gitshot/main.dart';
import 'package:gitshot/utils/information_provider.dart';
import 'package:gitshot/views/welcome_view.dart';

class UserTokenInputView extends StatelessWidget{

  final TextEditingController tokenTextEditingController = TextEditingController();

  UserTokenInputView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Row(
            children: [
              SizedBox(width: 5),
              Material(
                child: IconButton(
                  onPressed: () {
                    welcomeViewKey.currentState?.setState(() => {
                      welcomeViewKey.currentState?.viewState = VIEW_STATE_WELCOME
                    });
                  },
                  color: Colors.grey.shade900,
                  icon: Icon(Icons.arrow_back_ios_rounded),
                  iconSize: 20,
                  splashRadius: 20,
                ),
              ),
            ],
          ),
          SizedBox(
            height: 40,
            child: TextField(
              controller: tokenTextEditingController,
              textAlign: TextAlign.center,
              cursorColor: Colors.green,
              obscureText: true,
              decoration: InputDecoration(
                border: OutlineInputBorder(borderSide: BorderSide(color: Colors.transparent, width: 2), borderRadius: BorderRadius.circular(10)),
                enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.transparent, width: 2), borderRadius: BorderRadius.circular(10)),
                focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.transparent, width: 2), borderRadius: BorderRadius.circular(10)),
                hintText: "paste your token here",
                hintStyle: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          SizedBox(
            width: 40,
            child: TextButton(
              onPressed: () {
                String token = tokenTextEditingController.text;
                if(token.isEmpty){
                  messagePaneKey.currentState?.setState(() {
                    messagePaneKey.currentState?.text = "Token can't be empty!";
                  });
                  return;
                }
                loginViaToken(token);
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.network('https://img.icons8.com/color-glass/24/undefined/circled-chevron-right.png'),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

}

class UserCredentialsInputView extends StatelessWidget {

  UserCredentialsInputView({Key? key}) : super(key: key);

  final TextEditingController usernameTextEditingController = TextEditingController();
  final TextEditingController passwordTextEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Row(
            children: [
              SizedBox(width: 5),
              Material(
                child: IconButton(
                  onPressed: () {
                    welcomeViewKey.currentState?.setState(() => {
                      welcomeViewKey.currentState?.viewState = VIEW_STATE_WELCOME
                    });
                  },
                  color: Colors.grey.shade900,
                  icon: Icon(Icons.arrow_back_ios_rounded),
                  iconSize: 20,
                  splashRadius: 20,
                ),
              ),
            ],
          ),
          SizedBox(
            height: 40,
            child: TextField(
              controller: usernameTextEditingController,
              textAlign: TextAlign.center,
              cursorColor: Colors.green,
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
              decoration: InputDecoration(
                border: OutlineInputBorder(borderSide: BorderSide(color: Colors.transparent, width: 2), borderRadius: BorderRadius.circular(10)),
                enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.transparent, width: 2), borderRadius: BorderRadius.circular(10)),
                focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.transparent, width: 2), borderRadius: BorderRadius.circular(10)),
                hintText: "username",
                hintStyle: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          SizedBox(height: 5),
          SizedBox(
            height: 40,
            child: TextField(
              controller: passwordTextEditingController,
              obscureText: true,
              textAlign: TextAlign.center,
              cursorColor: Colors.green,
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
              decoration: InputDecoration(
                border: OutlineInputBorder(borderSide: BorderSide(color: Colors.transparent, width: 2), borderRadius: BorderRadius.circular(10)),
                enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.transparent, width: 2), borderRadius: BorderRadius.circular(10)),
                focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.transparent, width: 2), borderRadius: BorderRadius.circular(10)),
                hintText: "password",
                hintStyle: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          SizedBox(
            width: 40,
            child: TextButton(
              onPressed: () {
                String username = usernameTextEditingController.text;
                String password = passwordTextEditingController.text;
                if(username.isEmpty){
                  messagePaneKey.currentState?.setState(() {
                    messagePaneKey.currentState?.text = "Username can't be empty!";
                  });
                  return;
                }
                loginViaUsernameAndPassword(username, password);
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.network('https://img.icons8.com/color-glass/24/undefined/circled-chevron-right.png'),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class LoginButton extends StatefulWidget{

  final String buttonLabel;
  final String iconUrl;
  final VoidCallback clickAction;

  const LoginButton({Key? key, required this.buttonLabel, required this.iconUrl, required this.clickAction}) : super(key: key);

  @override
  State<StatefulWidget> createState() => LoginButtonState();

}

class LoginButtonState extends State<LoginButton>{

  dynamic buttonLabel;
  dynamic iconUrl;
  dynamic clickAction;

  void resetState(){
    buttonLabel = widget.buttonLabel;
    iconUrl = widget.iconUrl;
    clickAction = widget.clickAction;
  }

  @override
  @protected
  @mustCallSuper
  void initState(){
    super.initState();
    if(buttonLabel == null){
      resetState();
    }
  }

  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: TextButton.styleFrom(
        primary: Colors.grey.shade900,
        backgroundColor: Colors.white,
      ),
      onPressed: clickAction,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.network(iconUrl),
          SizedBox(width: 10),
          Text(
            buttonLabel,
            style: TextStyle(
              fontFamily: "UbuntuMono",
            ),
          ),
        ],
      ),
    );
  }
}

class MessagePane extends StatefulWidget {

  final String text;

  const MessagePane({Key? key, required this.text}) : super(key: key);

  @override
  State<StatefulWidget> createState() => MessagePaneState();

}

class MessagePaneState extends State<MessagePane>{

  dynamic text;

  @override
  @protected
  @mustCallSuper
  void initState(){
    super.initState();
    text ??= widget.text;
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        fontWeight: FontWeight.bold,
      ),
    );
  }

  void setText(String text){
    setState(() => {
      this.text = text
    });
  }

}

void loginViaUsernameAndPassword(String username, String password){
  messagePaneKey.currentState?.setText("Authenticating ...");
  if(loginWithUsernameAndPassword(username, password)){
    initUser().then((completed) {
      if(completed){
        messagePaneKey.currentState?.setText("Hello ${user?.name}!");
        welcomeViewKey.currentState?.setState(() {
          welcomeViewKey.currentState?.enterDashboardButtonVisible = true;
        });
      }
      else{
        messagePaneKey.currentState?.setText("Login Failed! Please prefer using your OAuth Token for logging in.");
      }
    });
  }
  else{
    messagePaneKey.currentState?.setText("Unable to Authenticate with GitHub!");
  }
}

void loginViaToken(String token){
  messagePaneKey.currentState?.setText("Authenticating ...");
  if(loginWithToken(token)){
    initUser().then((completed) {
      if(completed){
        messagePaneKey.currentState?.setText("Hello ${user?.name}!");
        welcomeViewKey.currentState?.setState(() {
          welcomeViewKey.currentState?.enterDashboardButtonVisible = true;
        });
      }
      else{
        messagePaneKey.currentState?.setText("Login Failed!");
      }
    });
  }
  else{
    messagePaneKey.currentState?.setText("Unable to Authenticate with GitHub!");
  }
}
