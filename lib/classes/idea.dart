class Idea {
  final int id;
  final String name;
  final String description;

  Idea({this.id, this.name, this.description});

  Map<String, dynamic> toMap(){
    return{
      'id': id,
      'name': name,
      'description': description,
    };
  } 

  @override 
  String toString() {
    return 'Idea{id: $id, name: $name, description: $description}';
  }
}