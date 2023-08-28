// ignore_for_file: non_constant_identifier_names, avoid_print
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'dart:developer' as devtools show log ;
import 'package:roadmonitoring/constants/routes.dart';
import 'package:roadmonitoring/services/geocoding/geocoding_service.dart';

// Geocoded Latitude and Longitude
double latitudeGeocodedfrom = 0;
double longitudeGeocodedfrom = 0;
double latitudeGeocodedto = 0;
double longitudeGeocodedto = 0;

class FirstPageView extends StatefulWidget 
{
  const FirstPageView({super.key});

  @override
  State<FirstPageView> createState() => _FirstPageViewState();
}

class _FirstPageViewState extends State<FirstPageView> 
{
  late final TextEditingController _from; 
  late final TextEditingController _to;

  @override
  void initState() 
  {
    _from = TextEditingController();
    _to = TextEditingController();
    super.initState();
  }
  
  @override
  void dispose()
  {
    _from.dispose();
    _to.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) 
  {
    return Scaffold
    (
      resizeToAvoidBottomInset : false,
      backgroundColor: Colors.green[50],
      body: Column
        (
            children: 
          [
            const SizedBox(height: 50,),
            const Center(child:Text("Welcome",style: TextStyle(fontSize: 25,color: Colors.black,fontWeight: FontWeight.w700 ),)),
            const SizedBox(height: 40,),
            Image.asset("assets/images/img_3.png",height: 300,width: 350,),  
            const SizedBox(height: 20,),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal:5.0,vertical: 5.0),
              child: TextField
              (
                controller: _from,  
                enableSuggestions: false,
                autocorrect: false,
                keyboardType: TextInputType.streetAddress,
                decoration: const InputDecoration
                (
                  border: OutlineInputBorder(),
                  hintText: "From",
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5.0,vertical: 5.0),
              child: TextField
              (
                controller: _to,
                enableSuggestions: false,
                autocorrect: false,
                keyboardType: TextInputType.streetAddress,
                decoration: const InputDecoration
                (
                  border: OutlineInputBorder(),
                  hintText: "To",
                ),
              ),
            ),          
            const SizedBox(height: 25,),
            SizedBox(
              width: 300,
              child: TextButton
              (
                style: ButtonStyle(backgroundColor: MaterialStatePropertyAll(Colors.green[100])) ,
                onPressed:()
                async
                {
                  await getgeocodedvalues();
                },
                child: const Text("Submit",style: TextStyle(fontSize: 22,color: Color.fromARGB(255, 46, 145, 50),fontWeight: FontWeight.w700 )),
              ),
            ),
            const SizedBox(height: 40,),  
            SizedBox(
              width: 300,
              child: TextButton
              (
                style: ButtonStyle(backgroundColor: MaterialStatePropertyAll(Colors.green[100])) ,
                onPressed:()
                async
                {
                  Navigator.of(context).pushNamed(mapRoute);
                }, 
                child: const Text("View Map",style: TextStyle(fontSize: 22,color: Color.fromARGB(255, 46, 145, 50),fontWeight: FontWeight.w700 )),
              ),
            ),
            const SizedBox(height: 105,),
            const Text("K^2PR",style: TextStyle(fontSize: 18,fontStyle: FontStyle.italic,color: Colors.black38,letterSpacing: 1.25,fontWeight: FontWeight.w700 )),
          ],
        ),
      );
  }
  
  Future<void> getgeocodedvalues() 
  async 
  {
    final from = _from.text;
    final to = _to.text;
    List<Location> locations = await GeocodingService.geocoding().getGeocodes(location: from);
    latitudeGeocodedfrom = locations[0].latitude;
    longitudeGeocodedfrom = locations[0].longitude;
    locations = await GeocodingService.geocoding().getGeocodes(location: to);
    latitudeGeocodedto = locations[0].latitude;
    longitudeGeocodedto = locations[0].longitude;
  }
  
}




