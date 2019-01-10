import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

import './posts.dart';

class BuildPostList extends StatelessWidget {
  List _post = new List();
  List _comments = new List();
  BuildPostList(this._post, this._comments);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        child: ListView.builder(
          shrinkWrap: true,
          itemCount: _post == null ? 0 : _post.length,
          itemBuilder: (BuildContext context, int index) {
            return _post[index]['categories'][0] == 6
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
                                padding: const EdgeInsets.only(
                                    left: 50.0, top: 10.0),
                                child: ListTile(
                                  title: Text(_post[index]["title"]["rendered"],
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18.0)),
                                  subtitle: Padding(
                                    padding: const EdgeInsets.only(top: 8.0),
                                    child: Text(
                                      _post[index]['excerpt']['rendered']
                                          .replaceAll(RegExp(r'<[^>]*>'), ''),
                                      style: TextStyle(color: Colors.black54),
                                      textAlign: TextAlign.start,
                                    ),
                                  ),
                                  trailing: Padding(
                                    padding: const EdgeInsets.only(top: 20.0),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: <Widget>[
                                        IconButton(
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
                                                        post: _post[index],
                                                        comments:
                                                            this._comments,
                                                      ),
                                                ),
                                              );
                                            }),
                                      ],
                                    ),
                                  ),
                                  isThreeLine: true,
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
                                imageUrl: _post[index]["featured_media"] == 0
                                    ? '' // post doesn't have image
                                    : _post[index]["_embedded"]
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
      ),
    );
  }
}
