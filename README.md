## Installation

**First, you need to get a kakao map javascript key**

For more information you can do check here
kakao map guide : https://apis.map.kakao.com/web/guide/

- **Android**

Minimum sdk must be higher than 19

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

No configuration required

## How to use

First import the package

`import 'package:kakaomap_webview/kakaomap_webview.dart';`

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

![kakaomap](https://user-images.githubusercontent.com/71013471/120890934-cc233c80-c640-11eb-8510-afb23ec089c7.gif){: width="50%" height="50%"}

- **Full sample code**

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
