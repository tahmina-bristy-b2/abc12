import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

class CommonInAppWebView extends StatefulWidget {
  const CommonInAppWebView(
      {super.key,
      required this.url,
      required this.cid,
      required this.userId,
      required this.userPassword});
  final String url;
  final String cid;
  final String userId;
  final String userPassword;

  @override
  State<CommonInAppWebView> createState() => _CommonInAppWebViewState();
}

class _CommonInAppWebViewState extends State<CommonInAppWebView> {
  double progress = 0;
  String? deviceId = '';

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print(
        '${widget.url}?cid=${widget.cid}&rep_id=${widget.userId}&rep_pass=${widget.userPassword}');
    return Scaffold(
        appBar: AppBar(
          title: const Text('Plugin'),
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
                            "${widget.url}?cid=${widget.cid}&rep_id=${widget.userId}&rep_pass=${widget.userPassword}")),
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
