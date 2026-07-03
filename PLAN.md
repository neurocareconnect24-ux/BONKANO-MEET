# Plan d'implémentation

## Résumé des changements

### A. Backend Laravel (D:\kivilaravel)
1. **Créer les tables chat** : `conversations` et `messages` (migration)
2. **Créer les modèles** : `Conversation`, `Message`
3. **Créer le contrôleur** : `ChatController` avec endpoints :
   - `GET get-conversations` - Liste des conversations du user
   - `GET get-messages?conversation_id=X` - Messages d'une conversation
   - `POST send-message` - Envoyer un message (texte, image, document)
   - `POST create-conversation` - Créer/retrouver une conversation avec un docteur
4. **Routes API** dans `routes/api.php` sous `auth:sanctum`

### B. App Patient (D:\PatientApp)

#### B1. Chat par messages complet
- Modifier `chat_list_controller.dart` : charger depuis l'API conversations (plus depuis appointments)
- Créer `chat_detail_screen.dart` : écran de conversation avec :
  - Liste des messages (bulles type WhatsApp)
  - Champ de saisie texte
  - Boutons envoi image (camera/galerie) et document (file_picker)
  - Envoi via API multipart pour les fichiers
- Créer `chat_detail_controller.dart` : gère l'envoi/réception des messages
- Créer `models/conversation_model.dart` et `models/message_model.dart`
- Ajouter les endpoints dans `api_end_points.dart`

#### B2. Supprimer le portefeuille
- Retirer le `SettingItemWidget` wallet de `profile_screen.dart`
- (Les fichiers wallet_history restent mais ne sont plus accessibles)

#### B3. Bouton "Nouveau RDV" dans l'écran des rendez-vous
- Ajouter un `FloatingActionButton` dans `appointments_screen.dart`
- Navigation vers `BookingFormScreen` existant

#### B4. Renommer l'app "NeuroCare Connect"
- Modifier `APP_NAME` dans `configs.dart`

### C. App Admin/Médecin (D:\AdminKiviApp)

#### C1. Ajouter le Chat
- Copier les fichiers chat (screen + controller + models) adaptés au rôle médecin
- Ajouter `chat` dans l'enum `BottomItem` de `menu.dart`
- Ajouter `ChatListScreen` dans `dashboard_controller.dart`
- Mettre à jour `dashboard_screen.dart` et `btm_nav_item.dart` pour 4-5 onglets
- Ajouter les traductions chat dans les fichiers locale

#### C2. Renommer l'app
- Modifier `APP_NAME` dans `configs.dart` → "NeuroCare Connect Praticien"

## Ordre d'exécution
1. Backend Laravel (tables + API chat)
2. App Patient : chat messages, supprimer wallet, bouton RDV, renommer
3. App Admin : ajouter chat, renommer
4. Build Windows pour test
