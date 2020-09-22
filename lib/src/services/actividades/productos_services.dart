import 'dart:io';

import 'package:app_invernadero_trabajador/src/models/actividades/gastos_model.dart';
import 'package:app_invernadero_trabajador/src/models/actividades/producto_model.dart';
import 'package:app_invernadero_trabajador/src/models/actividades/sobrantes_model.dart';
import 'package:app_invernadero_trabajador/src/models/actividades/tareas_model.dart';
import 'package:app_invernadero_trabajador/src/providers/actividades/gastos_provider.dart';
import 'package:app_invernadero_trabajador/src/providers/actividades/producto_provider.dart';
import 'package:app_invernadero_trabajador/src/providers/actividades/sobrantes_provider.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

class ProductosService with ChangeNotifier{
  
  ProductosProvider productosProvider = ProductosProvider();
  
  // SolarCultivoBloc solarCultivoBloc = SolarCultivoBloc();
  
  List<Producto> productoList = List();

  

  final _productosController = new BehaviorSubject<List<Producto>>();
  final _responseController = new BehaviorSubject<String>(); 


  Stream<List<Producto>> get productosStream => _productosController.stream;
  

  Function(String) get changeResponse => _responseController.sink.add;
  

  String get response => _responseController.value;

  List<Producto> get productos => productoList;
  
  
  ProductosService(){
    this.getProductos();
  }
  
  
  dispose(){
    _productosController.close();
    _responseController.close();
  }

  


  Future<bool> getProductos()async{
    print(">>>>>>>>>>>>>cargando productos>>>>>>>>>>>>>");
    final list =  await productosProvider.loadProductos();
    if(list!=[] && list.isNotEmpty){
      this.productoList.addAll(list);
      _productosController.sink.add(productoList);
      return true;
    }
    notifyListeners();
    return false;
  }

  // Future<bool> fetchSolares()async{
  //   print(">>>>>>>>>>>>>cargando Solares>>>>>>>>>>>>>");
  //   final list =  await solaresCultivosProvider.loadSolares();
  //   if(list!=[] && list.isNotEmpty){
  //     this.solarList.addAll(list);
  //     _solaresController.sink.add(solarList);
  //     return true;
  //   }
  //   return false;
  //   // notifyListeners();
  // }

  Future<bool> addProducto(Producto producto)async{
    final Producto resp = await productosProvider.addProducto(producto);
    if(resp!=null){
      this.productoList.add(resp);
      _productosController.sink.add(productoList);
      changeResponse("Registro agregado");
      return true;
    }else{
      changeResponse("Algo ha salido mal");
      return true;
    }
  }

  Future<bool> updateProducto(Producto producto)async{
    final resp = await productosProvider.updateProducto(producto);
    if(resp!=null){
      int index = this.productoList.indexWhere((item)=>item.id==producto.id);  
      print("index de elemento $index"); 
      this.productoList[index]=resp;
      _productosController.sink.add(productoList);
      //solarCultivoBloc.onChangeSolar(resp); <__in stream
      changeResponse("Registro actualizado");
      return true;
    }else{
      changeResponse("Algo ha salido mal");
      return false;
    }
  }

  Future<bool> deleteProducto(int  idProducto)async{
    final resp = await productosProvider.deleteProducto(idProducto.toString());
    if(resp){
      this.productoList.removeWhere((item)=>item.id==idProducto);   
      _productosController.sink.add(productoList);
       changeResponse("Registro eliminado");
      return true;
    }else{
      changeResponse("Algo ha salido mal");
      return false;
    }
  }

  Future<String> subirFoto(File foto) async{
    final fotoUrl = await productosProvider.subirImagenCloudinary(foto);
    if(fotoUrl != null){
      changeResponse("Imagen cargada");
      return fotoUrl;
    }else {
      changeResponse("Algo salio mal");
      return "";
    }
  }
}