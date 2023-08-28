import 'package:roadmonitoring/services/geocoding/geocoding_gecoder.dart';
import 'package:roadmonitoring/services/geocoding/geocoding_provider.dart';

class GeocodingService implements GeocodingProvider
{
  final GeocodingProvider geoprovider ;

  const GeocodingService(this.geoprovider);
  
    factory GeocodingService.geocoding() 
  {
    return GeocodingService(GeocoderGecoding(),);
  }
  
  @override
  Future getGeocodes({required String location}) => geoprovider.getGeocodes(location: location);
    
}