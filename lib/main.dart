import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';
import 'package:cached_network_image/cached_network_image.dart';

import 'posts.dart';
import 'category_posts.dart';

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

  Future<Null> refreshPage() async {
    await Future.delayed(Duration(seconds: 1));

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => HomePage(),
      ),
    );

    return null;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        //backgroundColor: new Color(0xFF333366),
        appBar: AppBar(
          iconTheme: IconThemeData(color: Colors.pink),
          backgroundColor: Colors.transparent,
          elevation: 0.0,
          //title: Text('Demo_app'),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.search),
              onPressed: () {},
            )
          ],
        ),
        drawer: Drawer(
            elevation: 16.0,
            child: new ListView(
              children: <Widget>[
                new DrawerHeader(
                  child: Center(
                      child: Text(
                    "Categories",
                    style:
                        TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
                  )),
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
                          color: Colors.black,
                          size: 25.0,
                        ),
                        title: Text('HOME', style: TextStyle(fontSize: 15.0)),
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
                            color: Colors.black,
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
                          color: Colors.black,
                          size: 25.0,
                        ),
                        title: new Text("Yoga for back pain",
                            style: TextStyle(fontSize: 15.0)),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => new CategoryPosts(
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
            )),
        body: RefreshIndicator(
          onRefresh: refreshPage,
          child: _isLoading
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : ListView.builder(
                  shrinkWrap: true,
                  itemCount: posts == null ? 0 : posts.length,
                  itemBuilder: (BuildContext context, int index) {
                    return posts[index]['categories'][0] == 6
                        ? Column(
                            children: <Widget>[
                              Container(
                                margin: const EdgeInsets.symmetric(
                                  vertical: 16.0,
                                  horizontal: 24.0,
                                ),
                                child: Stack(
                                  children: <Widget>[
                                    Container(
                                      height: 124.0,
                                      margin: new EdgeInsets.only(left: 46.0),
                                      decoration: new BoxDecoration(
                                        color: Colors.white,
                                        shape: BoxShape.rectangle,
                                        borderRadius:
                                            new BorderRadius.circular(8.0),
                                        boxShadow: <BoxShadow>[
                                          new BoxShadow(
                                            color: Colors.black12,
                                            blurRadius: 10.0,
                                            offset: new Offset(0.0, 10.0),
                                          ),
                                        ],
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                            left: 50.0, top: 10.0),
                                        child: ListTile(
                                          title: Text(
                                              posts[index]["title"]["rendered"],
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 18.0)),
                                          subtitle: Padding(
                                            padding:
                                                const EdgeInsets.only(top: 8.0),
                                            child: Text(
                                              posts[index]['excerpt']
                                                      ['rendered']
                                                  .replaceAll(
                                                      RegExp(r'<[^>]*>'), ''),
                                              style: TextStyle(),
                                            ),
                                          ),
                                          trailing: Padding(
                                            padding: const EdgeInsets.only(
                                                top: 28.0),
                                            child: IconButton(
                                                icon: Icon(
                                                  Icons.navigate_next,
                                                  color: Colors.blueAccent,
                                                ),
                                                onPressed: () {
                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (context) =>
                                                          new Posts(
                                                              post:
                                                                  posts[index]),
                                                    ),
                                                  );
                                                }),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Container(
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                      ),
                                      margin: new EdgeInsets.symmetric(
                                          vertical: 16.0),
                                      alignment: FractionalOffset.centerLeft,
                                      child: CachedNetworkImage(
                                        fit: BoxFit.fill,
                                        height: 92.0,
                                        width: 98.0,
                                        imageUrl:
                                            posts[index]["featured_media"] == 0
                                                ? '' // post doesn't have image
                                                : posts[index]["_embedded"]
                                                        ["wp:featuredmedia"][0]
                                                    ["source_url"],
                                        placeholder:
                                            CircularProgressIndicator(),
                                        errorWidget: Icon(Icons.error),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          )
                        : SizedBox();
                  },
                ),
        ),
      ),
    );
  }
}
