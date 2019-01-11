import 'package:flutter/material.dart';

import './build_post_list.dart';

class PostsSearch extends SearchDelegate<List> {
  List _posts = new List();
  List _comments = new List();
  PostsSearch(this._posts, this._comments);

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
          icon: Icon(
            Icons.clear,
            color: Colors.pink,
          ),
          onPressed: () {
            query = '';
          })
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
        icon: Icon(
          Icons.arrow_back,
          color: Colors.pink,
        ),
        onPressed: () {
          close(context, null);
        });
  }

  @override
  Widget buildResults(BuildContext context) {
    final results = this
        ._posts
        .where((a) => a['title']['rendered'].toLowerCase().contains(query));

    return query.isEmpty || results.isEmpty
        ? Center(
            child: Text('Nothing found!', style: TextStyle(fontSize: 20.0)),
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
              BuildPostList(results.toList(), this._comments),
            ],
          );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final results = this
        ._posts
        .where((a) => a['title']['rendered'].toLowerCase().contains(query));

    return query.isEmpty
        ? Center(
            child: Text(
              'Start typing to search!',
              style: TextStyle(fontSize: 20.0),
            ),
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
              BuildPostList(results.toList(), this._comments),
            ],
          );
  }
}
