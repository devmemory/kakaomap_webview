import 'package:flutter/material.dart';
import 'package:kakaomap_webview/src/kakao_latlng.dart';

/// change Color to String hex code
extension HexColor on Color {
  String get toHex {
    return '\'#${this.value.toRadixString(16).substring(2, 8)}\'';
  }
}

/// KakaoMap polygon
class KakaoPolygon {
  /// Add polygon lat, lng. It must not be null
  List<KakaoLatLng> polygon;

  /// StrokeColor. Default blue.
  /// If you want to change opacity, use [strokeColorOpacity]
  Color strokeColor;

  /// StrokeWeight. Default 2.0
  double strokeWeight;

  /// StrokeWeight. Default 0.8
  double strokeColorOpacity;

  /// Polygon color. Default lightBlue.
  /// If you want to change opacity, use [polygonColorOpacity]
  Color polygonColor;

  /// Polygon color opacity. Default 0.7
  double polygonColorOpacity;

  /// This getter is used to make a hex code for the stroke color
  String get getStrokeColor => strokeColor.toHex;

  /// This getter is used to make a hex code for the polygon color
  String get getPolygonColor => polygonColor.toHex;

  /// This getter is used to make a hex code for the polygon array
  String get getPolygon {
    String polygonText = '[';
    String polygonList = '';
    polygon.forEach((element) {
      polygonList += 'new kakao.maps.LatLng(${element.lat}, ${element.lng}),';
    });
    polygonText += '$polygonList]';
    return polygonText;
  }

  KakaoPolygon(
      {required this.polygon,
      this.strokeColor = Colors.blue,
      this.strokeWeight = 2.0,
      this.strokeColorOpacity = 0.8,
      this.polygonColor = Colors.lightBlue,
      this.polygonColorOpacity = 0.7});
}
