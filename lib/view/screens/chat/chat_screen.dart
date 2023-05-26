import 'dart:io';
import 'package:efood_multivendor_driver/controller/auth_controller.dart';
import 'package:efood_multivendor_driver/controller/chat_controller.dart';
import 'package:efood_multivendor_driver/controller/splash_controller.dart';
import 'package:efood_multivendor_driver/data/model/body/notification_body.dart';
import 'package:efood_multivendor_driver/data/model/response/conversation_model.dart';
import 'package:efood_multivendor_driver/helper/responsive_helper.dart';
import 'package:efood_multivendor_driver/helper/user_type.dart';
import 'package:efood_multivendor_driver/util/dimensions.dart';
import 'package:efood_multivendor_driver/util/images.dart';
import 'package:efood_multivendor_driver/util/styles.dart';
import 'package:efood_multivendor_driver/view/base/custom_snackbar.dart';
import 'package:efood_multivendor_driver/view/base/paginated_list_view.dart';
import 'package:efood_multivendor_driver/view/screens/chat/widget/message_bubble.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class ChatScreen extends StatefulWidget {
  final NotificationBody notificationBody;
  final User user;
  final int conversationId;
  const ChatScreen({Key key, @required this.notificationBody, @required this.user, this.conversationId}) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _inputMessageController = TextEditingController();
  bool _isLoggedIn;

  @override
  void initState() {
    super.initState();

    _isLoggedIn = Get.find<AuthController>().isLoggedIn();
    Get.find<ChatController>().getMessages(1, widget.notificationBody, widget.user, widget.conversationId, firstLoad: true);

  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ChatController>(builder: (chatController) {
      String _baseUrl = '';
      if(widget.notificationBody.customerId != null) {
        _baseUrl = Get.find<SplashController>().configModel.baseUrls.customerImageUrl;
      }else {
        _baseUrl = Get.find<SplashController>().configModel.baseUrls.restaurantImageUrl;
      }
      return Scaffold(
        appBar: AppBar(
            title: Text(
              chatController.messageModel != null ? '${chatController.messageModel.conversation.receiver.fName ?? ''}'
                  ' ${chatController.messageModel.conversation.receiver.lName ?? ''}' : 'receiver_name'.tr,
            ),
            backgroundColor: Theme.of(context).primaryColor,
            actions: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  width: 40, height: 40, alignment: Alignment.center,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                    border: Border.all(width: 2,color: Theme.of(context).cardColor),
                    color: Theme.of(context).cardColor,
                  ),
                  child: ClipOval(
                    child: Image.network(
                        '$_baseUrl/${chatController.messageModel != null ? chatController.messageModel.conversation.receiver.image : ''}',
                      fit: BoxFit.cover, height: 40, width: 40,
                    ),
                  ),
                ),
              )
            ]),

        body: _isLoggedIn ? SafeArea(
          child: Center(
            child: Container(
              width: MediaQuery.of(context).size.width,
              child: Column(children: [

                Expanded(child: chatController.messageModel != null ? chatController.messageModel.messages.length > 0 ? SingleChildScrollView(
                  controller: _scrollController,
                  reverse: true,
                  child: PaginatedListView(
                    scrollController: _scrollController,
                    totalSize: chatController.messageModel != null ? chatController.messageModel.totalSize : null,
                    offset: chatController.messageModel != null ? chatController.messageModel.offset : null,
                    onPaginate: (int offset) async => await chatController.getMessages(
                      offset, widget.notificationBody, widget.user, widget.conversationId,
                    ),
                    productView: ListView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      reverse: true,
                      itemCount: chatController.messageModel.messages.length,
                      itemBuilder: (context, index) {
                        return MessageBubble(
                          message: chatController.messageModel.messages[index],
                          user: chatController.messageModel.conversation.receiver,
                          sender: chatController.messageModel.conversation.sender,
                          userType: widget.notificationBody.customerId != null ? UserType.user : UserType.vendor,
                        );
                      },
                    ),
                  ),
                ) : Center(child: Text('no_message_found'.tr)) : Center(child: CircularProgressIndicator())),

                (chatController.messageModel != null && (chatController.messageModel.status || chatController.messageModel.messages.length <= 0)) ? Container(
                  color: Theme.of(context).cardColor,
                  child: Column(children: [

                    chatController.chatImage.length > 0 ? Container(height: 100,
                      child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          shrinkWrap: true,
                          itemCount: chatController.chatImage.length,
                          itemBuilder: (BuildContext context, index){
                            return  chatController.chatImage.length > 0 ? Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Stack(children: [

                                Container(width: 100, height: 100,
                                  decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.all(Radius.circular(20))),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.all(Radius.circular(Dimensions.PADDING_SIZE_DEFAULT)),
                                    child: ResponsiveHelper.isWeb() ? Image.network(
                                      chatController.chatImage[index].path, width: 100, height: 100, fit: BoxFit.cover,
                                    ) : Image.file(
                                      File(chatController.chatImage[index].path), width: 100, height: 100, fit: BoxFit.cover,
                                    ),
                                  ),
                                ),

                                Positioned(top:0, right:0,
                                  child: InkWell(
                                    onTap : () => chatController.removeImage(index),
                                    child: Container(
                                      decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.all(Radius.circular(Dimensions.PADDING_SIZE_DEFAULT))
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(4.0),
                                        child: Icon(Icons.clear, color: Colors.red, size: 15),
                                      ),
                                    ),
                                  ),
                                )],
                              ),
                            ) : SizedBox();
                          }),
                    ) : SizedBox(),

                    Row(children: [

                      InkWell(
                        onTap: () async {
                          Get.find<ChatController>().pickImage(false);
                        },
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_DEFAULT),
                          child: Image.asset(Images.image, width: 25, height: 25, color: Theme.of(context).hintColor),
                        ),
                      ),

                      SizedBox(
                        height: 25,
                        child: VerticalDivider(width: 0, thickness: 1, color: Theme.of(context).hintColor),
                      ),
                      SizedBox(width: Dimensions.PADDING_SIZE_DEFAULT),

                      Expanded(
                        child: TextField(
                          inputFormatters: [LengthLimitingTextInputFormatter(Dimensions.MESSAGE_INPUT_LENGTH)],
                          controller: _inputMessageController,
                          textCapitalization: TextCapitalization.sentences,
                          style: robotoRegular,
                          keyboardType: TextInputType.multiline,
                          maxLines: null,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: 'type_here'.tr,
                            hintStyle: robotoRegular.copyWith(color: Theme.of(context).hintColor, fontSize: Dimensions.FONT_SIZE_LARGE),
                          ),
                          onSubmitted: (String newText) {
                            if(newText.trim().isNotEmpty && !Get.find<ChatController>().isSendButtonActive) {
                              Get.find<ChatController>().toggleSendButtonActivity();
                            }else if(newText.isEmpty && Get.find<ChatController>().isSendButtonActive) {
                              Get.find<ChatController>().toggleSendButtonActivity();
                            }
                          },
                          onChanged: (String newText) {
                            if(newText.trim().isNotEmpty && !Get.find<ChatController>().isSendButtonActive) {
                              Get.find<ChatController>().toggleSendButtonActivity();
                            }else if(newText.isEmpty && Get.find<ChatController>().isSendButtonActive) {
                              Get.find<ChatController>().toggleSendButtonActivity();
                            }
                          },
                        ),
                      ),

                      GetBuilder<ChatController>(builder: (chatController) {
                          return InkWell(
                            onTap: () async {
                              if(chatController.isSendButtonActive) {
                                await chatController.sendMessage(
                                  message: _inputMessageController.text, notificationBody: widget.notificationBody, conversationId: widget.conversationId,
                                ).then((value) {
                                  if(value.statusCode == 200){
                                    Future.delayed(Duration(seconds: 2),() {
                                      Get.find<ChatController>().getMessages(1, widget.notificationBody, widget.user, widget.conversationId);
                                    });
                                  }
                                });
                                _inputMessageController.clear();
                              }else{
                                showCustomSnackBar('write_somethings'.tr);
                              }
                            },
                            child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_DEFAULT),
                              child: chatController.isLoading ? SizedBox(
                                width: 25, height: 25,
                                child: CircularProgressIndicator(),
                              ) : Image.asset(
                                Images.send, width: 25, height: 25,
                                color: chatController.isSendButtonActive ? Theme.of(context).primaryColor : Theme.of(context).hintColor,
                              ),
                            ),
                          );
                        }
                      ),

                    ]),
                  ]),
                ) : SizedBox(),
              ]),
            ),
          ),
        ) : Center(child: Text('Not Login')),
      );
    }
    );
  }
}
