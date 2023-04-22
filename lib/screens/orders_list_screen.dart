import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_ui_firestore/firebase_ui_firestore.dart';
import 'package:flutterfire_cookbooks/components/order_tile.dart';
import 'package:flutterfire_cookbooks/model/order_model.dart';
import '../firebase_options.dart';
import 'package:flutter/material.dart';

// Leave main method here so we can run in isolation
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const OrdersListScreen());
}

class OrdersListScreen extends StatelessWidget {
  const OrdersListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final collectionRef = FirebaseFirestore.instance.collection('orders');

    var collection = collectionRef.withConverter<OrderModel>(
      fromFirestore: (snapshot, _) => OrderModel.fromJson(snapshot.data()!),
      toFirestore: (order, _) => order.toJson(),
    );

    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pushReplacementNamed(context, '/menu');
            },
          ),
          title: const Text('Firestore List Screen'),
        ),
        body: FirestoreListView<OrderModel>(
          query: collection,
          padding: const EdgeInsets.all(8.0),
          itemBuilder: (context, snapshot) {
            final order = snapshot.data();
            return Column(
              children: [
                OrderTile(order: order),
                const Divider(),
              ],
            );
          },
        ),
      ),
    );
  }
}
