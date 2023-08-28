import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:roadmonitoring/constants/routes.dart';
import 'package:roadmonitoring/views/first_page.dart';
import 'package:roadmonitoring/views/loading_page.dart';
import 'package:roadmonitoring/views/map_my_india_view.dart';
import 'firebase_options.dart';

// TODO :Integrity at DB Side
// TODO: Different ways to route from one view to another
// TODO: Factory constructor
// TODO: Initstate,setstate,dispose


void main() 
async
{
  //  WidgetFlutterBinding is used to interact with the Flutter engine.
  // An instance of the WidgetsBinding,is required to use platform channels to call the native code.
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MaterialApp
    (
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData
            (
            primarySwatch: Colors.teal,
            ),
      home: const Homepage() ,
      routes:
      { 
        mapRoute:(context) => const MapView2(),
      },
     ),
  );
}

class Homepage extends StatefulWidget 
{
  const Homepage({super.key});
  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> 
{
  final Future<FirebaseApp> fApp = Firebase.initializeApp
                                  (
                                    options: DefaultFirebaseOptions.currentPlatform,
                                  );
                                  
  @override
  Widget build(BuildContext context) 
  {
    return FutureBuilder
    (
      future : fApp,
        builder: (context, snapshot) 
        {
          switch(snapshot.connectionState)  
          {    
            case ConnectionState.done:
              return const FirstPageView() ; 
            default:
              return const LoadingView();
          }  
        }, 
    );
    
    }
}







 

 
  





