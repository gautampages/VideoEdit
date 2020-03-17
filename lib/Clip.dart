class Clip {
  int _id;
  int _pid;
  String _title;
  String _description;
  String _color;
  String _path;
  String _statrTime;
  String _endTime;

  Clip(this._pid, this._title, this._description, this._path, this._color,
      this._statrTime, this._endTime);

  Clip.map(dynamic obj) {
    this._id = obj['clipId'];
    this._pid = obj['project_id'];
    this._title = obj['title'];
    this._description = obj['description'];
    this._path = obj['path'];
    this._color = obj['color'];
    this._statrTime = obj['startTime'];
    this._endTime = obj['endTime'];
  }

  int get clipId => _id;
  int get projectId => _pid;
  String get title => _title;
  String get description => _description;
  String get path => _path;
  String get color => _color;
  String get startTime => _statrTime;
  String get endTime => _endTime;

  Map<String, dynamic> toMap() {
    var map = new Map<String, dynamic>();
    if (_id != null) {
      map['clipId'] = _id;
    }
    map['projectId'] = _pid;
    map['title'] = _title;
    map['description'] = _description;
    map['path'] = _path;
    map['color'] = _color;
    map['startTime'] = _statrTime;
    map['endTime'] = _endTime;

    return map;
  }

  Clip.fromMap(Map<String, dynamic> map) {
    this._id = map['clipId'];
    this._pid = map['projectId'];
    this._title = map['title'];
    this._description = map['description'];
    this._path = map['path'];
    this._color = map['color'];
    this._statrTime = map['startTime'];
    this._endTime = map['endTime'];
  }
}
