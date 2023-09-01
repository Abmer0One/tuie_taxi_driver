import 'dart:convert';
import 'dart:math';
import 'package:google_maps_webservice/places.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:tuie_driver_taxi/constants/constant_variable.dart';
import 'package:tuie_driver_taxi/model/localizacao_model.dart';
import 'package:tuie_driver_taxi/services/localizacao_service.dart';

enum LocationProviderStatus {
  Initial,
  Loading,
  Success,
  Error,
}

class LocalizacaoProvider with ChangeNotifier {
    Position _currentPosition = Position(
       longitude: 0.0, latitude: 0.0, timestamp: DateTime.now(),
       accuracy: 0.0, altitude: 0.0, heading: 0.0, speed: 0.0,
       speedAccuracy: 0.0
    );

    Position get currentPosition => _currentPosition;

    LatLng? _destination;
    LatLng? get destination => _destination;

    LatLng? _origem;
    LatLng? get origem => _origem;

    double _zoom = 18;
    double get zoom => _zoom;

    List<LatLng> _routeCoordinates = [];
    List<LatLng> get routeCoordinates => _routeCoordinates;

    final places = GoogleMapsPlaces(apiKey: ConstantVariable.chaveAPI);



    void setZoom(double zoom) {
      _zoom = zoom;
      notifyListeners();
    }

     LocalizacaoProvider() {
        _currentPosition = Position(
            longitude: 0.0, latitude: 0.0, timestamp: DateTime.now(), accuracy: 0.0,
            altitude: 0.0, heading: 0.0, speed: 0.0, speedAccuracy: 0.0
        );
    }

     setRouteCoordinates(List<LatLng> coordinates) {
       _routeCoordinates = coordinates;
       notifyListeners();
     }

    LatLngBounds moverCamera(double latitude_origem, double latitude_destino, double longitude_origem, double longitude_destino){
      LatLngBounds bounds = LatLngBounds(
         southwest: LatLng(
             min(
                 latitude_origem,
                 latitude_destino == null ? latitude_origem : latitude_destino),
             min(
                 longitude_origem,
                 longitude_destino == null ?
                 longitude_origem : longitude_destino)
         ),
         northeast: LatLng(
             max(
                 latitude_origem,
                 latitude_destino == null ? latitude_origem : latitude_destino),
             max(
                 longitude_origem,
                 longitude_destino == null ?
                 longitude_origem : longitude_destino)
         ),
       );

       return bounds;


     }

    String createMapStyle() {
      return '''
      [
        {
          "featureType": "all",
          "elementType": "labels.text.fill",
          "stylers": [
            {
              "color": "#808080"
            }
          ]
        },
        {
          "featureType": "administrative",
          "elementType": "geometry.stroke",
          "stylers": [
            {
              "color": "#ffffff"
            },
            {
              "lightness": 14
            }
          ]
        },
        {
          "featureType": "landscape.man_made",
          "elementType": "geometry",
          "stylers": [
            {
              "color": "#f2f2f2"
            }
          ]
        },
        {
          "featureType": "poi",
          "stylers": [
            {
              "visibility": "off"
            }
          ]
        },
        {
          "featureType": "road",
          "elementType": "geometry",
          "stylers": [
            {
              "color": "#ffffff"
            }
          ]
        },
        {
          "featureType": "road",
          "elementType": "labels",
          "stylers": [
            {
              "visibility": "on"
            }
          ]
        },
        {
          "featureType": "transit",
          "stylers": [
            {
              "visibility": "off"
            }
          ]
        },
        {
          "featureType": "water",
          "elementType": "geometry",
          "stylers": [
            {
              "color": "#c7ece9"
            }
          ]
        },
        {
          "featureType": "poi.business",
          "elementType": "all",
          "stylers": [
            {
              "color": "#808080"
            }
          ]
        },
        {
          "featureType": "poi.medical",
          "elementType": "geometry",
          "stylers": [
            {
              "color": "#808080"
            }
          ]
        },
        {
          "featureType": "poi.park",
          "elementType": "geometry",
          "stylers": [
            {
              "color": "#808080"
            }
          ]
        }
      ]
    ''';
    }


   List<PlacesSearchResult> _searchResults = [];
   List<PlacesSearchResult> get searchResults => _searchResults;

   Future<void> searchPlaces(String query) async {
     PlacesSearchResponse response = await places.searchByText(query);
     _searchResults = response.results;
     notifyListeners();
   }

    double _calculatedDistancePassageiro = 0.0;
    double get calculatedDistancePassageiro => _calculatedDistancePassageiro;

    double _calculatedDistance = 0.0;
    double get calculatedDistance => _calculatedDistance;

    calculateDistance(double startLat, double startLng, double endLat, double endLng) {
      double distanceInMeters = Geolocator.distanceBetween(startLat, startLng, endLat, endLng);
      _calculatedDistance = distanceInMeters / 1000; // Convert meters to kilometers
      //notifyListeners();
    }

    calculateDistancePassageiro(double startLat, double startLng, double endLat, double endLng) {
      double distanceInMeters = Geolocator.distanceBetween(startLat, startLng, endLat, endLng);
      _calculatedDistancePassageiro = distanceInMeters / 1000; // Convert meters to kilometers
      //notifyListeners();
    }





    Localizacao _userLocation = Localizacao(0.0, 0.0);
    LocationServices _locationServices = LocationServices();

    LocationProviderStatus _status = LocationProviderStatus.Success;

    Localizacao get userLocation => _userLocation;

    LocationProviderStatus get status => _status;

    Future<void> getLocation() async {
      try {
        _updateStatus(LocationProviderStatus.Loading);
        _userLocation = await _locationServices.getCurrentLocation();
        _updateStatus(LocationProviderStatus.Success);
      } catch (e) {
        _updateStatus(LocationProviderStatus.Error);
      }
    }

    void _updateStatus(LocationProviderStatus status) {
      if (_status != status) {
        //developer.log('LocationProvider: Status updated from: $_status to: $status');
        _status = status;
        notifyListeners();
      }
    }



}