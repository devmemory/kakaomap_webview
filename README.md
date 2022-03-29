## Installation

**First, you need to get a kakao map javascript key**

For more information, you can check here
kakao map guide : https://apis.map.kakao.com/web/guide/

- **Android**

Minimum sdk must be higher than 21

AndroidManifest.xml file
- Internet permission is required
- Add android:usesCleartextTraffic="true" in application tag

```
<application
  android:label="your app name"
  android:icon="@mipmap/ic_launcher"
  android:usesCleartextTraffic="true">
```

- **IOS**

- IOS version must be higher than 9.0

- Add following code in your Info.plist

```
<key>NSAppTransportSecurity</key>
      <dict>
        <key>NSAllowsArbitraryLoads</key> <true/>
      </dict>
    <key>io.flutter.embedded_views_preview</key> <true/>
```

## How to use
First, import the package

```
import 'package:kakaomap_webview/kakaomap_webview.dart';
```

You can use this as Widget and full screen webview

1. When you want to use as Widget

```
    KakaoMapView(
    width: size.width,
    height: 400,
    kakaoMapKey: kakaoMapKey,
    lat: 33.450701,
    lng: 126.570667,
    showMapTypeControl: true,
    showZoomControl: true,
    markerImageURL: 'https://t1.daumcdn.net/localimg/localimages/07/mapapidoc/marker_red.png',
    onTapMarker: (message) {
      //event callback when the marker is tapped
    });
```

2. When you want to use full screen webview

```
    KakaoMapUtil util = KakaoMapUtil();
    // String url = await util.getResolvedLink(
    //     util.getKakaoMapURL(37.402056, 127.108212, name: 'Kakao 본사'));

    /// This is short form of the above comment
    String url =
        await util.getMapScreenURL(37.402056, 127.108212, name: 'Kakao 본사');

    Navigator.push(
        context, MaterialPageRoute(builder: (_) => KakaoMapScreen(url: url)));
```

![kakaomap](https://user-images.githubusercontent.com/71013471/120911063-15b26c80-c6bf-11eb-9ddd-bbb6d93792e2.gif)

- **Sample code**

```
import 'package:flutter/material.dart';
import 'package:kakaomap_webview/kakaomap_webview.dart';

const String kakaoMapKey = 'yourKey';

class KakaoMapTest extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(title: Text('Kakao map webview test')),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          KakaoMapView(
              width: size.width,
              height: 400,
              kakaoMapKey: kakaoMapKey,
              lat: 33.450701,
              lng: 126.570667,
              showMapTypeControl: true,
              showZoomControl: true,
              markerImageURL:
                  'https://t1.daumcdn.net/localimg/localimages/07/mapapidoc/marker_red.png',
              onTapMarker: (message) async {
                ScaffoldMessenger.of(context)
                    .showSnackBar(SnackBar(content: Text('Marker is clicked')));

                //await _openKakaoMapScreen(context);
              }),
          ElevatedButton(
              child: Text('Kakao map screen'),
              onPressed: () async {
                await _openKakaoMapScreen(context);
              })
        ],
      ),
    );
  }

  Future<void> _openKakaoMapScreen(BuildContext context) async {
    KakaoMapUtil util = KakaoMapUtil();

    // String url = await util.getResolvedLink(
    //     util.getKakaoMapURL(37.402056, 127.108212, name: 'Kakao 본사'));

    /// This is short form of the above comment
    String url =
        await util.getMapScreenURL(37.402056, 127.108212, name: 'Kakao 본사');

    Navigator.push(
        context, MaterialPageRoute(builder: (_) => KakaoMapScreen(url: url)));
  }
}
```

- **Add polygon**

![polygon](https://user-images.githubusercontent.com/71013471/126046341-24c3869f-ef6a-440d-94b7-385845c16602.png)

polygonColor, polygonColorOpacity, strokeColor, strokeWeight, strokeColorOpacity

These features are optional. It can be null.

So you can add only polygon.

```
        KakaoMapView(
              width: size.width,
              height: 400,
              kakaoMapKey: kakaoMapKey,
              lat: 33.450701,
              lng: 126.570667,
              showMapTypeControl: true,
              showZoomControl: true,
              draggableMarker: true,
              mapType: MapType.BICYCLE,
              polygon: KakaoPolygon(
                polygon: [
                  KakaoLatLng(33.45086654081833, 126.56906858718982),
                  KakaoLatLng(33.45010890948828, 126.56898629127468),
                  KakaoLatLng(33.44979857909499, 126.57049357211622),
                  KakaoLatLng(33.450137483918496, 126.57202991943016),
                  KakaoLatLng(33.450706188506054, 126.57223147947938),
                  KakaoLatLng(33.45164068091554, 126.5713126693152)
                ],
                polygonColor: Colors.red,
                polygonColorOpacity: 0.3,
                strokeColor: Colors.deepOrange,
                strokeWeight: 2.5,
                strokeColorOpacity: 0.9
              ),
              markerImageURL:
                  'https://t1.daumcdn.net/localimg/localimages/07/mapapidoc/marker_red.png',
              onTapMarker: (message) {
                ScaffoldMessenger.of(context)
                    .showSnackBar(SnackBar(content: Text(message.message)));
        })
```

- **Multiple markers**

You can make multiple markers only in customScript now.

Still, there is a sample code.

```
    KakaoMapView(
        width: size.width,
        height: 400,
        kakaoMapKey: kakaoMapKey,
        lat: 33.450701,
        lng: 126.570667,
        customScript: '''
    var markers = [];

    function addMarker(position) {

      var marker = new kakao.maps.Marker({position: position});

      marker.setMap(map);

      markers.push(marker);
    }

    for(var i = 0 ; i < 3 ; i++){
      addMarker(new kakao.maps.LatLng(33.450701 + 0.0003 * i, 126.570667 + 0.0003 * i));

      kakao.maps.event.addListener(markers[i], 'click', (function(i) {
        return function(){
          onTapMarker.postMessage('marker ' + i + ' is tapped');
        };
      })(i));
    }

		  var zoomControl = new kakao.maps.ZoomControl();
      map.addControl(zoomControl, kakao.maps.ControlPosition.RIGHT);

      var mapTypeControl = new kakao.maps.MapTypeControl();
      map.addControl(mapTypeControl, kakao.maps.ControlPosition.TOPRIGHT);
              ''',
        onTapMarker: (message) {
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text(message.message)));
    });
```

- **Overlay**

![overlay](https://user-images.githubusercontent.com/71013471/126056308-87c1fc7c-2183-4d63-8a39-c7f4d7b3070d.png)

You can put text since 0.2.0 version.

Simply, you can add overlayText in KakaoMapView

* Don't use overlayText and customOverlay at the same time.

```
    overlayText: '카카오!'
```

- **Custom Overlay**

![custom](https://user-images.githubusercontent.com/71013471/126056325-cb134017-a9a4-4496-acf7-2d1342969229.png)

You can customize overlay with kakao guideline.

In this case, you can use customOverlayStyle and customOverlay.

* Don't use overlayText and customOverlay at the same time.

Sample code

```
    customOverlayStyle: '''<style>
                  .customoverlay {position:relative;bottom:85px;border-radius:6px;border: 1px solid #ccc;border-bottom:2px solid #ddd;float:left;}
    .customoverlay:nth-of-type(n) {border:0; box-shadow:0px 1px 2px #888;}
    .customoverlay a {display:block;text-decoration:none;color:#000;text-align:center;border-radius:6px;font-size:14px;font-weight:bold;overflow:hidden;background: #d95050;background: #d95050 url(https://t1.daumcdn.net/localimg/localimages/07/mapapidoc/arrow_white.png) no-repeat right 14px center;}
    .customoverlay .title {display:block;text-align:center;background:#fff;margin-right:35px;padding:10px 15px;font-size:14px;font-weight:bold;}
    .customoverlay:after {content:'';position:absolute;margin-left:-12px;left:50%;bottom:-12px;width:22px;height:12px;background:url('https://t1.daumcdn.net/localimg/localimages/07/mapapidoc/vertex_white.png')}
                  </style>''',
                  customOverlay: '''
    var content = '<div class="customoverlay">' +
        '  <a href="https://map.kakao.com/link/map/11394059" target="_blank">' +
        '    <span class="title">카카오!</span>' +
        '  </a>' +
        '</div>';

    var position = new kakao.maps.LatLng(33.450701, 126.570667);

    var customOverlay = new kakao.maps.CustomOverlay({
        map: map,
        position: position,
        content: content,
        yAnchor: 1
    });
                  '''
```

- **Map controller**

![controller](https://user-images.githubusercontent.com/71013471/134121052-3e12befb-b642-4c89-b32c-88dd810c074b.gif)

Now you can control map more with webview controller.
When mapController is not initated, please use StatefulWidget

Sample code

```
    KakaoMapView(
       mapController: (controller) {
          _mapController = controller;
       },
    ),
    Row(
       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
       children: [
         InkWell(
           onTap: () {
             _mapController.runJavascript(
                  'map.setLevel(map.getLevel() - 1, {animate: true})');
           },
           child: CircleAvatar(
             backgroundColor: Colors.red,
             child: const Icon(
               Icons.remove,
               color: Colors.white,
               ),
             ),
           ),
         InkWell(
           onTap: () {
             _mapController.runJavascript(
                  'map.setLevel(map.getLevel() + 1, {animate: true})');
           },
           child: CircleAvatar(
             backgroundColor: Colors.blue,
             child: const Icon(
               Icons.add,
               color: Colors.white,
               ),
             ),
           ),
         ],
       ),
```

- **Callbacks**

Tap marker, zoom change, camera idel events are available.

Sample code

```
    KakaoMapView(
      onTapMarker: (message) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(message.message)));
      },
      zoomChanged: (message) {
        debugPrint('current zoom level : ${message.message}');
      },
      cameraIdle: (message) {
        KakaoMapUtil util = KakaoMapUtil();
        KakaoLatLng latlng = util.getLatLng(message.message);
        debugPrint('current lat lng : ${latlng.lat}, ${latlng.lng}');
      },
    )
```