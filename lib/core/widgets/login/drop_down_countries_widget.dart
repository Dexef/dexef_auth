import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl_phone_field/countries.dart';
import '../../../../../../core/size_widgets/app_font_style.dart';
import '../../../dexef_auth/login/presentation/cubit/login_cubit.dart';
import '../../rest/cash_helper.dart';
import '../../rest/constants.dart';
import '../../theme/colors.dart';
import '../public/custom_search_bar.dart';
import '../public/default_text.dart';

class DropDownCountries extends StatefulWidget{
  final LoginCubit loginCubit;
  const DropDownCountries({super.key, required this.loginCubit});
  @override
  State<DropDownCountries> createState() => _DropDownCountriesState();
}

class _DropDownCountriesState extends State<DropDownCountries> {
  final LayerLink layerLink = LayerLink();
  OverlayEntry? overlayEntry;
  final TextEditingController searchController = TextEditingController();
  bool isArabic = CacheHelper.getData(key: Constants.isArabic.toString()) ?? true;
  Country selectedUnite = countries[0];

  @override
  void initState() {
    selectedUnite = countries.where((e) => e.code == widget.loginCubit.userCountryCode ).toList()[0];
    CacheHelper.saveData(key: Constants.selectedCountryCode.toString(), value: selectedUnite.dialCode);
    super.initState();
  }
////////////////////////////////////////////
  void removeOverlay() {
    searchController.clear();
    overlayEntry?.remove();
    overlayEntry = null;
  }
////////////////////////////////////////////
  void showDropdown(){
    overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        width: 300,
        child: CompositedTransformFollower(
          link: layerLink,
          showWhenUnlinked: false,
          followerAnchor: Alignment.topRight,
          offset: const Offset(0.0, 40), // Below the button
          child: Material(
            elevation: 4.0,
            borderRadius: BorderRadius.circular(8),
            color: Colors.white,
            child: Container(
              constraints: const BoxConstraints(maxHeight: 300),
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                children: [
                  CustomSearchBar(
                    controller: searchController,
                    borderColor: brushBorder,
                    radius: 12,
                    onChanged: (value){
                      widget.loginCubit.searchCountries(searchController.text);
                      overlayEntry?.markNeedsBuild();
                    },
                  ),
                  const SizedBox(height: 8),
                  Expanded(
                    child: ListView.builder(
                      itemCount: searchController.text.isEmpty ? countries.length : widget.loginCubit.searchInCountries.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          title: DefaultText(
                            text: isArabic == true ? "${searchController.text.isEmpty ? countries[index].nameTranslations["ar"] : widget.loginCubit.searchInCountries[index].nameTranslations["ar"]}": widget.loginCubit.searchInCountries[index].name,
                            fontSize: AppFontStyle.appFontSize.setFontSize(context, webFontSize: 12, mobileFontSize: 10.sp),
                          ),
                          trailing: DefaultText(
                            text: "+ ${searchController.text.isEmpty ? countries[index].dialCode : widget.loginCubit.searchInCountries[index].dialCode}",
                            fontSize: AppFontStyle.appFontSize.setFontSize(context, webFontSize: 12, mobileFontSize: 10.sp),
                          ),
                          onTap: () {
                            setState(() {
                              selectedUnite = searchController.text.isEmpty ? countries[index] : widget.loginCubit.searchInCountries[index];
                              CacheHelper.saveData(key: Constants.selectedCountryCode.toString(), value: selectedUnite.dialCode);
                              removeOverlay();
                            });
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
    Overlay.of(context).insert(overlayEntry!);
  }
////////////////////////////////////////////
  @override
  Widget build(BuildContext context) {
    return CompositedTransformTarget(
      link: layerLink,
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: GestureDetector(
          onTap: (){
            if(overlayEntry == null){
              showDropdown();
            }else{
              removeOverlay();
            }
          },
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(width: 6),
              const Icon(Icons.arrow_drop_down, size: 14,),
              DefaultText(
                text: selectedUnite.dialCode,
                fontSize: AppFontStyle.appFontSize.setFontSize(context, webFontSize: 12, mobileFontSize: 10.sp),
              ),
              const SizedBox(width: 6,),
              Container(height: 8, color: Colors.black54, width: 1,),
              const SizedBox(width: 6),
            ],
          ),
        ),
      ),
    );
  }
}