import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:contained_tab_bar_view/contained_tab_bar_view.dart';

class PrivacyPolicyView extends StatefulWidget {
  const PrivacyPolicyView({super.key});

  @override
  State<PrivacyPolicyView> createState() => _PrivacyPolicyViewState();
}

class _PrivacyPolicyViewState extends State<PrivacyPolicyView> {
  //MaterialColor? _themeColor;
  WebViewController privacyPolicy_controller = WebViewController();
  WebViewController termsAndConditions_controller = WebViewController();
  WebViewController copyrights_controller = WebViewController();

  @override
  void initState() {
    super.initState();
    setState(() {
      // _themeColor = AppConstants.themeColor ?? AppColors.theme_one;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Object Detection', style: TextStyle(color: Colors.white)),
        centerTitle: true,
        backgroundColor: Color.fromARGB(255, 2, 20, 69),
      ),
      body: Container(
        //color: Color.fromARGB(255, 209, 84, 72),
        child: ContainedTabBarView(
          tabBarProperties: TabBarProperties(
              indicatorColor: Colors.blue, indicatorWeight: 3.0),
          tabs: [
            Text(
              "Privacy Policy",
              style: TextStyle(
                fontSize: 14,
                color: Colors.black,
              ),
            ),
            Text(
              "Terms & Conditions",
              style: TextStyle(
                fontSize: 14,
                color: Colors.black,
              ),
              textAlign: TextAlign.center,
            ),
            Text(
              "Copy Right Policy",
              style: TextStyle(fontSize: 14,
                  color: Colors.black,
              ),
            )
          ],
          views: [
            Container(
              child: WebViewWidget(
                controller: privacyPolicy_controller
                  ..setJavaScriptMode(JavaScriptMode.unrestricted)
                  ..setBackgroundColor(Color.fromARGB(0, 243, 214, 214))
                  ..setNavigationDelegate(
                    NavigationDelegate(
                      onWebResourceError: (WebResourceError error) {},
                    ),
                  )
                  ..loadRequest(Uri.parse(
                      "https://www.cgg.gov.in/mgov-privacy-policy/?depot_name=Centre%20for%20Good%20Governance%20(CGG),%20Govt.%20of%20Telangana")),
                gestureRecognizers: Set()
                  ..add(Factory<VerticalDragGestureRecognizer>(
                      () => VerticalDragGestureRecognizer())),
              ),
            ),
            Container(
              child: WebViewWidget(
                controller: termsAndConditions_controller
                  ..setJavaScriptMode(JavaScriptMode.unrestricted)
                  ..setBackgroundColor(const Color(0x00000000))
                  ..setNavigationDelegate(
                    NavigationDelegate(
                      onWebResourceError: (WebResourceError error) {},
                    ),
                  )
                  ..loadRequest(Uri.parse(
                      "https://www.cgg.gov.in/mgov-terms-conditions/?depot_name=Centre%20for%20Good%20Governance%20(CGG),%20Govt.%20of%20Telangana&capital=Hyderabad,%20Telangana")),
                gestureRecognizers: Set()
                  ..add(Factory<VerticalDragGestureRecognizer>(
                      () => VerticalDragGestureRecognizer())),
              ),
            ),
            Container(
              child: WebViewWidget(
                controller: copyrights_controller
                  ..setJavaScriptMode(JavaScriptMode.unrestricted)
                  ..setBackgroundColor(const Color(0x00000000))
                  ..setNavigationDelegate(
                    NavigationDelegate(
                      onWebResourceError: (WebResourceError error) {},
                    ),
                  )
                  ..loadRequest(Uri.parse(
                      "https://www.cgg.gov.in/mgov-copyright-policy/?depot_name=Centre%20for%20Good%20Governance%20(CGG),%20Govt.%20of%20Telangana&depot_email=info@cgg.gov.in")),
                gestureRecognizers: Set()
                  ..add(Factory<VerticalDragGestureRecognizer>(
                      () => VerticalDragGestureRecognizer())),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
