import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:efood_multivendor_driver/controller/order_controller.dart';
import 'package:efood_multivendor_driver/util/dimensions.dart';
import 'package:efood_multivendor_driver/util/images.dart';
import 'package:efood_multivendor_driver/util/styles.dart';
import 'package:efood_multivendor_driver/view/base/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NewRequestDialog extends StatefulWidget {
  final bool isRequest;
  final Function onTap;
  final int orderId;
  NewRequestDialog({@required this.isRequest, @required this.onTap, @required this.orderId});

  @override
  State<NewRequestDialog> createState() => _NewRequestDialogState();
}

class _NewRequestDialogState extends State<NewRequestDialog> {
  Timer _timer;

  @override
  void initState() {
    super.initState();

    _startAlarm();
    print('============${widget.orderId}');
    Get.find<OrderController>().getOrderDetails(widget.orderId);
  }

  @override
  void dispose() {
    super.dispose();

    _timer?.cancel();
  }

  void _startAlarm() {
    AudioCache _audio = AudioCache();
    _audio.play('notification.mp3');
    _timer = Timer.periodic(Duration(seconds: 3), (timer) {
      _audio.play('notification.mp3');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(Dimensions.RADIUS_SMALL)),
      //insetPadding: EdgeInsets.all(Dimensions.PADDING_SIZE_LARGE),
      child: Padding(
        padding: EdgeInsets.all(Dimensions.PADDING_SIZE_LARGE),
        child: GetBuilder<OrderController>(
          builder: (orderController) {
            return Column(mainAxisSize: MainAxisSize.min, children: [

              Image.asset(Images.notification_in, height: 60, color: Theme.of(context).primaryColor),

              Padding(
                padding: EdgeInsets.only(top: Dimensions.PADDING_SIZE_LARGE, bottom: Dimensions.PADDING_SIZE_SMALL),
                child: Text(
                  widget.isRequest ? 'new_order_request_from_a_customer'.tr : 'you_have_assigned_a_new_order'.tr, textAlign: TextAlign.center,
                  style: robotoRegular.copyWith(fontSize: Dimensions.FONT_SIZE_LARGE),
                ),
              ),

              orderController.orderDetailsModel != null ? Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                Text('with'.tr , textAlign: TextAlign.center, style: robotoRegular.copyWith(fontSize: Dimensions.FONT_SIZE_DEFAULT)),
                Text(
                  ' ${orderController.orderDetailsModel != null ? orderController.orderDetailsModel.length.toString() : 0} ',
                  textAlign: TextAlign.center, style: robotoMedium.copyWith(fontSize: Dimensions.FONT_SIZE_LARGE),
                  ),
                Text('items'.tr, textAlign: TextAlign.center, style: robotoRegular.copyWith(fontSize: Dimensions.FONT_SIZE_DEFAULT)),
              ]) : SizedBox(),

              orderController.orderDetailsModel != null ? ListView.builder(
                itemCount: orderController.orderDetailsModel.length,
                  shrinkWrap: true,
                  padding: EdgeInsets.symmetric(vertical: Dimensions.PADDING_SIZE_SMALL),
                  itemBuilder: (context,index){
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                  child: Row(children: [
                    Text('item'.tr + ' ${index + 1}: ', style: robotoMedium.copyWith(fontSize: Dimensions.FONT_SIZE_SMALL)),
                    Flexible(child: Text(
                        orderController.orderDetailsModel[index].foodDetails.name + ' ( x ' +'${orderController.orderDetailsModel[index].quantity})',
                        maxLines: 2, overflow: TextOverflow.ellipsis, style: robotoRegular.copyWith(fontSize: Dimensions.FONT_SIZE_SMALL)),
                    ),
                  ]),
                );
              }) : SizedBox(),

              CustomButton(
                height: 40,
                buttonText: widget.isRequest ? (Get.find<OrderController>().currentOrderList != null
                    && Get.find<OrderController>().currentOrderList.length > 0) ? 'ok'.tr : 'go'.tr : 'ok'.tr,
                onPressed: () {
                  if(!widget.isRequest) {
                    _timer?.cancel();
                  }
                  Get.back();
                  widget.onTap();
                },
              ),

            ]);
          }
        ),
      ),
    );
  }
}
