import 'dart:convert';

import 'package:cloudium/model/aerticlemodel.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  List<Article> articleslist = [];
  Future<List<Article>> fetchArticles() async {
    String apiUrl =
        "http://api.nytimes.com/svc/mostpopular/v2/mostviewed/all-sections/7.json?api-key=Gs68yllHxm92qMaoHZca1frTiqT7nXGh";
    var response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      List<dynamic> data = [];

      data = json.decode(response.body)['results'];
      if (data.isNotEmpty) {
        for (int i = 0; i < data.length; i++) {
          if (data[i] != null) {
            Map<String, dynamic> map = data[i];
            articleslist.add(Article.fromJson(map));
          }
        }
      }

      return articleslist;
    } else {
      throw Exception("Failed to load articles");
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            appBar: AppBar(
              backgroundColor: const Color.fromRGBO(62, 201, 157, 1),
              automaticallyImplyLeading: false,
              leading: const Icon(Icons.dehaze_outlined),
              leadingWidth: 50,
              title: const Text("NY Times Most Popular"),
              actions: [
                IconButton(onPressed: () {}, icon: Icon(Icons.search)),
                IconButton(
                    onPressed: () {}, icon: Icon(Icons.more_vert_outlined))
              ],
            ),
            body: Padding(
                padding: const EdgeInsets.only(top: 10),
                child: FutureBuilder<List<Article>>(
                    future: fetchArticles(),
                    builder: (BuildContext context, AsyncSnapshot snapshot) {
                      return ListView.separated(
                          itemBuilder: (BuildContext context, int index) {
                            return ListTile(
                              leading: Container(
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.grey,
                                ),
                                height: 50,
                                width: 50,
                              ),
                              title: Text(
                                articleslist[index].title,
                                maxLines: 2,
                                softWrap: true,
                              ),
                              subtitle: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(articleslist[index].byline),
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      const Icon(Icons.date_range_outlined),
                                      Text(articleslist[index].publishedDate)
                                    ],
                                  )
                                ],
                              ),
                              trailing: Icon(Icons.navigate_next_outlined),
                            );
                          },
                          separatorBuilder: (BuildContext context, int index) =>
                              SizedBox(
                                height: 10,
                              ),
                          itemCount: articleslist.length);
                    }))));
  }
}
