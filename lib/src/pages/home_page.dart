import 'package:flutter/material.dart';
import 'package:sweet_trust/src/pages/ProductPage.dart';
import 'package:sweet_trust/src/pages/food_details_page.dart';
import 'package:sweet_trust/src/scoped-model/main_model.dart';
import 'package:sweet_trust/src/widgets/bought_foods.dart';
import 'package:scoped_model/scoped_model.dart';
import '../widgets/home_top_info.dart';
import '../widgets/food_category.dart';
import '../widgets/search_file.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:sweet_trust/src/widgets/search_input.dart';

// Model
import '../models/food_model.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key key, this.user}) : super(key: key);

  // final FoodModel foodModel;

  // HomePage(this.foodModel);
  @override
  _HomePageState createState() => _HomePageState();

  final FirebaseUser user;
}

class _HomePageState extends State<HomePage> {
  // List<Food> _foods = foods;

  @override
  void initState() {
    // widget.foodModel.fetchFoods();
    super.initState();
  }

  List<Food> _food = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: ListView(
        padding: EdgeInsets.only(left: 20.0, right: 20.0),
        children: <Widget>[
          HomeTopInfo(),
          FoodCategory(),
          SizedBox(
            height: 20.0,
          ),
          SearchField(),
          // SearchInput(),
          SizedBox(
            height: 20.0,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                "Frequently Bought Foods",
                style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              GestureDetector(
                onTap: () {
                  print("I' pressed");
                },
                child: Text(
                  "View all",
                  style: TextStyle(
                    color: Colors.orangeAccent,
                    fontWeight: FontWeight.bold,
                    fontSize: 18.0,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 20.0),
          ScopedModelDescendant<MainModel>(
            builder: (BuildContext context, Widget child, MainModel model) {
              return Column(
                children: model.foods.map(_buildFoodItems).toList(),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildFoodItems(Food food) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
          builder: (BuildContext context) => new ProductPage(
            food: food,
          ),
        ));
      },
      child: Container(
        margin: EdgeInsets.only(bottom: 20.0),
        child: BoughtFood(
          id: food.id,
          name: food.name,
          imagePath: "assets/images/lunch.jpeg",
          category: food.category,
          discount: food.discount,
          price: food.price,
          ratings: food.ratings,
        ),
      ),
    );
  }
}
