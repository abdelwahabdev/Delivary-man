import 'package:efood_multivendor_driver/controller/splash_controller.dart';
import 'package:efood_multivendor_driver/data/model/response/order_model.dart';
import 'package:efood_multivendor_driver/helper/date_converter.dart';
import 'package:efood_multivendor_driver/helper/route_helper.dart';
import 'package:efood_multivendor_driver/util/dimensions.dart';
import 'package:efood_multivendor_driver/util/images.dart';
import 'package:efood_multivendor_driver/util/styles.dart';
import 'package:efood_multivendor_driver/view/screens/order/order_details_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HistoryOrderWidget extends StatelessWidget {
  final OrderModel orderModel;
  final bool isRunning;
  final int index;
  HistoryOrderWidget({@required this.orderModel, @required this.isRunning, @required this.index});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => Get.toNamed(
        RouteHelper.getOrderDetailsRoute(orderModel.id),
        arguments: OrderDetailsScreen(orderId: orderModel.id, isRunningOrder: isRunning, orderIndex: index),
      ),
      child: Container(
        padding: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
        margin: EdgeInsets.only(bottom: Dimensions.PADDING_SIZE_SMALL),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          boxShadow: [BoxShadow(color: Colors.grey[Get.isDarkMode ? 700 : 300], spreadRadius: 1, blurRadius: 5)],
          borderRadius: BorderRadius.circular(Dimensions.RADIUS_SMALL),
        ),
        child: Row(children: [

          ClipRRect(
            borderRadius: BorderRadius.circular(Dimensions.RADIUS_SMALL),
            child: FadeInImage.assetNetwork(
              placeholder: Images.placeholder, height: 70, width: 70, fit: BoxFit.cover,
              image: '${Get.find<SplashController>().configModel.baseUrls.restaurantImageUrl}'
                  '/${orderModel.restaurantLogo ?? ''}',
              imageErrorBuilder: (c, o, s) => Image.asset(Images.placeholder, height: 70, width: 70, fit: BoxFit.cover),
            ),
          ),
          SizedBox(width: Dimensions.PADDING_SIZE_SMALL),

          Expanded(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

              Row(children: [
                Text('${'order_id'.tr}:', style: robotoRegular.copyWith(fontSize: Dimensions.FONT_SIZE_SMALL)),
                SizedBox(width: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                Text(
                  '#${orderModel.id}',
                  style: robotoMedium.copyWith(fontSize: Dimensions.FONT_SIZE_SMALL),
                ),
              ]),
              SizedBox(height: Dimensions.PADDING_SIZE_EXTRA_SMALL),

              Text(
                orderModel.restaurantName ?? 'no_restaurant_data_found'.tr,
                style: robotoMedium.copyWith(fontSize: Dimensions.FONT_SIZE_SMALL, color: Theme.of(context).primaryColor),
              ),
              SizedBox(height: Dimensions.PADDING_SIZE_EXTRA_SMALL),

              Row(children: [
                Icon(Icons.access_time, size: 15),
                SizedBox(width: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                Text(
                  DateConverter.dateTimeStringToDateTime(orderModel.createdAt),
                  style: robotoRegular.copyWith(color: Theme.of(context).disabledColor, fontSize: Dimensions.FONT_SIZE_SMALL),
                ),
              ]),

            ]),
          ),

        ]),
      ),
    );
  }
}
