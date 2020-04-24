class Objet {

  String _path;
  String _name;

  Objet(String path, String name) {
    this._path = path;
    this._name = name;
  }

  String get name => _name;

  String get path => _path;

}