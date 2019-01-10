import 'package:flutter/material.dart';

import './build_post_list.dart';

class PostsSearch extends SearchDelegate<List> {
  List _posts = new List();
  PostsSearch(this._posts);

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
          icon: Icon(Icons.clear),
          onPressed: () {
            query = '';
          })
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
        icon: Icon(Icons.arrow_back),
        onPressed: () {
          close(context, null);
        });
  }

  @override
  Widget buildResults(BuildContext context) {
    return Container();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final results = this
        ._posts
        .where((a) => a['title']['rendered'].toLowerCase().contains(query));
    //print(results.toList());

    return query.isEmpty
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
                  'Search Results',
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
              BuildPostList(results.toList()),
//                    buildList(context),
            ],
          );
  }
}
