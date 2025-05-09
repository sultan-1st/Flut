
// create sample screen 
import 'package:flutter/material.dart';

class LinesScreen extends StatelessWidget {
  const LinesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Lines Screen'),
      ),
      body: Center(
        child: Text('This is the Lines Screen'),
      ),
    );
  }
}
