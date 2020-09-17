

import 'dart:convert';

import 'package:flutter/services.dart' show rootBundle;

class _MenuProvider{
  List<dynamic> opciones = [];

  _MenuProvider(){
    loadData();
    loadMenu();
  }

  Future<List<dynamic>>  loadData() async{
    final resp = await rootBundle.loadString('data/menu_opts.json');

    Map dataMap = json.decode(resp);
    opciones = dataMap['rutas'];
    return opciones;

  }
 
  Future<List<dynamic>>  loadRoutesEmployee() async{
    final resp = await rootBundle.loadString('data/menu_employee.json');
    Map dataMap = json.decode(resp);
    opciones = dataMap['rutas'];
    return opciones;

  }
  Future<List<dynamic>>  loadMenu() async{
    final resp = await rootBundle.loadString('data/menu_ajustes.json');

    Map dataMap = json.decode(resp);
    opciones = dataMap['rutas'];
    return opciones;

  }
}

final menuProvider = _MenuProvider();