enum MapType { TRAFFIC, ROADVIEW, TERRAIN, USE_DISTRICT, BICYCLE }

extension MapTypeExtension on MapType {
  String get getType {
    switch (this) {
      case MapType.TRAFFIC:
        return 'kakao.maps.MapTypeId.TRAFFIC;';
      case MapType.ROADVIEW:
        return 'kakao.maps.MapTypeId.ROADVIEW;';
      case MapType.TERRAIN:
        return 'kakao.maps.MapTypeId.TERRAIN;';
      case MapType.USE_DISTRICT:
        return 'kakao.maps.MapTypeId.USE_DISTRICT;';
      case MapType.BICYCLE:
        return 'kakao.maps.MapTypeId.BICYCLE;';
    }
  }
}
