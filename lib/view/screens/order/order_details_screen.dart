import 'dart:async';

import 'package:efood_multivendor_driver/controller/auth_controller.dart';
import 'package:efood_multivendor_driver/controller/localization_controller.dart';
import 'package:efood_multivendor_driver/controller/order_controller.dart';
import 'package:efood_multivendor_driver/controller/splash_controller.dart';
import 'package:efood_multivendor_driver/data/model/body/notification_body.dart';
import 'package:efood_multivendor_driver/data/model/response/conversation_model.dart';
import 'package:efood_multivendor_driver/data/model/response/order_model.dart';
import 'package:efood_multivendor_driver/helper/date_converter.dart';
import 'package:efood_multivendor_driver/helper/route_helper.dart';
import 'package:efood_multivendor_driver/util/dimensions.dart';
import 'package:efood_multivendor_driver/util/images.dart';
import 'package:efood_multivendor_driver/util/styles.dart';
import 'package:efood_multivendor_driver/view/base/confirmation_dialog.dart';
import 'package:efood_multivendor_driver/view/base/custom_app_bar.dart';
import 'package:efood_multivendor_driver/view/base/custom_button.dart';
import 'package:efood_multivendor_driver/view/base/custom_snackbar.dart';
import 'package:efood_multivendor_driver/view/screens/order/widget/cancellation_dialogue.dart';
import 'package:efood_multivendor_driver/view/screens/order/widget/order_product_widget.dart';
import 'package:efood_multivendor_driver/view/screens/order/widget/verify_delivery_sheet.dart';
import 'package:efood_multivendor_driver/view/screens/order/widget/info_card.dart';
import 'package:efood_multivendor_driver/view/screens/order/widget/slider_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OrderDetailsScreen extends StatefulWidget {
  final int orderId;
  final bool isRunningOrder;
  final int orderIndex;
  OrderDetailsScreen({@required this.orderId, @required this.isRunningOrder, @required this.orderIndex});

  @override
  State<OrderDetailsScreen> createState() => _OrderDetailsScreenState();
}

class _OrderDetailsScreenState extends State<OrderDetailsScreen> {
  Timer _timer;
  int orderPosition;

  void _startApiCalling(){
    _timer = Timer.periodic(Duration(seconds: 10), (timer) {
      Get.find<OrderController>().getOrderWithId(Get.find<OrderController>().orderModel.id);
    });
  }

  Future<void> _loadData() async {
    if(widget.orderIndex == null){
      await Get.find<OrderController>().getCurrentOrders();
      for(int index=0; index<Get.find<OrderController>().currentOrderList.length; index++) {
        if(Get.find<OrderController>().currentOrderList[index].id == widget.orderId){
          orderPosition = index;
          break;
        }
      }
    }
    Get.find<OrderController>().getOrderWithId(widget.orderId);
    Get.find<OrderController>().getOrderDetails(widget.orderId);
  }

  @override
  void initState() {
    super.initState();

    orderPosition = widget.orderIndex;

    _loadData();
    _startApiCalling();
  }

  @override
  void dispose() {
    super.dispose();
    _timer?.cancel();
  }
  @override
  Widget build(BuildContext context) {
    bool _cancelPermission = Get.find<SplashController>().configModel.canceledByDeliveryman;
    bool _selfDelivery = Get.find<AuthController>().profileModel.type != 'zone_wise';

    return Scaffold(
      backgroundColor: Theme.of(context).cardColor,
      appBar: CustomAppBar(title: 'order_details'.tr),
      body: Padding(
        padding: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
        child: GetBuilder<OrderController>(builder: (orderController) {
          OrderModel controllerOrderModel = orderController.orderModel;

          bool _restConfModel = Get.find<SplashController>().configModel.orderConfirmationModel != 'deliveryman';

          bool _showBottomView;
          bool _showSlider;

          if(controllerOrderModel != null){
            _showBottomView = controllerOrderModel.orderStatus == 'accepted' || controllerOrderModel.orderStatus == 'confirmed'
                || controllerOrderModel.orderStatus == 'processing' || controllerOrderModel.orderStatus == 'handover'
                || controllerOrderModel.orderStatus == 'picked_up' || (widget.isRunningOrder ?? true);
            _showSlider = (controllerOrderModel.paymentMethod == 'cash_on_delivery' && controllerOrderModel.orderStatus == 'accepted' && !_restConfModel && !_selfDelivery)
                || controllerOrderModel.orderStatus == 'handover' || controllerOrderModel.orderStatus == 'picked_up';
          }

          return (orderController.orderDetailsModel != null && controllerOrderModel != null) ? Column(children: [

            Expanded(child: SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              child: Column(children: [

                DateConverter.isBeforeTime(controllerOrderModel.scheduleAt) ? (controllerOrderModel.orderStatus != 'delivered'
                && controllerOrderModel.orderStatus != 'failed'&& controllerOrderModel.orderStatus != 'canceled' && controllerOrderModel.orderStatus != 'refund_requested'
                && controllerOrderModel.orderStatus != 'refunded' && controllerOrderModel.orderStatus != 'refund_request_canceled') ? Column(children: [

                  ClipRRect(borderRadius: BorderRadius.circular(10), child: Image.asset(Images.animate_delivery_man, fit: BoxFit.contain)),
                  SizedBox(height: Dimensions.PADDING_SIZE_DEFAULT),

                  Text('food_need_to_deliver_within'.tr, style: robotoRegular.copyWith(fontSize: Dimensions.FONT_SIZE_DEFAULT, color: Theme.of(context).disabledColor)),
                  SizedBox(height: Dimensions.PADDING_SIZE_EXTRA_SMALL),

                  Center(
                    child: Row(mainAxisSize: MainAxisSize.min, children: [

                      Text(
                        DateConverter.differenceInMinute(controllerOrderModel.restaurantDeliveryTime, controllerOrderModel.createdAt, controllerOrderModel.processingTime, controllerOrderModel.scheduleAt) < 5 ? '1 - 5'
                            : '${DateConverter.differenceInMinute(controllerOrderModel.restaurantDeliveryTime, controllerOrderModel.createdAt, controllerOrderModel.processingTime, controllerOrderModel.scheduleAt)-5} '
                            '- ${DateConverter.differenceInMinute(controllerOrderModel.restaurantDeliveryTime, controllerOrderModel.createdAt, controllerOrderModel.processingTime, controllerOrderModel.scheduleAt)}',
                        style: robotoBold.copyWith(fontSize: Dimensions.FONT_SIZE_EXTRA_LARGE),
                      ),
                      SizedBox(width: Dimensions.PADDING_SIZE_EXTRA_SMALL),

                      Text('min'.tr, style: robotoMedium.copyWith(fontSize: Dimensions.FONT_SIZE_LARGE, color: Theme.of(context).primaryColor)),
                    ]),
                  ),
                  SizedBox(height: Dimensions.PADDING_SIZE_EXTRA_LARGE),

                ]) : SizedBox() : SizedBox(),

                Row(children: [
                  Text('${'order_id'.tr}:', style: robotoRegular),
                  SizedBox(width: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                  Text(controllerOrderModel.id.toString(), style: robotoMedium),
                  SizedBox(width: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                  Expanded(child: SizedBox()),
                  Container(height: 7, width: 7, decoration: BoxDecoration(shape: BoxShape.circle,
                      color: (controllerOrderModel.orderStatus == 'failed' || controllerOrderModel.orderStatus == 'canceled' || controllerOrderModel.orderStatus == 'refund_request_canceled')
                      ? Colors.red : controllerOrderModel.orderStatus == 'refund_requested' ? Colors.yellow : Colors.green)),
                  SizedBox(width: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                  Text(
                    controllerOrderModel.orderStatus.tr ?? '',
                    style: robotoRegular,
                  ),
                ]),
                SizedBox(height: Dimensions.PADDING_SIZE_LARGE),

                InfoCard(
                  title: 'restaurant_details'.tr, addressModel: DeliveryAddress(address: controllerOrderModel.restaurantAddress),
                  image: '${Get.find<SplashController>().configModel.baseUrls.restaurantImageUrl}/${controllerOrderModel.restaurantLogo}',
                  name: controllerOrderModel.restaurantName, phone: controllerOrderModel.restaurantPhone,
                  latitude: controllerOrderModel.restaurantLat, longitude: controllerOrderModel.restaurantLng,
                  showButton: (controllerOrderModel.orderStatus != 'delivered' && controllerOrderModel.orderStatus != 'failed' && controllerOrderModel.orderStatus != 'canceled'),
                  orderModel: controllerOrderModel,
                  messageOnTap: () async {
                    if(controllerOrderModel.restaurantModel != 'commission' && controllerOrderModel.chatPermission == 0){
                      showCustomSnackBar('restaurant_have_no_chat_permission'.tr);
                    }else{
                      _timer?.cancel();
                      await Get.toNamed(RouteHelper.getChatRoute(
                        notificationBody: NotificationBody(
                          orderId: controllerOrderModel.id, vendorId: controllerOrderModel.vendorId,
                        ),
                        user: User(
                          id: controllerOrderModel.vendorId, fName: controllerOrderModel.restaurantName,
                          image: controllerOrderModel.restaurantLogo,
                        ),
                      ));
                      _startApiCalling();
                    }
                  },
                ),
                SizedBox(height: Dimensions.PADDING_SIZE_LARGE),

                InfoCard(
                  title: 'customer_contact_details'.tr, addressModel: controllerOrderModel.deliveryAddress, isDelivery: true,
                  image: controllerOrderModel.customer != null ? '${Get.find<SplashController>().configModel.baseUrls.customerImageUrl}/${controllerOrderModel.customer.image}' : '',
                  name: controllerOrderModel.deliveryAddress.contactPersonName, phone: controllerOrderModel.deliveryAddress.contactPersonNumber,
                  latitude: controllerOrderModel.deliveryAddress.latitude, longitude: controllerOrderModel.deliveryAddress.longitude,
                  showButton: (controllerOrderModel.orderStatus != 'delivered' && controllerOrderModel.orderStatus != 'failed' && controllerOrderModel.orderStatus != 'canceled'),
                  orderModel: controllerOrderModel,
                  messageOnTap: () async {
                    if(controllerOrderModel.customer != null){
                      _timer?.cancel();
                      await Get.toNamed(RouteHelper.getChatRoute(
                        notificationBody: NotificationBody(
                          orderId: controllerOrderModel.id, customerId: controllerOrderModel.customer.id,
                        ),
                        user: User(
                          id: controllerOrderModel.customer.id, fName: controllerOrderModel.customer.fName,
                          lName: controllerOrderModel.customer.lName, image: controllerOrderModel.customer.image,
                        ),
                      ));
                      _startApiCalling();
                    }else{
                      showCustomSnackBar('${'customer_not_found'.tr}');
                    }
                  },
                ),
                SizedBox(height: Dimensions.PADDING_SIZE_LARGE),

                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

                  Padding(
                    padding: EdgeInsets.symmetric(vertical: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                    child: Row(children: [
                      Text('${'item'.tr}:', style: robotoRegular),
                      SizedBox(width: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                      Text(
                        orderController.orderDetailsModel.length.toString(),
                        style: robotoMedium.copyWith(color: Theme.of(context).primaryColor),
                      ),
                      Expanded(child: SizedBox()),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_SMALL, vertical: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                        decoration: BoxDecoration(color: Theme.of(context).primaryColor.withOpacity(0.1), borderRadius: BorderRadius.circular(5)),
                        child: Text(
                          controllerOrderModel.paymentMethod == 'cash_on_delivery' ? 'cod'.tr : controllerOrderModel.paymentMethod == 'wallet'
                              ? 'wallet_payment'.tr : 'digitally_paid'.tr,
                          style: robotoMedium.copyWith(fontSize: Dimensions.FONT_SIZE_EXTRA_SMALL, color: Theme.of(context).primaryColor),
                        ),
                      ),
                    ]),
                  ),
                  Divider(height: Dimensions.PADDING_SIZE_LARGE),
                  SizedBox(height: Dimensions.PADDING_SIZE_SMALL),

                  ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: orderController.orderDetailsModel.length,
                    itemBuilder: (context, index) {
                      return OrderProductWidget(order: controllerOrderModel, orderDetails: orderController.orderDetailsModel[index]);
                    },
                  ),

                  (controllerOrderModel.orderNote  != null && controllerOrderModel.orderNote.isNotEmpty) ? Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text('additional_note'.tr, style: robotoRegular),
                    SizedBox(height: Dimensions.PADDING_SIZE_SMALL),
                    Container(
                      width: 1170,
                      padding: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        border: Border.all(width: 1, color: Theme.of(context).disabledColor),
                      ),
                      child: Text(
                        controllerOrderModel.orderNote,
                        style: robotoRegular.copyWith(fontSize: Dimensions.FONT_SIZE_SMALL, color: Theme.of(context).disabledColor),
                      ),
                    ),
                    SizedBox(height: Dimensions.PADDING_SIZE_LARGE),
                  ]) : SizedBox(),

                ]),

              ]),
            )),

            _showBottomView ? ((controllerOrderModel.orderStatus == 'accepted' && (controllerOrderModel.paymentMethod != 'cash_on_delivery' || _restConfModel || _selfDelivery))
             || controllerOrderModel.orderStatus == 'processing' || controllerOrderModel.orderStatus == 'confirmed') ? Container(
              padding: EdgeInsets.all(Dimensions.PADDING_SIZE_DEFAULT),
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(Dimensions.RADIUS_SMALL),
                border: Border.all(width: 1),
              ),
              alignment: Alignment.center,
              child: Text(
                controllerOrderModel.orderStatus == 'processing' ? 'food_is_preparing'.tr : 'food_waiting_for_cook'.tr,
                style: robotoMedium,
              ),
            ) : _showSlider ? (controllerOrderModel.paymentMethod == 'cash_on_delivery' && controllerOrderModel.orderStatus == 'accepted'
            && !_restConfModel && _cancelPermission && !_selfDelivery) ? Row(children: [
              Expanded(child: TextButton(
                onPressed: (){
                  orderController.setOrderCancelReason('');
                  Get.dialog(CancellationDialogue(orderId: widget.orderId));
                },
                // onPressed: () => Get.dialog(ConfirmationDialog(
                //   icon: Images.warning, title: 'are_you_sure_to_cancel'.tr, description: 'you_want_to_cancel_this_order'.tr,
                //   onYesPressed: () {
                //     orderController.setOrderCancelReason('');
                //     Get.dialog(CancellationDialogue(orderId: widget.orderId));
                //     // orderController.updateOrderStatus(orderPosition, 'canceled', back: true).then((success) {
                //     //   if(success) {
                //     //     Get.find<AuthController>().getProfile();
                //     //     Get.find<OrderController>().getCurrentOrders();
                //     //   }
                //     // });
                //   },
                // ), barrierDismissible: false),
                style: TextButton.styleFrom(
                  minimumSize: Size(1170, 40), padding: EdgeInsets.zero,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(Dimensions.RADIUS_SMALL),
                    side: BorderSide(width: 1, color: Theme.of(context).textTheme.bodyLarge.color),
                  ),
                ),
                child: Text('cancel'.tr, textAlign: TextAlign.center, style: robotoRegular.copyWith(
                  color: Theme.of(context).textTheme.titleSmall.color,
                  fontSize: Dimensions.FONT_SIZE_LARGE,
                )),
              )),
              SizedBox(width: Dimensions.PADDING_SIZE_SMALL),
              Expanded(child: CustomButton(
                buttonText: 'confirm'.tr, height: 40,
                onPressed: () {
                  Get.dialog(ConfirmationDialog(
                    icon: Images.warning, title: 'are_you_sure_to_confirm'.tr, description: 'you_want_to_confirm_this_order'.tr,
                    onYesPressed: () {
                      orderController.updateOrderStatus(controllerOrderModel.id, 'confirmed', back: true).then((success) {
                        if(success) {
                          Get.find<AuthController>().getProfile();
                          Get.find<OrderController>().getCurrentOrders();
                        }
                      });
                    },
                  ), barrierDismissible: false);
                },
              )),
            ]) : SliderButton(
              action: () {
                if(controllerOrderModel.paymentMethod == 'cash_on_delivery' && controllerOrderModel.orderStatus == 'accepted' && !_restConfModel && !_selfDelivery) {
                  Get.dialog(ConfirmationDialog(
                    icon: Images.warning, title: 'are_you_sure_to_confirm'.tr, description: 'you_want_to_confirm_this_order'.tr,
                    onYesPressed: () {
                      orderController.updateOrderStatus(controllerOrderModel.id, 'confirmed', back: true).then((success) {
                        if(success) {
                          Get.find<AuthController>().getProfile();
                          Get.find<OrderController>().getCurrentOrders();
                        }
                      });
                    },
                  ), barrierDismissible: false);
                }else if(controllerOrderModel.orderStatus == 'picked_up') {
                  if(Get.find<SplashController>().configModel.orderDeliveryVerification
                      || controllerOrderModel.paymentMethod == 'cash_on_delivery') {
                    Get.bottomSheet(VerifyDeliverySheet(
                      orderId: controllerOrderModel.id, verify: Get.find<SplashController>().configModel.orderDeliveryVerification,
                      orderAmount: controllerOrderModel.orderAmount, cod: controllerOrderModel.paymentMethod == 'cash_on_delivery',
                    ), isScrollControlled: true);
                  }else {
                    Get.find<OrderController>().updateOrderStatus(controllerOrderModel.id, 'delivered').then((success) {
                      if(success) {
                        Get.find<AuthController>().getProfile();
                        Get.find<OrderController>().getCurrentOrders();
                      }
                    });
                  }
                }else if(controllerOrderModel.orderStatus == 'handover') {
                  if(Get.find<AuthController>().profileModel.active == 1) {
                    Get.find<OrderController>().updateOrderStatus(controllerOrderModel.id, 'picked_up').then((success) {
                      if(success) {
                        Get.find<AuthController>().getProfile();
                        Get.find<OrderController>().getCurrentOrders();
                      }
                    });
                  }else {
                    showCustomSnackBar('make_yourself_online_first'.tr);
                  }
                }
              },
              label: Text(
                (controllerOrderModel.paymentMethod == 'cash_on_delivery' && controllerOrderModel.orderStatus == 'accepted' && !_restConfModel && !_selfDelivery)
                    ? 'swipe_to_confirm_order'.tr : controllerOrderModel.orderStatus == 'picked_up' ? 'swipe_to_deliver_order'.tr
                    : controllerOrderModel.orderStatus == 'handover' ? 'swipe_to_pick_up_order'.tr : '',
                style: robotoMedium.copyWith(fontSize: Dimensions.FONT_SIZE_LARGE, color: Theme.of(context).primaryColor),
              ),
              dismissThresholds: 0.5, dismissible: false, shimmer: true,
              width: 1170, height: 60, buttonSize: 50, radius: 10,
              icon: Center(child: Icon(
                Get.find<LocalizationController>().isLtr ? Icons.double_arrow_sharp : Icons.keyboard_arrow_left,
                color: Colors.white, size: 20.0,
              )),
              isLtr: Get.find<LocalizationController>().isLtr,
              boxShadow: BoxShadow(blurRadius: 0),
              buttonColor: Theme.of(context).primaryColor,
              backgroundColor: Color(0xffF4F7FC),
              baseColor: Theme.of(context).primaryColor,
            ) : SizedBox() : SizedBox(),

          ]) : Center(child: CircularProgressIndicator());
        }),
      ),
    );
  }
}
