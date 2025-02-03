import 'dart:convert';
import 'dart:typed_data';
import 'package:encrypt/encrypt.dart';
import 'package:crypto/crypto.dart';

class EncryptionHelper {
  static String encrypt(String plainText, String key) {
    final keyBytes = _getKeyBytes(key);
    final iv = IV.fromLength(16); // Generate a random IV
    final encrypter =
        Encrypter(AES(Key(keyBytes), mode: AESMode.cbc, padding: 'PKCS7'));
    final encrypted = encrypter.encrypt(plainText, iv: iv);
    return '${base64.encode(iv.bytes)}:${encrypted.base64}';
  }

  static String decrypt(String encryptedText, String key) {
    final parts = encryptedText.split(':');
    final iv = IV.fromBase64(parts[0]);
    final encryptedData = parts[1];
    final keyBytes = _getKeyBytes(key);
    final encrypter =
        Encrypter(AES(Key(keyBytes), mode: AESMode.cbc, padding: 'PKCS7'));
    final decrypted = encrypter.decrypt64(encryptedData, iv: iv);
    return decrypted;
  }

  static Uint8List _getKeyBytes(String key) {
    final keyBytes = List<int>.filled(16, 0);
    final secretKeyBytes = utf8.encode(key);
    for (int i = 0; i < 16 && i < secretKeyBytes.length; i++) {
      keyBytes[i] = secretKeyBytes[i];
    }
    return Uint8List.fromList(keyBytes);
  }
}
