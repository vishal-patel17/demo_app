import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:flutter_html_view/flutter_html_view.dart';

import 'posts.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Demo App',
      theme: new ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: new HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    this.getPosts();
  }

  bool _isLoading = false;

  List _postNames = new List();

  final String apiUrl = "https://haasyayoga.com/wp-json/wp/v2/";
  List posts;

  // Function to fetch list of posts
  Future<String> getPosts() async {
    setState(() {
      this._isLoading = true;
    });
    var res = await http.get(Uri.encodeFull(apiUrl + "posts?_embed"),
        headers: {"Accept": "application/json"});

    // fill our posts list with results and update state
    setState(() {
      var resBody = json.decode(res.body);
      posts = resBody;
      for (int i = 0; i < posts.length; ++i) {
        _postNames.add(posts[i]["title"]["rendered"]);
      }
      this._isLoading = false;
    });

    print(this._postNames);

    return "Success!";
  }

  void launchURL(String url) async {
    //const url = 'https://flutter.io';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blueAccent,
          title: Text('Demo_app'),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.search),
              onPressed: () {},
            )
          ],
        ),
        drawer: Drawer(),
        body: _isLoading
            ? Center(
                child: CircularProgressIndicator(),
              )
            : ListView.builder(
                itemCount: posts == null ? 0 : posts.length,
                itemBuilder: (BuildContext context, int index) {
                  return Column(
                    children: <Widget>[
                      Card(
                        child: Column(
                          children: <Widget>[
                            FadeInImage.memoryNetwork(
                              fit: BoxFit.scaleDown,
                              placeholder: kTransparentImage,
                              image: posts[index]["featured_media"] == 0
                                  ? '' // post doesn't have image
                                  : posts[index]["_embedded"]
                                      ["wp:featuredmedia"][0]["source_url"],
                            ),
                            Padding(
                              padding: EdgeInsets.all(10.0),
                              child: ListTile(
                                title: Padding(
                                  padding: EdgeInsets.symmetric(vertical: 10.0),
                                  child: Text(posts[index]["title"]["rendered"],
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20.0)),
                                ),
                                subtitle: Text(
                                  posts[index]['excerpt']['rendered']
                                      .replaceAll(RegExp(r'<[^>]*>'), ''),
                                  style: TextStyle(),
                                ),
                              ),
                            ),
                            new ButtonTheme.bar(
                              child: new ButtonBar(
                                children: <Widget>[
                                  new FlatButton(
                                    child: const Text('READ MORE'),
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        new MaterialPageRoute(
                                          builder: (context) =>
                                              new Posts(post: posts[index]),
                                        ),
                                      );
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  );
                },
              ),
      ),
    );
  }
}
