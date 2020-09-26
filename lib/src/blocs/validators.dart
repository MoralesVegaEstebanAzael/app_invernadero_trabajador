import 'dart:async';

import 'package:app_invernadero_trabajador/src/blocs/solar_cultivo_bloc.dart';
import 'package:app_invernadero_trabajador/src/models/actividades/gastos_model.dart' as gasto;
import 'package:app_invernadero_trabajador/src/models/actividades/herramienta_model.dart';
import 'package:app_invernadero_trabajador/src/models/actividades/producto_model.dart';
import 'package:app_invernadero_trabajador/src/models/insumos/insumo.dart';
import 'package:app_invernadero_trabajador/src/models/solares_cultivos/cultivo.dart';
import 'package:app_invernadero_trabajador/src/models/solares_cultivos/etapa_cultivo.dart';
import 'package:app_invernadero_trabajador/src/models/task/tarea_date_mode.dart' ;

import 'actividad_producto_bloc.dart';

class Validators{
  final validarTelefono=StreamTransformer<String,String>.fromHandlers(
    handleData: (telefono,sink){
      if(telefono.length>0){
        sink.add(telefono);
      }else{
        sink.addError('Teléfono incorrecto');
      }
    }
  );

  final validarCodigo=StreamTransformer<String,String>.fromHandlers(
    handleData: (code,sink){
      if(code.length>0 && code.length<=10){
        sink.add(code);
      }else{
        sink.addError('Código incorrecto');
      }
    }
  );
  final validarPinCode=StreamTransformer<String,String>.fromHandlers(
    handleData: (code,sink){
      if(code.length==4){
        sink.add(code);
      }else{
        sink.addError('Código incorrecto');
      }
    }
  );

  final validarPassword=StreamTransformer<String,String>.fromHandlers(
    handleData: (password,sink){
      String  pattern = r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$';
      bool b = RegExp(pattern).hasMatch(password);
      
      b?sink.add(password):sink.addError("error");
    }
  );


  final validarEmail=StreamTransformer<String,String>.fromHandlers(
    handleData: (email,sink){
      bool emailValid = 
      RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(email);
      emailValid?sink.add(email):sink.addError("correo invalido");
    }
  );

 final validarNombre=StreamTransformer<String,String>.fromHandlers(
    handleData: (nombre,sink){
      (nombre.length>1)?sink.add(nombre):sink.addError("Ingrese este campo");
    }
  );

  final validarAp=StreamTransformer<String,String>.fromHandlers(
    handleData: (ap,sink){
      (ap.length>1)?sink.add(ap):sink.addError("Ingrese este campo");
    }
  );

  final validarAm=StreamTransformer<String,String>.fromHandlers(
    handleData: (am,sink){
      (am.length>1)?sink.add(am):sink.addError("Ingrese este campo");
    }
  );

 final validarRFC = StreamTransformer<String, String>.fromHandlers(
   handleData: (rfc, sink){ 
      bool rfcValid = 
      RegExp(r"^([A-ZÑ\x26]{3,4}([0-9]{2})(0[1-9]|1[0-2])(0[1-9]|1[0-9]|2[0-9]|3[0-1])([A-Z]|[0-9]){2}([A]|[0-9]){1})?$").hasMatch(rfc);
      rfcValid?sink.add(rfc):sink.addError("RFC invalido");
   }
 );


 final validarToneladas=StreamTransformer<String,String>.fromHandlers(
    handleData: (t,sink){
      (t.length>1)?sink.add(t):sink.addError("Ingrese este campo");
    }
  );



  //Solares-Cultivos
   final validateSolarNombre=StreamTransformer<String,String>.fromHandlers(
    handleData: (nombre,sink){
      //print("data valid-> $nombre");
      if(nombre.length>0){
        print("Agrenado valorrr $nombre");
        sink.add(nombre);
      }else{
        print("hay error");
        sink.addError("");
      }
    }
  );


  final validateSolarLargo=StreamTransformer<String,String>.fromHandlers(
    handleData: (largo,sink){
      bool valid = 
      RegExp(r'(^\-?\d*\.?\d*)$').hasMatch(largo);
      // RegExp(r"[0-9]+(\.[0-9][0-9]?)?").hasMatch(largo);
       if(valid){
        sink.add(largo);
      }else{
        sink.addError('');
      }
    }
  );

  final validateSolarAncho=StreamTransformer<String,String>.fromHandlers(
    handleData: (ancho,sink){
      bool valid = 
      RegExp(r"[0-9]+(\.[0-9][0-9]?)?").hasMatch(ancho);
       if(valid){
        sink.add(ancho);
      }else{
        sink.addError('');
      }
    }
  );
  
  final validateSolarDescripcion=StreamTransformer<String,String>.fromHandlers(
    handleData: (descripcion,sink){
       if(descripcion.length>0){
        sink.add(descripcion);
      }else{
        sink.addError('');
      }
    }
  );
  // static SolarCultivoBloc sBloc = new SolarCultivoBloc();

  final validateDecimal=StreamTransformer<String,String>.fromHandlers(
    handleData: (d,sink){
      bool valid = 
      RegExp(r'(^\-?\d*\.?\d*)$').hasMatch(d);
    if(valid&&d.isNotEmpty){
        sink.add(d);
    }else{
        sink.addError('');
      }  
    }
  );
  static final actBloc = new ActividadProductoBloc();
  final validateMenudeo=StreamTransformer<String,String>.fromHandlers(
    handleData: (d,sink){
      bool valid = 
      RegExp(r'(^\-?\d*\.?\d*)$').hasMatch(d);
    if(valid&&d.isNotEmpty){
      if(actBloc.precioMay!=null&&actBloc.precioMay.isNotEmpty){
        double menudeo = double.parse(d);
        double mayoreo = double.parse(actBloc.precioMay);
        if(menudeo<=mayoreo)
          sink.add(d);
        else
          sink.addError('Precio de menudeo debe ser menor o igual al de mayoreo.');
      }else{
        sink.addError('Agrega el precio de mayoreo.');
      }
    }else{
        sink.addError('');
      }  
    }
  );
  static final sBloc = new SolarCultivoBloc();

  final validateLargoC=StreamTransformer<String,String>.fromHandlers(
    handleData: (d,sink){
      bool valid = 
      RegExp(r'(^\-?\d*\.?\d*)$').hasMatch(d);
      if(valid&&d.isNotEmpty){
        
        if(sBloc.cultivoAncho!=null&&sBloc.cultivoAncho.isNotEmpty){
          double ancho = double.parse(sBloc.cultivoAncho);
          double largo = double.parse(d);
          double m2 = ancho*largo;
          if(m2 <= sBloc.solar.m2Libres)
            sink.add(d);
          else  
            sink.addError("Las medidas exceden las dimenciones del solar");
        }else{
          sink.add(d);
        }
      }else{
        sink.addError('');
      }  
    }
  );

  final validateAnchoC=StreamTransformer<String,String>.fromHandlers(
    handleData: (d,sink){ 
      bool valid = 
      RegExp(r'(^\-?\d*\.?\d*)$').hasMatch(d);
    if(valid&&d.isNotEmpty){
        if(sBloc.cultivoLargo!=null && sBloc.cultivoLargo.isNotEmpty){
          double ancho = double.parse(d);
          double largo = double.parse(sBloc.cultivoLargo);
          double m2 = ancho*largo;
          if(m2 <=sBloc.solar.m2Libres)
            sink.add(d);
          else  
            sink.addError("Las medidas exceden las dimenciones del solar");
        }else{
          sink.add(d);
        }
      }else{
        sink.addError('');
      } 
    }
  );

  final validateInteger=StreamTransformer<String,String>.fromHandlers( //enter mayor a 0
    handleData: (cantidad,sink){
      bool valid = 
      RegExp(r"^[0-9]{1,10}$").hasMatch(cantidad);
      print("cantidad");

       if(valid){
        int x = int.parse(cantidad);
        print("Value x $x");
        if(x>0)
          sink.add(cantidad);
      }else{ 
          sink.addError(''); 
      }
      
     
    }
  );

   final validateUrlImagenProducto=StreamTransformer<String,String>.fromHandlers(
    handleData: (url,sink){
       if(url.length>0){
        sink.add(url);
      }else{
        sink.addError('');
      }
    }
  );

  final validateEtapa=StreamTransformer<Etapa,Etapa>.fromHandlers(
    handleData: (e,sink){
     if(e!=null && e.nombre!=""){
        sink.add(e);
      }else{
        sink.addError('');
      }
    }
  );

  final validateCultivo=StreamTransformer<Cultivo,Cultivo>.fromHandlers(
    handleData: (e,sink){
     if(e!=null && e.nombre!=""){
        sink.add(e);
      }else{
        sink.addError('');
      }
    }
  );

  final validateHerramienta=StreamTransformer<Herramienta,Herramienta>.fromHandlers(
    handleData: (e,sink){
     if(e!=null && e.nombre!=""){
        sink.add(e);
      }else{
        sink.addError('');
      }
    }
  );
  final validatePersonal=StreamTransformer<gasto.Personal,gasto.Personal>.fromHandlers(
    handleData: (e,sink){
     if(e!=null && e.nombre!=""){
        sink.add(e);
      }else{
        sink.addError('');
      }
    }
  );
  
  final validateProducto=StreamTransformer<Producto,Producto>.fromHandlers(
    handleData: (e,sink){
     if(e!=null && e.nombre!=""){
        sink.add(e);
      }else{
        sink.addError('');
      }
    }
  );
  final validarNombrePlaga=StreamTransformer<String,String>.fromHandlers(
    handleData: (nombre,sink){
      (nombre.length>3)?sink.add(nombre):sink.addError("Ingrese este campo");
    }
  );

  final validarFechaPlaga=StreamTransformer<String,String>.fromHandlers(
    handleData: (nombre,sink){
      (nombre != null)?sink.add(nombre):sink.addError("Ingrese este campo");
    }
  );

  final validarTratamientoPlaga=StreamTransformer<String,String>.fromHandlers(
    handleData: (tratamiento,sink){
      (tratamiento.length>5)?sink.add(tratamiento):sink.addError("Ingrese este campo");
    }
  );

  final validarObservacionPlaga=StreamTransformer<String,String>.fromHandlers(
    handleData: (observacion,sink){
      (observacion.length>5)?sink.add(observacion):sink.addError("Ingrese este campo");
    }
  );

  final validarImagenPlaga=StreamTransformer<String,String>.fromHandlers(
    handleData: (imagen,sink){
      (imagen.length>0)?sink.add(imagen):sink.addError("Ingrese este campo");
    }
  );

  final validarNombreHerramienta=StreamTransformer<String,String>.fromHandlers(
    handleData: (nombre,sink){
      (nombre.length>2)?sink.add(nombre):sink.addError("Ingrese este campo");
    }
  );

  final validarDescripcionHerramienta=StreamTransformer<String,String>.fromHandlers(
    handleData: (descripcion,sink){
      (descripcion.length>5)?sink.add(descripcion):sink.addError("Ingrese este campo");
    }
  );

   final validarCantidadHerramienta=StreamTransformer<int,int>.fromHandlers(
    handleData: (cantidad,sink){
      if(cantidad >0 && cantidad <=100){
        sink.add(cantidad);
      }else{
        sink.addError('Cantidad incorrecto');
      }
    }
  );

  final validarDescripcionOferta=StreamTransformer<String,String>.fromHandlers(
    handleData: (descripcion,sink){
      (descripcion.length>5)?sink.add(descripcion):sink.addError("Ingrese este campo");
    }
  );

  //insumos
  final validarNombreInsumo=StreamTransformer<String,String>.fromHandlers(
    handleData: (nombre,sink){
      (nombre.length>3)?sink.add(nombre):sink.addError("Ingrese este campo");
    }
  ); 

  final validarTipoInsumo=StreamTransformer<String,String>.fromHandlers(
    handleData: (tipo,sink){
      print("tipo");
      (tipo.length>0)?sink.add(tipo):sink.addError("Ingrese este campo");
    }
  ); 

  final validarUnidadInsumo=StreamTransformer<String,String>.fromHandlers(
    handleData: (unidad,sink){
      print("unidad");
      (unidad.length>0)?sink.add(unidad):sink.addError("Ingrese este campo");
    }
  );
  
  final validarCantidadInsumo=StreamTransformer<String,String>.fromHandlers(
     handleData: (cantidad,sink){
      bool valid = 
      RegExp(r"^[0-9]{1,10}$").hasMatch(cantidad);
      print("cantidad");

       if(valid){
        int x = int.parse(cantidad);
        print("Value x $x");
        if(x>0)
          sink.add(cantidad);
      }else{ 
          sink.addError('Solo digitos y menos de 10 digitos'); 
      }
    }
  );

  final validarComposicionInsumo=StreamTransformer<String,String>.fromHandlers(
    handleData: (composicion,sink){
      (composicion.length>3)?sink.add(composicion):sink.addError("Ingrese este campo");
    }
  );

  final validarObservacionInsumo=StreamTransformer<String,String>.fromHandlers(
    handleData: (observacion,sink){
      (observacion.length>5)?sink.add(observacion):sink.addError("Ingrese este campo");
    }
  );

  final validarImagenInsumo=StreamTransformer<String,String>.fromHandlers(
     handleData: (imagen,sink){
       print("imagen");
      (imagen.length>0)?sink.add(imagen):sink.addError("Ingrese este campo");
    }
  );



   final validateProductsList=StreamTransformer<List<Producto>,List<Producto>>.fromHandlers(
    handleData: (list,sink){
      // (nombre.length>2)?sink.add(nombre):sink.addError("Ingrese este campo");
      if(list!=null&&list.isNotEmpty){
        sink.add(list);
      }else{
        sink.addError('');
      }

    }
  );

  final validateTarea=StreamTransformer<Tarea,Tarea>.fromHandlers(
    handleData: (obj,sink){
      // (nombre.length>2)?sink.add(nombre):sink.addError("Ingrese este campo");
      if(obj!=null){
        sink.add(obj);
      }else{
        sink.addError('');
      }

    }
  );

  final validateTrabajador=StreamTransformer<Personal,Personal>.fromHandlers(
    handleData: (obj,sink){
      // (nombre.length>2)?sink.add(nombre):sink.addError("Ingrese este campo");
      if(obj!=null){
        sink.add(obj);
      }else{
        sink.addError('');
      }

    }
  );

    final validarImagenOferta=StreamTransformer<String,String>.fromHandlers(
    handleData: (imagen,sink){
      (imagen.length>0)?sink.add(imagen):sink.addError("Ingrese este campo");
    }
  );

  final validarFechaIniOferta=StreamTransformer<String,String>.fromHandlers(
    handleData: (inicio,sink){
      (inicio.length>0)?sink.add(inicio):sink.addError("Ingrese este campo");
    }
  );

  final validarFechaFinOferta=StreamTransformer<String,String>.fromHandlers(
    handleData: (fin,sink){
      (fin.length>0)?sink.add(fin):sink.addError("Ingrese este campo");
    }
  );

   
  final validarImagenHerramienta=StreamTransformer<String,String>.fromHandlers(
    handleData: (imagen,sink){
      (imagen.length>0)?sink.add(imagen):sink.addError("Ingrese este campo");
    }
  );

  final validarNombreTrabajador=StreamTransformer<String,String>.fromHandlers(
    handleData: (nombre,sink){
      (nombre.length>1)?sink.add(nombre):sink.addError("Ingrese este campo");
    }
  );

  final validarApTrabajador=StreamTransformer<String,String>.fromHandlers(
    handleData: (ap,sink){
      (ap.length>1)?sink.add(ap):sink.addError("Ingrese este campo");
    }
  );

  final validarAmTrabajador=StreamTransformer<String,String>.fromHandlers(
    handleData: (am,sink){
      (am.length>1)?sink.add(am):sink.addError("Ingrese este campo");
    }
  );

 final validarRFCTrabajador = StreamTransformer<String, String>.fromHandlers(
   handleData: (rfc, sink){ 
      bool rfcValid = 
      RegExp(r"^([A-ZÑ\x26]{3,4}([0-9]{2})(0[1-9]|1[0-2])(0[1-9]|1[0-9]|2[0-9]|3[0-1])([A-Z]|[0-9]){2}([A]|[0-9]){1})?$").hasMatch(rfc);
      rfcValid?sink.add(rfc):sink.addError("RFC invalido");
   }
 );

 final validarImagenTrabajador=StreamTransformer<String,String>.fromHandlers(
     handleData: (imagen,sink){
       print("imagen");
      (imagen.length>0)?sink.add(imagen):sink.addError("Ingrese este campo");
    }
  );

  final validarCantidadCompra=StreamTransformer<String,String>.fromHandlers(
     handleData: (cantidad,sink){
      bool valid = 
      RegExp(r"^[0-9]{1,10}$").hasMatch(cantidad);
      print("cantidad");
       if(valid){
        sink.add(cantidad);
      }else{ 
          sink.addError('Solo digitos y menos de 10 digitos'); 
      }
    }
  );

  final validarPrecioCompra=StreamTransformer<String,String>.fromHandlers(
     handleData: (cantidad,sink){
      bool valid = 
      RegExp(r"^[0-9]+(\.[0-9]{1,2})?$").hasMatch(cantidad);
      print("cantidad");
       if(valid){
        sink.add(cantidad);
      }else{ 
          sink.addError('Solo digitos y menos de 10 digitos'); 
      }
    }
  );

  final validarInsumosCompra=StreamTransformer<List<Insumo>,List<Insumo>>.fromHandlers(
     handleData: (list,sink){ 
       if(list!=null && list.isNotEmpty){
        sink.add(list);
      }else{ 
          sink.addError(''); 
      }
    }
  );
}