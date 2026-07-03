import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:bonkano_meet/components/app_scaffold.dart';
import 'package:bonkano_meet/utils/colors.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:url_launcher/url_launcher.dart';

import 'chat_controller.dart';
import 'model/chat_message_model.dart';
import '../../../utils/app_common.dart';

class ChatScreen extends StatelessWidget {
  ChatScreen({super.key});

  final ChatController chatController = Get.put(ChatController());

  @override
  Widget build(BuildContext context) {
    return AppScaffoldNew(
      appBartitleText: "Discussion",
      body: Column(
        children: [
          Expanded(
            child: Obx(
              () => ListView.builder(
                reverse: true,
                padding: const EdgeInsets.all(16),
                itemCount: chatController.messages.length,
                itemBuilder: (context, index) {
                  final message = chatController.messages[index];
                  bool isMe = message.senderId == loginUserData.value.id;
                  return _buildMessageBubble(message, isMe);
                },
              ),
            ),
          ),
          if (chatController.isUploadingImage.value)
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: LinearProgressIndicator(),
            ),
          _buildMessageInput(context),
        ],
      ),
    );
  }

  Widget _buildMessageBubble(ChatMessage message, bool isMe) {
    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: Get.width * 0.75),
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 4),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          decoration: BoxDecoration(
            color: isMe ? appColorPrimary : Colors.grey.shade200,
            borderRadius: BorderRadius.only(
              topLeft: const Radius.circular(16),
              topRight: const Radius.circular(16),
              bottomLeft: isMe ? const Radius.circular(16) : const Radius.circular(0),
              bottomRight: isMe ? const Radius.circular(0) : const Radius.circular(16),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (message.imageUrl != null)
                Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(message.imageUrl!, fit: BoxFit.cover),
                  ),
                ),
              if (message.documentUrl != null)
                GestureDetector(
                  onTap: () async {
                    final Uri url = Uri.parse(message.documentUrl!);
                    if (await canLaunchUrl(url)) {
                      await launchUrl(url, mode: LaunchMode.externalApplication);
                    } else {
                      toast("Impossible d'ouvrir le fichier");
                    }
                  },
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: isMe ? Colors.white.withOpacity(0.2) : Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.insert_drive_file, color: isMe ? Colors.white : Colors.black87),
                        8.width,
                        Flexible(
                          child: Text(
                            message.text.replaceAll("📄 Fichier joint : ", ""),
                            style: primaryTextStyle(color: isMe ? Colors.white : Colors.black87, decoration: TextDecoration.underline),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              if (message.text.isNotEmpty && message.text != "📷 Image" && !message.text.startsWith("📄 Fichier joint : "))
                Text(
                  message.text,
                  style: primaryTextStyle(color: isMe ? Colors.white : Colors.black87),
                ),
              4.height,
              Text(
                DateFormat('HH:mm').format(message.timestamp),
                style: secondaryTextStyle(
                  size: 10,
                  color: isMe ? Colors.white70 : Colors.black54,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMessageInput(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      decoration: BoxDecoration(
        color: context.cardColor,
        boxShadow: defaultBoxShadow(),
      ),
      child: SafeArea(
        child: Row(
          children: [
            IconButton(
              icon: const Icon(Icons.attach_file, color: Colors.grey),
              onPressed: () {
                showModalBottomSheet(
                  context: context,
                  backgroundColor: context.cardColor,
                  shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(16))),
                  builder: (BuildContext context) {
                    return SafeArea(
                      child: Wrap(
                        children: [
                          ListTile(
                            leading: const Icon(Icons.photo_camera, color: appColorPrimary),
                            title: const Text('Image (Galerie/Caméra)'),
                            onTap: () {
                              Navigator.pop(context);
                              chatController.sendImage();
                            },
                          ),
                          ListTile(
                            leading: const Icon(Icons.insert_drive_file, color: appColorPrimary),
                            title: const Text('Document (PDF, Word, etc.)'),
                            onTap: () {
                              Navigator.pop(context);
                              chatController.sendDocument();
                            },
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
            Expanded(
              child: TextField(
                controller: chatController.messageController,
                decoration: InputDecoration(
                  hintText: "Saisissez un message...",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(24),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  fillColor: Colors.grey.shade100,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                ),
                maxLines: null,
                textInputAction: TextInputAction.send,
                onSubmitted: (_) => chatController.sendMessage(),
              ),
            ),
            8.width,
            Obx(
              () => IconButton(
                icon: chatController.isSendingMessage.value
                    ? const SizedBox(width: 24, height: 24, child: CircularProgressIndicator(strokeWidth: 2))
                    : const Icon(Icons.send, color: appColorPrimary),
                onPressed: chatController.isSendingMessage.value ? null : () => chatController.sendMessage(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
