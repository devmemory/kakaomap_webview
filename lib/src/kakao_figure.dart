import 'package:flutter/material.dart';
import 'package:kakaomap_webview/src/kakao_latlng.dart';

/// stroke style
enum StrokeStyle { solid, dashed, shortdashdot, longdash }

/// change Color to String hex code
extension HexColor on Color {
  String get toHex {
    return '\'#${this.value.toRadixString(16).substring(2, 8)}\'';
  }
}

/// This class is used for polygon, ployline
class KakaoFigure {
  /// Add polygon or polyline lat, lng. It must not be null
  List<KakaoLatLng> path;

  /// Stroke style. default is [StrokeStyle.solid]
  StrokeStyle strokeStyle;

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
  String get getPath {
    String pathText = '[';
    String pathList = '';
    path.forEach((element) {
      pathList += 'new kakao.maps.LatLng(${element.lat}, ${element.lng}),';
    });
    pathText += '$pathList]';
    return pathText;
  }

  KakaoFigure(
      {required this.path,
      this.strokeColor = Colors.blue,
      this.strokeWeight = 2.0,
      this.strokeColorOpacity = 0.8,
      this.polygonColor = Colors.lightBlue,
      this.polygonColorOpacity = 0.7,
      this.strokeStyle = StrokeStyle.solid});
}
