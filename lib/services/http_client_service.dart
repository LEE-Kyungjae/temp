import 'dart:io';
import 'package:http/io_client.dart';

HttpClient createHttpClient(SecurityContext? context) {
  final HttpClient client = HttpClient(context: context);
  client.badCertificateCallback =
      (X509Certificate cert, String host, int port) => true;
  return client;
}

IOClient createIoClient() {
  return IOClient(createHttpClient(null));
}
