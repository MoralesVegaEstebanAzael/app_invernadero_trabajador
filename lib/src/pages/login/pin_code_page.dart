
import 'package:app_invernadero_trabajador/src/blocs/login_bloc.dart';
import 'package:app_invernadero_trabajador/src/storage/secure_storage.dart';
import 'package:app_invernadero_trabajador/src/theme/theme.dart';
import 'package:app_invernadero_trabajador/src/utils/countdown_base.dart';
import 'package:app_invernadero_trabajador/src/utils/responsive.dart';
import 'package:app_invernadero_trabajador/src/widgets/rounded_button.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/svg.dart';
import 'package:line_icons/line_icons.dart';
// import 'package:nexmo_verify/basemodel.dart';
// import 'package:nexmo_verify/model/nexmo_response.dart';
// import 'package:nexmo_verify/nexmo_sms_verify.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

import '../../../app_config.dart';


class PinCodePage extends StatefulWidget {
  //String mobileNumber;
  
  PinCodePage();//this.mobileNumber);
  @override
  _PinCodePageState createState() => _PinCodePageState();//this.mobileNumber);
}
  
class _PinCodePageState extends State<PinCodePage>{

  String _pinCode = "";
  bool _isLoading = false;
  bool _isResendEnable = false;
  bool _cancel=false;
  String otpWaitTimeLabel = "";
  SecureStorage _prefs = SecureStorage(); 
  LoginBloc bloc;
  // NexmoSmsVerificationUtil _nexmoSmsVerificationUtil;
  _PinCodePageState();//this.mobileNumber);

  Responsive responsive; 
  @override
  void initState() {
    super.initState();
    
    startTimer();
  }

  @override
  void didChangeDependencies() {
    bloc = LoginBloc();
    responsive = Responsive.of(context);
    super.didChangeDependencies();
  }


  @override
  void dispose() {
    super.dispose();
    _cancel=true;
  }


  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: GestureDetector(
          onTap: (){
            FocusScope.of(context).unfocus();
          },
          child: Container( 
            height: responsive.height,
            child: Stack(
              children:<Widget>[
                Positioned(
                      child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                          AspectRatio(
                      aspectRatio: 16/7,
                      child: LayoutBuilder(
                        builder:(_,contraints){
                          return Container(
                            
                            child:  SvgPicture.asset('assets/images/enter_code.svg',
                              height: contraints.maxHeight*.4,
                              width: contraints.maxWidth,
                            ),
                          );
                        }
                      )
                    )   ,
                    SizedBox(height: responsive.ip(1),),
                    Text("Código de verificación",style: TextStyle(fontSize:responsive.ip(3),fontWeight:FontWeight.bold),),
                    SizedBox(height: responsive.ip(1),),
                    Padding(
                      padding:  EdgeInsets.symmetric(horizontal:10.0),
                      child: FutureBuilder(
                        future: _prefs.read('celular'),
                        builder: (BuildContext context, AsyncSnapshot snapshot) {
                          return Text("El código de verificación se ha enviado al:+ ${snapshot.data}",
                          textWidthBasis: TextWidthBasis.longestLine, 
                          style: TextStyle(color:Color(0xffbbbbbb),),
                            textAlign: TextAlign.left,
                          );
                        },
                      ), 
                    ),
                    SizedBox(height:responsive.ip(0.5)),
                    _inputBox(),
                    SizedBox(height: responsive.ip(1),),

                    //timer label
                    Text(
                        otpWaitTimeLabel,
                        style: TextStyle( fontWeight: FontWeight.w700),
                    ),


                    SizedBox(height: responsive.ip(1),),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children:<Widget>[
                        Text("¿No recibiste el código?",),
                        CupertinoButton(
                          child: Text("REENVIAR",style: TextStyle(fontWeight: FontWeight.bold, 
                          color: _isResendEnable? miTema.accentColor:Color(0xffbbbbbb)),), 
                          onPressed: _isResendEnable?_resendOtp:null,)
                      ]
                    ),
                    SizedBox(height: responsive.ip(2),),  
                    RoundedButton(
                      label: "Siguiente", 
                      onPressed:
                      (_pinCode.length<4 || _isResendEnable)
                      ? null
                      :()=>_sendCode() )
                ],) ,),

                Positioned.fill(
                  child: _isLoading? Container(
                    color:Colors.black45,
                    child: Center(
                      child:SpinKitCircle(color: miTema.accentColor),
                    ),
                  ):Container()),
              ]
            )
          ),
      ),
    );
  }

  _sendCode()async{

    if(_isLoading)return;
    
    setState(() {
      _isLoading=true;
    });

    bloc.changeCode(_pinCode);
    
    await bloc.verifyCode(_pinCode);

    setState(() {
      _isLoading = false;
    });
    
    if(bloc.navRoute.contains("error")){
       Flushbar(
        message:  bloc.navRoute,
        duration:  Duration(seconds: 2),              
      )..show(context);
    }else{
      Navigator.pushReplacementNamed(context, bloc.navRoute);
    }
  }
  
  // _submit()async{
  //   //enviar codigo de verificación para validar
  //   if(_isLoading)return;

  //   if(_pinCode.length==4){
      
  //     setState(() {
  //       _isLoading=true;
  //     });
  //   Map info = await _nexmoSmsVerifyProvider.verify(code: _pinCode);
    
  //   setState(() {
  //     _isLoading=false;
  //   });

    
  //   if(info['ok']){//SOLICITUD API REST
  //       Flushbar(
  //       backgroundColor: Colors.black45,
  //       icon: Icon(
  //       LineIcons.check,
  //       size: 28.0,
  //       color: miTema.accentColor,
  //       ),
  //       margin: EdgeInsets.all(4),
  //       borderRadius: 5,
  //       message:   "Verificado",
  //       duration:  Duration(seconds:1),              
  //     )..show(context);


  //       _user.registered = '1';
  //       _prefs.user = _user; //save new user
  //      // Scaffold.of(context).showSnackBar(snackBarSucces);
  //       _cancel=true;    //stop timer   
  //       if(_user.password=='0')//si no ha configurado su contraseña
  //         Navigator.pushReplacementNamed(context, 'config_password');
  //       else if(_user.direccion=='0') //si no ha configurado su información
  //         Navigator.pushReplacementNamed(context, 'config_location');
  //   }else{
  //     // Scaffold.of(context).showSnackBar(snackBar);
  //     print("ocurrio un error en la verificacion: " + info['message']);
  //      Flushbar(
  //       backgroundColor: Colors.black45,
  //       icon: Icon(
  //       Icons.close,
  //       size: 28.0,
  //       color: Colors.red,
  //       ),
  //       margin: EdgeInsets.all(4),
  //       borderRadius: 5,
  //       message:   "Código incorrecto",
  //       duration:  Duration(seconds:1),              
  //     )..show(context);

  //   }
    
  //   } 
  // }

  //solicitar nuevo codigo de verificación
  void _resendOtp() {
    if (_isResendEnable) {
     //_nexmoSmsVerificationUtil.resentOtp();
     restarTimer();
     print("enviando codigo de verificacion");
    }else{
      print("aun no se puede solicitar un nuevo codigo");
    }
  }

  //**timer **/
  void startTimer() {
    print("|start timer....");
    setState(() {
      _isResendEnable = false;
    });

    var sub = CountDown(new Duration(minutes: 5)).stream.listen(null);
   
    sub.onData((Duration d) {
      if(!_cancel){
              setState(() {
        int sec = d.inSeconds % 60;
        otpWaitTimeLabel = d.inMinutes.toString() + ":" + sec.toString();
      });
      }else{
        sub.cancel();
      }

    });


    sub.onDone(() {
      setState(() {
        _isResendEnable = true;
      });
    });
  }

  void restarTimer(){
    if(_isResendEnable){

      startTimer();
      _isResendEnable=false;
    }
  }
 
  Widget _inputBox() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal:40),
      child: PinCodeTextField( 
        length: 4,
        obsecureText: false,
        animationType: AnimationType.fade,
        shape: PinCodeFieldShape.underline,
        animationDuration: Duration(milliseconds: 300),
        borderRadius: BorderRadius.circular(5),
        fieldHeight: 50,
        fieldWidth: 40,
        selectedColor: miTema.accentColor,
        inactiveColor: Colors.grey,
        onChanged: (value) {
        setState(() {
          _pinCode = value; 
        });
        },
        
      ),
    );
  }

  
}