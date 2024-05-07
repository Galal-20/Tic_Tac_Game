import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:tic_tac/HomeScreen.dart';
class GameScreen extends StatefulWidget {
  String player1;
  String player2;
  GameScreen({super.key, required this.player1, required this.player2});
  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  late List<List<String>> _board;
  late String _currentPlayer;
  late String _winner;
  late bool _gameOver;
  final String restartText = "Restart Game";
  final String resetText = "Reset Game";

  @override
  void initState() {
    super.initState();
    _board = List.generate(3, (_) => List.generate(3 , (_) => ""));
    _currentPlayer = "X";
    _winner = "";
    _gameOver = false;
  }

  void resetGame(){
    setState(() {
      _board = List.generate(3, (_) => List.generate(3 , (_) => ""));
      _currentPlayer = "X";
      _winner = "";
      _gameOver = false;
    });
  }

  void _makeMove(int row, int col){
    if(_board[row][col] != "" || _gameOver){
      return;
    }
    setState(() {
      _board[row][col] = _currentPlayer;
      // check winner:
      if(
      _board[row][0] == _currentPlayer &&
      _board[row][1] == _currentPlayer &&
      _board[row][2] == _currentPlayer
      ){
        _winner = _currentPlayer;
        _gameOver = true;
      }
      else if(
      _board[0][col] == _currentPlayer &&
          _board[1][col] == _currentPlayer &&
          _board[2][col] == _currentPlayer
      ){
        _winner = _currentPlayer;
        _gameOver = true;
      }
      else if(
      _board[0][0] == _currentPlayer &&
      _board[1][1] ==_currentPlayer &&
      _board[2][2] == _currentPlayer){
        _winner = _currentPlayer;
        _gameOver = true;
      }
      else if(
      _board[0][2] == _currentPlayer &&
      _board[1][1] ==_currentPlayer &&
      _board[2][0] == _currentPlayer){
        _winner = _currentPlayer;
        _gameOver = true;
      }

      // switchPlayer:
      _currentPlayer = _currentPlayer == "X" ? "O" : "X";

      // check for tie:
      if(!_board.any((row) => row.any((cell) => cell == "" ))){
        _gameOver = true;
        _winner = "It's a Tie";
      }

  if(_winner != ""){
    AwesomeDialog(
      context: context,
      dialogType: DialogType.success,
      animType: AnimType.bottomSlide,
      btnOkText: "Play Again",
      title: _winner == "X" ? widget.player1+ " Won!" : _winner == "O" ?
      widget.player2 + " Won!" : "No one winner",
      btnOkOnPress: () => resetGame()
    )..show();
  }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 70),
            SizedBox(
              height: 90,
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment:  MainAxisAlignment.center,
                    children: [
                      Text(
                          "Turn: ",
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.white
                          ),
                      ),
                      Text(
                          _currentPlayer == "X" ? widget.player1 + "($_currentPlayer)" :
                              widget.player2 + "($_currentPlayer)",
                          style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                            color: _currentPlayer == "X" ? Colors.red :Colors.green,
                          ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(30),
              ),
              margin: EdgeInsets.all(1),
              child: GridView.builder(
                itemCount: 9,
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3
                  ),
                  itemBuilder: (context, index){
                  int row = index ~/ 3;
                  int col = index % 3;
                  return GestureDetector(
                    onTap: () => _makeMove(row, col),
                    child: Container(
                      margin: EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Center(
                        child: Text(
                          _board[row][col],
                          style: TextStyle(
                            fontSize: 80,
                            fontWeight: FontWeight.bold,
                            color: _board[row][col] == "X" ? Colors.red : Colors.green
                          ),
                        ),
                      ),
                    ),
                  );
                  }
              ),
            ),
            SizedBox(height: 15),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                InkWell(
                  onTap: resetGame,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.green,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30),
                        bottomRight: Radius.circular(50)
                      ),
                    ),
                    padding: EdgeInsets.symmetric(vertical: 18, horizontal: 20),
                    child: Text(
                      resetText,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                InkWell(
                  onTap: (){
                    Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => HomeScreen()),
                    );
                    widget.player1 = "";
                    widget.player2 = "";
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.green,
                      borderRadius: BorderRadius.only(
                          topRight: Radius.circular(30),
                          bottomLeft: Radius.circular(50)
                      ),
                    ),
                    padding: EdgeInsets.symmetric(vertical: 18, horizontal: 20),
                    child: Text(
                      restartText,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
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
