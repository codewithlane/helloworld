import 'dart:io';

class UrlEncryption {
  static final String _flutterApp = 'flutterApp' + '%^!GGGG';

  static String encryptUrl(String url) {
    final keyBytes = _flutterApp.codeUnits;
    final urlBytes = url.codeUnits;
    final encrypted = <int>[];

    for (int i = 0; i < urlBytes.length; i++) {
      encrypted.add(urlBytes[i] ^ keyBytes[i % keyBytes.length]);
    }

    return Uri.encodeComponent(String.fromCharCodes(encrypted));
  }

  static String decryptUrl(String encryptedUrl) {
    try {
      final decoded = Uri.decodeComponent(encryptedUrl);
      final encryptedBytes = decoded.codeUnits;
      final keyBytes = _flutterApp.codeUnits;
      final decrypted = <int>[];

      for (int i = 0; i < encryptedBytes.length; i++) {
        decrypted.add(encryptedBytes[i] ^ keyBytes[i % keyBytes.length]);
      }

      return String.fromCharCodes(decrypted);
    } catch (e) {
      print('Error decrypting URL: $e');
      return '';
    }
  }

  static String getEncryptedUrlTemplate() {
    const encryptedTemplate =
        "%0E%18%01%04%07_%5Dn%17%19Q6T%25i%24(%0BC%16%1B%10%00%05(%04%18I%3FO%22h%2F%22%0A%00%1A%03%1B%17%1E%25_%12I1Ch*%26.%08C%0E%16%01%0B%16-%159A%23%0E.(4i%0C%03%1B";
    return encryptedTemplate;
  }

  static String getDecryptedUrl(String bundleId) {
    final encryptedTemplate = getEncryptedUrlTemplate();
    final decryptedTemplate = decryptUrl(encryptedTemplate);
    final platform = Platform.isAndroid ? 'android' : 'ios';
    return decryptedTemplate
        .replaceAll('{bundleId}', bundleId)
        .replaceAll('{platform}', platform);
  }
}
