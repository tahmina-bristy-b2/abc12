import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RxReportPageWebView extends StatefulWidget {
  String reportUrl;
  String cid;
  String userId;
  String userPassword;
  RxReportPageWebView(
      {Key? key,
      required this.reportUrl,
      required this.cid,
      required this.userId,
      required this.userPassword})
      : super(key: key);

  @override
  State<RxReportPageWebView> createState() => _RxReportPageWebViewState();
}

class _RxReportPageWebViewState extends State<RxReportPageWebView> {
  double progress = 0;
  String? deviceId = '';

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print(
        "${widget.reportUrl}?cid=${widget.cid}&rep_id=${widget.userId}&rep_pass=${widget.userPassword}&device_id=$deviceId");
    return Scaffold(
        appBar: AppBar(
          title: const Text('Rx Report'),
          centerTitle: true,
          leading: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.home),
          ),
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
                            "${widget.reportUrl}?cid=${widget.cid}&rep_id=${widget.userId}&rep_pass=${widget.userPassword}&device_id=$deviceId")),
                    onReceivedServerTrustAuthRequest:
                        (controller, challenge) async {
                      return ServerTrustAuthResponse(
                          action: ServerTrustAuthResponseAction.PROCEED);
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
        ));
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
}
