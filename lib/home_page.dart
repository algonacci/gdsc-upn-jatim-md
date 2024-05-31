import 'package:flutter/material.dart';
import 'button.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Demo GDSC UPN Jatim'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              InkWell(
                onTap: () {
                  Navigator.pushNamed(context, "/streaming");
                },
                child: const Button(
                  text: "Streaming",
                  icon: Icons.bubble_chart_outlined,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
