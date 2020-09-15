import 'package:app_invernadero_trabajador/src/blocs/actividad_gasto_bloc.dart';
import 'package:app_invernadero_trabajador/src/blocs/actividad_producto_bloc.dart';
import 'package:app_invernadero_trabajador/src/blocs/actividad_tarea_bloc.dart';
import 'package:app_invernadero_trabajador/src/blocs/page_bloc.dart';
import 'package:app_invernadero_trabajador/src/blocs/solar_cultivo_bloc.dart';
import 'package:app_invernadero_trabajador/src/models/actividades/gastos_model.dart';
import 'package:app_invernadero_trabajador/src/models/actividades/producto_model.dart';
import 'package:app_invernadero_trabajador/src/models/actividades/sobrantes_model.dart';
import 'package:app_invernadero_trabajador/src/models/actividades/tareas_model.dart';
import 'package:app_invernadero_trabajador/src/models/solares_cultivos/solar.dart';
import 'package:app_invernadero_trabajador/src/pages/actividades/gastos/gasto_widget.dart';
import 'package:app_invernadero_trabajador/src/pages/actividades/productos/producto_widget.dart';
import 'package:app_invernadero_trabajador/src/pages/actividades/tareas/tarea_widget.dart';
import 'package:app_invernadero_trabajador/src/pages/solar_cultivos/solar_widget.dart';
import 'package:app_invernadero_trabajador/src/services/actividades/gastos_services.dart';
import 'package:app_invernadero_trabajador/src/services/actividades/productos_services.dart';
import 'package:app_invernadero_trabajador/src/services/actividades/tareas_services.dart';
import 'package:app_invernadero_trabajador/src/services/solares_services.dart';
import 'package:app_invernadero_trabajador/src/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:line_icons/line_icons.dart';
import 'package:provider/provider.dart';
class GastosPage extends StatefulWidget {
  GastosPage({Key key}) : super(key: key);

  @override
  _GastosPageState createState() => _GastosPageState();
}

class _GastosPageState extends State<GastosPage> {
  PageBloc _pageBloc;
  ScrollController _hideButtonController;
  bool _isVisible;
  ActividadGastoBloc gastoBloc = ActividadGastoBloc();
  bool _isLoading=false;


  @override
  void initState() {
    _pageBloc = PageBloc();
    _hideButtonController  = _pageBloc.scrollCont;
    super.initState();
    _isVisible = true;
    _hideButtonController.addListener((){
      if(_hideButtonController.position.userScrollDirection == ScrollDirection.reverse){
        if(_hideButtonController.position.pixels==_hideButtonController.position.maxScrollExtent){
          print("final**********");
        
          setState(() {
          _isLoading=true;
          });

           Provider.of<GastosService>(context,listen: false)
           .getGastos()
           .then((v){
              if(mounted){
              setState(() {
                _isLoading=false;
              });

              
              if(v){
                _hideButtonController.animateTo(
                  _hideButtonController.position.pixels +100,
                   duration: Duration(milliseconds:250), 
                   curve: Curves.fastOutSlowIn);
              }
             }
           });
        }
        if(_isVisible == true) {
            
            if(mounted){
              setState((){
              _isVisible = false;
            });
            }
        }
      } else {
        if(_hideButtonController.position.userScrollDirection == ScrollDirection.forward){
          if(_isVisible == false) {
               if(mounted){
                 setState((){
                 _isVisible = true;
               });
               }
           }
        }
    }});
  }

  

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: <Widget>[
          Positioned(
                      child: Container(
              margin:EdgeInsets.only(left:8,right: 8),
              child: StreamBuilder(
                stream: Provider.of<GastosService>(context).gastosStream,
                builder: (BuildContext context, AsyncSnapshot snapshot){
                  if(snapshot.hasData){
                    List<Gasto> gastos = snapshot.data;
                    return ListView.builder(
                      controller: _pageBloc.scrollCont,
                      physics: BouncingScrollPhysics(),
                      itemCount: gastos.length,
                      itemBuilder: (BuildContext context, int index) {
                       return GastoWidget(gasto:gastos[index],gastoBloc:gastoBloc);
                      },
                    );
                  }
                  return Container(
                  );
                },
              ),
            ),
          ),

         Positioned(child:  _createLoading(),)
        ],
      ),
      floatingActionButton: Visibility(
        visible: _isVisible,
              child: FloatingActionButton(
          onPressed: () {
            Navigator.pushNamed(context, 'gasto_add');
          },
          child: Icon(LineIcons.plus),
          backgroundColor: miTema.accentColor,
        ),
      ),
    );
  }
  _createLoading(){
    if(_isLoading){
      return Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                CircularProgressIndicator()
            ],),
            SizedBox(height:15.0)
          ],
      );
     
    }
    return Container();
  }
}