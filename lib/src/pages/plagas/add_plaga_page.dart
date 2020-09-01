import 'dart:io'; 

import 'package:app_invernadero_trabajador/src/blocs/plagaBloc/plaga_bloc.dart';
import 'package:app_invernadero_trabajador/src/blocs/solar_cultivo_bloc.dart';
import 'package:app_invernadero_trabajador/src/models/plagasEnfermedades/plaga.dart';
import 'package:app_invernadero_trabajador/src/models/solares_cultivos/cultivo.dart';
import 'package:app_invernadero_trabajador/src/models/solares_cultivos/solar.dart';
import 'package:app_invernadero_trabajador/src/services/plagasService/plaga_services.dart';
import 'package:app_invernadero_trabajador/src/theme/theme.dart';
import 'package:app_invernadero_trabajador/src/utils/colors.dart';
import 'package:app_invernadero_trabajador/src/utils/responsive.dart';
import 'package:app_invernadero_trabajador/src/widgets/dialog_list_cultivos.dart';
import 'package:app_invernadero_trabajador/src/widgets/dialog_list_solares.dart'; 
import 'package:app_invernadero_trabajador/src/widgets/rounded_button.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';  
import 'package:intl/intl.dart'; 
import 'package:line_icons/line_icons.dart';
import 'package:provider/provider.dart';

import '../../../app_config.dart';

class AddPlagaPage extends StatefulWidget {
  AddPlagaPage({Key key}) : super(key: key);

  @override
  _AddPlagaPageState createState() => _AddPlagaPageState();
}

class _AddPlagaPageState extends State<AddPlagaPage> {
  SolarCultivoBloc solarCultivoBloc;
  PlagaBloc plagaBloc;
  PlagaService _plagaService;
  Responsive _responsive;
  TextStyle _style; 
  String _fecha= ''; 
  String urlImagen = '';
  File foto;
  bool _isLoading=false;
  final scaffolKey = GlobalKey<ScaffoldState>(); 

  TextEditingController _inputDateController = new TextEditingController();
  
  @override
  void initState() { 
    imageCache.clear();
    super.initState();
    
  }
  
  @override
  void didChangeDependencies() { 
    super.didChangeDependencies();

     _responsive = Responsive.of(context); 
     solarCultivoBloc = new SolarCultivoBloc(); 

     _plagaService = Provider.of<PlagaService>(context);

    plagaBloc = new PlagaBloc();

    _style = TextStyle(
      color: MyColors.GreyIcon,
      fontFamily: AppConfig.quicksand,
      fontWeight: FontWeight.w600,
      fontSize: _responsive.ip(1.8)
    );
  
      
  }

  @override
  void dispose() { 
    plagaBloc.reset();
    solarCultivoBloc.reset();
    super.dispose(); 
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffolKey,
      backgroundColor: Colors.white,
      appBar: AppBar(
        brightness: Brightness.light,
        elevation: 0.0,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(LineIcons.angle_left, color: MyColors.GreyIcon), 
          onPressed: ()=> Navigator.pop(context)
        ),
        title:Text("Nueva plaga",
             style: TextStyle(color: MyColors.GreyIcon) 
        ),
        actions: <Widget>[
          _crearBoton()
        ],
      ),
      body: Stack(
        children: <Widget>[
          SafeArea(
            child: _body()
          ),
          _isLoading ? Positioned.fill(child: Container(
            color: Colors.black45,
            child: Center(
              child: SpinKitCircle(color: miTema.accentColor,),
            ),
          )
          ):Container()
        ],
      ),
    );
  }

  Widget _body(){
     return Container( 
      margin: EdgeInsets.only(left:10,right:10,top: 10),
      height: double.infinity,
      width: double.infinity,
      child: SingleChildScrollView(
        child:Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text("Información de la plaga",style: TextStyle(
              fontFamily:AppConfig.quicksand,fontWeight: FontWeight.w700,
              color: MyColors.GreyIcon,fontSize: _responsive.ip(1.8)
            ),),
            SizedBox(height:2),
            Container(
              width: double.infinity,
              height: 2,
              color: Colors.grey[300],
            ),
            SizedBox(height:15),
            _mostrarFoto(),
            SizedBox(height:_responsive.ip(1)),             
            _mostrarSolares(),            
            SizedBox(height:_responsive.ip(0.5)),
            _inputDeteccionDate(), 
            SizedBox(height:_responsive.ip(2)),
            _inputNombre(),
            SizedBox(height:_responsive.ip(2)),
            _observaciones(),
            SizedBox(height:_responsive.ip(2)),
            _tratamiento(),
            SizedBox(height:_responsive.ip(3)), 

          ],
        )
      ),
    );
  }

  _inputDeteccionDate(){
    return StreamBuilder(
              stream: plagaBloc.fechaStream,
              builder: (BuildContext context, AsyncSnapshot snapshot){
                return TextFormField( 
                  enableInteractiveSelection: false, 
                  controller: _inputDateController,
                  decoration: InputDecoration(
                    focusedBorder:  UnderlineInputBorder(      
                              borderSide: BorderSide(color:miTema.accentColor)),
                    icon: Icon(LineIcons.calendar),
                    labelText: 'Deteccion', 
                     errorText: snapshot.error == '*' ? null : snapshot.error
                  ),
                  onChanged: plagaBloc.changeFecha,
                  onTap: (){
                    FocusScope.of(context).requestFocus(new FocusNode()); //quitar foco
                    _selectDate(context);
                  },
                );
              }
            );
  }

  _selectDate(BuildContext context) async{
       DateTime picked = await showDatePicker(
        context: context,  
        initialDate: new DateTime.now(), 
        firstDate: new DateTime(2020), 
        lastDate: new DateTime.now(), 
        locale: Locale('es')
      );

      if(picked != null){
        setState(() {
          //_fecha = picked.toString()
          var formatter = new DateFormat("yyyy-MM-dd");
          _fecha = formatter.format(picked);
          _inputDateController.text = _fecha; 
          plagaBloc.changeFecha(_fecha);
          //_plagaModel.fecha = _fecha;
          print(_fecha);
        });
      }
  }

  _inputNombre(){
    return StreamBuilder(
      stream: plagaBloc.nombreStream, 
      builder: (BuildContext context, AsyncSnapshot snapshot){
        return TextFormField(
            decoration: InputDecoration(
              focusedBorder:  UnderlineInputBorder(      
                        borderSide: BorderSide(color:miTema.accentColor)),
              icon: Icon(LineIcons.bug),
              labelText: 'Nombre',
              
              errorText: snapshot.error == '*' ? null : snapshot.error,
            ),
            onChanged: plagaBloc.changeNombre, 
          );
      },
    );
  }

  _mostrarSolares(){
    return  Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
          children: <Widget>[
            Icon(LineIcons.sun_o,color: MyColors.GreyIcon,),
            SizedBox(width:10),
            Text("Solar",style: _style,),
          ],
        ),
          SizedBox(height:_responsive.ip(2)),
          StreamBuilder(
            stream: solarCultivoBloc.solarActiveStream ,
            builder: (BuildContext context, AsyncSnapshot snapshot){
              Solar solar = snapshot.data;
              return GestureDetector(
                onTap: (){
                   showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return DialogList(solarCultivoBloc: solarCultivoBloc,);
                  });
                },
                child:snapshot.hasData?
                 _select(solar.nombre):
                 _select("Elije el solar"),
              );
            },            
          ),
          SizedBox(height:_responsive.ip(2)),
          Row(
            children: <Widget>[
              SvgPicture.asset('assets/icons/seelding_icon.svg',color:MyColors.GreyIcon,height: 20,),
              SizedBox(width:10),
              Text("Cultivo",style: _style,),
            ],
          ),
          SizedBox(height:_responsive.ip(2)),
          StreamBuilder(
            stream: solarCultivoBloc.cultivoActiveStream ,
            builder: (BuildContext context, AsyncSnapshot snapshot){            
              Cultivo cultivo = snapshot.data;
              return GestureDetector(
                onTap: (){
                   showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return DialogListCultivo(solarCultivoBloc: solarCultivoBloc,);
                  });
                },
                child:snapshot.hasData
                
                ? _select((
                  cultivo.nombre),
                ):_select("Elije el cultivo"),
              );
            },
          ),
        ], 
    ); 
  }

  _select(String data){
    return Container(
      height: 50,
      margin: EdgeInsets.only(left:35,right:10),
      padding: const EdgeInsets.all(5.0),
      decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(5),
      border: Border.all(
        width: 1,
        color: MyColors.GreyIcon)  
      ),
      child: Row(
        children:<Widget>[
         Text(data,style: TextStyle(color:MyColors.GreyIcon,fontFamily: AppConfig.quicksand,
          fontSize: _responsive.ip(1.5),fontWeight: FontWeight.w700
        ),),
        Expanded(child:Container()),
        Icon(Icons.expand_more,color: MyColors.GreyIcon,)
        ]
      )
    );
  }

    
  
 
  Widget _observaciones(){
    return Container(
      child: Column(
        children:<Widget>[
          Row(
              children: <Widget>[
               // SvgPicture.asset('assets/icons/ruler_icon.svg',color:MyColors.GreyIcon,height: 20,),
                Icon(LineIcons.clipboard,color: MyColors.GreyIcon,),
                SizedBox(width:18),
                Text("Observaciones",style: _style,),
              ],
            ),
           SizedBox(height:_responsive.ip(2)),
          Container(
            margin: EdgeInsets.only(left:30),
            padding: EdgeInsets.all(8), 
            child: StreamBuilder(
              stream: plagaBloc.observacionStream,
              builder: (BuildContext context, AsyncSnapshot snapshot){
                return TextFormField(
                    maxLines: 3,
                    decoration: InputDecoration(
                    hintText: "Ingresa una descripción..",
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color:MyColors.GreyIcon),
                      ),
                          focusedBorder:  OutlineInputBorder(      
                          borderSide: BorderSide(color:miTema.accentColor)),
                          errorText: snapshot.error == '*' ? null : snapshot.error
                        ), 
                    onChanged: plagaBloc.changeObservacion,  
                  );
              }
            )
          )
        ]
      ),
    );
  }

  Widget _tratamiento(){
    return Container(
      child: Column(
        children:<Widget>[
          Row(
              children: <Widget>[
               // SvgPicture.asset('assets/icons/ruler_icon.svg',color:MyColors.GreyIcon,height: 20,),
                Icon(LineIcons.medkit,color: MyColors.GreyIcon,),
                SizedBox(width:18),
                Text("Tratamiento",style: _style,),
              ],
            ),
           SizedBox(height:_responsive.ip(2)),
          Container(
            margin: EdgeInsets.only(left:30),
            padding: EdgeInsets.all(8), 
            child: StreamBuilder(
              stream: plagaBloc.tratamientoStream,
              builder: (BuildContext context, AsyncSnapshot snapshot){
                return TextFormField(
              maxLines: 4,
              decoration: InputDecoration(
               hintText: "Ingresa un tratamiento..",
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color:MyColors.GreyIcon),
                ),
                     focusedBorder:  OutlineInputBorder(      
                     borderSide: BorderSide(color:miTema.accentColor)),
                     errorText: snapshot.error == '*' ? null : snapshot.error
                  ), 
                  onChanged: plagaBloc.changeTratamiento, 
                );
              }
            )
          )
        ]
      ),
    );
 }


  Widget _mostrarFoto(){     
     return Stack(
        alignment: const Alignment(0.8, 1.0),
        children: <Widget>[          
            ClipRRect(
             borderRadius: BorderRadius.circular(100),
             child: Container(
                height: 140,
                width: 140,
                child: (foto!=null)
                ? new Image.file(foto,fit: BoxFit.cover)
                : Image.asset('assets/bug-96.png', fit: BoxFit.cover,), 
              ),
            ),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(100),
              color: miTema.accentColor,
            ),         
            child: IconButton(
                icon: Icon(LineIcons.camera, color:Colors.white, size: 30,), 
                onPressed: _procesarImagen
              ),
          ),
        ],
      );
    } 
 
    _procesarImagen()async{
      //ImageSource origen = ImageSource.gallery;
      //foto = await ImagePicker.pickImage(source: origen);
      final _picker = ImagePicker();
      final pickedFile = await _picker.getImage(source: ImageSource.gallery);
      foto = File(pickedFile.path);

      if(foto != null){
        urlImagen = null;
      }

      setState(() {
        _guardarImagen();
      });
    }

    _guardarImagen()async{
      if(foto!=null){
       
        setState(() {
          _isLoading=true;
        });

        urlImagen = await _plagaService.subirFoto(foto);
        print("++++++++++++++++++++++++++++");
        print(urlImagen);
        plagaBloc.changeUrlImagen(urlImagen);

        setState(() {
          _isLoading=false;
        });
      }
    }

    _crearBoton(){
      return StreamBuilder(
        stream: plagaBloc.formValidStream ,
        builder: (BuildContext context, AsyncSnapshot snapshot){
            return IconButton(
            icon: Icon(LineIcons.save,color: MyColors.GreyIcon,), 
            onPressed:  snapshot.hasData ? ()=>_submit(): _muestraFlush
            );
        },
      );
    }

    bool _inputCorrectos(){
      if(solarCultivoBloc.solarActive != null && solarCultivoBloc.cultivoActive != null){
           return true;
      }
      return false;
    }

    void _submit(){      
      print("--------------------------------"); 
      print(plagaBloc.fecha);
      print(plagaBloc.urlImagen);
       if(_inputCorrectos()){
         Plagas plagaNew = Plagas( 
          idSolar: solarCultivoBloc.solarActive.id,
          idCultivo: solarCultivoBloc.cultivoActive.id,
          nombreCultivo: solarCultivoBloc.cultivoActive.nombre,
          nombre: plagaBloc.nombre,
          fecha:plagaBloc.fecha,
          observacion: plagaBloc.observacion,
          tratamiento: plagaBloc.tratamiento,
          urlImagen: plagaBloc.urlImagen
        );

        _plagaService.addPlaga(plagaNew);

        Flushbar(
          message:  "Agregado correctamente",
          duration:  Duration(seconds: 2),              
        )..show(context).then((r){
          Navigator.pop(context);
        });

      }else{
        _muestraFlush();
      }
      


    }

    _muestraFlush(){
       final snackbar = SnackBar(
      content: Text("Campos vacios"),
      duration: Duration(milliseconds: 1500),
    );
    scaffolKey.currentState.showSnackBar(snackbar);
    }

 
 
}