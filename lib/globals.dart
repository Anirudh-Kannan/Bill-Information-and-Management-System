import 'auth.dart';
import 'src/shared/Product.dart';
Auth user;
String type;
String uid;
List<Product> foodcart = new List<Product>();
String barcode1;

Future getuid() async{
uid = await user.currentUser();

}