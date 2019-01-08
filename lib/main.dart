import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';
import 'package:cached_network_image/cached_network_image.dart';

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
  List _finalPosts = new List();

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

      for (int i = 0; i < posts.length; ++i) {
        if (posts[i]['categories'][0] == 6) {
          _finalPosts = posts;
        }
      }

      //print(_finalPosts);

      this._isLoading = false;
    });

    //print(posts);

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
                  return posts[index]['categories'][0] == 6
                      ? Column(
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 15.0,
                                  top: 8.0,
                                  right: 15.0,
                                  bottom: 8.0),
                              child: Card(
                                elevation: 8.0,
                                child: Column(
                                  children: <Widget>[
                                    CachedNetworkImage(
                                      alignment: Alignment.center,
                                      fit: BoxFit.fill,
                                      height: 150.0,
                                      width: MediaQuery.of(context).size.width,
                                      imageUrl:
                                          posts[index]["featured_media"] == 0
                                              ? '' // post doesn't have image
                                              : posts[index]["_embedded"]
                                                      ["wp:featuredmedia"][0]
                                                  ["source_url"],
                                      placeholder: CircularProgressIndicator(),
                                      errorWidget: Icon(Icons.error),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(top: 10.0),
                                      child: ListTile(
                                        title: Padding(
                                          padding: EdgeInsets.symmetric(
                                              vertical: 10.0),
                                          child: Text(
                                              posts[index]["title"]["rendered"],
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 20.0)),
                                        ),
                                        subtitle: Text(
                                          posts[index]['excerpt']['rendered']
                                              .replaceAll(
                                                  RegExp(r'<[^>]*>'), ''),
                                          style: TextStyle(),
                                        ),
                                      ),
                                    ),
                                    ButtonTheme.bar(
                                      child: ButtonBar(
                                        alignment: MainAxisAlignment.end,
                                        children: <Widget>[
                                          FlatButton(
                                            child: const Text('READ MORE'),
                                            onPressed: () {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      new Posts(
                                                          post: posts[index]),
                                                ),
                                              );
                                            },
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            )
                          ],
                        )
                      : null;
                },
              ),
      ),
    );
  }
}
