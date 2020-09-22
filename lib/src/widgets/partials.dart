import 'package:flutter/material.dart';
import 'package:sweet_trust/src/models/food_model.dart';
// import '../../src/widgets/Product.dart';
import '../../src/widgets/colors.dart';
import '../../src/widgets/styles.dart';

Widget foodItem(
  Food food, {
  double imgWidth,
}) {
  return Container(
    width: 180,
    height: 180,
    // color: Colors.red,
    margin: EdgeInsets.only(left: 20),
    child: Stack(
      children: <Widget>[
        Container(
            width: 200,
            height: 200,
            child: RaisedButton(
                color: white,
                // elevation: (isProductPage) ? 20 : 12,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5)),
                // onPressed: onTapped,
                child: Hero(
                    transitionOnUserGestures: true,
                    tag: food.name,
                    child: Image.network(
                        "https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcSNqc23hR0uCkmd5pq3ogL1A5_aKKXi7AMc3w&usqp=CAU",
                        width: (imgWidth != null) ? imgWidth : 100)))),
        // Positioned(
        //   bottom: () ? 10 : 70,
        //   right: 0,
        //   child: FlatButton(
        //     padding: EdgeInsets.all(20),
        //     shape: CircleBorder(),
        //     // onPressed: onLike,
        //     child: Icon(
        //       (food.userLiked) ? Icons.favorite : Icons.favorite_border,
        //       color: (food.userLiked) ? primaryColor : darkText,
        //       size: 30,
        //     ),
        //   ),
        // ),
        // Positioned(
        //   bottom: 0,
        //   left: 0,
        //   child: (!isProductPage)
        //       ? Column(
        //           mainAxisAlignment: MainAxisAlignment.start,
        //           crossAxisAlignment: CrossAxisAlignment.start,
        //           children: <Widget>[
        //             Text(food.name, style: foodNameText),
        //             Text(food.price.toString(), style: priceText),
        //           ],
        //         )
        //       : Text(' '),
        // ),
        Positioned(
            top: 10,
            left: 10,
            child: (food.discount != null)
                ? Container(
                    padding:
                        EdgeInsets.only(top: 5, left: 10, right: 10, bottom: 5),
                    decoration: BoxDecoration(
                        color: Colors.grey[600],
                        borderRadius: BorderRadius.circular(50)),
                    child: Text('-' + food.discount.toString() + '%',
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.w700)),
                  )
                : SizedBox(width: 0))
      ],
    ),
  );
}