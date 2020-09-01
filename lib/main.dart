import 'package:app_invernadero_trabajador/src/pages/actividades/actividades_home_page.dart';
import 'package:app_invernadero_trabajador/src/pages/actividades/gastos/gasto_add_page.dart';
import 'package:app_invernadero_trabajador/src/pages/actividades/gastos/gasto_edit_page.dart';
import 'package:app_invernadero_trabajador/src/pages/actividades/productos/producto_add_page.dart';
import 'package:app_invernadero_trabajador/src/pages/actividades/productos/producto_edit_page.dart';
import 'package:app_invernadero_trabajador/src/pages/actividades/sobrantes/sobrante_add_page.dart';
import 'package:app_invernadero_trabajador/src/pages/actividades/sobrantes/sobrante_edit_page.dart';
import 'package:app_invernadero_trabajador/src/pages/actividades/tareas/tarea_add_page.dart';
import 'package:app_invernadero_trabajador/src/pages/actividades/tareas/tarea_edit_page.dart';
import 'package:app_invernadero_trabajador/src/pages/actividades/tareas/tarea_herramientas.dart';
import 'package:app_invernadero_trabajador/src/pages/ajustes/ajustes_page.dart';
import 'package:app_invernadero_trabajador/src/pages/herramientas/herramientas_home_page.dart';
import 'package:app_invernadero_trabajador/src/pages/home/home_page.dart';
import 'package:app_invernadero_trabajador/src/pages/home/main_page.dart';
import 'package:app_invernadero_trabajador/src/pages/insumos/insumos_home_page.dart';
import 'package:app_invernadero_trabajador/src/pages/login/config_password_page.dart';
import 'package:app_invernadero_trabajador/src/pages/login/login_password_page.dart';
import 'package:app_invernadero_trabajador/src/pages/login/login_phone_page.dart';
import 'package:app_invernadero_trabajador/src/pages/login/pin_code_page.dart';
import 'package:app_invernadero_trabajador/src/pages/login/register_code_page.dart';
import 'package:app_invernadero_trabajador/src/pages/menu_drawer.dart';
import 'package:app_invernadero_trabajador/src/pages/ofertas/ofertas_home_page.dart';
import 'package:app_invernadero_trabajador/src/pages/pedidos/pedidos_home_page.dart';
import 'package:app_invernadero_trabajador/src/pages/plagas/plagas_home_page.dart';
import 'package:app_invernadero_trabajador/src/pages/solar_cultivos/cultivo_add_page.dart';
import 'package:app_invernadero_trabajador/src/pages/solar_cultivos/cultivo_edit_page.dart';
import 'package:app_invernadero_trabajador/src/pages/solar_cultivos/cultivo_etapas_page.dart';
import 'package:app_invernadero_trabajador/src/pages/solar_cultivos/details_solar_page.dart';
import 'package:app_invernadero_trabajador/src/pages/solar_cultivos/solar_add_page.dart';
import 'package:app_invernadero_trabajador/src/pages/solar_cultivos/solar_cultivos_home_page.dart';
import 'package:app_invernadero_trabajador/src/pages/solar_cultivos/solar_edit_page.dart';
import 'package:app_invernadero_trabajador/src/pages/ventas/ventas_home_page.dart';
import 'package:app_invernadero_trabajador/src/services/actividades/gastos_services.dart';
import 'package:app_invernadero_trabajador/src/services/actividades/productos_services.dart';
import 'package:app_invernadero_trabajador/src/services/actividades/sobrantes_services.dart';
import 'package:app_invernadero_trabajador/src/services/actividades/tareas_services.dart';
import 'package:app_invernadero_trabajador/src/services/solares_services.dart';
import 'package:app_invernadero_trabajador/src/storage/secure_storage.dart';
import 'package:app_invernadero_trabajador/src/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_statusbarcolor/flutter_statusbarcolor.dart';
import 'package:provider/provider.dart';

void main() async{
  //var path = await getApplicationDocumentsDirectory();
  //Hive.init(path.path );
  

  WidgetsFlutterBinding.ensureInitialized();
  final prefs = new SecureStorage();
  await prefs.initPrefs();

  // DBProvider db = DBProvider();
  // await db.initDB();
  // SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
  //  systemNavigationBarColor: Colors.white, // navigation bar color
  //   statusBarColor: Colors.white, // status bar color
  //   statusBarIconBrightness: Brightness.dark,
  //   statusBarBrightness: Brightness.light,
  //   systemNavigationBarIconBrightness: Brightness.dark,
    
  // ));

  // PushNotificationsProvider provider = PushNotificationsProvider();
  // provider.initNotifications();
  // provider.getToken();

// SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyl e.dark);
  runApp(MyApp());
} 

class MyApp extends StatefulWidget {
  // This widget is the root of your application.
  @override
  _MyAppState createState() => _MyAppState();
}


class _MyAppState extends State<MyApp> {
  final prefs = new SecureStorage();

  @override
  void initState() {
    FlutterStatusbarcolor.setStatusBarColor(Colors.transparent);
    FlutterStatusbarcolor.setStatusBarWhiteForeground(false);
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
     return MultiProvider(
        providers: [
            //ChangeNotifierProvider(create: (_)=> new LocalService()),
            ChangeNotifierProvider(create: (_)=> new SolarCultivoService(),),
            ChangeNotifierProvider(create: (_)=> new TareasService(),),
            ChangeNotifierProvider(create: (_)=> new ProductosService(),),
            ChangeNotifierProvider(create: (_)=> new GastosService(),),
            ChangeNotifierProvider(create: (_)=> new SobrantesService(),),

          ],
            child: new MaterialApp(
              localizationsDelegates: [ 
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: [
              const Locale('en'), // English
              const Locale('es'), // Español
            ],
        title: 'SS Invernadero',
        theme: miTema,
        initialRoute: prefs.route,
        debugShowCheckedModeBanner: false,
        routes: {
          'main'                  : (BuildContext)=>MainPage(),
          'menu'                  : (BuildContext)=>MenuDrawer(),
          'register_code'         : (BuildContext)=>CodeRegisterPage(),
          'login_phone'           : (BuildContext)=>LoginPhonePage(),
          'login_password'        : (BuildContext)=>LoginPasswordPage(),
          'pin_code'              : (BuildContext)=>PinCodePage(),
          'config_password'       : (BuildContext)=>ConfigPasswordPage(),
          
          'menu_drawer'           : (BuildContext)=>MenuDrawer(),

          'home'                  : (BuildContext)=>MyHomePage(),
          'solar_cultivos'        : (BuildContext)=>SolarCultivosHomePage(),
          'details_solar'         : (BuildContext)=>DetailsSolarPage(),
          'solar_add'             : (BuildContext)=>SolarAddPage(),
          'solar_edit'            : (BuildContext)=>SolarEditPAge(),
          'cultivo_add'           : (BuildContext)=>CultivoAddPage(),
          'cultivo_edit'          : (BuildContext)=>CultivoEditPage(),
          'cultivo_etapas'        : (BuildContext)=>CultivoEtapasPage(),

          'actividades'           : (BuildContext)=>ActividadesHomePage(),
          
          'tarea_add'             :(BuildContext)=>TareaAddPage(),
          'tarea_edit'             :(BuildContext)=>TareaEditPage(),
          'tarea_herramientas'    : (BuildContext)=>TareaHerramientasPage(),
          'producto_add'          : (BuildContext)=>ProductoAddPage(),
          'producto_edit'         : (BuildContext)=>ProductoEditPage(),
          'gasto_add'             : (BuildContext)=>GastoAddPage(),
          'gasto_edit'            : (BuildContext)=>GastoEditPage(),
          'sobrante_add'          : (BuildContext)=>SobranteAddPage(),
          'sobrante_edit'         : (BuildContext)=>SobranteEditPage(),
          'herramientas'          : (BuildContext)=>HerramientasHomePage(),
          'insumos'               : (BuildContext)=>InsumosHomePage(),

          'ofertas'               : (BuildContext)=>OfertasHomePage(),
          'pedidos'               : (BuildContext)=>PedidosHomePage(),
          'plagas'                : (BuildContext)=>PlagasHomePage(),
          'ventas'                : (BuildContext)=>VentasHomePage(),
          'ajustes'               : (BuildContext)=>AjustesPage(),
        }
      ),
     );
  }
}


