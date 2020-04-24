class Rep {

  int _ID;
  int _IDquest;
  String _rep;
  String _time;

  Rep(int ID, int IDquest, String rep, String time) {
    this._ID = ID;
    this._IDquest = IDquest;
    this._rep = rep;
    this._time = time;
  }

  String get rep => _rep;

  int get IDquest => _IDquest;

  int get ID => _ID;

  String get time => _time;

}