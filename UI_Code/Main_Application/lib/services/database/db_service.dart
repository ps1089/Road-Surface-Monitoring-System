
import 'package:roadmonitoring/services/database/db_firebase.dart';
import 'package:roadmonitoring/services/database/db_provider.dart';

// Basically in service we are creating a object of the class and using the obj we are accessing the methods.

class DbService implements DbProvider
{
  final DbProvider provider ;
  const DbService(this.provider);
  
  // factory constructor..
  factory DbService.firebasertdb() 
  {
    return DbService(FirebaseDbProvider(),);
  }
  
  @override
  Future getData() => provider.getData();
    
  


    
  


}