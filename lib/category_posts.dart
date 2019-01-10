import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:collection/collection.dart';

import './posts.dart';
import './main.dart';
import './category_backpain.dart';
import './posts_search.dart';

class CategoryPosts extends StatefulWidget {
  var post;
  var comments;
  CategoryPosts({Key key, @required var this.post, this.comments})
      : super(key: key);
  @override
  _CategoryPostsState createState() => _CategoryPostsState();
}

class _CategoryPostsState extends State<CategoryPosts> {
  @override
  void initState() {
    super.initState();
    getCategoryCode();
  }

  Future<Null> refreshPage() async {
    await Future.delayed(Duration(seconds: 1));

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => CategoryPosts(
              post: widget.post,
            ),
      ),
    );

    return null;
  }

  Function eq = const ListEquality().equals;

  List<int> arr;
  void getCategoryCode() {
    setState(() {
      this.arr = [6, 7];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.pink),
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              showSearch(
                  context: context,
                  delegate: PostsSearch(widget.post, widget.comments));
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
                  child: Text(
                "Categories",
                style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
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
                      color: Colors.pink,
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
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => new CategoryPosts(
                                  post: this.widget.post,
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
                                post: widget.post,
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(
                  top: 8.0, bottom: 8.0, left: 20.0, right: 8.0),
              child: Text(
                'YOGA FOR DIGESTION',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20.0,
                    color: Colors.blue,
                    letterSpacing: 3.5),
              ),
            ),
            Container(
              margin: EdgeInsets.only(left: 20.0, right: 300.0),
              height: 1.5,
              color: Colors.pink,
            ),
            Expanded(
              child: Container(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: widget.post == null ? 0 : widget.post.length,
                  itemBuilder: (BuildContext context, int index) {
                    return eq(widget.post[index]['categories'], this.arr)
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
                                              widget.post[index]["title"]
                                                  ["rendered"],
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 18.0)),
                                          subtitle: Padding(
                                            padding:
                                                const EdgeInsets.only(top: 8.0),
                                            child: Text(
                                              widget.post[index]['excerpt']
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
                                                              post: widget
                                                                  .post[index]),
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
                                        imageUrl: widget.post[index]
                                                    ["featured_media"] ==
                                                0
                                            ? '' // post doesn't have image
                                            : widget.post[index]["_embedded"]
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
            )
          ],
        ),
      ),
    );
  }
}
