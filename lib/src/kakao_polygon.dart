import 'package:flutter/material.dart';
import 'package:kakaomap_webview/src/kakao_latlng.dart';

extension HexColor on Color {
  String get toHex {
    return '\'#${this.value.toRadixString(16).substring(2, 8)}\'';
  }
}

class KakaoPolygon {
  /// Add polygon lat, lng. It must not be null
  List<KakaoLatLng> polygon;

  /// StrokeColor. Default blue.
  /// If you want to change opacity, use [strokeColorOpacity]
  Color strokeColor = Colors.blue;

  /// StrokeWeight. Default 2.0
  double strokeWeight = 2.0;

  /// StrokeWeight. Default 0.8
  double strokeColorOpacity = 0.8;

  /// Polygon color. Default lightBlue.
  /// If you want to change opacity, use [polygonColorOpacity]
  Color polygonColor = Colors.lightBlue;

  /// Polygon color opacity. Default 0.7
  double polygonColorOpacity = 0.7;

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
