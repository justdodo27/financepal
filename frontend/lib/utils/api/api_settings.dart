class ApiSettings {
  /// Server address.
  static const serverUrl = 'http://10.0.2.2:8080/';

  /// Builds uri for the backend request on the specified enpoint.
  static Uri buildUri(String endpoint) => Uri.parse('$serverUrl$endpoint'); 
}
