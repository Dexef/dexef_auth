import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../size_widgets/app_font_style.dart';
import 'default_text.dart';

class PopUpMenuWidget extends StatefulWidget {
  final List <String> optionsName;
  final void Function(int)? onSelected;
  final Widget child;
  final bool setWidthMenu;
  final void Function()? onOpened;
  final void Function()? onCanceled;

  const PopUpMenuWidget({
    super.key,
    required this.optionsName,
    this.onSelected,
    required this.child,
    this.setWidthMenu = true,
    this.onOpened,
    this.onCanceled
  });
  @override
  State<PopUpMenuWidget> createState() => _PopUpMenuWidgetState();
}

class _PopUpMenuWidgetState extends State<PopUpMenuWidget> {
  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
        hoverColor: Colors.transparent,
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
      ),
      child: PopupMenuButton(
        position: PopupMenuPosition.under,
        color: const Color(0xFFCA423B),
        tooltip: "",
        menuPadding: EdgeInsets.zero,
        // popUpAnimationStyle: AnimationStyle(
        //   duration: const Duration(milliseconds: 800),
        //   curve: Curves.easeOut,
        //   reverseDuration: const Duration(milliseconds: 300)
        // ),
        shape: RoundedRectangleBorder(
          side: const BorderSide(width: .3, color: Colors.white),
          borderRadius: BorderRadius.circular(8),
        ),
        offset: const Offset(0, 4),
        constraints: widget.setWidthMenu ? BoxConstraints(
          minWidth: MediaQuery.of(context).size.width *.30
        ):null,
        itemBuilder: (context) {
          List<PopupMenuEntry<int>> menuItems = [];
          for (int index = 0; index < widget.optionsName.length; index++) {
            menuItems.add(
              HoverPopupMenuItem(
                padding: EdgeInsets.symmetric(horizontal: 0.w),
                value: index,
                optionsName: widget.optionsName,
                index: index,
                child: DefaultText(
                  text: widget.optionsName[index],
                  fontSize: AppFontStyle.appFontSize.setFontSize(context, webFontSize: 12, mobileFontSize: 10.sp),
                  fontColor: Colors.white,
                ),
              ),
            );
            // Add a divider except for the last item
            if (index < widget.optionsName.length - 1) {
              menuItems.add(
                PopupMenuItem(
                  padding: EdgeInsets.zero,
                  enabled: false, // Disable selection
                  height: 1.h, // Control the height
                  child: Container(
                    width: double.infinity,
                    height: .3, // Divider thickness
                    color: Colors.white // Change this to your desired color
                  ),
                ),
              );
            }
          }
          return menuItems;
        },
        onSelected: widget.onSelected,
        onOpened: widget.onOpened,
        onCanceled: widget.onCanceled,
        child: widget.child,
      ),
    );
  }
}
////////////////////////////////////////////////////////////////////////////////
class HoverPopupMenuItem<T> extends PopupMenuItem<T> {
  final T value;
  final Widget child;
  final EdgeInsets? padding;
  final List <String> optionsName;
  final int index;

  const HoverPopupMenuItem({
    Key? key,
    required this.value,
    required this.child,
    required this.optionsName,
    required this.index,
    this.padding
  }) : super(key: key, value: value, child: child);

  @override
  _HoverPopupMenuItemState<T> createState() => _HoverPopupMenuItemState<T>();
}

class _HoverPopupMenuItemState<T> extends  PopupMenuItemState<T, HoverPopupMenuItem<T>> {
  bool isHovered = false;
  @override
  Widget buildChild() {
    return MouseRegion(
      onEnter: (_) => setState(() => isHovered = true),
      onExit: (_) => setState(() => isHovered = false),
      child: Container(
        padding: EdgeInsetsDirectional.only(start: 20.w),
        decoration: BoxDecoration(
          color: isHovered ? Colors.black.withOpacity(.08) : Colors.transparent,
          borderRadius: getRadius(),
        ),
        child: PopupMenuItem<T>(
          padding: widget.padding,
          value: widget.value,
          child: super.buildChild(),
        ),
      ),
    );
  }
////////////////////////////////////////////
  getRadius(){
    if(widget.index == 0){
      return const BorderRadius.only(topLeft: Radius.circular(8), topRight: Radius.circular(8));
    }else if(widget.index == widget.optionsName.length -1 ){
      return const BorderRadius.only(bottomRight: Radius.circular(8), bottomLeft: Radius.circular(8));
    }else{
      return BorderRadius.circular(0);
    }
  }
}
////////////////////////////////////////////////////////////////////////////////