import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:collection/collection.dart';

import 'posts.dart';

class CategoryPosts extends StatefulWidget {
  var post;
  CategoryPosts({Key key, @required var this.post}) : super(key: key);
  @override
  _CategoryPostsState createState() => _CategoryPostsState();
}

class _CategoryPostsState extends State<CategoryPosts> {
  @override
  void initState() {
    super.initState();
    getCategoryCode();
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
    //arr.clear();
    print("categories:  ${widget.post[0]['categories']}");
    print("Array:  ${this.arr}");
    print(eq(widget.post[0]['categories'], this.arr));
    return Scaffold(
      appBar: AppBar(),
      body: ListView.builder(
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
                              borderRadius: new BorderRadius.circular(8.0),
                              boxShadow: <BoxShadow>[
                                new BoxShadow(
                                  color: Colors.black12,
                                  blurRadius: 10.0,
                                  offset: new Offset(0.0, 10.0),
                                ),
                              ],
                            ),
                            child: Padding(
                              padding:
                                  const EdgeInsets.only(left: 50.0, top: 10.0),
                              child: ListTile(
                                title: Text(
                                    widget.post[index]["title"]["rendered"],
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18.0)),
                                subtitle: Padding(
                                  padding: const EdgeInsets.only(top: 8.0),
                                  child: Text(
                                    widget.post[index]['excerpt']['rendered']
                                        .replaceAll(RegExp(r'<[^>]*>'), ''),
                                    style: TextStyle(),
                                  ),
                                ),
                                trailing: Padding(
                                  padding: const EdgeInsets.only(top: 28.0),
                                  child: IconButton(
                                      icon: Icon(
                                        Icons.navigate_next,
                                        color: Colors.blueAccent,
                                      ),
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => new Posts(
                                                post: widget.post[index]),
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
                            margin: new EdgeInsets.symmetric(vertical: 16.0),
                            alignment: FractionalOffset.centerLeft,
                            child: CachedNetworkImage(
                              fit: BoxFit.fill,
                              height: 92.0,
                              width: 98.0,
                              imageUrl:
                                  widget.post[index]["featured_media"] == 0
                                      ? '' // post doesn't have image
                                      : widget.post[index]["_embedded"]
                                          ["wp:featuredmedia"][0]["source_url"],
                              placeholder: CircularProgressIndicator(),
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
    );
  }
}
