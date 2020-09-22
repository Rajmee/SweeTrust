import 'package:sweet_trust/src/scoped-model/carrier_model.dart';
import 'package:sweet_trust/src/scoped-model/user_scoped_model.dart';
import '../scoped-model/food_model.dart';
import 'package:scoped_model/scoped_model.dart';
import '../../src/scoped-model/customer_model.dart';
import '../../src/scoped-model/carrier_model.dart';

class MainModel extends Model
    with FoodModel, UserMode, UserModel, CarUserModel {}
