import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:bonkano_meet/utils/app_common.dart';

import '../model/chat_message_model.dart';
import 'package:path/path.dart' as p;

class ChatService {
  FirebaseFirestore get _firestore => FirebaseFirestore.instanceFor(
      app: Firebase.app(), databaseId: 'baseneurocarekivi');
  FirebaseStorage get _storage => FirebaseStorage.instanceFor(
      bucket: 'kivicareneurocare.firebasestorage.app');

  /// Fonction générique pour récupérer l'ID de la chambre de discussion basé sur l'appointmentId
  String getChatRoomId(int appointmentId) {
    return appointmentId.toString();
  }

  /// Écoute les messages d'un rendez-vous en temps réel
  Stream<List<ChatMessage>> getMessages(int appointmentId) {
    String roomId = getChatRoomId(appointmentId);

    return _firestore
        .collection('chats')
        .doc(roomId)
        .collection('messages')
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) => ChatMessage.fromFirestore(doc)).toList();
    });
  }

  /// Envoie un message texte
  Future<void> sendMessage(int appointmentId, String text, int receiverId) async {
    if (text.trim().isEmpty) return;
    
    String roomId = getChatRoomId(appointmentId);
    int senderId = loginUserData.value.id;

    ChatMessage message = ChatMessage(
      id: '',
      appointmentId: appointmentId,
      text: text,
      senderId: senderId,
      receiverId: receiverId,
      timestamp: DateTime.now(),
    );

    // Mettre à jour l'état général de la chambre de discussion (utile pour lister les chats plus tard)
    await _firestore.collection('chats').doc(roomId).set({
      'appointmentId': appointmentId,
      'patientId': senderId,
      'doctorId': receiverId,
      'lastMessage': text,
      'lastTimestamp': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));

    // Ajouter le message dans la sous-collection
    await _firestore
        .collection('chats')
        .doc(roomId)
        .collection('messages')
        .add(message.toFirestore());
  }

  /// Upload une image dans Firebase Storage et envoie l'URL sous forme de message
  Future<void> sendImageMessage(int appointmentId, File imageFile, int receiverId) async {
    String roomId = getChatRoomId(appointmentId);
    int senderId = loginUserData.value.id;
    
    
    try {
      if (FirebaseAuth.instance.currentUser == null) {
        await FirebaseAuth.instance.signInAnonymously();
      }
    } catch (e) {
      print("Firebase Auth Error: $e");
    }

      String fileName = '${DateTime.now().millisecondsSinceEpoch}_${p.basename(imageFile.path)}';
    Reference storageRef = _storage.ref().child('chats/$roomId/images/$fileName');

    try {
      // Upload de l'image
      UploadTask uploadTask = storageRef.putFile(imageFile);
      TaskSnapshot snapshot = await uploadTask;
      String downloadUrl = await snapshot.ref.getDownloadURL();

      ChatMessage message = ChatMessage(
        id: '',
        appointmentId: appointmentId,
        text: "📷 Image",
        senderId: senderId,
        receiverId: receiverId,
        timestamp: DateTime.now(),
        imageUrl: downloadUrl,
      );

      // Mettre à jour la chambre
      await _firestore.collection('chats').doc(roomId).set({
        'appointmentId': appointmentId,
        'patientId': senderId,
        'doctorId': receiverId,
        'lastMessage': "📷 Image",
        'lastTimestamp': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));

      // Ajouter le message
      await _firestore
          .collection('chats')
          .doc(roomId)
          .collection('messages')
          .add(message.toFirestore());
    } catch (e) {
      throw 'Erreur lors de l\'envoi de l\'image : $e';
    }
  }

  /// Upload un document dans Firebase Storage et envoie l'URL sous forme de message
  Future<void> sendDocumentMessage(int appointmentId, File documentFile, int receiverId, String originalFileName) async {
    String roomId = getChatRoomId(appointmentId);
    int senderId = loginUserData.value.id;
    
    String fileName = '${DateTime.now().millisecondsSinceEpoch}_$originalFileName';
    Reference storageRef = _storage.ref().child('chats/$roomId/documents/$fileName');

    try {
      // Upload du document
      UploadTask uploadTask = storageRef.putFile(documentFile);
      TaskSnapshot snapshot = await uploadTask;
      String downloadUrl = await snapshot.ref.getDownloadURL();

      ChatMessage message = ChatMessage(
        id: '',
        appointmentId: appointmentId,
        text: "📄 Fichier joint : $originalFileName",
        senderId: senderId,
        receiverId: receiverId,
        timestamp: DateTime.now(),
        documentUrl: downloadUrl,
      );

      // Mettre à jour la chambre
      await _firestore.collection('chats').doc(roomId).set({
        'appointmentId': appointmentId,
        'patientId': senderId,
        'doctorId': receiverId,
        'lastMessage': "📄 Fichier",
        'lastTimestamp': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));

      // Ajouter le message
      await _firestore
          .collection('chats')
          .doc(roomId)
          .collection('messages')
          .add(message.toFirestore());
    } catch (e) {
      throw 'Erreur lors de l\'envoi du document : $e';
    }
  }
}
