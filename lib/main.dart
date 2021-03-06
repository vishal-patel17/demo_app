import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

import './category_posts.dart';
import './category_backpain.dart';
import './build_post_list.dart';
import './posts_search.dart';
import 'package:connectivity/connectivity.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      debugShowCheckedModeBanner: false,
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
    checkConnectivity();
  }

  bool _isConnected = false;

  Future<void> checkConnectivity() async {
    var connectivityResult = await (new Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi) {
      setState(() {
        this._isConnected = true;
      });
      getPostsAndComments();
    } else if (connectivityResult == ConnectivityResult.none) {
      setState(() {
        this._isConnected = false;
      });
    } else {
      setState(() {
        this._isConnected = false;
      });
    }
  }

  bool _isLoading = false;
  final String apiUrl = "https://haasyayoga.com/wp-json/wp/v2/";
  List posts;
  List comments;

  Future<String> getPostsAndComments() async {
    setState(() {
      this._isLoading = true;
    });
    var res = await http.get(Uri.encodeFull(apiUrl + "posts?_embed"),
        headers: {"Accept": "application/json"});

    var resComments = await http.get(Uri.encodeFull(apiUrl + "comments?_embed"),
        headers: {"Accept": "application/json"});

    if (res.statusCode == 200) {
      setState(() {
        var resBody = json.decode(res.body);
        posts = resBody;

        var resCommentBody = json.decode(resComments.body);
        comments = resCommentBody;

        this._isLoading = false;
      });
      return "Success!";
    } else {
      this._isLoading = false;
      return "Failure";
    }
  }

  void launchURL(String url) async {
    //const url = 'https://flutter.io';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  Future<Null> refreshPage() async {
    await Future.delayed(Duration(seconds: 1));
    getPostsAndComments();

    return null;
  }

  @override
  Widget build(BuildContext context) {
    return _isConnected
        ? MaterialApp(
            debugShowCheckedModeBanner: false,
            home: Scaffold(
              //backgroundColor: new Color(0xFF333366),
              appBar: AppBar(
                iconTheme: IconThemeData(color: Colors.pink),
                backgroundColor: Colors.transparent,
                elevation: 0.0,
                actions: <Widget>[
                  IconButton(
                    icon: Icon(
                      Icons.search,
                      color: Colors.pink,
                    ),
                    onPressed: () {
                      showSearch(
                          context: context,
                          delegate: PostsSearch(this.posts, this.comments));
                    },
                  )
                ],
              ),
              drawer: Drawer(
                elevation: 16.0,
                child: new ListView(
                  children: <Widget>[
                    new DrawerHeader(
                      child: Center(
                        child: GestureDetector(
                          child: Text(
                            "HAASYAYOGA",
                            style: TextStyle(
                                fontSize: 20.0, fontWeight: FontWeight.bold),
                          ),
                          onTap: () => launchURL('https://haasyayoga.com/'),
                        ),
                      ),
                      //decoration: BoxDecoration(color: Colors.blue),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ListView(
                        shrinkWrap: true,
                        children: <Widget>[
                          ListTile(
                            leading: Icon(
                              Icons.home,
                              color: Colors.pink,
                              size: 25.0,
                            ),
                            title:
                                Text('HOME', style: TextStyle(fontSize: 15.0)),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => new HomePage(),
                                ),
                              );
                            },
                          ),
                          ListTile(
                              leading: Icon(
                                Icons.category,
                                color: Colors.pink,
                                size: 25.0,
                              ),
                              title: Text(
                                "Yoga for digestion",
                                style: TextStyle(fontSize: 15.0),
                              ),
                              trailing: Icon(
                                Icons.navigate_next,
                                color: Colors.blueAccent,
                              ),
                              onTap: () {
//                          Navigator.of(context).pop();
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => new CategoryPosts(
                                          post: this.posts,
                                        ),
                                  ),
                                );
                              }),
                          ListTile(
                            leading: Icon(
                              Icons.category,
                              color: Colors.pink,
                              size: 25.0,
                            ),
                            title: new Text("Yoga for back pain",
                                style: TextStyle(fontSize: 15.0)),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => new CategoryBackPain(
                                        post: this.posts,
                                      ),
                                ),
                              );
                            },
                            trailing: Icon(
                              Icons.navigate_next,
                              color: Colors.blueAccent,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              body: RefreshIndicator(
                onRefresh: refreshPage,
                child: _isLoading
                    ? Center(
                        child: CircularProgressIndicator(),
                      )
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.only(
                                top: 8.0, bottom: 8.0, left: 20.0, right: 8.0),
                            child: Text(
                              'LATEST BLOG POSTS',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20.0,
                                  color: Colors.blue,
                                  letterSpacing: 3.5),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(left: 20.0, right: 330.0),
                            height: 1.5,
                            color: Colors.pink,
                          ),
                          BuildPostList(this.posts, this.comments),
                        ],
                      ),
              ),
            ),
          )
        : Scaffold(
            body: Center(
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    'You appear to be offline!',
                    style: TextStyle(fontSize: 20.0),
                  ),
                  IconButton(
                    icon: Icon(Icons.refresh),
                    onPressed: () => checkConnectivity(),
                  ),
                ],
              ),
            ),
          );
  }
}
