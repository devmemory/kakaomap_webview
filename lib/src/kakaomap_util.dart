import 'package:http/http.dart' as http;
import 'package:kakaomap_webview/src/kakao_latlng.dart';

class KakaoMapUtil {
  /// To get resolved link from redirection.
  /// When the link is invalid, result will be 'error'.
  Future<String> getResolvedLink(String url) async {
    String? link;
    try {
      http.Request request = http.Request('GET', Uri.parse(url));
      request.followRedirects = false;

      http.Client client = http.Client();

      http.StreamedResponse streamedResponse = await client.send(request);

      link = streamedResponse.headers['location'] ?? 'error';
    } catch (e) {
      link = 'error';
    }

    return link;
  }

  /// This method is used for kakao map screen lat, lng, placeName(optional).
  /// If placeName is null, marker might not be showing.
  /// And to get resolved link, please use getResolvedLink method with this.
  String getKakaoMapURL(double lat, double lng, {String? name}) {
    String placeName = '';
    if (name != null) {
      placeName = '$name,';
    }
    return 'https://map.kakao.com/link/map/$placeName$lat,$lng';
  }

  /// This method is to use getResolvedLink and getKakaoMapURL easily with latitude, longitude, placeName(optional).
  Future<String> getMapScreenURL(double lat, double lng, {String? name}) async {
    String originalURL = getKakaoMapURL(lat, lng, name: name);

    String resolvedURL = await getResolvedLink(originalURL);

    return resolvedURL;
  }

  /// This method is to get Lat lng from camera idle event
  @deprecated
  KakaoLatLng getLatLng(String latlng) {
    String oob = latlng.substring(1, latlng.length - 1);
    List<String> list = oob.split(',');
    return KakaoLatLng(
        lat: double.parse(list.first), lng: double.parse(list.last));
  }
}
