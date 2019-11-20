class Idea {
  int _id;
  String _title;
  String _description;

  Idea(this._title, [this._description]);

  Idea.withId(this._id, this._title, [this._description]);

  int get id => _id;

  String get title => _title;

  String get description => _description;

  set title(String newTitle){
    if (newTitle.length <= 255) {
      this._title = newTitle;
    }
  }

  set description(String newDesc){
    if (newDesc.length <= 255) {
      this._description = newDesc;
    }
  }

  Map<String, dynamic> toMap(){
    var map = Map<String, dynamic>();
    if (id != null) {
      map['id'] = _id;
    }
    map['title'] = _title;
    map['description'] = _description;

    return map;
  }

  Idea.fromMapObject(Map<String, dynamic> map){
    this._id = map['id'];
    this._title = map['title'];
    this._description = map['description'];
  }
}