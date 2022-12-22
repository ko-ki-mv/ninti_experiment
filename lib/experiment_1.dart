import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/services.dart';
import 'dart:html' as html;

String displayText = "loading";
var displayColor = Colors.grey;

var trialNumber = 0;
var expStatus = 0;
var trialFlag = 0;

List<int> time1 = [];
List<int> time2 = [];
List<int> time3 = [];

List<int> errata1 = [];
List<int> errata2 = [];
List<int> errata3 = [];

var tapEnable = false;


var textElement0 = [1,2,0,2,0,2,1,0,1,0];
var colorElement0 =[0,1,2,0,2,0,2,1,0,1];

var textElement1 = [0,2,1,0,1,0,2,1,2,0,2,0,1,2,0,1,2,0,1,2,0,2,1,0,1];
var colorElement1 =[2,1,0,1,2,1,0,2,0,2,1,2,0,1,2,0,1,2,0,1,2,1,0,1,2];

var textElement2 = [2,1,0,2,0,2,1,0,2,1,0,2,1,0,2,0,1,2,0,1,2,1,0,2,0];
var colorElement2 =[1,2,1,0,2,1,0,2,1,0,2,1,0,2,0,1,2,0,1,2,1,2,1,0,2];

var textElement3 = [0,2,1,0,2,1,0,2,1,2,0,1,2,0,1,2,1,0,2,1,0,2,1,0,2];
var colorElement3 =[1,0,2,1,0,2,1,0,2,1,0,2,1,2,0,1,0,2,1,2,1,0,2,1,0];

var startTime = DateTime.now();

class Exp1 extends StatefulWidget {

  final String title;
  const Exp1({Key? key, required this.title}) : super(key: key);

  @override
  State<Exp1> createState() => Exp1State();
}

class Exp1State extends State<Exp1> {

  late AudioPlayer _player;

  @override
  void initState() {
    trialNumber = 0;
    trialFlag = 0;
    displayText = "loading";
    displayColor = Colors.grey;

    setState(() {
      expStatus = 1;
    });

    super.initState();
    _setupSession();
  }

  Future<void> _setupSession() async {
    _player = AudioPlayer();
    _player.onPlayerComplete.listen((event) {
    });
  }

  Future<void> countDown() async {
    tapEnable =false;
    displayText = "loading";
    displayColor = Colors.grey;
    int count = 5;
    if(trialFlag == 2){
      _player.play(AssetSource("exp_music.mp3"));
    }
    else if(trialFlag == 3){
      _player.play(AssetSource("exp_discord.mp3"));
    }
    //countdownの処理。awaitで割り込みを禁止して実装。
    while(count >= 0){
      await Future.delayed(const Duration(seconds: 1));
      setState(() {
        if (count == 0){
          displayText= "";
        }
        else{
          displayText = "$count";
        }
      });
      count = count - 1;
    }
    runTrial();
  }

  void runTrial() {
    tapEnable =true;

    if(trialNumber ==0){
      startTime = DateTime.now();
    }
    var textElement = [];
    if(trialFlag == 0){
      textElement = textElement0;
    }
    else if(trialFlag == 1){
      textElement = textElement1;
    }
    else if(trialFlag == 2){
      textElement = textElement2;
    }
    else if(trialFlag == 3){
      textElement = textElement3;
    }
    
    if(trialNumber >= textElement.length){

      setState(() {
        if(trialFlag == 0){
          expStatus = 4;
        }
        else if (trialFlag == 1){
          expStatus = 5;
        }
        else if (trialFlag == 2){
          _player.stop();
          expStatus = 6;
        }
        else{
          _player.stop();
          expStatus = 10;
          endOfTest();
        }
      });
      return;
    }
    else{
      var number = 3;
      int text;
      if(trialFlag == 0){
        number = colorElement0[trialNumber];
      }
      else if(trialFlag == 1){
        number = colorElement1[trialNumber];
      }
      else if(trialFlag == 2){
        number = colorElement2[trialNumber];
      }
      else if(trialFlag == 3){
        number = colorElement3[trialNumber];
      }

      text = textElement[trialNumber];

      setState(() {
        if (number == 0){
          displayColor = Colors.yellow;
        }
        else if (number == 1){
          displayColor = Colors.red;
        }
        else if (number == 2){
          displayColor = Colors.blue;
        }
        else{
          displayColor = Colors.grey;
        }

        if (text ==0){
          displayText = "黄色";
        }
        else if (text ==1){
          displayText = "赤色";
        }
        else if (text ==2){
          displayText = "青色";
        }
        else {
          displayText = "エラー";
        }
      });
    }
  }

  void endOfTest(){
    print("Finished");
    print(time1);
    print(errata1);
  }

  String listToString(List<int> list) {
    return list.map<String>((int value) => value.toString()).join(',');
  }

  Future<void> clickCopy() async {
    String timedata1 = listToString(time1);
    String erratadata1 = listToString(errata1);
    String timedata2 = listToString(time2);
    String erratadata2 = listToString(errata2);
    String timedata3 = listToString(time3);
    String erratadata3 = listToString(errata3);

    String outputdata = "$timedata1#$erratadata1#$timedata2#$erratadata2#$timedata3#$erratadata3";

    final data = ClipboardData(text: outputdata);
    await Clipboard.setData(data);
}

  Future<void> onTap(taps) async {
    if(tapEnable == true){
      var nowTime = DateTime.now();
      var diff = nowTime.difference(startTime).inMilliseconds;

      startTime = nowTime;

      print(diff);

      if(trialFlag == 0){
        if(textElement0[trialNumber] == taps){
          await _player.play(AssetSource("correct.mp3"));
        }
        else{
          await _player.play(AssetSource("wrong.mp3"));
        }
      }

      if(trialFlag == 1){
        time1.add(diff);
        if(textElement1[trialNumber] == taps){
          errata1.add(1);
        }
        else{
          errata1.add(0);
        }
      }
      else if(trialFlag == 2){
        time2.add(diff);
        if(textElement2[trialNumber] == taps){
          errata2.add(1);
        }
        else{
          errata2.add(0);
        }
      }
      else if(trialFlag == 3){
        time3.add(diff);
        if(textElement3[trialNumber] == taps){
          errata3.add(1);
        }
        else{
          errata3.add(0);
        }
      }



      trialNumber += 1;
      runTrial();
    }

}

  _launchURL(url) {
    html.window.open(url, '');
  }


  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Stack(
        children: [
          if(expStatus==1) Container(
            alignment: const Alignment(0, -0.6),
            child:
            const Text("本実験は、慶應義塾大学 認知科学ワークショップグループ5のメンバーによって行われます。\n実験内で取得したデータは研究目的でのみ使用されます。",
              style: TextStyle(
                fontSize: 20,
                color: Colors.black,
              ),
            ),),
          if(expStatus==1) Container(
            alignment: const Alignment(0, 0.6),
            child: SizedBox(
              width: 200, //横幅
              height: 60,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepOrangeAccent,
                ),
                onPressed: () {
                  setState(() {
                    expStatus = 11;
                  });
                },
                child: const Text(
                  "次へ",
                  style: TextStyle(
                    fontSize: 30,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
          ),
          if(expStatus==11) Container(
            alignment: const Alignment(0, -0.6),
            child:
            const Text("実験を開始する前にイヤホンを装着してください。\n実験中はイヤホンを外さないでください。\nまた、音量操作を行わないでください。",
              style: TextStyle(
                fontSize: 30,
                color: Colors.black,
              ),
            ),),
          if(expStatus==11) Container(
            alignment: const Alignment(0, 0.6),
            child: SizedBox(
              width: 200, //横幅
              height: 60,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepOrangeAccent,
                ),
                onPressed: () async {
                  _player.play(AssetSource("volume.mp3"));
                  setState(() {
                    expStatus = 2;
                  });
                },
                child: const Text(
                  "次へ",
                  style: TextStyle(
                    fontSize: 30,
                    color: Colors.black,
                ),
                ),
              ),
            ),
          ),

          if(expStatus==2) Container(
            alignment: const Alignment(0, -0.6),
            child:
            const Text("今流れている音楽を十分な音量に調節してください",
              style: TextStyle(
                fontSize: 30,
                color: Colors.black,
              ),
            ),),
          if(expStatus==2) Container(
            alignment: const Alignment(0, 0),
            child: SizedBox(
              width: 200, //横幅
              height: 60,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepOrangeAccent,
                ),
                onPressed: () async {
                  await _player.stop();
                  setState(() {
                    expStatus = 3;
                  });
                },
                child: const Text(
                  "次へ",
                  style: TextStyle(
                    fontSize: 30,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
          ),

          if(expStatus==3) Container(
            alignment: const Alignment(0, -0.6),
            child:
            const Text("今から練習用の問題を表示します。\n画面の中央に「黄色・赤色・青色」のいずれかの文字が表示されます。\n"
                "また、文字の下にグレー色のボタンが表示されます。ボタンには何も書いてありません。\n"
              "表示された文字が日本語で「黄色」と書かれていれば一番左のボタンを押してください\n"
              "「赤色」と書かれていれば真ん中のボタンを押してください。\n"
                "「青色」と書かれていれば一番右のボタンを押してください。\n"
              "文字の色は解答には影響しません。",
              style: TextStyle(
                fontSize: 20,
                color: Colors.black,
              ),
            ),),
          if(expStatus==3) Container(
            alignment: const Alignment(0, 0.7),
            child: SizedBox(
              width: 200, //横幅
              height: 40,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepOrangeAccent,
                ),
                onPressed: () {
                  trialNumber = 0;
                  runTrial();
                  setState(() {
                    expStatus = 9;
                  });
                },
                child: const Text(
                  "練習開始",
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
          ),

          if(expStatus==4) Container(
            alignment: const Alignment(0, -0.9),
            child:
            const Text("練習終了",
              style: TextStyle(
                fontSize: 25,
                color: Colors.black,
              ),
            ),),
          if(expStatus==4) Container(
            alignment: const Alignment(0, -0.4),
            child:
            const Text("次は１回目の試験です（全３回）。ルールは同じですが再確認のため表示します。\n画面の中央に「黄色・赤色・青色」のいずれかの文字が表示されます。\n"
                "また、文字の下にグレー色のボタンが表示されます。ボタンには何も書いてありません。\n"
                "表示された文字が日本語で「黄色」と書かれていれば一番左のボタンを押してください\n"
                "「赤色」と書かれていれば真ん中のボタンを押してください。\n"
                "「青色」と書かれていれば一番右のボタンを押してください。\n"
                "文字の色は解答には影響しません。",
              style: TextStyle(
                fontSize: 18,
                color: Colors.black,
              ),
            ),),
          if(expStatus==4) Container(
            alignment: const Alignment(0, 0.6),
            child: SizedBox(
              width: 180, //横幅
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                ),
                onPressed: () {
                  trialNumber = 0;
                  trialFlag = 1;
                  countDown();
                  setState(() {
                    expStatus = 9;
                  });
                },
                child: const Text(
                  "本番開始",
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
          ),
          if(expStatus==4) Container(
            alignment: const Alignment(0, 0.8),
            child:
            const Text("ここからは正解・不正解音は鳴りません。",
              style: TextStyle(
                fontSize: 18,
                color: Colors.black,
              ),
            ),),

          if(expStatus==5) Container(
            alignment: const Alignment(0, -0.4),
            child:
            const Text("次は２回目の試験です（全３回）。\nルールは同じです。\nイヤホンから音楽が流れます。\n音量操作を行わないでください。\n正解・不正解音は鳴りません。",
              style: TextStyle(
                fontSize: 18,
                color: Colors.black,
              ),
            ),),
          if(expStatus==5) Container(
            alignment: const Alignment(0, 0.6),
            child: SizedBox(
              width: 180, //横幅
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                ),
                onPressed: () {
                  trialNumber = 0;
                  trialFlag = 2;
                  countDown();
                  setState(() {
                    expStatus = 9;
                  });
                },
                child: const Text(
                  "本番開始",
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
          ),
          if(expStatus==6) Container(
            alignment: const Alignment(0, -0.4),
            child:
            const Text("次は最後の試験です（全３回）。\nルールは同じです。\nイヤホンから音楽が流れます。\n音量操作を行わないでください。\n正解・不正解音は鳴りません。",
              style: TextStyle(
                fontSize: 18,
                color: Colors.black,
              ),
            ),),
          if(expStatus==6) Container(
            alignment: const Alignment(0, 0.6),
            child: SizedBox(
              width: 180, //横幅
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                ),
                onPressed: () {
                  trialNumber = 0;
                  trialFlag = 3;
                  countDown();
                  setState(() {
                    expStatus = 9;
                  });
                },
                child: const Text(
                  "本番開始",
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
          ),

          if(expStatus==9) Container(
            alignment: const Alignment(0, -0.6),
            child:
            Text(displayText,
              style: TextStyle(
                fontSize: 50,
                color: displayColor,
              ),
          ),),

          if(expStatus==9) Container(
            alignment: const Alignment(-0.6, 0.3),
            child: SizedBox(
              width: 100, //横幅
              height: 100,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey,
                ),
                onPressed: () {
                  onTap(0);
                },
                child: const Text(
                  "",
                ),
              ),
            ),
          ),
          if(expStatus==9) Container(
            alignment: const Alignment(0, 0.3),
            child: SizedBox(
              width: 100, //横幅
              height: 100,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey,
                ),
                onPressed: () {
                  onTap(1);
                },
                child: const Text(
                  "",
                ),
              ),
            ),
          ),
          if(expStatus==9) Container(
            alignment: const Alignment(0.6, 0.3),
            child: SizedBox(
              width: 100, //横幅
              height: 100,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey,
                ),
                onPressed: () {
                  onTap(2);
                },
                child: const Text(
                  "",
                ),
              ),
            ),
          ),
          if(expStatus==10) Container(
            alignment: const Alignment(0, -0.4),
            child:
            const Text("試験終了です。\nまだ結果はサーバーに送られていません。\n下の「結果をクリップボートにコピーする」を押すと\n"
                        "結果がクリップボードにコピーされます。\n"
                         "さらに下の「Google Formで結果を送信」を開き、結果をペーストし、送信してください。\nご協力ありがとうございました。",
              style: TextStyle(
                fontSize: 18,
                color: Colors.black,
              ),
            ),),
          if(expStatus==10) Container(
            alignment: const Alignment(0, 0),
            child: SizedBox(
              width: 380, //横幅
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                ),
                onPressed: () {
                  clickCopy();
                },
                child: const Text(
                  "結果をクリップボードにコピー",
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
          ),
          if(expStatus==10) Container(
            alignment: const Alignment(0, 0.8),
            child: SizedBox(
              width: 380, //横幅
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                ),
                onPressed: () async {
                  String url = "https://forms.gle/7iHn63J8virkafuJ7";
                  await _launchURL(url);
                },
                child: const Text(
                  "Googleフォームで結果を送信",
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
