import 'dart:async';
import 'package:flutter/material.dart';
import 'dart:math';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.yellow,
        scaffoldBackgroundColor: Colors.amber
      ),
      home: const MyHomePage(title: 'Gratitude'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  //DATA MEMBERS
  final TextEditingController itemController = TextEditingController();
  List<String>? grateful = [];
  int? size = 0;

  //METHODS
  void getStringList() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(
          () {
        if (prefs.getStringList("a") != null) {
          grateful = prefs.getStringList("a");
        }
        size = grateful?.length;
      },
    );
  }

  void storeStringList(List<String> grateful) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setStringList("a", grateful);
  }

  void addItem(BuildContext context) async {
      if(Text(itemController.text).data != ""){
        grateful?.add(itemController.text);
        itemController.clear();
        Navigator.of(context).pop();
        storeStringList(grateful!);
      }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            FloatingActionButton.large(
              onPressed: () {
                getStringList();
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text("Add Item"),
                      content: TextField (
                        controller: itemController,
                        decoration: InputDecoration(
                          labelText: "What are you grateful for?",
                          border: InputBorder.none,
                          hintText: size==0?"":grateful?[new Random().nextInt(size!)],
                          hintStyle: TextStyle(color: Colors.grey),
                        ),
                      ),
                      actions: [
                        TextButton(
                          child: Text("CANCEL"),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                        TextButton(
                          child: Text("ADD"),
                          onPressed: ()=> addItem(context),
                        )
                      ],
                    );
                  },
                );
              },
              child: const Icon(Icons.add),
            ),
          ],
        ),
      ),
    );
  }
}