import 'package:flutter/material.dart';
// import '../../src/widgets/Product.dart';
import '../../src/widgets/styles.dart';
import '../../src/widgets/colors.dart';
import '../../src/widgets/partials.dart';
import '../../src/widgets/buttons.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';
import 'package:sweet_trust/src/models/food_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:math';

class ProductPage extends StatefulWidget {
  // final String pageTitle;
  // final Product productData;
  // final Food foodData;
  final Food food;

  final FirebaseUser user;

  ProductPage({
    this.food,
    this.user,
  });

  // ProductPage({Key key, this.pageTitle, this.productData}) : super(key: key);

  @override
  _ProductPageState createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  final firestoreInstance = Firestore.instance;
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
  // static int orderCount = 0;

  Map data;
  double _rating = 4;
  int _quantity = 1;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        backgroundColor: bgColor,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: bgColor,
          centerTitle: true,
          leading: BackButton(
            color: darkText,
          ),
          title: Text(widget.food.name, style: h4),
        ),
        body: ListView(
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(top: 20),
              child: Center(
                child: Stack(
                  children: <Widget>[
                    Align(
                      alignment: Alignment.center,
                      child: Container(
                        margin: EdgeInsets.only(top: 100, bottom: 100),
                        padding: EdgeInsets.only(top: 100, bottom: 50),
                        width: MediaQuery.of(context).size.width * 0.85,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            // Text(widget.foodData.name, style: h5),
                            // Text(widget.food.district, style: h3),
                            // Text("(" + widget.food.area + ")", style: h6),
                            SizedBox(height: 20.0),
                            Text("\u{09F3} ${widget.food.price}", style: h3),
                            Container(
                              margin: EdgeInsets.only(top: 5, bottom: 20),
                              child: SmoothStarRating(
                                allowHalfRating: false,
                                // onRatingChanged: (v) {
                                //   setState(() {
                                //     _rating = v;
                                //   });
                                // },
                                starCount: 5,
                                rating: _rating,
                                size: 27.0,
                                color: Colors.orange,
                                borderColor: Colors.orange,
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(top: 10, bottom: 25),
                              child: Column(
                                children: <Widget>[
                                  Container(
                                    child: Text('Quantity', style: h6),
                                    margin: EdgeInsets.only(bottom: 15),
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: <Widget>[
                                      Container(
                                        width: 55,
                                        height: 55,
                                        child: OutlineButton(
                                          onPressed: () {
                                            setState(() {
                                              _quantity += 1;
                                            });
                                          },
                                          child: Icon(Icons.add),
                                        ),
                                      ),
                                      Container(
                                        margin: EdgeInsets.only(
                                            left: 20, right: 20),
                                        child: Text(_quantity.toString(),
                                            style: h3),
                                      ),
                                      Container(
                                        width: 55,
                                        height: 55,
                                        child: OutlineButton(
                                          onPressed: () {
                                            setState(() {
                                              if (_quantity == 1) return;
                                              _quantity -= 1;
                                            });
                                          },
                                          child: Icon(Icons.remove),
                                        ),
                                      )
                                    ],
                                  )
                                ],
                              ),
                            ),
                            Container(
                              width: 180,
                              child: froyoOutlineBtn('Buy Now', () {}),
                            ),
                            Container(
                              width: 180,
                              child: froyoFlatBtn('Add to Cart', () {
                                addOrder();
                                _notifyAlert();
                                Navigator.of(context).pop();
                              }),
                            )
                          ],
                        ),
                        decoration: BoxDecoration(
                            color: white,
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: [
                              BoxShadow(
                                  blurRadius: 15,
                                  spreadRadius: 5,
                                  color: Color.fromRGBO(0, 0, 0, .05))
                            ]),
                      ),
                    ),
                    Align(
                      alignment: Alignment.center,
                      child: SizedBox(
                        width: 200,
                        height: 180,
                        child: foodItem(
                          widget.food,
                          imgWidth: 300,
                        ),
                      ),
                    )
                  ],
                ),
              ),
            )
          ],
        ));
  }

  addOrder() async {
    var firebaseUser = await FirebaseAuth.instance.currentUser();

    Random random = new Random();
    int orderCount = random.nextInt(100000) + 1000;

    firestoreInstance
        .collection('customerData')
        .document(firebaseUser.phoneNumber)
        .collection('cartItems')
        .document(orderCount.toString())
        .setData({
      "cartNumber": "$orderCount",
      "sweetName": "${widget.food.name}",
      "price": "${widget.food.price}",
      "quantity": "$_quantity",
      "imgUrl": "${widget.food.imagePath}",
      "lat": "${widget.food.lat}",
      "lng": "${widget.food.lng}",
      "area": "${widget.food.area}",
    });
  }

  _notifyAlert() async {
    // Navigator.of(context).pop();
    SnackBar snackBar = SnackBar(content: Text("Item added to cart !!!"));
    _scaffoldKey.currentState.showSnackBar(snackBar);
  }
}
