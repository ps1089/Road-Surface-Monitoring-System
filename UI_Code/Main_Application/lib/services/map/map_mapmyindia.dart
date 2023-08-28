// ignore_for_file: non_constant_identifier_names

import 'package:mapmyindia_gl/mapmyindia_gl.dart';
import '../../views/first_page.dart';

class MapmyindiaMapProvider 
{
  // API Keys for the MapMyIndia
  String get MAP_SDK_KEY => 'c0ede9b522325f0668015db761885d43';
  String get REST_API_KEY => 'c0ede9b522325f0668015db761885d43';
  String get ATLAS_CLIENT_ID => '33OkryzDZsJiZkswq_6HFMvtZXmlLbHpMVtzzgazODNoPw3z9_KENvWfaXjGARZ2bg3FURyNYjKBLN9wkDv5Gw==';
  String get ATLAS_CLIENT_SECRET => 'lrFxI-iSEg_Ut510bKwvJv2IVuolgCYwNn2bucjB34NWfyv6SRHv52GQYQhcdsFihvV_gI3Qx42Rq7lxturvQOCMpLoJ2KFU';
  
  // Initial Camera Position..
  CameraPosition get kInitialPosition => CameraPosition(  target: LatLng(latitudeGeocodedfrom, longitudeGeocodedfrom),  
                                                          zoom: 15.0, 
                                                        //tilt: 50.0,
                                                        //bearing : 60.0,
                                                        );
}