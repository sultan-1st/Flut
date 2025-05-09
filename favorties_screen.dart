// create sample screen
import 'package:flutter/material.dart';

class FavorScreen extends StatelessWidget {
  const FavorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Favorites Screen'),
      ),
      body: Center(
        child: Text('This is the Favorites Screen'),
      ),
    );
  }
}
