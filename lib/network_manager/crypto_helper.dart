import 'package:convert/convert.dart';
import 'package:cryptography/cryptography.dart';
import 'dart:convert';

class CryptoHelper {
  final algorithm = AesCbc.with128bits(macAlgorithm: MacAlgorithm.empty);

  final key = SecretKey(
    utf8.encode('VisiQBackendResp'),
  ); // AES-128 requires a 16-byte key
  final iv = utf8.encode('VisiQBackendiv12'); // 16-byte IV

  Future<String> encryptData(String text) async {
    final secretBox = await algorithm.encrypt(
      utf8.encode(text),
      secretKey: key,
      nonce: iv,
    );
    return base64.encode(secretBox.cipherText);
  }

  Future<String> decryptData(String encryptedText) async {
    final cipherText = hex.decode(
      encryptedText,
    ); // Decode the hex-encoded string to bytes

    final secretBox = SecretBox(cipherText, nonce: iv, mac: Mac.empty);

    final clearText = await algorithm.decrypt(secretBox, secretKey: key);

    return utf8.decode(clearText);
  }
}
