// import 'dart:html';
import 'package:flutter/material.dart';
import 'package:sweet_trust/src/models/sweet_model.dart';
import 'package:sweet_trust/src/pages/order_item_page.dart';
import '../../src/widgets/order_items_card.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class OrderPage extends StatefulWidget {
  // final String pageTitle;
  // final Product productData;

  // ProductPage({Key key, this.pageTitle, this.productData}) : super(key: key);

  @override
  _OrderPageState createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderPage> {
  String phone;
  String swtName;
  String quantity;
  String price;
  String orderNum;

  String chkPhone;
  String chkSwtname;
  String chkQuantity;
  String chkPrice;
  String chkOrderNum;

  // final firestoreInstance = Firestore.instance;

  @override
  void initState() {
    super.initState();
    getPhone();
  }

  @override
  Widget build(BuildContext context) {
    DocumentSnapshot documentSnapshot;
    return Scaffold(
      body: StreamBuilder<QuerySnapshot>(
          stream: Firestore.instance
              .collection("customerdata")
              .document(phone)
              .collection('orderCart')
              .snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            return ListView.builder(
                itemCount: snapshot.data.documents.length,
                itemBuilder: (context, index) {
                  documentSnapshot = snapshot.data.documents[index];
                  swtName = documentSnapshot['sweetName'];
                  quantity = documentSnapshot['quantity'];
                  price = documentSnapshot['price'];
                  orderNum = documentSnapshot['orderNumber'];

                  return GestureDetector(
                    onTap: () => {
                      navigateToDetail(snapshot.data.documents[index]),
                    },
                    child: OrderItemsCard(
                        "$swtName", "$quantity", "$price", "$orderNum"),
                  );
                });
          }),
    );
  }

  navigateToDetail(DocumentSnapshot post) {
    Navigator.of(context).push(MaterialPageRoute(
        builder: (BuildContext context) => OrderItemPage(
              post: post,
            )));
  }

  getPhone() async {
    var firebaseUser = await FirebaseAuth.instance.currentUser();

    String getPhone = firebaseUser.phoneNumber;

    setState(() {
      phone = getPhone;
    });
  }
}
