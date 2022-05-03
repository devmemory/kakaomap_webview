import 'dart:convert';
import 'package:example/kakaomap_screen.dart';
import 'package:flutter/material.dart';
import 'package:kakaomap_webview/kakaomap_webview.dart';
import 'package:webview_flutter/webview_flutter.dart';

const String kakaoMapKey = 'yourKey';

void main() {
  runApp(MaterialApp(home: KakaoMapTest()));
}

class KakaoMapTest extends StatefulWidget {
  @override
  State<KakaoMapTest> createState() => _KakaoMapTestState();
}

class _KakaoMapTestState extends State<KakaoMapTest> {
  late WebViewController _mapController;
  final double _lat = 33.450701;
  final double _lng = 126.570667;

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
            lat: _lat,
            lng: _lng,
            showMapTypeControl: true,
            showZoomControl: true,
            draggableMarker: true,
            mapType: MapType.BICYCLE,
            mapController: (controller) {
              _mapController = controller;
            },
            polyline: KakaoFigure(
              path: [
                KakaoLatLng(lat: 33.45080604081833, lng: 126.56900858718982),
                KakaoLatLng(lat: 33.450766588506054, lng: 126.57263147947938),
                KakaoLatLng(lat: 33.45162008091554, lng: 126.5713226693152)
              ],
              strokeColor: Colors.blue,
              strokeWeight: 2.5,
              strokeColorOpacity: 0.9,
            ),
            polygon: KakaoFigure(
              path: [
                KakaoLatLng(lat: 33.45086654081833, lng: 126.56906858718982),
                KakaoLatLng(lat: 33.45010890948828, lng: 126.56898629127468),
                KakaoLatLng(lat: 33.44979857909499, lng: 126.57049357211622),
                KakaoLatLng(lat: 33.450137483918496, lng: 126.57202991943016),
                KakaoLatLng(lat: 33.450706188506054, lng: 126.57223147947938),
                KakaoLatLng(lat: 33.45164068091554, lng: 126.5713126693152)
              ],
              polygonColor: Colors.red,
              polygonColorOpacity: 0.3,
              strokeColor: Colors.deepOrange,
              strokeWeight: 2.5,
              strokeColorOpacity: 0.9,
              strokeStyle: StrokeStyle.shortdashdot,
            ),
            // overlayText: '카카오!',
            customOverlayStyle: '''<style>
              .customoverlay {position:relative;bottom:85px;border-radius:6px;border: 1px solid #ccc;border-bottom:2px solid #ddd;float:left;}
.customoverlay:nth-of-type(n) {border:0; box-shadow:0px 1px 2px #888;}
.customoverlay a {display:block;text-decoration:none;color:#000;text-align:center;border-radius:6px;font-size:14px;font-weight:bold;overflow:hidden;background: #d95050;background: #d95050 url(https://t1.daumcdn.net/localimg/localimages/07/mapapidoc/arrow_white.png) no-repeat right 14px center;}
.customoverlay .title {display:block;text-align:center;background:#fff;margin-right:35px;padding:10px 15px;font-size:14px;font-weight:bold;}
.customoverlay:after {content:'';position:absolute;margin-left:-12px;left:50%;bottom:-12px;width:22px;height:12px;background:url('https://t1.daumcdn.net/localimg/localimages/07/mapapidoc/vertex_white.png')}
              </style>''',
            customOverlay: '''
const content = '<div class="customoverlay">' +
    '  <a href="https://map.kakao.com/link/map/11394059" target="_blank">' +
    '    <span class="title">카카오!</span>' +
    '  </a>' +
    '</div>';

const position = new kakao.maps.LatLng($_lat, $_lng);

const customOverlay = new kakao.maps.CustomOverlay({
    map: map,
    position: position,
    content: content,
    yAnchor: 1
});
              ''',
            markerImageURL:
                'https://t1.daumcdn.net/localimg/localimages/07/mapapidoc/marker_red.png',
            onTapMarker: (message) {
              ScaffoldMessenger.of(context)
                  .showSnackBar(SnackBar(content: Text(message.message)));
            },
            zoomChanged: (message) {
              debugPrint('[zoom] ${message.message}');
            },
            cameraIdle: (message) {
              KakaoLatLng latLng =
                  KakaoLatLng.fromJson(jsonDecode(message.message));
              debugPrint('[idle] ${latLng.lat}, ${latLng.lng}');
            },
            boundaryUpdate: (message) {
              KakaoBoundary boundary =
                  KakaoBoundary.fromJson(jsonDecode(message.message));
              debugPrint(
                  '[boundary] ne : ${boundary.neLat}, ${boundary.neLng}, sw : ${boundary.swLat}, ${boundary.swLng}');
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
              )
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              InkWell(
                onTap: () {
                  _mapController.runJavascript('''
      addMarker(new kakao.maps.LatLng($_lat + 0.0003, $_lng + 0.0003));
      
      function addMarker(position) {
        let testMarker = new kakao.maps.Marker({position: position});

        testMarker.setMap(map);
      }
                      ''');
                },
                child: CircleAvatar(
                  backgroundColor: Colors.amber,
                  child: const Icon(
                    Icons.pin_drop,
                    color: Colors.white,
                  ),
                ),
              ),
              InkWell(
                onTap: () async {
                  await _mapController.reload();
                  debugPrint('[refresh] done');
                },
                child: CircleAvatar(
                  backgroundColor: Colors.green,
                  child: const Icon(
                    Icons.refresh,
                    color: Colors.white,
                  ),
                ),
              )
            ],
          ),
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

    debugPrint('url : $url');

    Navigator.push(
        context, MaterialPageRoute(builder: (_) => KakaoMapScreen(url: url)));
  }

  Widget _testingCustomScript(
      {required Size size, required BuildContext context}) {
    return KakaoMapView(
        width: size.width,
        height: 400,
        kakaoMapKey: kakaoMapKey,
        lat: 33.450701,
        lng: 126.570667,
        customScript: '''
    let markers = [];
    
    function addMarker(position) {
    
      let marker = new kakao.maps.Marker({position: position});

      marker.setMap(map);
    
      markers.push(marker);
    }
    
    for(let i = 0 ; i < 3 ; i++){
      addMarker(new kakao.maps.LatLng(33.450701 + 0.0003 * i, 126.570667 + 0.0003 * i));

      kakao.maps.event.addListener(markers[i], 'click', (i) => {
        return function(){
          onTapMarker.postMessage('marker ' + i + ' is tapped');
        };
      });
    }
    
		  const zoomControl = new kakao.maps.ZoomControl();
      map.addControl(zoomControl, kakao.maps.ControlPosition.RIGHT);
   
      const mapTypeControl = new kakao.maps.MapTypeControl();
      map.addControl(mapTypeControl, kakao.maps.ControlPosition.TOPRIGHT);
              ''',
        onTapMarker: (message) {
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text(message.message)));
        });
  }
}
