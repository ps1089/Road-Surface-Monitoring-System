
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'dart:developer' as devtools show log ;

late Map data ;
// To create a new DatabaseReference, pass the path to the ref method
final DatabaseReference ref = FirebaseDatabase.instance.ref("UsersData/oLfO3QsayPcmUVsW8kySWtQLYdM2/readings");
Query dbRef = FirebaseDatabase.instance.ref("UsersData/oLfO3QsayPcmUVsW8kySWtQLYdM2/readings/1680085497/loc_latlong");

class FetchDataView extends StatefulWidget
{
  const FetchDataView({super.key});
  @override
  State<FetchDataView> createState() => _FetchDataViewState();
}

class _FetchDataViewState extends State<FetchDataView> 
{

int i = 1;
@override
  Widget build(BuildContext context) 
  {
    return Scaffold
      (
           appBar: AppBar
           (
             title: const Text('Data from Firebase'),
           ),
           body: Column
           (
              children: 
            [
              Expanded(
                  child: 
                    FirebaseAnimatedList
                    (
                    query: ref, 
                    itemBuilder: (context,snapshot,animation,index)
                    {
                      data = snapshot.value as Map;
                      data['key'] = snapshot.key;
                      devtools.log(data.toString());
                      // return listItem(student: student);
                      return ListTile
                      (
                      title: Text('${i++}. Fundamental Frequency : ${snapshot.child('Fundamental_Frequency').value}'),
                      subtitle: Text('Location : ${snapshot.child('loc_latlong').value}'),
                      
                      );
                    }
                    
                    
                    ),
                ),
              
              
            ],
           ), 
      );
  }
}