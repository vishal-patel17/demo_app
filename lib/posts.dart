import 'package:flutter/material.dart';
import 'package:flutter_html_view/flutter_html_view.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:share/share.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:url_launcher/url_launcher.dart';

import './build_comment_list.dart';
import './main.dart';
import 'main.dart';

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
    // TODO: implement initState
    super.initState();
    //getComments();
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
        title: new Text(widget.post['title']['rendered']),
      ),
      body: RefreshIndicator(
        onRefresh: refreshPage,
        child: _isLoading
            ? Center(
                child: CircularProgressIndicator(),
              )
            : Padding(
                padding: EdgeInsets.all(16.0),
                child: ListView(
                  children: <Widget>[
                    CachedNetworkImage(
                      imageUrl: widget.post["featured_media"] == 0
                          ? ''
                          : widget.post["_embedded"]["wp:featuredmedia"][0]
                              ["source_url"],
                      placeholder: CircularProgressIndicator(),
                      errorWidget: Icon(Icons.error),
                    ),
                    SizedBox(height: 8.0),
                    HtmlView(data: widget.post['content']['rendered']),
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
