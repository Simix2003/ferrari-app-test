import 'package:flutter/material.dart';
import 'avdel_page.dart';
import 'carrellista_page.dart';

/*

H O M E P A G E

This is the HomePage, the first page the user will see based off what was configured in the MainPage.
Currently it is just showing a vertical list of boxes.

What should the HomePage for your app look like?

You should place the most important aspect of your app on this page
as this is the very first page the user will see!

*/

class HomePage extends StatelessWidget {
  const HomePage({Key? key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 252, 36, 0),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
        child: ListView.builder(
          itemCount: 2,
          itemBuilder: (context, index) {
            String content = index == 0 ? 'AVDEL' : 'CARRELLISTA';

            return GestureDetector(
              onTap: () {
                if (index == 0) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const AvdelPage()),
                  );
                } else if (index == 1) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const Carrellista_Page()),
                  );
                }
              },
              child: Container(
                height: 200,
                margin: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4),
                  color: Colors.black,
                ),
                child: Center(
                  child: Text(
                    content,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
