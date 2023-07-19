import 'package:flutter/material.dart';

class InfoPage extends StatefulWidget {
  const InfoPage({Key? key}) : super(key: key);

  @override
  State<InfoPage> createState() => _InfoPageState();
}

class _InfoPageState extends State<InfoPage>
    with SingleTickerProviderStateMixin {
  /*late AnimationController _controller;
  late Animation<double> _animation;
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(microseconds: 120),
      vsync: this,
    );
    _animation = Tween<double>(begin: 0, end: 300).animate(_controller);
    _controller.forward();
  }*/
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("About"),
      ),
      body: const Column(
        children: [
          //Image(image: AssetImage('Assets/cover.png')),
          Image(image: AssetImage('Assets/Images/image2.png')),
          AnimatedPositioned(
              duration: Duration(seconds: 2),
              //top: _animation.value,
              child: Text(
                  "Hello!\n My name is Md Hasibul Hossain Rezvi.\n I'm studying Computer Science at Comilla University."
                  "\n\nIt is my first App.\nThank you for trying this App.",
                  style: TextStyle(fontSize: 25),
                  textAlign: TextAlign.center))
        ],
      ),
      backgroundColor: Colors.blue[100],
    );
  }
}
