import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OrderReportWebViewScreen extends StatefulWidget {
  final String report_url;
  final String cid;
  final String userId;
  final String userPassword;
  const OrderReportWebViewScreen(
      {Key? key,
      required this.report_url,
      required this.cid,
      required this.userId,
      required this.userPassword})
      : super(key: key);

  @override
  State<OrderReportWebViewScreen> createState() =>
      _OrderReportWebViewScreenState();
}

class _OrderReportWebViewScreenState extends State<OrderReportWebViewScreen> {
  double progress = 0;
  String? deviceId = '';
  InAppWebViewController? _controller;
  final Completer<InAppWebViewController> _controllerCompleter =
      Completer<InAppWebViewController>();
  @override
  void initState() {
    SharedPreferences.getInstance().then((prefs) {
      deviceId = prefs.getString("deviceId");

      // deviceBrand = prefs.getString("deviceBrand");
      // deviceModel = prefs.getString("deviceModel");
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => _goBack(context),
      child: Scaffold(
          appBar: AppBar(
            backgroundColor: const Color.fromARGB(255, 138, 201, 149),

            title: const Text('Report'),
            titleTextStyle: const TextStyle(
                color: Color.fromARGB(255, 27, 56, 34),
                fontWeight: FontWeight.w500,
                fontSize: 20),
            centerTitle: true,
            // leading: IconButton(
            //     onPressed: () => Navigator.pop(context),
            //     icon: const Icon(Icons.home)),
            // automaticallyImplyLeading: false,
            actions: [
              IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.home))
            ],
          ),
          body: Stack(
            children: [
              Align(
                alignment: Alignment.center,
                child: SafeArea(
                  child: Center(
                    child: InAppWebView(
                      initialUrlRequest: URLRequest(
                          url: Uri.parse(
                              "${widget.report_url}?cid=${widget.cid}&rep_id=${widget.userId}&password=${widget.userPassword}&device_id=$deviceId")),
                      onReceivedServerTrustAuthRequest:
                          (controller, challenge) async {
                        // print(challenge);
                        return ServerTrustAuthResponse(
                            action: ServerTrustAuthResponseAction.PROCEED);
                      },
                      onWebViewCreated:
                          (InAppWebViewController webViewController) {
                        _controllerCompleter.future
                            .then((value) => _controller = value);
                        _controllerCompleter.complete(webViewController);
                      },
                      onProgressChanged:
                          (InAppWebViewController controller, int progress) {
                        setState(() {
                          this.progress = progress / 100;
                        });
                      },
                    ),
                  ),
                ),
              ),
              Align(alignment: Alignment.topCenter, child: _buildProgressBar()),
            ],
          )),
    );
  }

  Widget _buildProgressBar() {
    if (progress != 1.0) {
      // return const CircularProgressIndicator();
// You can use LinearProgressIndicator also
      return LinearProgressIndicator(
        value: progress,
        valueColor: const AlwaysStoppedAnimation<Color>(Colors.orange),
        backgroundColor: Colors.blue,
        minHeight: 7,
      );
    }
    return Container();
  }

  Future<bool> _goBack(BuildContext context) async {
    if (await _controller!.canGoBack()) {
      _controller!.goBack();
      return Future.value(false);
    } else {
      // showDialog(
      //     context: context,
      //     builder: (context) => AlertDialog(
      //           title: Text('Do you want to exit'),
      //           actions: <Widget>[
      //             ElevatedButton(
      //               onPressed: () {
      //                 Navigator.of(context).pop();
      //               },
      //               child: Text('No'),
      //             ),
      //             ElevatedButton(
      //               onPressed: () {
      //                 SystemNavigator.pop();
      //               },
      //               child: Text('Yes'),
      //             ),
      //           ],
      //         ));
      return Future.value(true);
    }
  }
}
