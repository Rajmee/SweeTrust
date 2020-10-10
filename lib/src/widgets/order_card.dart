import 'package:flutter/material.dart';

class OrderCard extends StatefulWidget {
  final String swtName;
  final String quantity;
  final String price;
  final String orderNum;
  final String imgurl;

  const OrderCard(
      this.swtName, this.quantity, this.price, this.orderNum, this.imgurl);

  @override
  _OrderCardState createState() => _OrderCardState(
      swtName: this.swtName,
      quantity: this.quantity,
      price: this.price,
      orderNum: this.orderNum,
      imgurl: imgurl);
}

class _OrderCardState extends State<OrderCard> {
  int _quantity = 1;

  String swtName;
  String quantity;
  String price;
  String orderNum;
  String imgurl;

  _OrderCardState(
      {this.swtName, this.quantity, this.price, this.orderNum, this.imgurl});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              width: 45.0,
              height: 73.0,
              decoration: BoxDecoration(
                border: Border.all(color: Color(0xFFD3D3D3), width: 2.0),
                borderRadius: BorderRadius.circular(10.0),
              ),

              // child: Padding(
              //   padding: EdgeInsets.symmetric(
              //     horizontal: 10.0,
              //   ),
              child: Column(
                children: <Widget>[
                  InkWell(
                      onTap: () {
                        setState(() {
                          _quantity += 1;
                        });
                      },
                      child: Icon(Icons.keyboard_arrow_up,
                          color: Color(0xFFD3D3D3))),
                  Text(
                    quantity.toString(),
                    style: TextStyle(fontSize: 18.0, color: Colors.grey),
                  ),
                  InkWell(
                      onTap: () {
                        setState(() {
                          if (_quantity == 1) return;
                          _quantity -= 1;
                        });
                      },
                      child: Icon(Icons.keyboard_arrow_down,
                          color: Color(0xFFD3D3D3))),
                ],
              ),
              // ),
            ),
            SizedBox(
              width: 20.0,
            ),
            Container(
              height: 70.0,
              width: 70.0,
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: NetworkImage("$imgurl"), fit: BoxFit.cover),
                  borderRadius: BorderRadius.circular(35.0),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.black,
                        blurRadius: 5.0,
                        offset: Offset(0.0, 2.0))
                  ]),
            ),
            SizedBox(
              width: 20.0,
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  "$swtName",
                  style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 5.0),
                Text(
                  "\u{09F3} $price",
                  style: TextStyle(
                      fontSize: 16.0,
                      color: Colors.orangeAccent,
                      fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 5.0),
                Container(
                  height: 25.0,
                  width: 120.0,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          SizedBox(
                            width: 5.0,
                          ),
                          SizedBox(
                            width: 10.0,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Spacer(),
            // GestureDetector(
            //   onTap: () {},
            //   child: Icon(
            //     Icons.cancel,
            //     color: Colors.grey,
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}
