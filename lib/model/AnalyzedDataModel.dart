class AnalyzedDataModel {
  final String? name;
  final String? description;
  final String? dateTime;

  AnalyzedDataModel({
    required this.name,
    required this.description,
    required this.dateTime,
  });

  AnalyzedDataModel.fromMap(Map<dynamic, dynamic> res)
      : name = res['name'],
        description = res['description'],
        dateTime = res['dateTime'];

  Map<String, Object?> toMap() {
    return {
      'name': name,
      'description': description,
      'dateTime': dateTime,
    };
  }
}
