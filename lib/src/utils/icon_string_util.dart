import 'package:app_invernadero_trabajador/src/utils/colors.dart';
import 'package:app_invernadero_trabajador/src/utils/responsive.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:line_icons/line_icons.dart';

final double icon_height =12;
final Color icon_color = MyColors.GreyIcon;


final _icons = <String,IconData>{
  'sun_o'             : LineIcons.sun_o,
  'bug'               : LineIcons.bug,
  'money'             : LineIcons.money,
  'question_circle'   : LineIcons.question_circle,
  'sign_in'           : LineIcons.sign_in,
  'key'               : LineIcons.key,
  'home'              : LineIcons.home,
  'heart'             : Icons.favorite_border,
  'bell'              : LineIcons.bell,
  'info-circle'       : LineIcons.info_circle,
  'question_circle'   : LineIcons.question_circle,
  'sign_in'           : LineIcons.sign_in,
};

final _icons_svg = <String,String>{ 
  'bottle_icon.svg'        :   'assets/icons/bottle_icon.svg',
  'tools_icon.svg'    :   'assets/icons/tools_icon.svg',
  'task_icon.svg'     :   'assets/icons/task_icon.svg',
  'order_icon.svg'    :   'assets/icons/order_icon.svg',
  'sale_icon.svg'     :   'assets/icons/sale_icon.svg',
};


dynamic getIcon(String iconName,Responsive _responsive,Color color){
  
  if(_icons.containsKey(iconName))
    return Icon(_icons[iconName],color: color,size:_responsive.ip(2.8) ,);
  else
    return SvgPicture.asset(_icons_svg[iconName],color: color,height: _responsive.ip(2.8),);
}
