import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'dart:io' show Platform;

void main() {
  runApp(const MyApp());
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cycle Dekho', debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: FutureBuilder(
        future: Future.delayed(Duration(seconds: 3)),
        builder: (ctx, timer) =>
        timer.connectionState == ConnectionState.done
            ? MyHomePage() //Screen to navigate to once the splashScreen is done.
            : Container(
          color: Colors.white,
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Image(
              image: AssetImage('assets/WhatsApp Image 2024-02-16 at 18.19.56_0b566de5.jpg'),
              fit: BoxFit.cover,
            ),
          ),
        ),
      ),
    );
  }
}


class MyHomePage extends StatefulWidget {
  MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  late final WebViewController controller;
  double progress = 0.0;
  void initState(){
    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progres) {
            setState(() {
              progress = progres / 100;
            });
          },
          onPageStarted: (String url) {},
          onPageFinished: (String url) {},
          onWebResourceError: (WebResourceError error) {},
          onNavigationRequest: (NavigationRequest request) {
            if (request.url.startsWith('https://cycledekhoj.in/')) {
              return NavigationDecision.prevent;
            }
            return NavigationDecision.navigate;
          },
        ),
      )..loadRequest(Uri.parse('https://digitalfriend.site/'));
    setState(() {

    });
  }
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  DateTime? _lastPressedAt;
  @override
  Widget build(BuildContext context) {
    int backButtonPressCount = 0;
    return  WillPopScope(
      onWillPop: () async {
        if (_lastPressedAt == null || DateTime.now().difference(_lastPressedAt!) > Duration(seconds: 2)) {
          if (await controller.canGoBack()) {
            controller.goBack();
          } else {
            _lastPressedAt = DateTime.now();
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Press back again to exit'),
                duration: Duration(seconds: 2),
              ),
            );
          }
          return false; // Do not exit the app
        } else {
          return true; // Allow exit the app
        }
      },
      child: Container(
        width : MediaQuery.of(context).size.width,
        height : MediaQuery.of(context).size.height,
        child: Scaffold(
          resizeToAvoidBottomInset: true ,
          key: _scaffoldKey ,
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(10.0) , // Set the desired height
            child: AppBar(
              backgroundColor: Color(0xff2d5be3) ,
              bottom: PreferredSize(
                preferredSize: Size.fromHeight(4.0) , // Set the desired height
                child: LinearProgressIndicator(
                  value: progress ,
                  backgroundColor: Colors.white ,
                  valueColor: AlwaysStoppedAnimation<Color>( Color(0xff2d5be3)),
                ),
              ),
            ),
          ),
          body: WebViewWidget(controller: controller,
          ),
        ),
      ),
    );
  }

  Future<void> _refreshWebView() async {
    await controller.reload();
  }
}