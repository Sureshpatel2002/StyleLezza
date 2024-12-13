import 'dart:convert'; // For JSON encoding/decoding
import 'package:http/http.dart' as http;

class GeminiService {
  final String apiKey = 'AIzaSyBQilyLKNNY6pWt0kotE8RgHg5EU6BDyQI'; // Replace with your Gemini API key

  // Send order details to Gemini API and get a response
Future<String> generateUserAndOrderDetailsResponse(String userName, String userEmail, List<Map<String, dynamic>> orders) async {
  final url = Uri.parse(
      "https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-flash-latest:generateContent?key=$apiKey");

  final headers = {"Content-Type": "application/json"};

  // Format the orders into a string for Gemini
  String formattedOrders = orders.map((order) {
    final totalPrice = order['totalPrice'] ?? 0.0;
    final orderDate = order['orderDate'] ?? 'Unknown Date';
    final productList = (order['products'] as List<dynamic>).map((product) {
      final productName = product['name'] ?? 'Unknown Product';
      final productPrice = product['price'] ?? 0.0;
      final productQuantity = product['quantity'] ?? 1;
      return '$productName (x$productQuantity) - \$${productPrice.toStringAsFixed(2)}';
    }).join('\n');

    return 'Order Date: $orderDate\nTotal Price: \$${totalPrice.toStringAsFixed(2)}\nProducts:\n$productList';
  }).join('\n\n');

  final body = json.encode({
    "contents": [
      {
        "parts": [
          {"text": "User Details:\nName: $userName\nEmail: $userEmail\n\nHere are the order details:\n$formattedOrders"}
        ]
      }
    ]
  });

  try {
  final response = await http.post(url, headers: headers, body: body);
  print('Response status: ${response.statusCode}');
  print('Response body: ${response.body}');
  if (response.statusCode == 200) {
    final data = json.decode(response.body);
    final content = data['contents'][0]['parts'][0]['text'] ?? 'No response';
    return content;
  } else {
    return 'Error: ${response.statusCode} - ${response.body}';
  }
} catch (e) {
  return 'Failed to generate content: $e';
}
}

}
