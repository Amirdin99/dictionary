import 'package:dictionary/models/dictionary_data.dart';
import 'package:flutter/material.dart';

class SeconScreen extends StatelessWidget {
  final DictionaryData dictionaryData;

  const SeconScreen({Key? key, required this.dictionaryData}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xff764abc),
        title: Text('Definition'),
      ),
      body: Column(
        children: [
          Row(
            children: [
              Text(
                dictionaryData.word,
                style: TextStyle(
                  fontSize: 24,
                  color: Colors.blueAccent,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Icon(
                Icons.linear_scale,
                color: Colors.blueAccent,
                size: 24,
              ),
              SizedBox(
                height: 30,
              ),
              Container(
                height: 30,
                width: 70,
                color: Colors.yellow,
                child: Center(
                  child: Text(
                    dictionaryData.wordtype,
                    style: TextStyle(
                      fontSize: 24,
                      color: Colors.black,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
              ),
            ],
          ),
          Container(
            //   margin: EdgeInsets.only(left: 8),
            child: Text(
              dictionaryData.definition,
              style: TextStyle(
                fontSize: 18,
              ),
              textAlign: TextAlign.left,
            ),
          ),
        ],
      ),
    );
  }
}
