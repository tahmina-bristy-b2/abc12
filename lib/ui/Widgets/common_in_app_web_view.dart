import 'dart:async';

import 'package:MREPORTING/services/order/order_apis.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

class CommonInAppWebView extends StatefulWidget {
  const CommonInAppWebView(
      {super.key,
      required this.title,
      required this.url,
      required this.cid,
      required this.userId,
      required this.userPassword,
      this.clientId});
  final String title;
  final String url;
  final String cid;
  final String userId;
  final String userPassword;
  final String? clientId;

  @override
  State<CommonInAppWebView> createState() => _CommonInAppWebViewState();
}

class _CommonInAppWebViewState extends State<CommonInAppWebView> {
  InAppWebViewController? _controller;
  final Completer<InAppWebViewController> _controllerCompleter =
      Completer<InAppWebViewController>();
  double progress = 0;
  String? deviceId = '';

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // print(
    //     '${widget.url}?cid=${widget.cid}&rep_id=${widget.userId}&rep_pass=${widget.userPassword}');
    return WillPopScope(
      onWillPop: () => _goBack(context),
      child: Scaffold(
          appBar: AppBar(
            title: Text(widget.title),
            centerTitle: true,
            // leading: IconButton(
            //   onPressed: () => Navigator.pop(context),
            //   icon: const Icon(Icons.home),
            // ),
          ),
          body: Stack(
            children: [
              Align(
                alignment: Alignment.center,
                child: SafeArea(
                  child: Center(
                    child: InAppWebView(
                      initialUrlRequest: URLRequest(
                          url: Uri.parse(widget.clientId != null
                              ? OrderApis.orderDynamicReportApi(
                                  widget.url,
                                  widget.cid,
                                  widget.userId,
                                  widget.userPassword,
                                  widget.clientId!)
                              : "${widget.url}?cid=${widget.cid}&rep_id=${widget.userId}&rep_pass=${widget.userPassword}")),
                      onReceivedServerTrustAuthRequest:
                          (controller, challenge) async {
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
