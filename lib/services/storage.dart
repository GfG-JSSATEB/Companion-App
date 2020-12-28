import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';

class StorageService {
  StorageService({@required this.id}) : assert(id != null);
  final String id;

  Future<String> uploadPoster({
    @required File file,
  }) async {
    return upload(
      file: file,
      path: 'event/$id.png',
      contentType: 'image/png',
    );
  }

  Future<String> upload({
    @required File file,
    @required String path,
    @required String contentType,
  }) async {
    final storageReference = FirebaseStorage.instance.ref().child(path);
    final UploadTask uploadTask = storageReference.putFile(
        file, SettableMetadata(contentType: contentType));

    final TaskSnapshot snapshot = await uploadTask;

    final String downloadUrl = await snapshot.ref.getDownloadURL();
    return downloadUrl;
  }
}
