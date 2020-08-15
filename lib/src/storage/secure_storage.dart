
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SecureStorage{  

  static final SecureStorage _instance = new SecureStorage._internal();

  factory SecureStorage(){
    return _instance;
  }
  SecureStorage._internal();

  FlutterSecureStorage _storage;
  SharedPreferences _prefs;

  initPrefs()async{
    this._storage = FlutterSecureStorage();
    this._prefs = await SharedPreferences.getInstance();
  }
  
  Future write(String _key,String _value) async {
    await _storage.write(key: _key, value: _value);
  }

  Future read(String _key) async {
    String value = await _storage.read(key: _key);
    if(value!=null)
    return value;

    return '';
  }

  Future delete(String _key) async {
    await _storage.delete(key: _key);
  }


  
  
  
  get informacion{
    return _prefs.getBool('informacion')??false;
  }
  
  set sesion(bool value){
    _prefs.setBool('sesion', value);
  }

  set informacion(bool value){
    _prefs.setBool('informacion', value);
  }

  get idClient{
    return _prefs.getInt('id_client')??'';
  }

  set idClient(int idClient){
    _prefs.setInt('id_client', idClient);
  }

  get idFeature{
    return _prefs.getString('id_feature')??'';
  }
  set idFeature(String idFeature){
    _prefs.setString('id_feature', idFeature);
  }
  
  get notificationId{
    return _prefs.getString('notification_id')??'';
  }
  set notificationId(String notificationId){
    _prefs.setString('notification_id', notificationId);
  }
  get route{
    return _prefs.getString('route')??'register_code';
  }
  set route(String route){
    _prefs.setString('route', route);
  }
}