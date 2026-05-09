import 'package:url_launcher/url_launcher.dart';

class WhatsAppHelper {
  static Future<void> launchWhatsApp({
    required String phone,
    required String message,
  }) async {
    final url = 'whatsapp://send?phone=$phone&text=${Uri.encodeComponent(message)}';
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    } else {
      // Fallback to web link if app is not installed
      final webUrl = 'https://wa.me/$phone/?text=${Uri.encodeComponent(message)}';
      await launchUrl(Uri.parse(webUrl), mode: LaunchMode.externalApplication);
    }
  }
}
