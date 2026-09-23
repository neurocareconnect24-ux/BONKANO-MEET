import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../services/ai_service.dart';
import 'chat_message_model.dart';
import 'package:nb_utils/nb_utils.dart';

class ChatIAController extends GetxController {
  final AiService _aiService = AiService();
  
  RxList<ChatMessage> messages = <ChatMessage>[].obs;
  RxBool isLoading = false.obs;
  TextEditingController textController = TextEditingController();

  final List<String> suggestions = [
    "🤒 Maux de tête fréquents ou migraines",
    "🧠 Troubles de la mémoire ou de la concentration",
    "😔 Sentiment de tristesse profonde ou dépression",
    "😰 Crises d'angoisse ou anxiété sévère",
    "💤 Troubles du sommeil ou insomnie",
    "⚡ Tremblements ou faiblesse musculaire",
    "🔄 Vertiges ou pertes d'équilibre",
    "🌀 Changements brusques d'humeur"
  ];

  void sendMessage(String text) async {
    if (text.trim().isEmpty) return;

    messages.insert(0, ChatMessage(text: text, isMe: true));
    textController.clear();
    isLoading.value = true;

    try {
      final response = await _aiService.askMedicalAssistant(text, messages.skip(1).toList());
      messages.insert(0, ChatMessage(text: response, isMe: false));
    } catch (e) {
      toast(e.toString());
      messages.insert(0, ChatMessage(text: "Désolé, une erreur est survenue. Veuillez réessayer.", isMe: false));
    } finally {
      isLoading.value = false;
    }
  }

  void clearChat() {
    messages.clear();
  }
}