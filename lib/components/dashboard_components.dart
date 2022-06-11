// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gitshot/utils/information_provider.dart';
import 'package:gitshot/views/dashboard.dart';
import 'package:percent_indicator/percent_indicator.dart';


import 'package:github/github.dart' as github;

final starImage = Image.network("https://img.icons8.com/stickers/50/undefined/star.png").image;
final issuesImage = Image.network("https://img.icons8.com/stickers/50/undefined/error.png").image;
final forkImage = Image.network("https://img.icons8.com/stickers/50/undefined/code-fork.png").image;
final watchersImage = Image.network("https://img.icons8.com/stickers/50/undefined/uchiha-eyes.png").image;
final diskImage = Image.network("https://img.icons8.com/stickers/50/undefined/cd.png").image;

class UserInfoWidget extends StatelessWidget{
  const UserInfoWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(30),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Image.network(
            "https://img.icons8.com/color/45/undefined/github--v1.png",
          ),
          Text(
            user?.name as String,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          CircleAvatar(
            radius: 25,
            backgroundColor: Colors.grey.withOpacity(0.5),
            child: ClipOval(
              child: SizedBox(
                width: 45,
                child: Image.network(user?.avatarUrl as String),
              ),
            ),
          )
        ],
      ),
    );
  }

}

class UserBioInfoWidget extends StatelessWidget{
  final bioGradient = LinearGradient(colors: [Colors.black, Colors.grey.shade800]);
  
  UserBioInfoWidget({Key? key}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return Center(
      child: ShaderMask(
        blendMode: BlendMode.srcIn,
        shaderCallback: (bounds) => bioGradient.createShader(bounds),
        child: Text(
          user?.bio as String,
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      )
    );
  }

}

class UserInteractivityInfoWidget extends StatelessWidget{

  final BoxConstraints constraints;

  const UserInteractivityInfoWidget({Key? key, required this.constraints}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(30),
      child: Column(
        children: [
          Row(
            children: [
              Text(
                "Quick Snapshot",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          SizedBox(height: 10),
          IntrinsicHeight(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Image.network("https://img.icons8.com/external-filled-outline-geotatah/32/undefined/external-best-friend-best-friend-forever-filled-outline-filled-outline-geotatah-13.png"),
                        SizedBox(width: 10),
                        Text(
                          "Followers",
                          style: TextStyle(
                            color: Colors.grey,
                            fontWeight: FontWeight.bold,
                            fontSize: 22,
                          ),
                        ),
                      ],
                    ),
                    Text(
                      "${user?.followersCount}",
                      style: TextStyle(
                        color: Colors.green,
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                  ],
                ),
                VerticalDivider(
                  color: Colors.grey.shade800,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          "Following",
                          style: TextStyle(
                            color: Colors.grey,
                            fontWeight: FontWeight.bold,
                            fontSize: 22,
                          ),
                        ),
                        SizedBox(width: 10),
                        Image.network("https://img.icons8.com/external-flaticons-flat-flat-icons/32/undefined/external-teacher-university-flaticons-flat-flat-icons-3.png"),
                      ],
                    ),
                    Text(
                      "${user?.followingCount}",
                      style: TextStyle(
                        color: Colors.pink,
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(height: 5),
          Divider(
            color: Colors.grey,
            indent: 10,
            thickness: 1,
          ),
          Image(image: starImage),
          Text(
            computeStarText(totalStarsEarned),
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 5),
          LinearPercentIndicator(
            animation: true,
            animationDuration: 1500,
            barRadius: Radius.circular(10),
            lineHeight: 6,
            percent: totalStarsEarned / computeNextLimit(totalStarsEarned),
            progressColor: Colors.red,
            backgroundColor: Colors.grey.withOpacity(0.3),
          ),
          SizedBox(height: 25),
          Row(
            children: [
              Image.network("https://img.icons8.com/arcade/50/undefined/experimental-marker-arcade.png"),
              SizedBox(width: 10),
              Text(
                "Lives in ${user?.location}",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w100,
                  fontFamily: "UbuntuMono",
                ),
              ),
            ],
          ),
          Row(
            children: [
              Image.network("https://img.icons8.com/external-photo3ideastudio-flat-photo3ideastudio/50/undefined/external-plan-digital-business-photo3ideastudio-flat-photo3ideastudio.png"),
              SizedBox(width: 10),
              Text(
                "Has ${user?.plan?.name?.toUpperCase()} GitHub plan",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w100,
                  fontFamily: "UbuntuMono",
                ),
              ),
            ],
          ),
          Row(
            children: [
              Image.network("https://img.icons8.com/external-flaticons-flat-flat-icons/50/undefined/external-disk-back-to-school-flaticons-flat-flat-icons.png"),
              SizedBox(width: 10),
              Text(
                "Disk Space Used ${formatBytes(user?.diskUsage as int, 0)}",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w100,
                  fontFamily: "UbuntuMono",
                ),
              ),
            ],
          ),
          Row(
            children: [
              Image.network("https://img.icons8.com/fluency/50/undefined/circled-envelope.png"),
              SizedBox(width: 10),
              Text(
                "Email ${user?.email}",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w100,
                  fontFamily: "UbuntuMono",
                ),
              ),
            ],
          ),
          SizedBox(height: 10),
          Row(
            children: [
              Text(
                "Recently Created Repos",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          SizedBox(
            child: SingleChildScrollView(
              primary: false,
              child: Column(
                children: latestThreeRepos.map((e) {
                  return RepoMiniViewWidget(repo: e, compactView: true);
                }).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class UserActionsWidget extends StatelessWidget{
  const UserActionsWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 30),
      child: SizedBox(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  "Actions",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            SizedBox(height: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Save Login Info",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(
                      width: 60,
                      child: FittedBox(
                        child: CupertinoSwitch(
                          value: true,
                          onChanged: (value) {

                          },
                        ),
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Auto-dive into the Dashboard",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(
                      width: 60,
                      child: FittedBox(
                        child: CupertinoSwitch(
                          value: true,
                          onChanged: (value) {

                          },
                        ),
                      ),
                    ),
                  ],
                ),
                CupertinoButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text(
                    "Log out",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

}

class DashboardMainViewWidget extends StatefulWidget{
  final BoxConstraints constraints;

  const DashboardMainViewWidget({Key? key, required this.constraints}) : super(key: key);

  @override
  State<DashboardMainViewWidget> createState() => DashboardMainViewWidgetState();
}

class DashboardMainViewWidgetState extends State<DashboardMainViewWidget> {

  int viewMode = 0;

  void switchViewToNotifications(){
    if(viewMode == 1) {
      return;
    }
    setState(() {
      viewMode = 1;
    });
  }

  void switchViewToRepositories(){
    if(viewMode == 0) {
      return;
    }
    setState(() {
      viewMode = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        DashboardTopPanelWidget(),
        getView(),
      ],
    );
  }

  Widget getView(){
    return viewMode == 0 ? RepositoriesViewWidget(constraints: widget.constraints) : NotificationsView(constraints: widget.constraints);
  }
}

class DashboardTopPanelWidget extends StatefulWidget {
  const DashboardTopPanelWidget({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => DashboardTopPanelWidgetState();

}

class DashboardTopPanelWidgetState extends State<DashboardTopPanelWidget>{

  String title = "Repositories";

  void setupRepoView(){
    setState(() {
      title = "Repositories";
      dashboardMainViewWidgetKey.currentState?.switchViewToRepositories();
    });
  }

  void setupNotificationsView(){
    setState(() {
      title = "Notifications";
      dashboardMainViewWidgetKey.currentState?.switchViewToNotifications();
    });
  }


  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: TextStyle(
            color: Colors.grey.shade700,
            fontSize: 40,
            fontFamily: "UbuntuMono",
            fontWeight: FontWeight.bold,
          ),
        ),
        Row(
          children: [
            Material(
              child: IconButton(
                splashRadius: 25,
                tooltip: "See Repositories",
                onPressed: () {
                  setupRepoView();
                },
                icon: Image.network("https://img.icons8.com/external-flat-icons-pause-08/64/undefined/external-and-management-flat-icons-pause-08.png"),
              ),
            ),
            Material(
              child: IconButton(
                splashRadius: 25,
                tooltip: "Show Notifications",
                onPressed: () {
                  setupNotificationsView();
                },
                icon: Image.network("https://img.icons8.com/external-sbts2018-outline-color-sbts2018/58/undefined/external-notification-ecommerce-basic-1-sbts2018-outline-color-sbts2018.png"),
              ),
            ),
          ],
        ),
      ],
    );
  }

}

class RepositoriesViewWidget extends StatelessWidget{
  final BoxConstraints constraints;

  const RepositoriesViewWidget({Key? key, required this.constraints}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Top Repos",
            style: TextStyle(
              color: Colors.grey.shade600,
              fontWeight: FontWeight.bold,
              fontSize: 22,
            ),
          ),
          SizedBox(
            height: 300,
            child: RotatedBox(
              quarterTurns: -1,
              child: ListWheelScrollView(
                itemExtent: 500,
                magnification: 2,
                children: topThreeRepos.map((repo)  {
                  return RotatedBox(
                    quarterTurns: 1,
                    child: RepoViewWidget(repo: repo),
                  );
                }).toList(),
              ),
            ),
          ),
          Text(
            "Other Repos",
            style: TextStyle(
              color: Colors.grey.shade600,
              fontWeight: FontWeight.bold,
              fontSize: 22,
            ),
          ),
          SizedBox(height: 25),
          SizedBox(
            width: constraints.maxWidth - 500,
            height: constraints.maxHeight - 540,
            child: SingleChildScrollView(
              primary: false,
              child: Column(
                children: otherRepos.map((e) {
                  return RepoMiniViewWidget(repo: e);
                }).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }

}

class RepoViewWidget extends StatelessWidget{

  final github.Repository repo;

  const RepoViewWidget({Key? key, required this.repo}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
          gradient: getGradient(repo.stargazersCount),
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.9),
              spreadRadius: 3,
              blurRadius: 3,
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image(
                image: starImage,
              ),
              Text(
                computeStarText(repo.stargazersCount),
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 10),
              SizedBox(
                width: 300,
                child: LinearPercentIndicator(
                  barRadius: Radius.circular(10),
                  lineHeight: 6,
                  percent: 0.7,
                  progressColor: Colors.white,
                  backgroundColor: Colors.grey.withOpacity(0.3),
                ),
              ),
              Text(
                repo.name,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Column(
                    children: [
                      Image(image: issuesImage),
                      Text(
                        "${repo.openIssuesCount}",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      Image(image: forkImage),
                      Text(
                        "${repo.forksCount}",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      Image(image: watchersImage),
                      Text(
                        "${repo.watchersCount}",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 5),
              Image(image: diskImage),
              Text(
                formatBytes(repo.size, 0),
                style: TextStyle(
                  color: Colors.white,
                  fontFamily: "UbuntuMono",
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

}

class RepoMiniViewWidget extends StatelessWidget{

  final github.Repository repo;

  final bool? compactView;

  const RepoMiniViewWidget({Key? key, required this.repo, this.compactView}) : super(key: key);

  Widget getDefaultView(){
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Image(
            image: starImage,
            width: 25,
            height: 25,
          ),
          SizedBox(width: 5),
          Text(
            "${repo.stargazersCount}",
            style: TextStyle(
              color: Colors.grey.shade700,
              fontFamily: "UbuntuMono",
            ),
          ),
          SizedBox(width: 5),
          SizedBox(width: 10),
          Text(
            repo.name,
            style: TextStyle(
              fontFamily: "UbuntuMono",
            ),
          ),
          SizedBox(width: 50),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.grey.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Image(image: issuesImage, width: 25, height: 25,),
                  Text(
                    "${repo.openIssuesCount}",
                    style: TextStyle(
                      color: Colors.grey.shade700,
                      fontFamily: "UbuntuMono",
                    ),
                  ),
                  Image(image: forkImage, width: 25, height: 25,),
                  Text(
                    "${repo.forksCount}",
                    style: TextStyle(
                      color: Colors.grey.shade700,
                      fontFamily: "UbuntuMono",
                    ),
                  ),
                  Image(image: watchersImage, width: 25, height: 25,),
                  Text(
                    "${repo.watchersCount}",
                    style: TextStyle(
                      color: Colors.grey.shade700,
                      fontFamily: "UbuntuMono",
                    ),
                  ),
                  Image(image: diskImage, width: 25, height: 25,),
                  Text(
                    formatBytes(repo.size, 0),
                    style: TextStyle(
                      color: Colors.grey.shade700,
                      fontFamily: "UbuntuMono",
                    ),
                  ),
                  SizedBox(width: 10),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }


  Widget getCompactView(){
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Row(
            children: [
              Image(
                image: starImage,
                width: 25,
                height: 25,
              ),
              SizedBox(width: 5),
              Text(
                "${repo.stargazersCount}",
                style: TextStyle(
                  color: Colors.grey.shade700,
                  fontFamily: "UbuntuMono",
                ),
              ),
              SizedBox(width: 5),
              Text(
                repo.name,
                style: TextStyle(
                  fontFamily: "UbuntuMono",
                ),
              ),
            ],
          ),
          SizedBox(width: 50),
          Container(
            decoration: BoxDecoration(
              color: Colors.grey.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              children: [
                Image(image: issuesImage, width: 25, height: 25,),
                Text(
                  "${repo.openIssuesCount}",
                  style: TextStyle(
                    color: Colors.grey.shade700,
                    fontFamily: "UbuntuMono",
                  ),
                ),
                Image(image: forkImage, width: 25, height: 25,),
                Text(
                  "${repo.forksCount}",
                  style: TextStyle(
                    color: Colors.grey.shade700,
                    fontFamily: "UbuntuMono",
                  ),
                ),
                Image(image: watchersImage, width: 25, height: 25,),
                Text(
                  "${repo.watchersCount}",
                  style: TextStyle(
                    color: Colors.grey.shade700,
                    fontFamily: "UbuntuMono",
                  ),
                ),
                Image(image: diskImage, width: 25, height: 25,),
                Text(
                  formatBytes(repo.size, 0),
                  style: TextStyle(
                    color: Colors.grey.shade700,
                    fontFamily: "UbuntuMono",
                  ),
                ),
                SizedBox(width: 10),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget getView(){
    return compactView == null ? getDefaultView() : getCompactView();
  }


  @override
  Widget build(BuildContext context) {
    return getView();
  }

}

class NotificationsView extends StatelessWidget {

  final BoxConstraints constraints;

  const NotificationsView({Key? key, required this.constraints}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: SizedBox(
        width: constraints.maxWidth - 500,
        height: constraints.maxHeight - 140,
        child: SingleChildScrollView(
          primary: true,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Unread Notifications",
                style: TextStyle(
                  color: Colors.grey.shade600,
                  fontWeight: FontWeight.bold,
                  fontSize: 22,
                ),
              ),
              Visibility(
                visible: unreadNotifications.isNotEmpty,
                child: Column(
                  children: unreadNotifications.map((notification) {
                    return NotificationViewWidget(notification: notification, constraints: constraints);
                  }).toList(),
                ),
              ),
              Visibility(
                visible: unreadNotifications.isEmpty,
                child: NoNotificationsBannerWidget(),
              ),
              SizedBox(height: 20),
              Text(
                "Participating Notifications",
                style: TextStyle(
                  color: Colors.grey.shade600,
                  fontWeight: FontWeight.bold,
                  fontSize: 22,
                ),
              ),
              Visibility(
                visible: participatingNotifications.isNotEmpty,
                child: Column(
                  children: participatingNotifications.map((notification) {
                    return NotificationViewWidget(notification: notification, constraints: constraints);
                  }).toList(),
                ),
              ),
              Visibility(
                visible: participatingNotifications.isEmpty,
                child: NoNotificationsBannerWidget(),
              ),
              SizedBox(height: 20),
              Text(
                "All Read Notifications",
                style: TextStyle(
                  color: Colors.grey.shade600,
                  fontWeight: FontWeight.bold,
                  fontSize: 22,
                ),
              ),
              Visibility(
                visible: readNotifications.isNotEmpty,
                child: Column(
                  children: readNotifications.map((notification) {
                    return NotificationViewWidget(notification: notification, constraints: constraints);
                  }).toList(),
                ),
              ),
              Visibility(
                visible: readNotifications.isEmpty,
                child: NoNotificationsBannerWidget(),
              ),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}

class NoNotificationsBannerWidget extends StatelessWidget{
  const NoNotificationsBannerWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      decoration: BoxDecoration(
        color: Colors.grey.withOpacity(0.1),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Center(
        child: Text(
          "Nothing here",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

}

class NotificationViewWidget extends StatelessWidget{

  final github.Notification notification;

  final BoxConstraints constraints;

  const NotificationViewWidget({Key? key, required this.notification, required this.constraints}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        width: constraints.maxWidth - 100,
        decoration: BoxDecoration(
          color: Colors.grey.withOpacity(0.1),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          children: [
            SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "${notification.repository?.owner?.login}/${notification.repository?.name}",
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  notification.subject?.title as String,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    "${notification.reason}",
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(width: 10),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

}

String formatBytes(int bytes, int decimals) {
  if (bytes <= 0) {
    return "0 B";
  }
  const suffixes = ["B", "KB", "MB", "GB", "TB", "PB", "EB", "ZB", "YB"];
  var i = (log(bytes) / log(1000)).floor();
  return '${(bytes / pow(1000, i)).toStringAsFixed(decimals)} ${suffixes[i]}';
}

String computeStarText(int n){
  int limit = computeNextLimit(n);
  return "${limit - n} more to reach $limit";
}

int computeNextLimit(int n){
  int limit = 0;
  int c = 0;
  int cn = n;
  while(n != 0){
    n = n ~/ 10;
    c++;
  }
  n = cn;
  double exp = pow(n, -c).toDouble();
  exp = exp.ceilToDouble();
  limit = (exp * pow(10, c)).toInt();
  return limit;
}

Gradient getGradient(int starCount) {
  if(starCount >= 1000) {
    return LinearGradient(colors: [Color(0xff2193b0), Color(0xff6dd5ed)]);
  } else if(starCount >= 500) {
    return LinearGradient(colors: [Color(0xffcc2b5e), Color(0xff753a88)]);
  } else if(starCount >= 250) {
    return LinearGradient(colors: [Color(0xff56ab2f), Color(0xffa8e063)]);
  } else if(starCount >= 100) {
    return LinearGradient(colors: [Color(0xff06beb6), Color(0xff48b1bf)]);
  } else if(starCount >= 50) {
    return LinearGradient(colors: [Color(0xffbdc3c7), Color(0xff2c3e50)]);
  } else if(starCount >= 40) {
    return LinearGradient(colors: [Color(0xff42275a), Color(0xff734b6d)]);
  }
  return LinearGradient(colors: [Color(0xff4568dc), Color(0xffb06ab3)]);
}

