/// KakaoMap boundary lat, lng
class KakaoBoundary {
  /// South West latitude
  double? swLat;

  /// South West longitude
  double? swLng;

  /// North East latitude
  double? neLat;

  /// North East longitude
  double? neLng;

  KakaoBoundary({this.swLat, this.swLng, this.neLat, this.neLng});

  factory KakaoBoundary.fromJson(Map<String, dynamic> json) {
    return KakaoBoundary(
      swLat: json['sw']['lat'],
      swLng: json['sw']['lng'],
      neLat: json['ne']['lat'],
      neLng: json['ne']['lng'],
    );
  }
}
