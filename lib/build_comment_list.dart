import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:intl/intl.dart';
import 'package:flutter_html/flutter_html.dart';

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
                      title: Html(data: comments[index]['content']['rendered']),
                      subtitle: Text("- ${comments[index]['author_name']}"),
                      leading: CachedNetworkImage(
                        imageUrl: comments[index]['author_avatar_urls']['48'],
                        placeholder: CircularProgressIndicator(),
                        errorWidget: Icon(Icons.error),
                      ),
                      trailing: Padding(
                        padding: const EdgeInsets.only(left: 10.0),
                        child: Text(
                            "${DateFormat.yMMMd().format(DateTime.parse(comments[index]['date'].substring(0, 10) + comments[index]['date'].substring(10)))}"),
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
