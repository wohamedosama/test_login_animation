import 'package:flutter/material.dart';
import 'package:simple_animated_login_screen/simple_animated_login_screen.dart';

void main() {
  runApp(const SimpleAnimated());
}

class SimpleAnimated extends StatelessWidget {
  const SimpleAnimated({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'SimpleAnimatedLoginScreen',
      debugShowCheckedModeBanner: false,
      home: SimpleAnimatedLoginScreen(),
    );
  }
}
