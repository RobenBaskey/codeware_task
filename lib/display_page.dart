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
      """[{"0":{"id":1,"title":"Gingerbread"},"1":{"id":2,"title":"Jellybean"},"2":{"id":3,"title":"KitKat"}},[{"id":4,"title":"Lollipop"},{"id":5,"title":"Pie"},{"id":6,"title":"Oreo"},{"id":7,"title":"Nougat"},{"id":8,"title":"Marshmellow"}],{"0":{"id":1,"title":"Gingerbread"},"4":{"id":3,"title":"KitKat"}}]""";

  final String input2 =
      """[{"0":{"id":1,"title":"Gingerbread"},"1":{"id":2,"title":"Jellybean"},"3":{"id":3,"title":"KitKat"}},{"0":{"id":8,"title":"Froyo"},"2":{"id":9,"title":"Éclair"},"3":{"id":10,"title":"Donut"}},[{"id":4,"title":"Lollipop"},{"id":5,"title":"Pie"},{"id":6,"title":"Oreo"},{"id":7,"title":"Nougat"}]]""";

  bool isLoading = false;
  int _maximumIndexNo = 0;
  int _mapMaximumLength = 0;
  List<AndroidVerison> demoList = [];
  List<AndroidVerison> dataList = [];

  @override
  void initState() {
    super.initState();
    getData(widget.title == "Output-1" ? input1 : input2);
  }

  getData(String inputData) async {
    isLoading = true;
    setState(() {});
    var data = List<dynamic>.from(json.decode(inputData));

    for (var myData in data) {
      if (myData.runtimeType == List) {
        var el = myData as List;
        _maximumIndexNo =
            el.length > _maximumIndexNo ? el.length : _maximumIndexNo;
      } else {
        var el = myData as Map;
        int lastLength = int.parse(el.entries.last.key.toString());
        _mapMaximumLength = lastLength + 1;
        _maximumIndexNo =
            lastLength > _maximumIndexNo ? lastLength : _maximumIndexNo;
      }
    }
    print("Max grid $_maximumIndexNo");

    for (var element in data) {
      if (element.runtimeType == List) {
        var el = element as List;
        for (int i = 0; i < _maximumIndexNo; i++) {
          if (el.length <= i) {
            demoList.add(AndroidVerison());
          } else {
            demoList
                .add(AndroidVerison(id: el[i]['id'], title: el[i]['title']));
          }
        }
      } else {
        var loop = 0;
        _mapMaximumLength = 0;
        var el = element as Map;
        el.forEach((key, value) {
          int k = int.parse(key.toString());
          var difference = k - loop;
          if (difference != 0) {
            for (int i = 0; i < difference; i++) {
              demoList.add(AndroidVerison());
              loop++;
            }
            demoList
                .add(AndroidVerison(id: value['id'], title: value['title']));
            loop++;
          } else {
            demoList
                .add(AndroidVerison(id: value['id'], title: value['title']));
            loop++;
          }
        });

        var length = _mapMaximumLength > loop ? _mapMaximumLength : loop;
        _maximumIndexNo = length > _maximumIndexNo ? length : _maximumIndexNo;
        print("Map max len $length");
        for (int i = 1; i <= _maximumIndexNo; i++) {
          if (length < _maximumIndexNo) {
            demoList.add(AndroidVerison());
            ++length;
          } else {
            ++length;
          }
        }
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
                    child: SingleChildScrollView(
                  child: Container(
                    padding: EdgeInsets.all(size.width * 0.02),
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.black, width: 3)),
                    child: Column(children: <Widget>[
                      Text(
                        widget.title,
                        style: const TextStyle(
                            fontWeight: FontWeight.w700,
                            decoration: TextDecoration.underline),
                      ),
                      SizedBox(
                        height: size.height * 0.02,
                      ),
                      GridView.builder(
                          shrinkWrap: true,
                          padding: const EdgeInsets.all(0),
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: dataList.length,
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisSpacing: size.width * 0.01,
                                  mainAxisSpacing: size.width * 0.01,
                                  crossAxisCount: _maximumIndexNo),
                          itemBuilder: (context, index) {
                            return Center(
                                child: Text(
                              dataList[index].title ?? "",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontSize: size.width * 0.03),
                            ));
                          })
                    ]),
                  ),
                ))
              ]),
            ),
    );
  }
}
