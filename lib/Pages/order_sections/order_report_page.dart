import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OrderReportWebViewScreen extends StatefulWidget {
  String report_url;
  String cid;
  String userId;
  String userPassword;
  OrderReportWebViewScreen(
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
    // var a = widget.report_url +
    //     "sales_report_invoice/sales_report_detail_url?cid=${widget.cid}&rep_id=${widget.userId}&password=${widget.userPassword}&device_id=$deviceId";
    print(widget.report_url +
        "?cid=${widget.cid}&rep_id=${widget.userId}&password=${widget.userPassword}&device_id=$deviceId");

    return Scaffold(
        appBar: AppBar(
          backgroundColor: const Color.fromARGB(255, 138, 201, 149),

          title: const Text('Report'),
          titleTextStyle: const TextStyle(
              color: Color.fromARGB(255, 27, 56, 34),
              fontWeight: FontWeight.w500,
              fontSize: 20),
          centerTitle: true,
          leading: IconButton(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(Icons.home)),
          // automaticallyImplyLeading: false,
        ),
        body: Stack(
          children: [
            Align(
              alignment: Alignment.center,
              child: SafeArea(
                child: Center(
                  child: InAppWebView(
                    initialUrlRequest: URLRequest(
                        url: Uri.parse(widget.report_url +
                            "?cid=${widget.cid}&rep_id=${widget.userId}&password=${widget.userPassword}&device_id=$deviceId")),
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
