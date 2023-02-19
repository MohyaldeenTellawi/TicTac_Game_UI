import 'package:flutter/material.dart';
import 'game_logic.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String activePlayer = "X";

  bool gameOver = false;
  int turn = 0;
  String result = "";

  Game game = Game();

  bool isSwitched = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: SafeArea(
        child: MediaQuery.of(context).orientation== Orientation.portrait?Column(
          children: [
            ...firstBlock(),
            const SizedBox(
              height: 60,
            ),
            buildExpanded(),
            ...lastBlock(),
              ],
            ):
        Row(
          children: [
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ...firstBlock(),
                  const SizedBox(
                    height: 100,
                  ),
                  ...lastBlock(),
                ],
              ),
            ),
            buildExpanded(),
          ],
        ),
        ),
      );
  }

  Expanded buildExpanded() {
    return Expanded(
            child: GridView.count(
              padding: const EdgeInsets.all(16),
              mainAxisSpacing: 8,
              crossAxisSpacing: 8,
              childAspectRatio: 1,
              crossAxisCount: 3,
              children: List.generate(
                9,
                (index) => InkWell(
                  borderRadius: BorderRadius.circular(90),
                  onTap: gameOver == true ? null : () => _onTap(index),
                  child: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(90),
                        color: const Color.fromRGBO(75, 34, 3, 1),
                    ),
                    child: Center(
                      child: Text(
                        Player.playerX.contains(index)
                            ? "X"
                            : Player.playerY.contains(index)
                                ? "O"
                                : "",
                        style: TextStyle(
                            fontSize: 50,
                            color: Player.playerX.contains(index)
                                ? Colors.blue
                                : Colors.redAccent),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
  }


  List<Widget> firstBlock(){
    return [
      SwitchListTile.adaptive(
        activeColor: const Color.fromRGBO(75, 34, 3, 1),
          title: const Text(
            "Turn On/Off Two Player",
            style: TextStyle(
              color:  Color.fromRGBO(53, 57, 53, 1),
              fontSize: 23,
              fontWeight: FontWeight.bold
            ),
            textAlign: TextAlign.center,
          ),
          value: isSwitched,
          onChanged: (bool newVal) {
            setState(() {
              isSwitched = newVal;
            });
          }),
      Text(
        "It's $activePlayer Turn".toUpperCase(),
        style: const TextStyle(
          color: Color.fromRGBO(75, 34, 3, 1),
          fontSize: 30,
          fontWeight: FontWeight.bold
        ),
      ),
    ];
  }

  List<Widget> lastBlock(){
    return [
      Text(
        result,
        style: const TextStyle(
          color: Color.fromRGBO(75, 34, 3, 1),
          fontSize: 35,
          fontWeight: FontWeight.bold
        ),
      ),
      const SizedBox(
        height: 60,
      ),
      ElevatedButton.icon(
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(const Color.fromRGBO(75, 34, 3, 1),)
        ),
        label: const Text("Replay The Game"),
        onPressed: () {
          setState(() {
            Player.playerX = [];
            Player.playerY = [];
            activePlayer = "X";
            gameOver = false;
            turn = 0;
            result = "";
          });
        },
        icon: const Icon(Icons.replay_circle_filled_sharp),
      ),
    ];
  }

  _onTap(int index) async {
    if ((Player.playerX.isEmpty || !Player.playerX.contains(index)) &&
        (Player.playerY.isEmpty || !Player.playerY.contains(index))) {
      game.playGame(index, activePlayer);
      updateState();

      if (!isSwitched && !gameOver && turn != 9) {
        await game.autoPlay(activePlayer);
        updateState();
      }
    }
  }

  void updateState() {
    return setState(() {
      activePlayer = (activePlayer == "X") ? "O" : "X";
      turn++;

      String winnerPlayer = game.checkWinner();
      if (winnerPlayer != "") {
        result = " $winnerPlayer Is The Winner ";
      } else if (!gameOver && turn == 9) {
        result = " It's Draw! ";
      }
    });
  }
}
