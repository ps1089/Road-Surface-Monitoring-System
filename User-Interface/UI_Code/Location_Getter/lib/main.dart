import 'dart:io';
import 'package:geolocator/geolocator.dart';
import 'package:mini_server/mini_server.dart';
import 'package:flutter/material.dart';
import 'package:phonelocation/views/homeview.dart';
import 'dart:developer' as devtools show log;
import 'package:phonelocation/views/keypoints.dart';
import 'constants/routes.dart';

// Global Variables
ValueNotifier<int> noOfRequests = ValueNotifier(0);
ValueNotifier<double> latitude = ValueNotifier(0.0);
ValueNotifier<double> longitude = ValueNotifier(0.0);

late String ipAdd ;
late Position position ;
late MiniServer miniServer ;

String currentIp = "Undefined" ;
int portNo = 8080;

// TODO: Better Design Tips

void main(List<String> args) 
async
{
  WidgetsFlutterBinding.ensureInitialized;
  await getIpAdd();

  // UI 
  runApp(MaterialApp
        (
          debugShowCheckedModeBanner: false,
          theme: ThemeData
          (
            primarySwatch: Colors.green ,
          ),
          home : const Home(),
          routes: 
          { 
            keypointsRoute:(context) => const KeyPointsView(),
          },
          ),
        );
  await miniServerConnect();
  await _determinePosition();
  devtools.log("Every Initialization done Successfully");
  
  // Server Code....
  miniServer.get("/", (HttpRequest httpRequest) async 
  {
    position = await Geolocator.getCurrentPosition();
    noOfRequests.value++;
    latitude.value = position.latitude;
    longitude.value = position.longitude;
    return httpRequest.response.write("${position.latitude} ${position.longitude}");
   // return httpRequest.response.write("The Latitude is :${position.latitude} & Longitude is :${position.longitude}");
  });
   miniServer.post("/test", (HttpRequest httpRequest) async 
   {
    MiniResponse res = await MiniResponse.instance.init(httpRequest); 
    return httpRequest.response.write(res.parameters);
  });

   miniServer.post("/test02", (HttpRequest httpRequest) async 
  {
    final res = await MiniResponse.instance.init(httpRequest);
    return httpRequest.response.write(res.body);
  });
  

  }


// IP address Recognition
Future getIpAdd() async
{
  // Cross Core Modem Network Interface(ccmni) : ccmni0 / ccmni1 which are basically interfaces for cellular data.
  // ap or swlan interfaces (depending on the Android distribution) can be found when the Mobile Hotspot (Access Point) is activated on an Android device.
  for (var interface in await NetworkInterface.list()) 
  {
    devtools.log('== Interface: ${interface.name} ==');
    for (var addr in interface.addresses) 
    {
      // devtools.log('${addr.address} ${addr.host} ${addr.isLoopback} ${addr.rawAddress} ${addr.type.name}');
      // Works fine with Mobile Hotspot as well as WLAN networks
       if(interface.name.startsWith("wlan") || interface.name.startsWith('ap')) 
      // If connected to WLAN(wlan) or  mobile Hotspot(ap)
      {
        if(addr.type.name == "IPv4") 
        {
         currentIp = addr.address.toString();
        }
        devtools.log(currentIp);
      }
    }
  }
}

// Server Initialization..
Future miniServerConnect() async
{
  if(currentIp != "Undefined")
  {
   miniServer = MiniServer(
    host: currentIp,
    port: portNo,
  );
  }
 
  devtools.log("Created Server");
}


// Location Services Initialization..
Future<void> _determinePosition() async 
{
 /// Determine the current position of the device.
///
/// When the location services are not enabled or permissions
/// are denied the `Future` will return an error.
 bool serviceEnabled;
 LocationPermission permission;

// Test if location services are enabled.
 serviceEnabled = await Geolocator.isLocationServiceEnabled();
   if (!serviceEnabled) 
   {
    // Location services are not enabled don't continue
    // accessing the position and request users of the 
    // App to enable the location services.
    return Future.error('Location services are disabled.');
  } 
  permission = await Geolocator.checkPermission();
  // Firstly,it is bound to be denied
  if (permission == LocationPermission.denied) 
  {
    // Requesting Location Permission..
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) 
    {
    // Permissions are denied, next time you could try
    // requesting permissions again (this is also where
    // Android's shouldShowRequestPermissionRationale 
    // returned true. According to Android guidelines
    // your App should show an explanatory UI now.
      return Future.error('Location permissions are denied');
    }
  }
   if (permission == LocationPermission.deniedForever) {
    // Permissions are denied forever, handle appropriately. 
    return Future.error(
      'Location permissions are permanently denied, we cannot request permissions.');
  } 

  // When we reach here, permissions are granted and we can
  // continue accessing the position of the device.
  devtools.log("Geo_Locator Initialized");
  // return await Geolocator.getCurrentPosition();
}
