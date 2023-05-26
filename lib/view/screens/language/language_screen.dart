import 'package:efood_multivendor_driver/controller/splash_controller.dart';
import 'package:efood_multivendor_driver/helper/route_helper.dart';
import 'package:efood_multivendor_driver/util/styles.dart';
import 'package:efood_multivendor_driver/view/base/custom_app_bar.dart';
import 'package:efood_multivendor_driver/view/screens/language/widget/language_widget.dart';
import 'package:flutter/material.dart';
import 'package:efood_multivendor_driver/controller/localization_controller.dart';
import 'package:efood_multivendor_driver/util/app_constants.dart';
import 'package:efood_multivendor_driver/util/dimensions.dart';
import 'package:efood_multivendor_driver/util/images.dart';
import 'package:efood_multivendor_driver/view/base/custom_button.dart';
import 'package:efood_multivendor_driver/view/base/custom_snackbar.dart';
import 'package:get/get.dart';

class ChooseLanguageScreen extends StatelessWidget {
  final bool fromProfile;
  ChooseLanguageScreen({@required this.fromProfile});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: fromProfile ? CustomAppBar(title: 'language'.tr) : null,
      body: SafeArea(
        child: GetBuilder<LocalizationController>(builder: (localizationController) {
          return Column(children: [

            Expanded(child: Center(
              child: Scrollbar(
                child: SingleChildScrollView(
                  physics: BouncingScrollPhysics(),
                  padding: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
                  child: Center(child: SizedBox(
                    width: 1170,
                    child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [

                      Center(child: Image.asset(Images.logo, width: 100)),
                      SizedBox(height: Dimensions.PADDING_SIZE_SMALL),
                      Center(child: Image.asset(Images.logo_name, width: 100)),

                      //Center(child: Text(AppConstants.APP_NAME, style: robotoMedium.copyWith(fontSize: Dimensions.FONT_SIZE_LARGE))),
                      SizedBox(height: 30),

                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                        child: Text('select_language'.tr, style: robotoMedium),
                      ),
                      SizedBox(height: Dimensions.PADDING_SIZE_EXTRA_SMALL),

                      GridView.builder(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: (1/1),
                        ),
                        itemCount: localizationController.languages.length,
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemBuilder: (context, index) => LanguageWidget(
                          languageModel: localizationController.languages[index],
                          localizationController: localizationController, index: index,
                        ),
                      ),
                      SizedBox(height: Dimensions.PADDING_SIZE_LARGE),

                      Text('you_can_change_language'.tr, style: robotoRegular.copyWith(
                        fontSize: Dimensions.FONT_SIZE_SMALL, color: Theme.of(context).disabledColor,
                      )),

                    ]),
                  )),
                ),
              ),
            )),

            CustomButton(
              buttonText: 'save'.tr,
              margin: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
              onPressed: () {
                if(localizationController.languages.length > 0 && localizationController.selectedIndex != -1) {
                  localizationController.setLanguage(Locale(
                    AppConstants.languages[localizationController.selectedIndex].languageCode,
                    AppConstants.languages[localizationController.selectedIndex].countryCode,
                  ));
                  if (fromProfile) {
                    Navigator.pop(context);
                  } else {
                    Get.find<SplashController>().setLanguageIntro(false);
                    Get.offNamed(RouteHelper.getSignInRoute());
                  }
                }else {
                  showCustomSnackBar('select_a_language'.tr);
                }
              },
            ),
          ]);
        }),
      ),
    );
  }
}
