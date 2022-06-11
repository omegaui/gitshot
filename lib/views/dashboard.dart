// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:gitshot/components/dashboard_components.dart';

final GlobalKey<DashboardMainViewWidgetState> dashboardMainViewWidgetKey = GlobalKey();

class Dashboard extends StatelessWidget{

  const Dashboard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      child: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints){
          return Container(
            color: Colors.blueAccent.withOpacity(0.1),
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      Container(
                        width: 400,
                        height: constraints.maxHeight - 40,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: SingleChildScrollView( //User Area
                          child: Column(
                            children: [
                              UserInfoWidget(),
                              UserBioInfoWidget(),
                              SizedBox(height: 30),
                              UserInteractivityInfoWidget(constraints: constraints),
                              UserActionsWidget(),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  width: constraints.maxWidth - 400 - 60,
                  height: constraints.maxHeight - 40,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: DashboardMainViewWidget(key: dashboardMainViewWidgetKey, constraints: constraints),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}


