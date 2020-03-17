class Project {
  int _id;
  String _title;
  String _description;
  String _path;
 
  Project(this._title, this._description,this._path);
 
  Project.map(dynamic obj) {
    this._id = obj['id'];
    this._title = obj['title'];
    this._description = obj['description'];
    this._path = obj['path'];
  }
 
  int get id => _id;
  String get title => _title;
  String get description => _description;
  String get path => _path;
 
  Map<String, dynamic> toMap() {
    var map = new Map<String, dynamic>();
    if (_id != null) {
      map['id'] = _id;
    }
    map['title'] = _title;
    map['description'] = _description;
    map['path'] = _path;
 
    return map;
  }
 
  Project.fromMap(Map<String, dynamic> map) {
    this._id = map['id'];
    this._title = map['title'];
    this._description = map['description'];
    this._path = map['path'];
  }
}