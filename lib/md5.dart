// ignore_for_file: unused_local_variable

import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:encrypt/encrypt.dart' as encrypt;

class Crypt {
  String generateMd5(String input) {
    return md5.convert(utf8.encode(input)).toString();
  }
}

class AESencryption {
  static encrypt.Key getKey(String secretKey) {
    final keyBytes = utf8.encode(secretKey);
    return encrypt.Key(keyBytes);
  }

  static encrypt.IV getIV(String secretKey) {
    final keyBytes = utf8.encode(secretKey);
    return encrypt.IV(keyBytes);
  }

  static encrypt.Encrypter getEncrypter(String secretKey) {
    final key = getKey(secretKey);
    final iv = getIV(secretKey);
    return encrypt.Encrypter(encrypt.AES(key, mode: encrypt.AESMode.cbc));
  }

  static String encryptString(String plainText, String secretKey) {
    final encrypter = getEncrypter(secretKey);
    final encrypted = encrypter.encrypt(plainText, iv: getIV(secretKey));
    return encrypted.base64;
  }

  static String decryptString(String encryptedText, String secretKey) {
    final encrypter = getEncrypter(secretKey);
    final decrypted = encrypter.decrypt64(encryptedText, iv: getIV(secretKey));
    return decrypted;
  }
}
