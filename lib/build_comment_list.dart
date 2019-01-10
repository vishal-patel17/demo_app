import 'package:flutter/material.dart';
import 'package:flutter_html_view/flutter_html_view.dart';

class BuildCommentList extends StatelessWidget {
  var postID;
  List comments = new List();
  BuildCommentList(this.postID, this.comments);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: comments == null ? 0 : comments.length,
      itemBuilder: (BuildContext context, int index) {
        return comments[index]['post'] == postID
            ? Column(
                children: <Widget>[
                  Card(
                    elevation: 8.0,
                    child: ListTile(
                      title: HtmlView(
                          data: comments[index]['content']['rendered']),
                      subtitle: Padding(
                        padding: const EdgeInsets.only(left: 15.0),
                        child: Text(comments[index]['date']),
                      ),
                    ),
                  ),
                ],
              )
            : SizedBox();
      },
    );
  }
}
