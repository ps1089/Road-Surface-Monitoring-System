import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class MapsView extends StatefulWidget 
 {
  const MapsView({super.key});

  @override
  State<MapsView> createState() => _MapsViewState();
}

class _MapsViewState extends State<MapsView> 
{
 // final MapController _mapController = MapController();
  LatLng point = LatLng(49.5, -0.09);
  final List<LatLng> _latLngList = 
  [
    LatLng(19.07254201125294, 72.90022552013399),
    LatLng(19.072516661542952, 72.89990901947023),
    LatLng(19.072607920480795, 72.8995442390442),
    LatLng(19.07394637912866, 72.89912581443788),
  ];
  List<Marker> _markers = [];
 
  @override
  void initState() 
  {
    _markers = _latLngList
    .map((point) => Marker
    (
      point: point,
      width: 5,
      height: 5,
      builder: (context) => const Icon(
              Icons.alarm_add,
              size: 20,
              color: Colors.red,
              ),
            ))
        .toList();
    
    super.initState();
  }
  
  @override
  Widget build(BuildContext context) {
  return Scaffold(
        appBar: AppBar(title: const Text("Map View"),centerTitle: true,),
        body: 
        FlutterMap(
    options: MapOptions(
        center: LatLng(19.074110,72.898298),
        zoom: 15.0,
        maxZoom: 18.0,
    ),
    nonRotatedChildren: [
        AttributionWidget.defaultWidget(
            source: 'OpenStreetMap contributors',
            onSourceTapped: null,
        ),
    ],
    children: [
        TileLayer(
            urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
            userAgentPackageName: 'com.example.app',
        ),
        MarkerLayer(
          markers: _markers,
        ),
        // PolylineLayer(
        //     polylineCulling: false,
        //     polylines: [
        //         Polyline(
        //           points: [LatLng(19.07254201125294,72.90022552013399 ),LatLng(19.07394637912866, 72.89912581443788),],
        //           color: Colors.red,
        //           strokeWidth: 3.5,
        //         ),
        //     ],
        // ),
     ],
    
)
  );
}
}