enum MapType { TRAFFIC, ROADVIEW, TERRAIN, USE_DISTRICT, BICYCLE }

extension MapTypeExtension on MapType {
  String get getType {
    return 'kakao.maps.MapTypeId.${this.name};';
  }
}