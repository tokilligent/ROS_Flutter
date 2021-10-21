import 'package:flutter/material.dart';
import 'package:roslib/core/core.dart';
import 'package:roslib/core/topic.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(debugShowCheckedModeBanner: false, home: HomePage());
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String ipAdd;
  Ros ros;
  Topic chatter, listener;

  @override
  void initState() {
    ros = Ros(url: 'ws://192.168.43.162:9090');
    chatter = Topic(
        ros: ros,
        name: '/chatting',
        type: "std_msgs/UInt8",
        reconnectOnClose: true,
        queueLength: 10,
        queueSize: 100);
    listener = Topic(
        ros: ros,
        name: '/listener',
        type: "std_msgs/String",
        reconnectOnClose: true,
        queueLength: 10,
        queueSize: 10);

    super.initState();
  }

  void initConnection() async {
    ros.connect();
    await chatter.subscribe();
    setState(() {});
  }

  void destroyConnection() async {
    await chatter.unsubscribe();
    await ros.close();
    setState(() {});
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Mongol Tori GUI"),
        actions: [
          IconButton(
              icon: Icon(Icons.power_settings_new),
              onPressed: () {
                initConnection();
              }),
          IconButton(
              icon: Icon(Icons.power_off),
              onPressed: () {
                destroyConnection();
              }),
        ],
      ),
      body: Column(
        children: [
          Center(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                "IP Address",
                style: TextStyle(fontSize: 32),
              ),
            ),
          ),
          Center(
            child: IconButton(
                iconSize: 64,
                icon: Icon(
                  Icons.arrow_drop_up_sharp,
                ),
                onPressed: () {
                  print("Action Button Clicked");
                  var a = 1;
                  chatter.publish({'data': a});
                }),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 0.0),
            child: IconButton(
                iconSize: 64,
                icon: Icon(
                  Icons.arrow_left_sharp,
                ),
                onPressed: () {
                  print("Action Button Clicked");
                }),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 0.0),
            child: IconButton(
                iconSize: 64,
                icon: Icon(
                  Icons.arrow_right_sharp,
                ),
                onPressed: () {
                  print("Action Button Clicked");
                }),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 0.0),
            child: IconButton(
                iconSize: 64,
                icon: Icon(
                  Icons.arrow_drop_down_sharp,
                ),
                onPressed: () {
                  print("Action Button Clicked");
                }),
          ),
        ],
      ),
    );
  }
}
