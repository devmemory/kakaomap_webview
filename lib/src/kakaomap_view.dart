import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:kakaomap_webview/src/kakao_polygon.dart';
import 'package:kakaomap_webview/src/kakaomap_type.dart';
import 'package:webview_flutter/webview_flutter.dart';

class KakaoMapView extends StatelessWidget {
  /// Map width. If width is wider than screen size, the map center can be changed
  final double width;

  /// Map height
  final double height;

  /// default zoom level : 3 (0 ~ 14)
  final int zoomLevel;

  /// center latitude
  final double lat;

  /// center longitude
  final double lng;

  /// Kakao map key javascript key
  final String kakaoMapKey;

  /// If it's true, zoomController will be enabled.
  final bool showZoomControl;

  /// If it's true, mapTypeController will be enabled. Normal map, Sky view are supported
  final bool showMapTypeControl;

  /// Set marker image. If it's null, default marker will be showing
  final String markerImageURL;

  /// TRAFFIC, ROADVIEW, TERRAIN, USE_DISTRICT, BICYCLE are supported.
  /// If null, type is default
  final MapType? mapType;

  /// Set marker draggable. Default is false
  final bool draggableMarker;

  /// Overlay text. If null, it won't be enabled.
  /// It must not be used with [customOverlay]
  final String? overlayText;

  /// Overlay style. You can customize your own overlay style
  final String? customOverlayStyle;

  /// Overlay text with other features.
  /// It must not be used with [overlayText]
  final String? customOverlay;

  /// Marker tap event
  final void Function(JavascriptMessage)? onTapMarker;

  /// Zoom change event
  final void Function(JavascriptMessage)? zoomChanged;

  /// When user stop moving camera, this event will occur
  final void Function(JavascriptMessage)? cameraIdle;

  /// [KakaoPolygon] is required [KakaoPolygon.polygon] to make polygon.
  /// If null, it won't be enabled
  final KakaoPolygon? polygon;

  /// This is used to make your own features.
  /// Only map size and center position is set.
  /// And other optional features won't work.
  /// such as Zoom, MapType, markerImage, onTapMarker.
  final String? customScript;

  /// When you want to use key for the widget to get some features.
  /// such as position, size, etc you can use this
  final GlobalKey? mapWidgetKey;

  /// You can use js code with controller.
  /// example)
  /// mapController.evaluateJavascript('map.setLevel(map.getLevel() + 1, {animate: true})');
  final void Function(WebViewController)? mapController;

  KakaoMapView({required this.width,
    required this.height,
    required this.kakaoMapKey,
    required this.lat,
    required this.lng,
    this.zoomLevel = 3,
    this.overlayText,
    this.customOverlayStyle,
    this.customOverlay,
    this.polygon,
    this.showZoomControl = false,
    this.showMapTypeControl = false,
    this.onTapMarker,
    this.zoomChanged,
    this.cameraIdle,
    this.markerImageURL = '',
    this.customScript,
    this.mapWidgetKey,
    this.draggableMarker = false,
    this.mapType,
    this.mapController});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      key: mapWidgetKey,
      height: height,
      width: width,
      child: WebView(
        initialUrl: (customScript == null) ? _getHTML() : _customScriptHTML(),
        onWebViewCreated: mapController,
        javascriptMode: JavascriptMode.unrestricted,
        javascriptChannels: _getChannels,
        debuggingEnabled: true,
        gestureRecognizers: <Factory<OneSequenceGestureRecognizer>>[
          Factory(() => EagerGestureRecognizer()),
        ].toSet(),
      ),
    );
  }

  Set<JavascriptChannel>? get _getChannels {
    Set<JavascriptChannel>? channels = {};
    if (onTapMarker != null) {
      channels.add(JavascriptChannel(
          name: 'onTapMarker', onMessageReceived: onTapMarker!));
    }

    if (zoomChanged != null) {
      channels.add(JavascriptChannel(
          name: 'zoomChanged', onMessageReceived: zoomChanged!));
    }

    if(cameraIdle != null){
      channels.add(JavascriptChannel(
          name: 'cameraIdle', onMessageReceived: cameraIdle!));
    }

    if (channels.isEmpty) {
      return null;
    }

    return channels;
  }

  String _getHTML() {
    String iosSetting = '';
    String markerImageOption = '';
    String overlayStyle = '';

    if (Platform.isIOS) {
      iosSetting = 'min-width:${width}px;min-height:${height}px;';
    }

    if (markerImageURL.isNotEmpty) {
      markerImageOption = 'image: markerImage';
    }

    if (overlayText != null) {
      if (customOverlayStyle == null) {
        overlayStyle = '''
<style>
  .label {margin-bottom: 96px;}
  .label * {display: inline-block;vertical-align: top;}
  .label .left {background: url("https://t1.daumcdn.net/localimg/localimages/07/2011/map/storeview/tip_l.png") no-repeat;display: inline-block;height: 24px;overflow: hidden;vertical-align: top;width: 7px;}
  .label .center {background: url(https://t1.daumcdn.net/localimg/localimages/07/2011/map/storeview/tip_bg.png) repeat-x;display: inline-block;height: 24px;font-size: 12px;line-height: 24px;}
  .label .right {background: url("https://t1.daumcdn.net/localimg/localimages/07/2011/map/storeview/tip_r.png") -1px 0  no-repeat;display: inline-block;height: 24px;overflow: hidden;width: 6px;}
</style>
      ''';
      } else {
        overlayStyle = customOverlayStyle ?? '';
      }
    } else {
      overlayStyle = customOverlayStyle ?? '';
    }

    return Uri.dataFromString('''
<html>
<head>
  <meta name='viewport' content='width=device-width, initial-scale=1.0, user-scalable=yes\'>
$overlayStyle
</head>
<body style="padding:0; margin:0;">
	<div id='map' style="width:100%;height:100%;$iosSetting"></div>
	<script type="text/javascript" src='https://dapi.kakao.com/v2/maps/sdk.js?autoload=true&appkey=$kakaoMapKey'></script>
	<script>
		var container = document.getElementById('map');
		
		var options = {
			center: new kakao.maps.LatLng($lat, $lng),
			level: $zoomLevel
		};

		var map = new kakao.maps.Map(container, options);
		
		if(${markerImageURL.isNotEmpty}){
		  var imageSrc = '$markerImageURL',
		      imageSize = new kakao.maps.Size(64, 69),
		      imageOption = {offset: new kakao.maps.Point(27, 69)},
		      markerImage = new kakao.maps.MarkerImage(imageSrc, imageSize, imageOption);
		}
		var markerPosition  = new kakao.maps.LatLng($lat, $lng);
		
		var marker = new kakao.maps.Marker({
      position: markerPosition,
      $markerImageOption
    });
    
    marker.setMap(map);
    
    if(${overlayText != null}){
      var content = '<div class ="label"><span class="left"></span><span class="center">$overlayText</span><span class="right"></span></div>';
  
      var overlayPosition = new kakao.maps.LatLng($lat, $lng);  
  
      var customOverlay = new kakao.maps.CustomOverlay({
          map: map,
          position: overlayPosition,
          content: content,
          yAnchor: 0.8
      });
    } else if(${customOverlay != null}){
      $customOverlay
    }
    
    if(${onTapMarker != null}){
      kakao.maps.event.addListener(marker, 'click', function(){
        onTapMarker.postMessage('marker is tapped');
      });
    }
		
		if(${zoomChanged != null}){
		  kakao.maps.event.addListener(map, 'zoom_changed', function() {        
        var level = map.getLevel();
        zoomChanged.postMessage(level.toString());
      });
		}
		
		if(${cameraIdle != null}){
		  kakao.maps.event.addListener(map, 'dragend', function() {        
        var latlng = map.getCenter(); 
        cameraIdle.postMessage(latlng.toString());
      });
		}
		
		if($showZoomControl){
		  var zoomControl = new kakao.maps.ZoomControl();
      map.addControl(zoomControl, kakao.maps.ControlPosition.RIGHT);
    }
    
    if($showMapTypeControl){
      var mapTypeControl = new kakao.maps.MapTypeControl();
      map.addControl(mapTypeControl, kakao.maps.ControlPosition.TOPRIGHT);
    }
    
    if(${mapType != null}){
      var changeMapType = ${mapType?.getType};
      
      map.addOverlayMapTypeId(changeMapType);
    }
    
    marker.setDraggable($draggableMarker); 
    
    if(${polygon != null}){
      var polygon = new kakao.maps.Polygon({
	      map: map,
        path: [${polygon?.getPolygon}],
        strokeWeight: ${polygon?.strokeWeight},
        strokeColor: ${polygon?.getStrokeColor},
        strokeOpacity: ${polygon?.strokeColorOpacity},
        fillColor: ${polygon?.getPolygonColor},
        fillOpacity: ${polygon?.polygonColorOpacity} 
      });
    }
	</script>
</body>
</html>
    ''', mimeType: 'text/html', encoding: Encoding.getByName('utf-8'))
        .toString();
  }

  String _customScriptHTML() {
    String iosSetting = '';

    if (Platform.isIOS) {
      iosSetting = 'min-width:${width}px;min-height:${height}px;';
    }

    return Uri.dataFromString('''
<html>
<head>
  <meta name='viewport' content='width=device-width, initial-scale=1.0, user-scalable=yes\'>
</head>
<body style="padding:0; margin:0;">
	<div id='map' style="width:100%;height:100%;$iosSetting"></div>
	<script type="text/javascript" src='https://dapi.kakao.com/v2/maps/sdk.js?autoload=true&appkey=$kakaoMapKey'></script>
	<script>
		var container = document.getElementById('map');
				
		var options = {
			center: new kakao.maps.LatLng($lat, $lng),
			level: 3
		};

		var map = new kakao.maps.Map(container, options);
		
		$customScript
	</script>
</body>
</html>
    ''', mimeType: 'text/html', encoding: Encoding.getByName('utf-8'))
        .toString();
  }
}
