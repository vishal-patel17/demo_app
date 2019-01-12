import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:share/share.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_html/flutter_html.dart';

import './build_comment_list.dart';

class Posts extends StatefulWidget {
  var post;
  var comments;
  Posts({Key key, @required var this.post, this.comments}) : super(key: key);
  @override
  _PostsState createState() => _PostsState();
}

class _PostsState extends State<Posts> {
  @override
  void initState() {
    super.initState();
  }

  bool _isLoading = false;

  void launchURL(String url) async {
    //const url = 'https://flutter.io';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  Future<String> getComments() async {
    setState(() {
      this._isLoading = true;
    });
    final String apiUrl = "https://haasyayoga.com/wp-json/wp/v2/";

    var resComments = await http.get(Uri.encodeFull(apiUrl + "comments?_embed"),
        headers: {"Accept": "application/json"});

    setState(() {
      var resCommentBody = json.decode(resComments.body);
      widget.comments = resCommentBody;
    });

    _isLoading = false;

    return "Success!";
  }

  Future<Null> refreshPage() async {
    await Future.delayed(Duration(seconds: 1));

    getComments();

    return null;
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        iconTheme: IconThemeData(color: Colors.pink),
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        actions: <Widget>[
          PopupMenuButton(
              itemBuilder: (_) => <PopupMenuItem<String>>[
                    new PopupMenuItem<String>(
                        child: const Text('Option 1 '), value: 'Option 1'),
                    new PopupMenuItem<String>(
                        child: const Text('Option 2'), value: 'Option 2'),
                  ],
              onSelected: (value) {
                if (value == 'Option 1') {
                  print('Create PDF');
                }
                if (value == 'Option 2') {
                  print('Option 2');
                }
              }),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: refreshPage,
        child: _isLoading
            ? Center(
                child: CircularProgressIndicator(),
              )
            : Padding(
                padding: EdgeInsets.only(left: 16.0, bottom: 16.0, right: 16.0),
                child: ListView(
                  children: <Widget>[
                    Text(
                      widget.post['title']['rendered'],
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20.0,
                          color: Colors.blue,
                          letterSpacing: 3.5),
                    ),
                    SizedBox(
                      height: 5.0,
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 4.0, right: 330.0),
                      height: 1.5,
                      color: Colors.pink,
                    ),
                    SizedBox(height: 8.0),
                    Html(data: widget.post['content']['rendered']),
//                    HtmlView(data: widget.post['content']['rendered']),
                    SizedBox(height: 8.0),
                    Text('Comments',
                        style: TextStyle(
                            fontWeight: FontWeight.w500,
                            color: Colors.pink,
                            fontSize: 20.0)),
                    Container(
                      margin:
                          EdgeInsets.only(left: 5.0, right: 320.0, top: 5.0),
                      height: 1.5,
                      color: Colors.pink,
                    ),
                    SizedBox(height: 10.0),
                    BuildCommentList(widget.post['id'], widget.comments),
                    ButtonTheme.bar(
                      child: ButtonBar(
                        children: <Widget>[
                          IconButton(
                              icon: Icon(Icons.comment),
                              color: Colors.pink,
                              onPressed: () {
                                launchURL(widget.post['link'] + '#comment');
                              }),
                          IconButton(
                              icon: Icon(Icons.share),
                              color: Colors.pink,
                              onPressed: () {
                                Share.share(widget.post['link']);
                              }),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}
