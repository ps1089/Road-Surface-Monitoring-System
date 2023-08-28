

import 'package:firebase_database/firebase_database.dart';
import 'package:roadmonitoring/services/database/db_provider.dart';

class FirebaseDbProvider implements DbProvider
{
  final DatabaseReference ref = FirebaseDatabase.instance.ref("UsersData/oLfO3QsayPcmUVsW8kySWtQLYdM2/readings");
  @override
  Future getData() 
  async
  {
    final snapshot = await ref.get();
    return snapshot.value as Map;
  }
}