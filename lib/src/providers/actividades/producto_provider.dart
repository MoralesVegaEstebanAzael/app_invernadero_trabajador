import 'dart:convert';
import 'dart:io';

import 'package:app_invernadero_trabajador/app_config.dart';
import 'package:app_invernadero_trabajador/src/models/actividades/gastos_model.dart';
import 'package:app_invernadero_trabajador/src/models/actividades/producto_model.dart';
import 'package:app_invernadero_trabajador/src/models/actividades/sobrantes_model.dart';
import 'package:app_invernadero_trabajador/src/storage/secure_storage.dart';
import 'package:http/http.dart' as http; 
import 'package:http_parser/http_parser.dart'; 
import 'package:mime_type/mime_type.dart';

class ProductosProvider{
  static final ProductosProvider _ProductosProvider = ProductosProvider._internal();

  factory ProductosProvider() {
    return _ProductosProvider;
  }

  ProductosProvider._internal();
  
  final _storage = SecureStorage();  
  int _page=0;
  bool _loading=false;


  Future<List<Producto>> loadProductos()async{  
    if(_loading)return [];
    _loading=true;
    
    _page++;
    
    final url = "${AppConfig.base_url}/api/personal/productos?page=$_page"; 
    final token = await _storage.read('token');
    Map<String, String> headers = {
      HttpHeaders.authorizationHeader: "Bearer $token",
      "Accept": "application/json",};
    
    final response = await http.get(
      url, 
      headers: headers,);

    print(response.body);
    if(response.body.contains('page_on_limit')){
      print("PAGEEEEEE $_page");
      return[];
    } 
    
    if(response.body.contains("productos") && response.body.contains("id")){
      ProductosModel p = ProductosModel.fromJson(json.decode(response.body));
      _loading=false;
      return p.productos.values.toList().cast();
    }
    return [];
  }
  
  Future<Producto> addProducto(Producto producto)async{
    final url = "${AppConfig.base_url}/api/personal/add_producto"; 
    final token = await _storage.read('token');
    Map<String, String> headers = {
      HttpHeaders.authorizationHeader: "Bearer $token",
      "Content-Type" : "application/json",
      "Accept": "application/json",}; 

    final response = await http.post(
      url, 
      headers: headers,
      body:   json.encode(
        {
          "idCultivo" : producto.idCultivo,
          "nombre" :producto.nombre,
          "equiKilos" : producto.equiKilos,
          "precioMay" : producto.precioMay,
          "precioMen" : producto.precioMen,
          "cantExis" : producto.cantExis,
          "url_imagen" : producto.urlImagen
        }
      )
      );
    print("RESPONSE BODY ${response.body}");
    if(response.body.contains("producto") && response.body.contains("id")){
      print("ADD-PRODUCTO RESPONSE-> ${response.body}");
      Producto p = Producto.fromJson(json.decode(response.body)['producto']);
      return p;
    }
    return null;
  }

 Future<Producto> updateProducto(Producto producto)async{
    final url = "${AppConfig.base_url}/api/personal/update_producto"; 
    final token = await _storage.read('token');
    Map<String, String> headers = {
      HttpHeaders.authorizationHeader: "Bearer $token",
      "Content-Type" : "application/json",
      "Accept": "application/json",}; 

    final response = await http.put(
      url, 
      headers: headers,
      body:   json.encode(
        {
          "id_producto" : producto.id,
          "idCultivo" : producto.idCultivo,
          "nombre" :producto.nombre,
          "equiKilos" : producto.equiKilos,
          "precioMay" : producto.precioMay,
          "precioMen" : producto.precioMen,
          "cantExis" : producto.cantExis,
          "url_imagen" : producto.urlImagen
        }
      )
      );
    print("RESPONSE BODY ${response.body}");
    if(response.body.contains("producto") && response.body.contains("id")){
      print("UPDATE-PRODUCTO RESPONSE-> ${response.body}");
      Producto p = Producto.fromJson(json.decode(response.body)['producto']);
      return p;
    }
    return null;
  }

  
  Future<bool> deleteProducto(String idProducto)async{
    final url = "${AppConfig.base_url}/api/personal/delete_producto?id_producto=$idProducto"; 
    final token = await _storage.read('token');
    Map<String, String> headers = {
      HttpHeaders.authorizationHeader: "Bearer $token",
      "Accept": "application/json",};

    final response = await http.delete(
      url, 
      headers: headers,
      );
    print("eliminando registro ${response.body}");
    if(response.body.contains("message") && response.body.contains("success")){
      print("eliminando");
      return true;
    }
    if(response.statusCode==200)
      return true;
    print("Error al eliminar");
    return false;
  }

  Future<String> subirImagenCloudinary(File imagen) async{
    final url = Uri.parse('https://api.cloudinary.com/v1_1/dtev8lpem/image/upload?upload_preset=f9k9os9d');
    final mimeType = mime(imagen.path).split('/'); //image/jpeg

    final imageUploadRequest = http.MultipartRequest( //peticion para subir el archivo
      'POST',
      url
    );

    final file = await http.MultipartFile.fromPath( //se carga el archivo
      'file', 
      imagen.path,
      contentType: MediaType(mimeType[0], mimeType[1]),
    );

    imageUploadRequest.files.add(file);
    
    final streamResponse = await imageUploadRequest.send();
    final resp = await http.Response.fromStream(streamResponse);

    if (resp.statusCode != 200 && resp.statusCode != 201) {
        print('Algo salio mal');
        print(resp.body);
        return null;
    }

    final respData = json.decode(resp.body);
    print(respData);

    return respData['secure_url'];
  } 

  
}