import 'package:fryo/login_page.dart';

import 'auth.dart';
import 'src/shared/Product.dart';
Auth user;
String type;
String uid;
List<Product> foodcart = new List<Product>();
String barcode1;
String unique_store_id=userId;/// Anirudh make a unique store id during shopowner login and place its value here    I am assuming the userid is generated in the same way for both store and user

Future getuid() async{
uid = await user.currentUser();

}