import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'dart:ui' as ui;
import 'dart:html' as html;
import 'animated_linear_progress_indicator.dart';
import 'network_failed.dart';

class DefaultLoginScreen extends StatefulWidget {
  final Widget body;
  final bool? isLoading;

  const DefaultLoginScreen({super.key, required this.body, this.isLoading});

  @override
  State<DefaultLoginScreen> createState() => _DefaultLoginScreenState();
}

class _DefaultLoginScreenState extends State<DefaultLoginScreen> {

////////////////////////////////////////////////////////////////////// for listen connectivity
  bool allowRefresh = false;
  ConnectivityResult connectionStatus = ConnectivityResult.none;
  final Connectivity connectivity = Connectivity();

  Future<void> initConnectivity() async {
    List<ConnectivityResult> results;
    try {
      results = await connectivity.checkConnectivity();
    } catch (e) {
      return;
    }
    if (!mounted) return;

    setState(() {
      // Pick the first result for simplicity
      final result = results.isNotEmpty ? results.first : ConnectivityResult.none;
      connectionStatus = result;
      allowRefresh = result != ConnectivityResult.none;
    });
  }


  void updateConnectionStatus(ConnectivityResult result) {
    setState(() {
      connectionStatus = result;
      if(connectionStatus == ConnectivityResult.none){
        allowRefresh = false;
      }else{
        allowRefresh = true;
      }
    });
  }

  setupBeforeUnloadListener() {
    html.window.onBeforeUnload.listen((event) {
      if (!allowRefresh) {
        event.preventDefault();
      }
    });
  }
/////////////////////////////////////////////////////////////////////////
  @override
  void initState() {
    initConnectivity();
    // connectivity.onConnectivityChanged.listen(updateConnectionStatus);
    setupBeforeUnloadListener();
    super.initState();
  }
//////////////////////////////////////////////////////////////////////
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: Size(double.infinity, widget.isLoading == true ? 2 : 0),
        child: widget.isLoading == true
            ? const AnimatedLinearProgressIndicator()
            : Container(),
      ),
      body: connectionStatus == ConnectivityResult.none ? const NetworkFailed() : Directionality(
        textDirection: ui.TextDirection.ltr ,
          child: SingleChildScrollView(child: widget.body)),
    );

  }
}
