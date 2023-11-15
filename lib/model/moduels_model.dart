class ModulesModel {
  String? moduleName;
  String? routeName;
  String? imagePath;

  ModulesModel({this.moduleName, this.routeName, this.imagePath});

  ModulesModel.fromJson(Map<String, dynamic> json) {
    moduleName = json['moduleName'];
    routeName = json['routeName'];
    imagePath = json['imagePath'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['moduleName'] = this.moduleName;
    data['routeName'] = this.routeName;
    data['imagePath'] = this.imagePath;
    return data;
  }
}
