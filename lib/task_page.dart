import 'package:codeware_task/display_page.dart';
import 'package:flutter/material.dart';

class TaskPage extends StatelessWidget {
  const TaskPage({super.key});

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: const Text("Codeware Task"),
      ),
      body: SizedBox(
        height: size.height,
        child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: const <Widget>[
              CustomButton(
                title: "Display 1",
              ),
              CustomButton(
                title: "Display 2",
              )
            ]),
      ),
    );
  }
}

class CustomButton extends StatelessWidget {
  const CustomButton({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return InkWell(
      onTap: () {
        Navigator.push(context,
            MaterialPageRoute(builder: (_) => DispalyPage(title: title)));
      },
      child: Container(
        height: size.width * 0.4,
        width: size.width * 0.4,
        decoration: BoxDecoration(
            border: Border.all(color: Colors.blue),
            borderRadius: BorderRadius.circular(10)),
        child: Center(
            child: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.w600),
        )),
      ),
    );
  }
}
