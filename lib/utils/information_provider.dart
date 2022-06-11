

import 'dart:async';

import 'package:github/github.dart';

late GitHub client;
CurrentUser? user;

int totalStarsEarned = 0;

List<Repository> topThreeRepos = [];
List<Repository> otherRepos = [];
List<Repository> allRepos = [];
List<Repository> latestThreeRepos = [];

List<Notification> allNotifications = [];
List<Notification> unreadNotifications = [];
List<Notification> readNotifications = [];
List<Notification> participatingNotifications = [];

Future<void> computeValues() async {
  topThreeRepos.clear();
  otherRepos.clear();
  allRepos.clear();
  latestThreeRepos.clear();
  allNotifications.clear();
  unreadNotifications.clear();
  readNotifications.clear();
  participatingNotifications.clear();
  // Counting total stars earned
  totalStarsEarned = 0;
  allRepos = await client.repositories.listUserRepositories(user?.login as String).toList();
  allRepos.every((element) {
    totalStarsEarned += element.stargazersCount;
    return true;
  });

  // Getting top three repos
  allRepos.sort((a, b) {
    return b.stargazersCount - a.stargazersCount;
  });

  for(int i = 0; i < 3 && i < allRepos.length; i++){
    topThreeRepos.add(allRepos.elementAt(i));
  }

  //Getting latest created three repos

  allRepos.sort((a, b) {
    return (b.createdAt as DateTime).compareTo(a.createdAt as DateTime);
  });

  for(int i = 0; i < 3 && i < allRepos.length; i++){
    latestThreeRepos.add(allRepos.elementAt(i));
  }

  // Adding Other repos
  allRepos.sort((a, b) {
    return b.stargazersCount - a.stargazersCount;
  });

  for(int i = 3; i < allRepos.length; i++){
    otherRepos.add(allRepos.elementAt(i));
  }

  // Getting organisations
  allNotifications = await client.activity.listNotifications(all: true).toList();
  participatingNotifications = await client.activity.listNotifications(participating: true).toList();
  for(Notification notification in allNotifications){
    if(notification.unread!) {
      unreadNotifications.add(notification);
    }
    else {
      readNotifications.add(notification);
    }
  }
}

bool loginFromEnvironment(){
  client = GitHub(auth: findAuthenticationFromEnvironment());
  return isAuthenticationCompleted();
}

bool loginWithUsernameAndPassword(String username, String password){
  client = GitHub(auth: Authentication.basic(username, password));
  return isAuthenticationCompleted();
}

bool loginWithToken(String token){
  client = GitHub(auth: Authentication.withToken(token));
  return isAuthenticationCompleted();
}

Future<bool> initUser() async {
  Future<CurrentUser> futureUser = client.users.getCurrentUser();
  futureUser.then((value) => user = value);
  if(user != null) {
    await computeValues();
  }
  else {
    client.auth = null;
  }
  return user != null;
}

bool isAuthenticationCompleted(){
  return client.auth != null;
}
