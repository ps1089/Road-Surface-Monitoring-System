// ignore_for_file: constant_identifier_names, avoid_print, non_constant_identifier_names

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart';
import 'package:mapmyindia_gl/mapmyindia_gl.dart';
import 'package:polyline_do/polyline_do.dart';
import 'package:roadmonitoring/services/map/map_service.dart';
import 'dart:developer' as devtools show log;
import 'first_page.dart';
import 'package:roadmonitoring/services/database/db_service.dart';

// Geometry from direction api ;
late String geometry ;

// Map for db data
late Map data ;

// Lists for Lat and Long
List<double> lat = [];
List<double> long = [] ;

// map controller object
late MapmyIndiaMapController mapController ;
// MapService..
MapService map_service = MapService();

// For DB
 String location = "undefined" ;
 late String conclusion ;


class MapView2 extends StatefulWidget 
{
  const MapView2({super.key});

  @override
  State<MapView2> createState() => _MapView2State();
}

class _MapView2State extends State<MapView2> 
{
  @override
  void initState() 
   {
    super.initState();
    // getGpsValues();
   
    MapmyIndiaAccountManager.setMapSDKKey(map_service.MAP_SDK_KEY);
    MapmyIndiaAccountManager.setRestAPIKey(map_service.REST_API_KEY);
    MapmyIndiaAccountManager.setAtlasClientId(map_service.ATLAS_CLIENT_ID);
    MapmyIndiaAccountManager.setAtlasClientSecret(map_service.ATLAS_CLIENT_SECRET);
  }
  
  
  @override
  Widget build(BuildContext context) 
  {
    return Scaffold
    (
      appBar: AppBar(title: const Text("Map View"),),
      body: MapmyIndiaMap
      (  
        initialCameraPosition: map_service.kInitialPosition,
        onMapCreated:(map) =>
        {
          mapController = map,
        },
        onStyleLoadedCallback:() => 
        { 
          // mapController.addSymbol(const SymbolOptions(geometry: LatLng(19.07254201125294, 72.90022552013399),iconSize: 0.6)),
          // mapController.addSymbol(const SymbolOptions(geometry: LatLng(19.072516661542952, 72.89990901947023),iconSize: 0.6)),
          // mapController.addSymbol(const SymbolOptions(geometry: LatLng(19.072607920480795, 72.8995442390442),iconSize: 0.6)),
          // mapController.addSymbol(const SymbolOptions(geometry: LatLng(19.07394637912866, 72.89912581443788),iconSize: 0.6)),
          
          addMarker(), // DB
          addPolyineandMarkers(), // Direction api
          
        },
      ),  
   );
  }
}

void addMarker() async 
{
   devtools.log("add marker"); 
   data = await DbService.firebasertdb().getData();
    int i = 0;
    data.forEach((key, value) 
    {
      location = value['loc_latlong'];
      conclusion = value['Kalman_Conclusion'];
      // TODO: Condition might change.
      if(conclusion == 'True')
      {
      if((location != 'undefined' )&(location!=""))
      {
        List<String> latlong = location.split(" ");
        double Latitude = double.parse(latlong[0]) ;
        double Longitude = double.parse(latlong[1]) ;
        lat.add(Latitude);
        long.add(Longitude);
        // devtools.log(i.toString());
        // devtools.log('Key: $key');
        // devtools.log("Latitude is $Latitude");
        // devtools.log("Longitude is $Longitude");
        // devtools.log('------------------------------');
        // devtools.log(lat[i].toString());
        // devtools.log(long[i].toString());
        // i++;
      }
      }
    });

  
  devtools.log("add Marker worked");
  i = 0;
  print(lat.length);
  print(long.length);
  while((i < lat.length) & (i < long.length))
  {
   print(lat[i]);
   print(long[i]);
   mapController.addSymbol(SymbolOptions(geometry: LatLng(lat[i], long[i]),iconSize: .6,iconColor:"#3bb2d0"));
   i++;
  }

}

 // Adds an asset image to the currently displayed style
  Future<void> addImageFromAsset(String name, String assetName) async 
  {
    print("started");
    final ByteData bytes = await rootBundle.load(assetName);
    final Uint8List list = bytes.buffer.asUint8List();
    print("executed");
    return mapController.addImage(name, list);
  }

  // iconColor => Hex input in String format.
void addPolyineandMarkers()
 async 
 {
  
  await addImageFromAsset("icon","assets/images/location.png");
  mapController.addSymbol(SymbolOptions(geometry: LatLng(latitudeGeocodedfrom, longitudeGeocodedfrom),iconImage: "icon",iconSize: 0.8 ),);
  mapController.addSymbol(SymbolOptions(geometry: LatLng(latitudeGeocodedto, longitudeGeocodedto),iconImage: "icon",iconSize: 0.8));
  devtools.log(".......");
  String url = "https://apis.mapmyindia.com/advancedmaps/v1/${map_service.MAP_SDK_KEY}/route_adv/driving/$longitudeGeocodedfrom,$latitudeGeocodedfrom;$longitudeGeocodedto,$latitudeGeocodedto?";
  devtools.log("getDirections Started");
  devtools.log(url);
  final response = await get(Uri.parse(url));
  print(response.statusCode);
  if(response.statusCode == 200)
  {
  final body = response.body;
  print(body);
  Map temp = jsonDecode(body);
  geometry = temp['routes'][0]['geometry'];
  }
  else
  {
    devtools.log("No response");
  }
  Polyline polyline = Polyline.Decode(encodedString:geometry,precision: 5);
    // 2D array ..
    devtools.log('Decoded Coords: ${polyline.decodedCoords}');
    
    var decodedCoords = polyline.decodedCoords;
    
    List<LatLng> latlng = <LatLng>[];
    for(int i = 0 ; i < decodedCoords.length ; i++)
    {
      double lat = decodedCoords[i][0];
      double long = decodedCoords[i][1];
      LatLng temp = LatLng(lat, long);
      latlng.add(temp);  
    }
    mapController.addLine(LineOptions(geometry: latlng, lineColor: "#165f87", lineWidth: 6));
    
 }

   











