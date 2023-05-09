import 'dart:convert';

import 'package:flutter/material.dart';

import 'version_model.dart';

class DispalyPage extends StatefulWidget {
  const DispalyPage({super.key, required this.title});
  final String title;

  @override
  State<DispalyPage> createState() => _DispalyPageState();
}

class _DispalyPageState extends State<DispalyPage> {
  final String input1 =
      """[{"0":{"id":1,"title":"Gingerbread"},"1":{"id":2,"title":"Jellybean"},"3":{"id":3,"title":"KitKat"}},[{"id":4,"title":"Lollipop"},{"id":5,"title":"Pie"},{"id":6,"title":"Oreo"},{"id":7,"title":"Nougat"}]]""";

  final String input2 =
      """[{"0":{"id":1,"title":"Gingerbread"},"1":{"id":2,"title":"Jellybean"},"3":{"id":3,"title":"KitKat"}},{"0":{"id":8,"title":"Froyo"},"2":{"id":9,"title":"Éclair"},"3":{"id":10,"title":"Donut"}},[{"id":4,"title":"Lollipop"},{"id":5,"title":"Pie"},{"id":6,"title":"Oreo"},{"id":7,"title":"Nougat"}]]""";

  bool isLoading = false;
  List<AndroidVerison> demoList = [];
  List<AndroidVerison> dataList = [];

  @override
  void initState() {
    super.initState();
    getData(widget.title == "Display 1" ? input1 : input2);
  }

  getData(String inputData) async {
    isLoading = true;
    setState(() {});
    var data = List<dynamic>.from(json.decode(inputData));
    for (var element in data) {
      if (element.runtimeType == List) {
        var el = element as List;
        for (var lData in el) {
          demoList.add(AndroidVerison(id: lData['id'], title: lData['title']));
        }
      } else {
        element.forEach((key, value) {
          demoList.add(AndroidVerison(id: value['id'], title: value['title']));
        });
      }
    }
    dataList = demoList;
    isLoading = false;
    setState(() {});
  }

  searchData(String id) {
    List<AndroidVerison> results = [];
    if (id.isEmpty) {
      results = demoList;
    } else {
      results = demoList
          .where((element) =>
              element.id.toString().toLowerCase().contains(id.toLowerCase()))
          .toList();
    }
    dataList = results;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(
                color: Colors.blue,
              ),
            )
          : Padding(
              padding: EdgeInsets.all(size.width * 0.03),
              child: Column(children: <Widget>[
                TextField(
                  onChanged: (value) {
                    searchData(value);
                  },
                  decoration: InputDecoration(
                      hintText: "Search here",
                      enabledBorder: OutlineInputBorder(
                          borderRadius:
                              BorderRadius.circular(size.width * 0.03),
                          borderSide:
                              const BorderSide(color: Colors.blueAccent)),
                      border: OutlineInputBorder(
                          borderRadius:
                              BorderRadius.circular(size.width * 0.03),
                          borderSide:
                              const BorderSide(color: Colors.blueAccent))),
                ),
                SizedBox(
                  height: size.height * 0.02,
                ),
                Expanded(
                    child: ListView.builder(
                        itemCount: dataList.length,
                        itemBuilder: (context, index) {
                          var result = dataList[index];
                          return Container(
                            margin: EdgeInsets.only(bottom: size.height * 0.03),
                            padding: EdgeInsets.all(size.width * 0.04),
                            decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.circular(size.width * 0.02),
                                border: Border.all(
                                    color: Colors.blueAccent.withOpacity(0.5))),
                            child: Row(children: <Widget>[
                              Text(
                                result.id.toString(),
                              ),
                              Expanded(
                                  child: Center(
                                      child: Text(
                                result.title.toString(),
                                style: const TextStyle(
                                    fontWeight: FontWeight.w600),
                              )))
                            ]),
                          );
                        }))
              ]),
            ),
    );
  }
}
