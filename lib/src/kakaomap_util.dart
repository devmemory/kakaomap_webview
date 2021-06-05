import 'package:http/http.dart' as http;

class KakaoMapUtil {
  /// To get resolved link from redirection
  /// When the link is invalid, result will be 'error'
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

  /// This method is used for kakao map screen lat, lng, placeName(optional)
  /// If placeName is null, marker won't be showing
  /// And to get resolved link, please use getResolvedLink method with this
  String getKakaoMapURL(double lat, double lng, {String? name}) {
    String placeName = '';
    if (name != null) {
      placeName = '$name,';
    }
    return 'https://map.kakao.com/link/map/$placeName$lat,$lng';
  }

  /// This is to get the resolved link with lat, lng, placeName(optional)
  /// If placeName is null, marker won't be showing
  Future<String> getMapScreenURL(double lat, double lng, {String? name}) async {
    String originalURL = getKakaoMapURL(lat, lng, name: name);

    String resolvedURL = await getResolvedLink(originalURL);

    return resolvedURL;
  }
}
