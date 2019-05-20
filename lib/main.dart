import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

void main() {
  runApp(APIApp());
}

class APIApp extends StatefulWidget {
  @override
  _APIAppState createState() => _APIAppState();
}

class _APIAppState extends State<APIApp> {
  var data;
  Future<List> GetData() async {
    http.Response response = await http.get(
      Uri.encodeFull('https://jsonplaceholder.typicode.com/photos'),
      headers: {"Accept": "Application/json"},
    );
    this.setState(() {
      data = json.decode(response.body);
    });
  }

  @override
  void initState() {
    this.GetData();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'api',
      home: Scaffold(
        appBar: AppBar(),
        body: RefreshIndicator(
          onRefresh: _handleRefresh,
          child: ListView.builder(
            itemCount: data == null ? 0 : data.length,
            itemBuilder: (BuildContext context, int index) {
              var url = data[index]['url'];
              var id = data[index]['id'];
              return Padding(
                padding: EdgeInsets.all(5),
                child: Card(
                  color: Colors.grey[300],
                  elevation: 8,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(25),
                    ),
                  ),
                  child: Column(
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.all(5),
                        child: Container(
                          height: 200,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                                image: NetworkImage(url), fit: BoxFit.cover),
                            borderRadius: BorderRadius.all(
                              Radius.circular(25),
                            ),
                          ),
                        ),
                      ),
                      Column(
                        children: <Widget>[
                          Text(
                            'ID: $id',
                            style: TextStyle(
                                fontSize: 18,
                                fontStyle: FontStyle.italic,
                                fontWeight: FontWeight.bold),
                            textAlign: TextAlign.center,
                          ),
                          Text(
                            data[index]['title'],
                            overflow: TextOverflow.clip,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 15, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      Padding(
                        padding: EdgeInsets.only(bottom: 5),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Future<Null> _handleRefresh() async {
    await new Future.delayed(new Duration(milliseconds: 1500));
    return null;
  }
}
