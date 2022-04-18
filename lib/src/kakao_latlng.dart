/// KakaoMap lat, lng
class KakaoLatLng {
  /// Latitude
  double? lat;

  /// Longitude
  double? lng;

  KakaoLatLng({this.lat, this.lng});

  factory KakaoLatLng.fromJson(Map<String, dynamic> json) {
    return KakaoLatLng(lat: json['lat'], lng: json['lng']);
  }
}
