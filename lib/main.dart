import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final Completer<WebViewController> _controller =
      Completer<WebViewController>();

  var index = 0;

  final videos = [
    "https://player.vimeo.com/external/530794320.hd.mp4?s=068c0f28633bbd8531fae2c03b12258c63c14d67%26profile_id=175",
    "https://player.vimeo.com/external/530793823.hd.mp4?s=942cfe1a1b8c5608ea367479b3bf464e5d896891%26profile_id=175&download=1",
    "https://player.vimeo.com/external/530793693.hd.mp4?s=fcecda4ed8bdccbe930f112e34c60031a5304dac%26profile_id=175&download=1",
    "https://player.vimeo.com/external/530793518.hd.mp4?s=aa253a6a492bb6ddc7fbe4ed314945214513e7bc%26profile_id=175&download=1"
  ];

  String _url = '';

  WebViewController _webViewController;

  @override
  void initState() {
    super.initState();
    // Enable hybrid composition.
    if (Platform.isAndroid) WebView.platform = SurfaceAndroidWebView();

    _url = 'https://junsuk5.github.io/web-test/index.html?url=${videos[0]}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(''),
      ),
      body: Column(
        children: [
          SizedBox(
            height: 300,
            child: WebView(
              initialUrl:
                  _url,
              javascriptMode: JavascriptMode.unrestricted,
              onWebViewCreated: (WebViewController webViewController) {
                _webViewController = webViewController;
                _controller.complete(webViewController);
              },
              javascriptChannels: <JavascriptChannel>{
                _toasterJavascriptChannel(context),
              },
            ),
          ),
          ElevatedButton(onPressed: prevVideo, child: Text('prev')),
          ElevatedButton(onPressed: nextVideo, child: Text('next')),
        ],
      ),
    );
  }

  JavascriptChannel _toasterJavascriptChannel(BuildContext context) {
    return JavascriptChannel(
        name: 'messageHandler',
        onMessageReceived: (JavascriptMessage message) {
          if (message.message == 'next') {
            nextVideo();
          } else if (message.message == 'prev') {
            prevVideo();
          }
          // ignore: deprecated_member_use
          print(message.message);
        });
  }

  void nextVideo() {
    setState(() {
      if (index < videos.length - 1) {
        index++;
      } else {
        index = 0;
      }
      _url = 'https://junsuk5.github.io/web-test/index.html?url=${videos[index]}';
      _webViewController.loadUrl(_url);
    });
  }

  void prevVideo() {
    setState(() {
      if (index > 0) {
        index--;
      } else {
        index = 0;
      }
      _url = 'https://junsuk5.github.io/web-test/index.html?url=${videos[index]}';
      _webViewController.loadUrl(_url);
    });
  }
}
