class DictionaryData {
  int? id;
  String word;
  int? favourite;
  String definition;
  String wordtype;

  static String tableName="data";
  static String tableName1="entries";
  DictionaryData({this.id, required this.word, required this.favourite ,required this.definition,required this.wordtype});

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'word': word,
      'definition': definition,
      'favourite':favourite,
      'wordtype':wordtype,
    };
  }

  factory DictionaryData.fromJson(Map<String, dynamic> json) {
    return DictionaryData(
      id: json['id'],
      word: json['word'],
      favourite:  json['favourite'],
      definition: json['definition'],
      wordtype: json ['wordtype'],

    );
  }
}
