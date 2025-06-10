import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../core/size_widgets/app_font_style.dart';
import '../../core/widgets/public/default_text.dart';

class MenuItemMainScaffold extends StatefulWidget {
  const MenuItemMainScaffold({
    this.onTap,
    this.drawerTitle,
    this.iconPath,
    this.containerColor,
    super.key
  });
  final String? iconPath;
  final String? drawerTitle;
  final void Function()? onTap;
  final Color? containerColor;

  @override
  State<MenuItemMainScaffold> createState() => _MenuItemMainScaffoldState();
}

class _MenuItemMainScaffoldState extends State<MenuItemMainScaffold> {
  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        // hoverColor: Colors.transparent,
        // highlightColor: Colors.transparent,  // Removes the background highlight color
        // splashColor: Colors.transparent,
        onTap: widget.onTap,
        child: Container(
          height: 36,
          decoration: BoxDecoration(
            color: widget.containerColor ?? Colors.transparent,
            borderRadius: widget.containerColor != null ? BorderRadius.circular(8) : null,
          ),
          padding: const EdgeInsetsDirectional.symmetric(horizontal: 16),
          child: Row(
            children: [
              // SvgPicture.asset('assets/images/${widget.iconPath}', color: Colors.white, width: 24, height: 24,),
              // const SizedBox(width: 8,),
              DefaultText(
                text: widget.drawerTitle,
                isTextTheme: true,
                themeStyle: Theme.of(context).textTheme.labelSmall!.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                  fontSize: AppFontStyle.appFontSize.setFontSize(context, webFontSize: 12.8, mobileFontSize: 10.8.sp),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
