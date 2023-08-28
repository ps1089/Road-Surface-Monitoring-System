import 'package:flutter/material.dart';
import 'package:restart_app/restart_app.dart';
import '../constants/routes.dart';
import '../main.dart';

class Home extends StatefulWidget 
{
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> 
{
  @override
  Widget build(BuildContext context) 
  {
  return Scaffold
  (
    appBar: AppBar
          (
            title: const Text("GPS Locator"),centerTitle: true,shadowColor: Colors.black,
          ),
            body: Container
            (
              color: Colors.green[100],
              child: Column
                  (
                    crossAxisAlignment: CrossAxisAlignment.stretch, // horizontal
                    mainAxisAlignment: MainAxisAlignment.start, // vertical
                    children: 
                    [
                      const SizedBox(height: 60,),
                      const Text("Server Started",style:TextStyle(fontWeight:FontWeight.bold,fontSize: 25),
                            textAlign: TextAlign.center,),
                      const SizedBox(height: 40,),  
                      Text("Server IP Address: $currentIp",style: const TextStyle(fontWeight:FontWeight.bold,fontSize: 20),
                           textAlign: TextAlign.center,),
                      const SizedBox(height: 40,),
                      Text("Server Port no : $portNo",style: const TextStyle(fontWeight:FontWeight.bold,fontSize: 20),
                           textAlign: TextAlign.center,),
                      const SizedBox(height: 60,),
                      ValueListenableBuilder
                      (
                        valueListenable: noOfRequests, 
                        builder:(_, value, __) 
                        {
                          return Text("No of Requests to Server: $value ",textAlign : TextAlign.center ,style: const TextStyle(fontWeight: FontWeight.bold,fontSize: 25,),);
                        },
                      ),
                      const SizedBox(height: 60,),
                      ValueListenableBuilder
                      (
                        valueListenable: latitude, 
                        builder:(_, value, __) 
                        {
                          return Text("Latitude: $value ",textAlign : TextAlign.center ,style: const TextStyle(fontWeight: FontWeight.bold,fontSize: 20,),);
                        },
                      ),
                      const SizedBox(height: 40,),
                      ValueListenableBuilder
                      (
                        valueListenable: longitude, 
                        builder:(_, value, __) 
                        {
                          return Text("Longitude: $value ",textAlign : TextAlign.center ,style: const TextStyle(fontWeight: FontWeight.bold,fontSize: 20,),);
                        },
                      ),
                      const SizedBox(height: 80,),
                      Container
                      (
                        color: Colors.green[400],
                        child: TextButton
                               (
                                onPressed:()
                                {
                                  Restart.restartApp();
                                }, 
                                child: const Text("Restart",textAlign : TextAlign.center ,style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20,color:Colors.black ),),
                              ),
                     ),
                     const SizedBox(height: 50,),
                      Container
                      (
                        color: Colors.green[400],
                        child: TextButton
                              (
                                onPressed:()
                                {
                                  Navigator.of(context).pushNamed(keypointsRoute);
                                }, 
                                child:const Text("Go to Key Points",textAlign : TextAlign.center ,style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20,color:Colors.black ),),
                              ),
                      ),
                              
                    ],
                  ),
            ),
    );
  }
}