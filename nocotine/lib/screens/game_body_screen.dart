import 'package:nocotine/constants/colors.dart';
import 'package:nocotine/constants/screens.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async';
import 'package:awesome_dialog/awesome_dialog.dart';
int currentMoves = 0;
List<String> _board = ['', '', '', '', '', '', '', '', '']; //empty board
String status = '';
String winner = '';
var _gamePageState;
var _turnState;
var _context;
String _turn = 'First Move: X';
bool loading = false;
late bool vsBot;
class GameBodyScreen extends StatefulWidget {
  bool isBot;
  GameBodyScreen(this.isBot) {
    _resetGame();
    vsBot = this.isBot;
    if (vsBot) _turn = 'First Move: O';
  }
  @override
  _GameBodyScreenState createState() => _GameBodyScreenState();
}

class _GameBodyScreenState extends State<GameBodyScreen> {
  @override
  Widget build(BuildContext context) {
    _gamePageState = this;
    return Scaffold(
      
      appBar: AppBar(
      centerTitle: true,
      title:
          Text(vsBot ? 'Playing vs Bot' : 'Playing vs Friend'),
        
      backgroundColor: AppColor.darkColor,
      leading: IconButton(onPressed: (){
        Navigator.pop(context);
      }, icon: Icon(Icons.arrow_back_ios)),
    ),
      body: Container(
        decoration: BoxDecoration(color: AppColor.whiteColor),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[_BoxContainer(), Status()],
          ),
        ),
      ),
      floatingActionButton: Container(
        margin: EdgeInsets.only(right: 12,bottom: 12),
        child: FloatingActionButton(
        
        backgroundColor: AppColor.lightyColor,
        onPressed: () {
          setState(() {
            
            awaitfn('Reset?', 'Want to reset the current game?', 'Go Back',
                'Reset');
          });
        },
        tooltip: 'Restart',
        child: Icon(Icons.refresh),
      ),
      )
    );
  }
}

class _BoxContainer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    _context = context;
    return Container(
        width: 300,
        height: 300,
        decoration: BoxDecoration(
            color: Colors.white,
            border: new Border.all(color: AppColor.primaryColor),
            ),
        child: Center(
            child: GridView.count(
          primary: false,
          crossAxisCount: 3,
          children: List.generate(9, (index) {
            return Box(index);
          }),
        )));
  }
}

class Box extends StatefulWidget {
  final int index;
  Box(this.index);
  @override
  _BoxState createState() => _BoxState();
}

class _BoxState extends State<Box> {
  void pressed() {
    print(currentMoves);
    setState(() {
      currentMoves++;
      if (_checkGame()) {
        awaitfnn();
      } else if (currentMoves >= 9) {
        awaitfn('It\'s a Draw', 'Want to try again?', 'Exit', 'New Game');
      }
      _turnState.setState(() {
        if (currentMoves % 2 == 0){
          _turn = 'Turn: X';}
        else
          _turn = 'Turn: O';
        _gamePageState.setState(() {});
      });
    });
  }

  @override
  Widget build(context) {
    return MaterialButton(
        padding: EdgeInsets.all(0),
        child: Container(
            decoration: BoxDecoration(
                shape: BoxShape.rectangle,
                border: new Border.all(color: AppColor.primaryColor)),
            child: Center(
              child: Text(
                _board[widget.index].toUpperCase(),
                style: TextStyle(
                  fontSize: 45,
                  fontWeight: FontWeight.bold,
                  color: AppColor.primaryColor
                ),
              ),
            )),
        onPressed: () {
          if (_board[widget.index] == '') {
            if (vsBot == false) {
              if (currentMoves % 2 == 0)
                _board[widget.index] = 'x';
              else
                _board[widget.index] = 'o';
            } else if (!loading) {
              loading = true;
              _board[widget.index] = 'o';
              if (currentMoves >= 8) {
              } else
                _bestMove(_board);
              //print(_board);
            }
            //print(vsBot);
            pressed();
          }
        });
  }
}

class Status extends StatefulWidget {
  @override
  _StatusState createState() => _StatusState();
}

class _StatusState extends State<Status> {
  @override
  Widget build(BuildContext context) {
    _turnState = this;
    return Text("");
  }
}

//-------------------------------------TicTacToe game fns ---------------------------

bool _checkGame() {
  for (int i = 0; i < 9; i += 3) {
    if (_board[i] != '' &&
        _board[i] == _board[i + 1] &&
        _board[i + 1] == _board[i + 2]) {
      winner = _board[i];
      return true;
    }
  }
  for (int i = 0; i < 3; i++) {
    if (_board[i] != '' &&
        _board[i] == _board[i + 3] &&
        _board[i + 3] == _board[i + 6]) {
      winner = _board[i];
      return true;
    }
  }
  if (_board[0] != '' && (_board[0] == _board[4] && _board[4] == _board[8]) ||
      (_board[2] != '' && _board[2] == _board[4] && _board[4] == _board[6])) {
    winner = _board[4];
    return true;
  }
  return false;
}

void _resetGame() {
  currentMoves = 0;
  status = '';
  _board = ['', '', '', '', '', '', '', '', ''];
  _turn = 'First Move: X';
  loading = false;
}
//------------------------------ Alerts Dialog --------------------------------------

void awaitfnn() async {
  bool result = await _showAlertBox(
      _context, '$winner won!', 'Start a new Game?', 'Exit', 'New Game');
  if (result) {
    _gamePageState.setState(() {
      _resetGame();
    });
  } else {
    Navigator.pop(_context);
  }
}

_showAlertBox(BuildContext context, String title, String content,
    String btn1, String btn2) async {
  return 
  showDialog<bool>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext _context) => AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(10.0))),
            
            title: Center(child: Text(title.toUpperCase())),
            
            content: 
                Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children:[ Text("$content")],
              
              ),
              
            
            actions: <Widget>[
            Container(
              margin: EdgeInsets.only(bottom: 15),
              child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                InkWell(
                        child: Container(
                          padding: EdgeInsets.all(10),
                          width: 120,
                          child: Center(child: Text("$btn1",style: TextStyle(color: AppColor.whiteColor,fontWeight: FontWeight.bold),)),
                          decoration: BoxDecoration(
                              color: AppColor.darkColor,
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(15),
                                    topRight: Radius.circular(15),
                                    bottomLeft: Radius.circular(15),
                                    bottomRight: Radius.circular(15),
                                ),
                          
                          )),
                        onTap: (){
                            Navigator.of(context).pop(false);
                        }
                      ),
                InkWell(
                        child: Container(
                          padding: EdgeInsets.all(10),
                          width: 120,
                          child: Center(child: Text("$btn2",style: TextStyle(color: AppColor.whiteColor,fontWeight: FontWeight.bold),)),
                          decoration: BoxDecoration(
                              color: AppColor.primaryColor,
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(15),
                                    topRight: Radius.circular(15),
                                    bottomLeft: Radius.circular(15),
                                    bottomRight: Radius.circular(15),
                                ),
                          
                          )),
                        onTap: (){
                          Navigator.of(context).pop(true);
                        }
                      ),

              ],
            )
            ,
            )
            ],
            
          ));
}

awaitfn(String title, String content, String btn1, String btn2) async {
  bool result = await _showAlertBox(_context, title, content, btn1, btn2);
  if(title=="It\'s a Draw"){
    bool result = await _showAlertBox(
      _context, '$title', '$content', '$btn1', '$btn2');
  if (result) {
    _gamePageState.setState(() {
      
      _resetGame();
    });
  } else {
    Navigator.pop(_context);
  }
  }else{
    if (result) {
    _gamePageState.setState(() {
      _resetGame();
    });
  }
  }
  
  
}

//------------------------------ MIN-MAX ------------------------------------------

int max(int a, int b) {
  return a > b ? a : b;
}

int min(int a, int b) {
  return a < b ? a : b;
}

String player = 'x', opponent = 'o';

bool isMovesLeft(List<String> _board) {
  int i;
  for (i = 0; i < 9; i++) {
    if (_board[i] == '') return true;
  }
  return false;
}

int _eval(List<String> _board) {
  for (int i = 0; i < 9; i += 3) {
    if (_board[i] != '' &&
        _board[i] == _board[i + 1] &&
        _board[i + 1] == _board[i + 2]) {
      winner = _board[i];
      return (winner == player) ? 10 : -10;
    }
  }
  for (int i = 0; i < 3; i++) {
    if (_board[i] != '' &&
        _board[i] == _board[i + 3] &&
        _board[i + 3] == _board[i + 6]) {
      winner = _board[i];
      return (winner == player) ? 10 : -10;
    }
  }
  if (_board[0] != '' && (_board[0] == _board[4] && _board[4] == _board[8]) ||
      (_board[2] != '' && _board[2] == _board[4] && _board[4] == _board[6])) {
    winner = _board[4];
    return (winner == player) ? 10 : -10;
  }
  return 0;
}

int minmax(List<String> _board, int depth, bool isMax) {
  int score = _eval(_board);
  //print(score);
  int best = 0, i;

  if (score == 10 || score == -10) return score;
  if (!isMovesLeft(_board)) return 0;
  if (isMax) {
    best = -1000;
    for (i = 0; i < 9; i++) {
      if (_board[i] == '') {
        _board[i] = player;
        best = max(best, minmax(_board, depth + 1, !isMax));
        _board[i] = '';
      }
    }
    return best;
  } else {
    best = 1000;
    for (i = 0; i < 9; i++) {
      if (_board[i] == '') {
        _board[i] = opponent;
        best = min(best, minmax(_board, depth + 1, !isMax));
        _board[i] = '';
      }
    }
    //print(best);
    return best;
  }
}

int _bestMove(List<String> _board) {
  int bestMove = -1000, moveVal;
  late int i, bi;
  for (i = 0; i < 9; i++) {
    if (_board[i] == '') {
      moveVal = -1000;
      _board[i] = player;
      moveVal = minmax(_board, 0, false);
      _board[i] = '';
      if (moveVal > bestMove) {
        bestMove = moveVal;
        bi = i;
      }
    }
  }
  _board[bi] = player;
  _gamePageState.setState(() {});
  loading = false;
  _turnState.setState(() {
    _turn = 'Turn: X';
    currentMoves++;
  });
  return bestMove;
}


