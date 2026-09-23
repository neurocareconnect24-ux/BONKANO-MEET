import 'package:flutter/material.dart';
import '../../core/legal/medical_disclaimer_banner.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import '../../utils/colors.dart';
import '../../generated/assets.dart';
import 'chat_ia_controller.dart';
import 'chat_message_model.dart';
import '../../utils/common_base.dart';

class ChatIAScreen extends StatelessWidget {
  ChatIAScreen({super.key});

  final ChatIAController controller = Get.put(ChatIAController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Assistant IA', style: boldTextStyle(color: Colors.white)),
        backgroundColor: appColorPrimary,
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_outline, color: Colors.white),
            onPressed: () => controller.clearChat(),
            tooltip: 'Effacer l\'historique',
          )
        ],
      ),
      body: Column(
        children: [
          const MedicalDisclaimerBanner(),
          // Bandeau fixe d'avertissement
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(8),
            color: Colors.orange.withValues(alpha: 0.1),
            child: Row(
              children: [
                const Icon(Icons.info_outline, color: Colors.orange, size: 20),
                8.width,
                Expanded(
                  child: Text(
                    'Assistant informatif - Ne remplace pas un avis m\u00e9dical.',
                    style: secondaryTextStyle(color: Colors.orange, size: 12),
                  ),
                ),
              ],
            ),
          ),
          
          Expanded(
            child: Obx(
              () => controller.messages.isEmpty
                  ? _buildEmptyState()
                  : ListView.builder(
                      reverse: true,
                      padding: const EdgeInsets.all(16),
                      itemCount: controller.messages.length,
                      itemBuilder: (context, index) {
                        final msg = controller.messages[index];
                        return _buildMessageBubble(msg);
                      },
                    ),
            ),
          ),
          
          Obx(() {
            if (controller.isLoading.value) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                    8.width,
                    Text('L\'assistant r\u00e9dige sa r\u00e9ponse...', style: secondaryTextStyle(size: 12)),
                  ],
                ),
              );
            }
            return const SizedBox.shrink();
          }),

          _buildInputArea(context),
          80.height, // Avoid bottom nav bar overlay
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.smart_toy, size: 80, color: appColorPrimary).paddingBottom(16),
            Text('Bonjour !', style: boldTextStyle(size: 22)),
            8.height,
            Text('Je suis l\'assistant IA de Bonkano.', style: secondaryTextStyle()),
            32.height,
            Text('Suggestions rapides :', style: primaryTextStyle()),
            16.height,
            Wrap(
              spacing: 8,
              runSpacing: 8,
              alignment: WrapAlignment.center,
              children: controller.suggestions.map((suggestion) {
                return ActionChip(
                  label: Text(suggestion, style: secondaryTextStyle(size: 13)),
                  backgroundColor: appColorPrimary.withValues(alpha: 0.1),
                  side: BorderSide.none,
                  onPressed: () => controller.sendMessage(suggestion),
                );
              }).toList(),
            ).paddingSymmetric(horizontal: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildMessageBubble(ChatMessage msg) {
    return Row(
      mainAxisAlignment: msg.isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        if (!msg.isMe) ...[
          CircleAvatar(
            backgroundColor: appColorPrimary.withValues(alpha: 0.2),
            child: const Icon(Icons.smart_toy, color: appColorPrimary, size: 20),
          ),
          8.width,
        ],
        Flexible(
          child: Container(
            margin: const EdgeInsets.only(bottom: 16),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: msg.isMe ? appColorPrimary : Colors.grey.withValues(alpha: 0.1),
              borderRadius: BorderRadius.only(
                topLeft: const Radius.circular(16),
                topRight: const Radius.circular(16),
                bottomLeft: Radius.circular(msg.isMe ? 16 : 0),
                bottomRight: Radius.circular(msg.isMe ? 0 : 16),
              ),
            ),
            child: Text(
              msg.text,
              style: primaryTextStyle(color: msg.isMe ? Colors.white : textPrimaryColorGlobal),
            ),
          ),
        ),
        if (msg.isMe) 28.width, // Padding for alignment
      ],
    );
  }

  Widget _buildInputArea(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      margin: const EdgeInsets.only(bottom: 90),
      decoration: BoxDecoration(
        color: context.cardColor,
        boxShadow: [
          BoxShadow(color: Colors.grey.withValues(alpha: 0.1), blurRadius: 4, offset: const Offset(0, -2))
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: AppTextField(
              controller: controller.textController,
              textFieldType: TextFieldType.MULTILINE,
              decoration: inputDecoration(Get.context!, hintText: 'Posez votre question m\u00e9dicale...'),
              maxLines: 4,
              minLines: 1,
            ),
          ),
          8.width,
          Container(
            decoration: const BoxDecoration(color: appColorPrimary, shape: BoxShape.circle),
            child: IconButton(
              icon: const Icon(Icons.send, color: Colors.white, size: 20),
              onPressed: () {
                controller.sendMessage(controller.textController.text);
              },
            ),
          ),
        ],
      ),
    );
  }
}