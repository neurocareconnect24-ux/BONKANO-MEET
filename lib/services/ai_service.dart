import 'package:dio/dio.dart';
import '../screens/auth/model/app_configuration_res.dart';
import '../screens/chat_ia/chat_message_model.dart';
import '../utils/common_base.dart';
import '../utils/app_common.dart';

class AiService {
  final Dio _dio = Dio();

  final String systemInstruction = '''
Tu es l'assistant virtuel de sant\u00e9 intelligent de l'application Bonkano.
Tu es EXTR\u00caMEMENT expert et sp\u00e9cialis\u00e9 en Neurologie et en Sant\u00e9 Mentale.
Tes connaissances m\u00e9dicales sont \u00e0 jour et fond\u00e9es sur la science.
Tu dois :
1. \u00catre empathique, rassurant et professionnel.
2. Donner des explications claires et d\u00e9taill\u00e9es sur les sympt\u00f4mes neurologiques ou psychiatriques.
3. Toujours pr\u00e9ciser que tes conseils ne remplacent pas une vraie consultation m\u00e9dicale.
4. Encourager le patient \u00e0 prendre rendez-vous avec un m\u00e9decin de l'application s'il s'agit d'une urgence ou d'un besoin de diagnostic.
5. Ne jamais formuler de diagnostic d\u00e9finitif ni prescrire de m\u00e9dicaments sur ordonnance.
''';

  Future<String> askMedicalAssistant(String userMessage, List<ChatMessage> history) async {
    final apiKey = appConfigs.value.chatgptKey;
    if (apiKey.isEmpty) {
      throw Exception('La cl\u00e9 API IA n\'est pas configur\u00e9e dans le panel Admin.');
    }

    if (apiKey.startsWith('sk-')) {
      return await _askOpenAI(apiKey, userMessage, history);
    } else {
      return await _askGemini(apiKey, userMessage, history);
    }
  }

  Future<String> _askGemini(String apiKey, String userMessage, List<ChatMessage> history) async {
    final url = 'https://generativelanguage.googleapis.com/v1beta/models/gemini-3.7-flash:generateContent?key=$apiKey';
    
    List<Map<String, dynamic>> contents = [];

    // System instruction injected as first user message (Gemini workaround if system_instruction is not supported in this API version)
    contents.add({
      "role": "user",
      "parts": [{"text": systemInstruction}]
    });
    contents.add({
      "role": "model",
      "parts": [{"text": "Je suis pr\u00eat. Je suis votre assistant sp\u00e9cialis\u00e9 en neurologie et sant\u00e9 mentale."}]
    });

    // Add conversation history (max last 10 messages to save context limit, reversed because messages are stored newest-first)
    final recentHistory = history.take(10).toList().reversed.toList();
    for (var msg in recentHistory) {
      contents.add({
        "role": msg.isMe ? "user" : "model",
        "parts": [{"text": msg.text}]
      });
    }

    // Add the new user message
    contents.add({
      "role": "user",
      "parts": [{"text": userMessage}]
    });

    final body = {
      "contents": contents,
      "generationConfig": {
        "temperature": 0.5,
        "maxOutputTokens": 4096
      }
    };

    try {
      final response = await _dio.post(
        url,
        data: body,
        options: Options(headers: {'Content-Type': 'application/json'}),
      );

      if (response.statusCode == 200) {
        return response.data['candidates'][0]['content']['parts'][0]['text'];
      } else {
        throw Exception('Erreur API Gemini: $response');
      }
    } on DioError catch (e) {
      throw Exception('Erreur de connexion \u00e0 Gemini: $e');
    }
  }

  Future<String> _askOpenAI(String apiKey, String userMessage, List<ChatMessage> history) async {
    final url = 'https://api.openai.com/v1/chat/completions';
    
    List<Map<String, dynamic>> messages = [];
    messages.add({"role": "system", "content": systemInstruction});

    final recentHistory = history.take(10).toList().reversed.toList();
    for (var msg in recentHistory) {
      messages.add({
        "role": msg.isMe ? "user" : "assistant",
        "content": msg.text
      });
    }

    messages.add({"role": "user", "content": userMessage});

    final body = {
      "model": "gpt-4o-mini",
      "messages": messages,
      "temperature": 0.5,
      "max_tokens": 4096
    };

    try {
      final response = await _dio.post(
        url,
        data: body,
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $apiKey',
          },
        ),
      );

      if (response.statusCode == 200) {
        return response.data['choices'][0]['message']['content'];
      } else {
        throw Exception('Erreur API OpenAI: $response');
      }
    } on DioError catch (e) {
      throw Exception('Erreur de connexion \u00e0 OpenAI: $e');
    }
  }
}