import 'package:flutter/material.dart';
import 'package:masked_controller/masked_controller.dart';
import 'package:masked_controller/mask.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final MaskedController _controller =
  MaskedController(mask: Mask(mask: 'NNN.NNN.NNN-NN'));

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: Padding(
            padding: EdgeInsets.all(16),
            child: TextField(
              controller: _controller,
            ),
          )),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
