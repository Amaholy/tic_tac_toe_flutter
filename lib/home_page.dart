import 'package:flutter/material.dart';
import 'package:tic_tac_toe/alert.dart';
import 'package:tic_tac_toe/my_custom.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  int _scoreX = 0;
  int _scoreO = 0;
  bool _turnOfO = true;
  int _filledBoxes = 0;
  final List<String> _xOrOList = List.filled(9, '');
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 500),
    )..repeat(reverse: true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.grey[900],
        actions: [
          IconButton(
            icon: const Icon(
              Icons.refresh,
              color: Colors.white,
            ),
            onPressed: () {
              _clearBoard();
            },
          )
        ],
        title: Row(
          children: [
            Text(
              'Tic Tac Toe',
              style: MyCustom(
                  fontSize: 20.0,
                  color: Colors.white,
                  fontWeight: FontWeight.w800),
            ),
            SizedBox(width: 10),
            _buildTurnIndicator(),
          ],
        ),
      ),
      backgroundColor: Colors.grey[900],
      body: Column(
        children: [
          _buildPointsTable(),
          _buildGrid(),
        ],
      ),
    );
  }

  Widget _buildTurnIndicator() {
    return Container(
      width: 20,
      height: 20,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: _turnOfO ? Colors.blue : Colors.red,
      ),
    );
  }

  Widget _buildPointsTable() {
    return Expanded(
      child: Container(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  Text(
                    'Player O',
                    style: MyCustom(
                        fontSize: 22.0,
                        color: Colors.blue,
                        fontWeight: FontWeight.w800),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Text(
                    _scoreO.toString(),
                    style: MyCustom(
                        color: Colors.blue,
                        fontSize: 25.0,
                        fontWeight: FontWeight.bold),
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  Text(
                    'Player X',
                    style: MyCustom(
                        fontSize: 22.0,
                        color: Colors.red,
                        fontWeight: FontWeight.w800),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Text(
                    _scoreX.toString(),
                    style: MyCustom(
                        color: Colors.red,
                        fontSize: 25.0,
                        fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildGrid() {
    return Expanded(
      flex: 3,
      child: GridView.builder(
          itemCount: 9,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
          ),
          itemBuilder: (BuildContext context, int index) {
            return GestureDetector(
              onTap: () {
                _tapped(index);
              },
              child: Container(
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.white),
                    color: Colors.grey[700]),
                child: Center(
                  child: Text(
                    _xOrOList[index],
                    style: TextStyle(
                      color: _xOrOList[index] == 'X' ? Colors.blue : Colors.red,
                      fontSize: 40,
                    ),
                  ),
                ),
              ),
            );
          }),
    );
  }

  void _tapped(int index) {
    setState(() {
      if (_turnOfO && _xOrOList[index] == '') {
        _xOrOList[index] = 'O';
        _filledBoxes += 1;
      } else if (!_turnOfO && _xOrOList[index] == '') {
        _xOrOList[index] = 'X';
        _filledBoxes += 1;
      }

      _turnOfO = !_turnOfO;
      _checkTheWinner();
    });
  }

  void _checkTheWinner() {
    for (int i = 0; i < 3; i++) {
      if (_xOrOList[i * 3] == _xOrOList[i * 3 + 1] &&
          _xOrOList[i * 3] == _xOrOList[i * 3 + 2] &&
          _xOrOList[i * 3] != '') {
        _showAlertDialog('Winner', _xOrOList[i * 3]);
        return;
      }
    }

    // Check columns
    for (int i = 0; i < 3; i++) {
      if (_xOrOList[i] == _xOrOList[i + 3] &&
          _xOrOList[i] == _xOrOList[i + 6] &&
          _xOrOList[i] != '') {
        _showAlertDialog('Winner', _xOrOList[i]);
        return;
      }
    }

    // Check diagonals
    if (_xOrOList[0] == _xOrOList[4] &&
        _xOrOList[0] == _xOrOList[8] &&
        _xOrOList[0] != '') {
      _showAlertDialog('Winner', _xOrOList[0]);
      return;
    }

    if (_xOrOList[2] == _xOrOList[4] &&
        _xOrOList[2] == _xOrOList[6] &&
        _xOrOList[2] != '') {
      _showAlertDialog('Winner', _xOrOList[2]);
      return;
    }

    if (_filledBoxes == 9) {
      _showAlertDialog('Draw', '');
    }
  }

  void _showAlertDialog(String title, String winner) {
    showAlertDialog(
        context: context,
        title: title,
        content: winner == ''
            ? 'NO WINNER'
            : 'Congrats! ${winner.toUpperCase()} is the WINNER',
        defaultActionText: 'ReMatch',
        onOkPressed: () {
          _clearBoard();
          Navigator.of(context).pop();
        });

    if (winner == 'O') {
      _scoreO += 1;
    } else if (winner == 'X') {
      _scoreX += 1;
    }
  }

  void _clearBoard() {
    setState(() {
      for (int i = 0; i < 9; i++) {
        _xOrOList[i] = '';
      }
    });

    _filledBoxes = 0;
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
}
