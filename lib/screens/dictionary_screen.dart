import 'package:dictionary/screens/second_screen.dart';
import 'package:flutter/material.dart';

import '../db/dbhelper.dart';
import '../models/dictionary_data.dart';

class DictionaryScreen extends StatefulWidget {
  const DictionaryScreen({Key? key}) : super(key: key);

  @override
  State<DictionaryScreen> createState() => _DictionaryScreenState();
}

class _DictionaryScreenState extends State<DictionaryScreen> {
  List<DictionaryData> words = [];
  var db = DbHelper.instance;
  String query = "";
  bool favourite = false;

  @override
  void initState() {
    super.initState();
    db.getSelectWords(query).then((value) {
      setState(() {
        words.clear();
        words.addAll(value);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey,
      appBar: AppBar(
        title: Text(
          "Dictionary search ",
          style: TextStyle(
              color: Colors.white, fontSize: 24, fontWeight: FontWeight.w500),
        ),
        actions: [
          IconButton(
            onPressed: () {
              if (!favourite) {
                db.getFavouriteWords(query).then((value) {
                  setState(() {
                    words.clear();
                    words.addAll(value);
                  });
                });
                setState(() {
                  favourite = true;
                });
              } else {
                db.getSelectWords(query).then((value) {
                  setState(() {
                    words.clear();
                    words.addAll(value);
                  });
                });
                setState(() {
                  favourite = true;
                });
              }
            },
            icon: Icon(
              favourite ? Icons.star : Icons.star_border,
              color: Colors.yellow,
            ),
            tooltip: 'Amirdin',
          )
        ],
        backgroundColor: Colors.black38,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Card(
            margin: EdgeInsets.all(8),
            child: TextField(
              onChanged: (newText) {
                onTextChanged(newText);
              },
              decoration: InputDecoration(
                prefix: Icon(Icons.search, size: 24),
                border: OutlineInputBorder(),
                //labelText: 'Please enter the nameS',
                hintText: 'Search',
              ),
              style: TextStyle(
                fontSize: 18,
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: words.length,
              itemBuilder: (BuildContext context, int index) {
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              SeconScreen(dictionaryData: words[index]),
                          settings: RouteSettings(
                            arguments: words[index].word,
                          ),
                        ));
                  },
                  child: Card(
                    child: ListTile(
                      title: Text('${words[index].word}'),
                      subtitle: Text('${words[index].wordtype}'),
                      trailing: GestureDetector(
                        onTap: () {
                          db
                              .setFavourite(
                            DictionaryData(
                                word: words[index].word,
                                favourite: words[index].favourite == 0 ? 1 : 0,
                                definition: words[index].definition,
                                wordtype: words[index].wordtype),
                          )
                              .then((value) {
                            setState(
                              () {
                                words[index].favourite == 0
                                    ? words[index].favourite = 1
                                    : words[index].favourite = 0;
                              },
                            );
                          });
                        },
                        child: Icon(
                          words[index].favourite == 0
                              ? Icons.star
                              : Icons.star_border,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          )
        ],
      ),
    );
  }

  onTextChanged(String newText) {
    query = newText;
    if (favourite) {
      db.getFavouriteWords(newText).then((value) {
        setState(() {
          words.clear();
          words.addAll(value);
        });
      });
    } else {
      db.getSelectWords(newText).then((value) {
        setState(() {
          words.clear();
          words.addAll(value);
        });
      });
    }
  }
}
