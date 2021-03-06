import 'package:http/http.dart' as http;
import 'dart:convert';

const GOOGLE_API_KEY = "AIzaSyBu60F_wyNCsWLJBUTWQ7PCc3TEpeCuOqc";

class LocationHelper {
  static String generateLocationPreviewImage(
      {double latitude, double longitude}) {
    print(latitude);
    print(longitude);
    return "https://maps.googleapis.com/maps/api/staticmap?center=$latitude,$longitude&zoom=13&size=600x300&maptype=roadmap&markers=color:blue%7Clabel:A%7C$latitude,$longitude&key=$GOOGLE_API_KEY";
  }

  static Future<String> getPlaceAddress(double lat, double lng) async {
    final url =
        "https://maps.googleapis.com/maps/api/geocode/json?latlng=$lat,$lng&key=$GOOGLE_API_KEY";
    final response = await http.get(url);
    print(response.body);
    return json.decode(response.body)["results"][0]["formatted_address"];
  }
}
