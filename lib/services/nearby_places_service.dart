import 'package:google_maps_webservice/places.dart';

class NearbyPlacesService {
  final GoogleMapsPlaces _places = GoogleMapsPlaces(apiKey: 'YOUR_API_KEY');

  Future<List<PlacesSearchResult>> fetchNearbyPlaces(double latitude, double longitude, String type) async {
    final response = await _places.searchNearbyWithRadius(
      Location(lat: latitude, lng: longitude),
      5000, // Radius in meters
      type: type, // Specify the type of places (e.g., restaurant, hospital, etc.)
    );
    
    if (response.status == 'OK') {
      return response.results;
    } else {
      throw Exception('Failed to fetch nearby places');
    }
  }
}
