import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'experiment_1.dart';


void main() {
  WidgetsFlutterBinding.ensureInitialized();
  //向き指定
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.landscapeLeft,//縦固定
  ]);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);
  @override
  State createState() => _MyAppState();
}

class _MyAppState extends State<MyHomePage> {

  final listItems = [
    'Music Tapping Test',
    'Beat Interval Test',
    'Beat Finding and Interval Test',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('実験一覧'),
        ),
        body: ListView(
          children: [
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const Exp1(title: "Experiment 1",)),
                );
              },
              child: const Card(
                child: SizedBox(
                  height: 60,
                  width: double.infinity,
                  child: Text('Experiment 1'),
                ),
              ),
            ),
          ],
        )
    );
  }
}