import 'package:flutter/material.dart';
import 'package:flutter_html_view/flutter_html_view.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:share/share.dart';

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
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text(widget.post['title']['rendered']),
      ),
      body: new Padding(
        padding: EdgeInsets.all(16.0),
        child: new ListView(
          children: <Widget>[
            new CachedNetworkImage(
              imageUrl: widget.post["featured_media"] == 0
                  ? ''
                  : widget.post["_embedded"]["wp:featuredmedia"][0]
                      ["source_url"],
              placeholder: new CircularProgressIndicator(),
              errorWidget: new Icon(Icons.error),
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
              margin: EdgeInsets.only(left: 5.0, right: 320.0, top: 5.0),
              height: 1.5,
              color: Colors.pink,
            ),
            SizedBox(height: 10.0),
            BuildCommentList(widget.post['id'], widget.comments),
            ButtonTheme.bar(
              child: new ButtonBar(
                children: <Widget>[
                  IconButton(
                      icon: Icon(Icons.comment),
                      color: Colors.pink,
                      onPressed: () {}),
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
    );
  }
}
