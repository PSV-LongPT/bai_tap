import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:webview_windows/webview_windows.dart';

class TrangNguyen extends StatefulWidget {
  final bool showFps;

  const TrangNguyen({Key? key, this.showFps = false}) : super(key: key);

  @override
  _TrangNguyenState createState() => _TrangNguyenState();
}

class _TrangNguyenState extends State<TrangNguyen> {
  final String _domain = 'https://account.trangnguyen.edu.vn/authorize/login?service=http%3A%2F%2Ftrangnguyen.edu.vn%2F';
  final navigatorKey = GlobalKey<NavigatorState>();
  final _controller = WebviewController();

  _TrangNguyenState();

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> initPlatformState() async {
    // Optionally initialize the webview environment using
    // a custom user data directory
    // and/or a custom browser executable directory
    // and/or custom chromium command line flags
    if (widget.showFps) {
      // await WebviewController.initializeEnvironment(additionalArguments: '--show-fps-counter');
    }

    try {
      await _controller.initialize();
      await _controller.setBackgroundColor(Colors.transparent);
      await _controller.setPopupWindowPolicy(WebviewPopupWindowPolicy.deny);
      await _controller.loadUrl(_domain);
      _controller.loadingState.listen((event) async {
        print(event);
        // await _controller.executeScript('''
        //     // Xóa menu
        //     document.getElementById('menu').remove();
        //   ''');
        if (event == LoadingState.navigationCompleted) {
          await _controller.executeScript('''
            // Xóa quảng cáo ở trang login/register
            const boxes = document.querySelectorAll('.banner-right');
            boxes.forEach(box => {
              box.remove();
            })
          ''');
          await _controller.executeScript('''
            // Mở rộng khung login nhìn cho đỡ xấu!
            document.getElementsByClassName('register-box')[0].style.width = '100%';
          ''');
          await _controller.executeScript('''
            // Mở rộng khung login nhìn cho đỡ xấu!
            document.getElementById('form_login').style.width = '100%';
          ''');
          await _controller.executeScript('''
            // Mở rộng khung login nhìn cho đỡ xấu!
            document.getElementById('register-form').style.width = '100%';
          ''');
        }
      });

      if (!mounted) return;
      setState(() {});
    } on PlatformException catch (e) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        showDialog(
          context: context,
          builder: (_) => AlertDialog(
            title: const Text('Error'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Code: ${e.code}'),
                Text('Message: ${e.message}'),
              ],
            ),
            actions: [
              TextButton(
                child: const Text('Continue'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              )
            ],
          ),
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Webview(
      _controller,
      permissionRequested: _onPermissionRequested,
    );
  }

  Future<WebviewPermissionDecision> _onPermissionRequested(String url, WebviewPermissionKind kind, bool isUserInitiated) async {
    final decision = await showDialog<WebviewPermissionDecision>(
      context: navigatorKey.currentContext!,
      builder: (BuildContext context) => AlertDialog(
        title: const Text('WebView permission requested'),
        content: Text('WebView has requested permission \'$kind\''),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.pop(context, WebviewPermissionDecision.deny),
            child: const Text('Deny'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, WebviewPermissionDecision.allow),
            child: const Text('Allow'),
          ),
        ],
      ),
    );

    return decision ?? WebviewPermissionDecision.none;
  }
}
