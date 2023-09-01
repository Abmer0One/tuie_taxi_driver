import 'dart:async';
import 'package:geolocator/geolocator.dart';
import 'package:tuie_driver_taxi/model/localizacao_model.dart';

class LocationServices {
  Localizacao? userLocation;
  Position? _currentLocation;

  Geolocator geolocator = Geolocator();
  StreamSubscription<Position> ?positionStream;

  StreamController<Localizacao> _locationController = StreamController<Localizacao>();
  Stream<Localizacao> get locationStream => _locationController.stream;

  LocationServices() {
    positionStream = Geolocator.getPositionStream().listen((location) {
      _locationController.add(Localizacao(location.latitude, location.longitude));
    });
  }

  void closeLocation() {
    if (positionStream != null) {
      positionStream!.cancel();
      _locationController.close();
      positionStream = null;
    } else {}
  }



  Future<Localizacao> getCurrentLocation() async {
    try {
      var isServiceEnabled = await Geolocator.isLocationServiceEnabled();

      if (!isServiceEnabled) {
        isServiceEnabled = await Geolocator.isLocationServiceEnabled();
        if (!isServiceEnabled) {
          throw Exception("The Location service is disabled!");
        }
      }

      var isPermission = await Geolocator.checkPermission();
      if (isPermission == LocationPermission.denied ||
          isPermission == LocationPermission.deniedForever) {
        isPermission = await Geolocator.requestPermission();
      }
      if (isPermission == LocationPermission.denied ||
          isPermission == LocationPermission.deniedForever) {
        throw Exception("Location Permission requests has been denied!");
      }

      if (isServiceEnabled &&
          (isPermission == LocationPermission.always ||
              isPermission == LocationPermission.whileInUse)) {
        _currentLocation = await Geolocator.getCurrentPosition().timeout(
          Duration(seconds: 10),
          onTimeout: () {
            throw TimeoutException(
                "Location information could not be obtained within the requested time.");
          },
        );

        userLocation =
            Localizacao(_currentLocation!.latitude, _currentLocation!.longitude);
        return userLocation!;
      } else {
        throw Exception("Location Service requests has been denied!");
      }
    } on TimeoutException catch (_) {
      print(_);
      throw _;
    } catch (e) {
      print(e);
      throw e;
    }
  }
}