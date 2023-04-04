import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            const Expanded(
              child: Icon(
                Icons.shopping_cart,
                size: 70,
                color: Colors.brown,
              ),
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.7,
              child:
                  const LinearProgressIndicator(backgroundColor: Colors.brown),
            ),
            const Expanded(
              child: Text(
                'Shopping',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 23),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
