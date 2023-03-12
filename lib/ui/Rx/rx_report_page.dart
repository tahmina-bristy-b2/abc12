import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RxReportPageWebView extends StatefulWidget {
  String report_url;
  String cid;
  String userId;
  String userPassword;
  RxReportPageWebView(
      {Key? key,
      required this.report_url,
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
    SharedPreferences.getInstance().then((prefs) {
      deviceId = prefs.getString("deviceId");
      // deviceBrand = prefs.getString("deviceBrand");
      // deviceModel = prefs.getString("deviceModel");
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print(widget.report_url +
        "?cid=${widget.cid}&rep_id=${widget.userId}&rep_pass=${widget.userPassword}&device_id=$deviceId");
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
                            // 'http://w05.yeapps.com/hamdard/report_seen_rx_mobile/index?cid=HAMDARD&rep_id=itmso&rep_pass=1234'

                            widget.report_url +
                                "?cid=${widget.cid}&rep_id=${widget.userId}&rep_pass=${widget.userPassword}&device_id=$deviceId")),
                    onReceivedServerTrustAuthRequest:
                        (controller, challenge) async {
                      // print(challenge);
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
}
