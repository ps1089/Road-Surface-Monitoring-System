import 'package:flutter/material.dart';
import '../main.dart';

class KeyPointsView extends StatefulWidget 
{
  const KeyPointsView({super.key});

  @override
  State<KeyPointsView> createState() => _KeyPointsViewState();
}

class _KeyPointsViewState extends State<KeyPointsView> 
{
  @override
  Widget build(BuildContext context) 
  {
    return Scaffold
    (
      appBar: AppBar(title: const Text("Key Points"),centerTitle: true,shadowColor: Colors.black),
      body: Container
      (
        color: Colors.green[100],
        child: Column
              (
               children: 
               [
                const SizedBox(height:75,),
                const Text("1.Give Location Permissions and Turn Location ON.",textAlign : TextAlign.center,style: TextStyle(fontWeight:FontWeight.bold,fontSize: 20)),
                const SizedBox(height: 40,),
                Text("2. $currentIp:$portNo for accessing Server.",textAlign : TextAlign.center,style: const TextStyle(fontWeight:FontWeight.bold,fontSize: 20)),
                const SizedBox(height: 40,),  
                const Text("3. First 10 digits Latitude and Next Longitude with decimal.",textAlign : TextAlign.center,style: TextStyle(fontWeight:FontWeight.bold,fontSize: 20)),
                ],
              ),
      ),
    );
  }
}