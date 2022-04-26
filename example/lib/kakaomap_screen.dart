import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';

class KakaoMapScreen extends StatelessWidget {
  KakaoMapScreen({Key? key, required this.url}) : super(key: key);

  final String url;

  final GlobalKey<ScaffoldMessengerState> _scaffoldMessengerKey =
      GlobalKey<ScaffoldMessengerState>();

  final MethodChannel _channel = MethodChannel('openIntentChannel');

  @override
  Widget build(BuildContext context) {
    return ScaffoldMessenger(
      key: _scaffoldMessengerKey,
      child: Scaffold(
          body: SafeArea(
        child: WebView(
            initialUrl: url,
            javascriptMode: JavascriptMode.unrestricted,
            javascriptChannels: <JavascriptChannel>{
              _toasterJavascriptChannel()
            },
            navigationDelegate: (delegate) async {
              debugPrint('[Webview] delegate : ${delegate.url}');

              if (Platform.isAndroid && delegate.url.startsWith('intent://')) {
                await _channel.invokeMethod('intent', {'url': delegate.url});

                return NavigationDecision.prevent;
              } else if (Platform.isIOS && delegate.url.contains('itms-apps')) {
                await _iosNavigate(delegate.url);

                return NavigationDecision.prevent;
              }

              return NavigationDecision.navigate;
            }),
      )),
    );
  }

  JavascriptChannel _toasterJavascriptChannel() {
    return JavascriptChannel(
        name: 'Toaster',
        onMessageReceived: (JavascriptMessage message) {
          _scaffoldMessengerKey.currentState
              ?.showSnackBar(SnackBar(content: Text(message.message)));
        });
  }

  /// navigate to other app.
  /// It needs to test in real device
  Future<void> _iosNavigate(String url) async {
    if (url.contains('id304608425')) {
      // if kakao map exists open app
      if (!(await launchUrl(Uri.parse('kakaomap://open')))) {
        // if kakao map doesn't exist open market and navigate to app store
        await launchUrl(Uri.parse('https://apps.apple.com/us/app/id304608425'));
      }
    } else {
      // rest of them are just launching..
      await launchUrl(Uri.parse(url));
    }
  }
}
