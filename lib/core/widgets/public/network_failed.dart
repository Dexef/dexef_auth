import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'dart:html' as html;
import '../../rest/app_localizations.dart';
import '../../theme/colors.dart';
import 'default_text.dart';

class NetworkFailed extends StatefulWidget {
  const NetworkFailed({Key? key}) : super(key: key);
  @override
  State<NetworkFailed> createState() => _NetworkFailedState();
}

class _NetworkFailedState extends State<NetworkFailed> {
  bool isConnected = true;
  bool allowRefresh = false;
  Future<void> checkNetworkAndReload() async {
    var connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult == ConnectivityResult.none) {
      setState(() {
        isConnected = false;
        allowRefresh = false;
      });
    } else {
      allowRefresh = true;
      isConnected = true;
      html.window.location.reload();
    }
  }
  @override
  void initState() {
    setupBeforeUnloadListener();
    super.initState();
  }
//////////////////////////////////////////////////////////////////////////
  setupBeforeUnloadListener() {
    html.window.onBeforeUnload.listen((event) {
      if (!allowRefresh) {
        event.preventDefault();
      }
    });
  }
//////////////////////////////////////////////////////////////////////////////
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.transparent,
      height: MediaQuery.of(context).size.height,
      child: Center(
        child: SingleChildScrollView(
          child: Theme(
            data: ThemeData(
                hoverColor: Colors.transparent,
                focusColor: Colors.transparent
            ),
            child: MouseRegion(
              cursor: SystemMouseCursors.click,
              child: InkWell(
                onTap: () => checkNetworkAndReload(),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SvgPicture.asset('assets/images/error.svg'),
                    const SizedBox(height: 10,),
                    Container(
                      padding: const EdgeInsetsDirectional.all(20),
                      decoration: BoxDecoration(color: redColor, borderRadius: BorderRadius.circular(10.r)),
                      child: DefaultText(
                        text: AppLocalizations.of(context)!.translate('an_error'),
                        isTextTheme: true,
                        themeStyle: Theme.of(context).textTheme.labelMedium?.copyWith(
                            color: Colors.white
                        ),
                      )
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////
class NetworkFailedScreen extends StatefulWidget {
  const NetworkFailedScreen({Key? key}) : super(key: key);
  @override
  State<NetworkFailedScreen> createState() => _NetworkFailedScreenState();
}

class _NetworkFailedScreenState extends State<NetworkFailedScreen> {
  bool isConnected = true;
  bool allowRefresh = false;
  Future<void> checkNetworkAndReload() async {
    var connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult == ConnectivityResult.none) {
      setState(() {
        isConnected = false;
        allowRefresh = false;
      });
    } else {
      allowRefresh = true;
      isConnected = true;
      html.window.location.reload();
    }
  }
  @override
  void initState() {
    setupBeforeUnloadListener();
    super.initState();
  }
//////////////////////////////////////////////////////////////////////////
  setupBeforeUnloadListener() {
    html.window.onBeforeUnload.listen((event) {
      if (!allowRefresh) {
        event.preventDefault();
      }
    });
  }
//////////////////////////////////////////////////////////////////////////////
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
          color: Colors.transparent,
          height: MediaQuery.of(context).size.height,
          child: Center(
            child: SingleChildScrollView(
              child: Theme(
                data: ThemeData(
                    hoverColor: Colors.transparent,
                    focusColor: Colors.transparent
                ),
                child: MouseRegion(
                  cursor: SystemMouseCursors.click,
                  child: InkWell(
                    onTap: () => checkNetworkAndReload(),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SvgPicture.asset('assets/images/error.svg'),
                        const SizedBox(height: 10,),
                        Container(
                            padding: const EdgeInsetsDirectional.all(20),
                            decoration: BoxDecoration(color: redColor, borderRadius: BorderRadius.circular(10.r)),
                            child: DefaultText(
                              text: AppLocalizations.of(context)!.translate('an_error'),
                              isTextTheme: true,
                              themeStyle: Theme.of(context).textTheme.labelMedium?.copyWith(
                                  color: Colors.white
                              ),
                            )
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        )
    );
  }
}