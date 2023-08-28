import 'package:geocoding/geocoding.dart';
import 'package:roadmonitoring/services/geocoding/geocoding_provider.dart';

class GeocoderGecoding implements GeocodingProvider
{
  @override
  Future getGeocodes({required String location}) 
  async 
  {
    List<Location> locations = await locationFromAddress(location);
    return locations ;
  }

}