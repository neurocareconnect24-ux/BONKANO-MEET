import 'package:cloud_firestore/cloud_firestore.dart';

class ChatMessage {
  final String id;
  final int appointmentId;
  final String text;
  final int senderId;
  final int receiverId;
  final DateTime timestamp;
  final bool isRead;
  final String? imageUrl;
  final String? documentUrl;

  ChatMessage({
    this.id = '',
    required this.appointmentId,
    required this.text,
    required this.senderId,
    required this.receiverId,
    required this.timestamp,
    this.isRead = false,
    this.imageUrl,
    this.documentUrl,
  });

  factory ChatMessage.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map<String, dynamic>;
    return ChatMessage(
      id: doc.id,
      appointmentId: data['appointmentId'] ?? data['appointment_id'] ?? 0,
      text: data['text'] ?? '',
      senderId: data['senderId'] ?? data['sender_id'] ?? -1,
      receiverId: data['receiverId'] ?? data['receiver_id'] ?? -1,
      timestamp: (data['timestamp'] as Timestamp?)?.toDate() ?? DateTime.now(),
      isRead: data['isRead'] ?? data['is_read'] ?? false,
      imageUrl: data['imageUrl'] ?? data['image_url'],
      documentUrl: data['documentUrl'] ?? data['document_url'],
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'appointmentId': appointmentId,
      'text': text,
      'senderId': senderId,
      'receiverId': receiverId,
      'timestamp': FieldValue.serverTimestamp(),
      'isRead': isRead,
      'imageUrl': imageUrl,
      'documentUrl': documentUrl,
    };
  }
}
