import 'package:auth_dexef/dexef_auth/login/presentation/cubit/login_cubit.dart';
import 'package:auth_dexef/dexef_auth/login/presentation/cubit/login_states.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:auth_dexef/locator.dart' as di;
import 'dart:html' as html;

class MainScaffold extends StatefulWidget {
  final Widget child;
  final bool hideAppbar;
  final bool hideSearchIcon;
  final String? url;
  const MainScaffold({super.key, required this.child, this.hideAppbar = false, this.url, this.hideSearchIcon = false});
  @override
  State<MainScaffold> createState() => _MainScaffoldState();
}
class _MainScaffoldState extends State<MainScaffold>{
  List<String> optionsName = [];
  bool isTap = false;
  bool whenTapSearch = false;
  late LoginCubit loginCubit;
//////////////////////////////////////////////////////////////////////////////// main scaffold
  @override
  void initState() {
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => di.locator<LoginCubit>()..getEmailType()..lookupUserCountry(),
      child: BlocConsumer<LoginCubit, LoginState>(
        listener: (context, state){},
        builder: (context, state){
          loginCubit = LoginCubit.instance;
          return Scaffold(
            body: widget.child,
          );
        },
      ),
    );
  }
}
