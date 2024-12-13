import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:stylelezza/element/custom_text.dart';
import 'package:stylelezza/element/custom_textfield.dart';
import 'package:stylelezza/utils/app_colors.dart';
import 'package:stylelezza/utils/utils.dart';

class ChatScreen extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final List<Map<String, String>> _messages = [];
  bool _isTyping = false;
  bool _showTextField = true;
  String? uId = FirebaseAuth.instance.currentUser?.uid;
  final Map<String, Function> _keywordActions = {
    'order details': (context) => context._fetchOrderDetails(),
    
    'success orders': (context) => context._fetchSuccessOrders(),
    'failed orders': (context) => context._fetchFailedOrders(),
    'my profile': (context) => context._fetchUserProfile(),
  };

  @override
  void initState() {
    super.initState();
    _sendBotResponse("Hello! I'm Gemini 🤖. How can I assist you today?");
  }

  Future<void> _handleUserMessage(String message) async {
    _sendUserMessage(message);
    _isTyping = true;

    bool keywordFound = false;
    for (String keyword in _keywordActions.keys) {
      if (_isSimilar(message, keyword)) {
        await _keywordActions[keyword]!(this);
        keywordFound = true;
        break;
      }
    }

    if (!keywordFound) {
      _sendBotResponse(
          "🤔 I'm not sure I understand. Try asking about your orders, cart, or profile.");
    }

    setState(() {
      _isTyping = false;
      _showTextField = true;
    });
  }

  bool _isSimilar(String input, String keyword, {int threshold = 3}) {
    final distance = levenshtein(input.toLowerCase(), keyword.toLowerCase());
    return distance <= threshold;
  }

  int levenshtein(String s1, String s2) {
    if (s1 == s2) return 0;
    if (s1.isEmpty) return s2.length;
    if (s2.isEmpty) return s1.length;

    List<List<int>> dp = List.generate(
      s1.length + 1,
      (i) => List<int>.generate(s2.length + 1, (j) => 0),
    );

    for (int i = 0; i <= s1.length; i++) dp[i][0] = i;
    for (int j = 0; j <= s2.length; j++) dp[0][j] = j;

    for (int i = 1; i <= s1.length; i++) {
      for (int j = 1; j <= s2.length; j++) {
        int cost = s1[i - 1] == s2[j - 1] ? 0 : 1;
        dp[i][j] = [
          dp[i - 1][j] + 1,
          dp[i][j - 1] + 1,
          dp[i - 1][j - 1] + cost
        ].reduce((a, b) => a < b ? a : b);
      }
    }
    return dp[s1.length][s2.length];
  }

  /// Fetch Order Details
 Future<void> _fetchOrderDetails() async {
  try {
    // Get the current user
    final user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      // Query the 'user_orders' sub-collection for the current user's orders
      QuerySnapshot snapshot = await _firestore
          .collection('orders')
          .doc(user.uid) // Reference the user's document by UID
          .collection('user_orders') // Access the sub-collection where orders are stored
          .get();

      if (snapshot.docs.isNotEmpty) {
        String response = "📦 Your Orders:\n";

        // Loop through each document in the snapshot
        for (var doc in snapshot.docs) {
          var data = doc.data() as Map<String, dynamic>;

          // Fetch the order details
          String orderStatus = data['status'] ?? 'Not available';
          String orderId = doc.id; // Get the document ID for the order ID
          double totalPrice = data['totalPrice'] ?? 0.0;
          String timestamp = data['timestamp']?.toDate().toString() ?? 'N/A';

          // Start building the response with order summary
          response += "- Order ID: $orderId\n  Status: $orderStatus\n  Total Price: ₹$totalPrice\n  Timestamp: $timestamp\n\n";

          // Fetch product details
          List products = data['products'] ?? [];
          if (products.isNotEmpty) {
            response += "🛒 Products:\n";
            for (var product in products) {
              String productName = product['name'] ?? 'Unknown Product';
              int quantity = product['quantity'] ?? 0;
              double price = product['price'] ?? 0.0;

              response += "- Product: $productName\n  Quantity: $quantity\n  Price: ₹$price\n\n";
            }
          } else {
            response += "No products found in this order.\n";
          }
        }

        _sendBotResponse(response); // Send the formatted response (e.g., to the user)
      } else {
        _sendBotResponse("You have no orders.");
      }
    } else {
      _sendBotResponse("User not logged in.");
    }
  } catch (e) {
    print('Error fetching orders: $e');
    _sendBotResponse("An error occurred while fetching your orders.");
  }
}




  /// Fetch Cart Details
Future<void> fetchCartProducts() async {
  try {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      Utils.flushBarErrorMessage('User not logged in!', context);
      return;
    }

    // Fetch the user's cart products from Firestore
    QuerySnapshot snapshot = await _firestore
        .collection('cart')
        .doc(user.uid) // Use the user's UID
        .collection('products') // Products sub-collection
        .get(); // This returns a QuerySnapshot, not a DocumentSnapshot

    if (snapshot.docs.isEmpty) {
      _sendBotResponse("Your cart is empty.");
    } else {
      // Iterate over documents in the snapshot and display the cart details
      String cartDetails = snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return "Product: ${data['name']}, Quantity: ${data['quantity']}, Size: ${data['selectedSize']}, Color: ${data['selectedColor']}";
      }).join("\n");

      _sendBotResponse("🛒 Cart Details:\n$cartDetails");
    }
  } catch (e) {
    _sendBotResponse("❌ Failed to fetch cart details. Error: $e");
  }
}



  /// Fetch Success Orders
  Future<void> _fetchSuccessOrders() async {
  try {
    final user = FirebaseAuth.instance.currentUser; // Get the logged-in user

    if (user != null) {
      // Query the 'orders' collection under the user's UID for 'success' status
      QuerySnapshot snapshot = await _firestore
          .collection('orders')
          .doc(user.uid)
          .collection('user_orders')
          .where('status', isEqualTo: 'success')
          .get();

      if (snapshot.docs.isEmpty) {
        _sendBotResponse("No successful orders found.");
      } else {
        String successOrders = snapshot.docs.map((doc) {
          final data = doc.data() as Map<String, dynamic>;
          return "Order ID: ${doc.id}, Total Price: ${data['totalPrice']}, Products: ${_formatProducts(data['products'])}";
        }).join("\n\n");

        _sendBotResponse("✅ Successful Orders:\n$successOrders");
      }
    } else {
      _sendBotResponse("User not logged in. Please log in to view your successful orders.");
    }
  } catch (e) {
    _sendBotResponse("❌ Failed to fetch successful orders. Error: $e");
  }
}

/// Helper method to format the products list
String _formatProducts(List<dynamic>? products) {
  if (products == null || products.isEmpty) {
    return "No products found";
  }

  return products.map((product) {
    final productData = product as Map<String, dynamic>;
    return "${productData['name']} (Qty: ${productData['quantity']})";
  }).join(", ");
}


  /// Fetch Failed Orders
  Future<void> _fetchFailedOrders() async {
  try {
    final user = FirebaseAuth.instance.currentUser; // Get the logged-in user

    if (user != null) {
      QuerySnapshot snapshot = await _firestore
          .collection('orders')
          .doc(user.uid)
          .collection('user_orders')
          .where('status', isEqualTo: 'failed')
          .get();

      if (snapshot.docs.isEmpty) {
        _sendBotResponse("No failed orders found.");
      } else {
        String failedOrders = snapshot.docs.map((doc) {
          final data = doc.data() as Map<String, dynamic>;
          return "Order ID: ${doc.id}, Total Price: ${data['totalPrice']}, Products: ${_formatProducts(data['products'])}";
        }).join("\n\n");

        _sendBotResponse("❌ Failed Orders:\n$failedOrders");
      }
    } else {
      _sendBotResponse("User not logged in. Please log in to view your failed orders.");
    }
  } catch (e) {
    _sendBotResponse("❌ Failed to fetch failed orders. Error: $e");
  }
}




  /// Fetch User Profile
  Future<void> _fetchUserProfile() async {
    try {
      DocumentSnapshot snapshot =
          await _firestore.collection('users').doc(uId).get();

      if (!snapshot.exists) {
        _sendBotResponse("User profile not found.");
      } else {
        final data = snapshot.data() as Map<String, dynamic>;
        String profileDetails =
            "Name: ${data['name']}\nEmail: ${data['email']}}";

        _sendBotResponse("👤 User Profile:\n$profileDetails");
      }
    } catch (e) {
      _sendBotResponse("❌ Failed to fetch user profile. Error: $e");
    }
  }

  void _sendUserMessage(String message) {
    setState(() {
      _messages.add({'user': message});
      _messageController.clear();
    });
  }

  void _sendBotResponse(String message) {
    setState(() {
      _messages.add({'bot': message});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
         leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Icon(Icons.arrow_back_ios_new_rounded,
              color: AppColors.whiteColor),
        ),
        backgroundColor: AppColors.textSubH3Color,
        centerTitle: true,
        title: CustomText(
          text: 'AI Bot 🤖',
          size: 24,
          fontWeight: FontWeight.w500,
          color: AppColors.whiteColor,
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final message = _messages[index];
                return ListTile(
                  title: CustomText(
                    text: message.keys.first == 'user' ? "You" : "Gemini",
                    fontWeight: FontWeight.bold,
                    size: 16,
                  ),
                  subtitle: CustomText(
                    text: message.values.first,
                    size: 14,
                  ),
                );
              },
            ),
          ),
          Divider(),
          if (_showTextField)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Expanded(
                    child: CustomTextField(
                      controller: _messageController,
                      hintText: 'Type a message...',
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.send),
                    onPressed: () =>
                        _handleUserMessage(_messageController.text.trim()),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
