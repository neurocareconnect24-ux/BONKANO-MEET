import codecs

file_path = 'D:/KIVIAPP/PatientApp/lib/screens/chat/services/chat_service.dart'

with codecs.open(file_path, 'r', 'utf-8') as f:
    content = f.read()

import_auth = "import 'package:firebase_auth/firebase_auth.dart';"
if import_auth not in content:
    content = content.replace("import 'package:firebase_storage/firebase_storage.dart';", "import 'package:firebase_storage/firebase_storage.dart';\nimport 'package:firebase_auth/firebase_auth.dart';")

auth_snippet = """
    try {
      if (FirebaseAuth.instance.currentUser == null) {
        await FirebaseAuth.instance.signInAnonymously();
      }
    } catch (e) {
      print("Firebase Auth Error: $e");
    }
"""

if "signInAnonymously" not in content:
    content = content.replace("String fileName = '${DateTime.now().millisecondsSinceEpoch}_${p.basename(imageFile.path)}';", 
                              auth_snippet + "\n      String fileName = '${DateTime.now().millisecondsSinceEpoch}_${p.basename(imageFile.path)}';")
    content = content.replace("String fileName = '${DateTime.now().millisecondsSinceEpoch}_${p.basename(documentFile.path)}';", 
                              auth_snippet + "\n      String fileName = '${DateTime.now().millisecondsSinceEpoch}_${p.basename(documentFile.path)}';")


with codecs.open(file_path, 'w', 'utf-8') as f:
    f.write(content)

print("Added Firebase Anonymous Auth successfully to PatientApp ChatService!")
