import 'package:flutter/material.dart';
import 'package:news/src/widgets/loading_container.dart';
import '../models/item_model.dart';
import 'dart:async';
import '../blocs/stories_provider.dart';
import 'loading_container.dart';

class NewsListTile extends StatelessWidget {
  final int itemId;
  final String query;

  NewsListTile({this.itemId, this.query});

  @override
  Widget build(BuildContext context) {
    final bloc = StoriesProvider.of(context);
    return StreamBuilder(
      stream: bloc.items,
      builder: (context, AsyncSnapshot<Map<int, Future<ItemModel>>> snapshot) {
        if (!snapshot.hasData) {
          return LoadingContainer();
        }
        return FutureBuilder(
          future: snapshot.data[itemId],
          builder: (context, AsyncSnapshot<ItemModel> itemSnapshot) {
            if (!itemSnapshot.hasData) {
              return LoadingContainer();
            } else if (itemSnapshot.data.title.toLowerCase().contains(query)) {
              return Padding(
                padding: const EdgeInsets.all(5.0),
                child: Container(
                    padding: EdgeInsets.all(10.0),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Color.fromRGBO(233, 233, 233, 1),
                      ),
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    child: buildTile(context, itemSnapshot.data)),
              );
            } else {
              return Container(
                height: 0.0,
                width: 0.0,
              );
            }
          },
        );
      },
    );
  }

  Widget buildTile(BuildContext context, ItemModel item) {
    return Column(
      children: <Widget>[
        ListTile(
          onTap: () {
            Navigator.pushNamed(context, '/${item.id}');
          },
          title: Text(
            item.title,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 16.0,
            ),
          ),
          subtitle: Text(
            '${item.score} upvotes',
            style: TextStyle(fontStyle: FontStyle.italic),
          ),
          trailing: Column(
            children: <Widget>[
              Icon(Icons.comment),
              Text('${item.descendants}'),
            ],
          ),
        ),
        // Divider(
        //   height: 8.0,
        //   thickness: 2.0,
        // )
      ],
    );
  }
}
