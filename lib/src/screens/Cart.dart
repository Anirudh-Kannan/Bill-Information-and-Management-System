import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fryo/src/shared/buttons.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../shared/styles.dart';
import '../shared/colors.dart';
import '../shared/fryo_icons.dart';
import './ProductPage.dart';
import '../shared/Product.dart';
import '../shared/partials.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fryo/globals.dart';
import 'Dashboard.dart';


class Cart extends StatefulWidget {
  @override
  _CartState createState() => _CartState();
}
Future insertdata() async{
  final prefs = await SharedPreferences.getInstance();
  final key = 'bill_id';
  final value_from_shared = prefs.getInt(key) ?? 150;
  final value_of_bill = value_from_shared;
  prefs.setInt(key, value_of_bill+1);
  print('saved $value_of_bill');
  String bill_id=value_of_bill.toString();
  String store_id="202";
  String total_amount="1001";
  String date="2019-11-01";
  String no_items=(foodcart.length).toString();
  print("the uid is "+getuid().toString());
  String cust_id=uid.toString();   //change to barcode string for actual use
  //  Keep the same url
  var url2 = 'https://jainilandroid.000webhostapp.com/insert_bill.php';

print("this is a");
print(cust_id);
  http.Response response2 = await http.get(url2);
  // Insert val
  /*  http.post(url2,body: {
      "username":"thi s isthis ia",
      "password":"password"
    });*/
  http.post(url2,body: {
    "bill_id":  bill_id,
    "store_id":store_id,
    "total_amount":total_amount,
    "no_items":no_items,
    "date":date,
    "cust_id":cust_id
  });

  //  To Check for Errors

  print(response2.body.toString());
}
class _CartState extends State<Cart> {
  @override
  Widget build(BuildContext context) {
    return Container(
      
      color: Colors.transparent,
      child:Column(children: <Widget>[
        Expanded( child:ListView.builder(
          // Let the ListView know how many items it needs to build.
          itemCount: foodcart.length,
          
          // Provide a builder function. This is where the magic happens.
          // Convert each item into a widget based on the type of item it is.
          itemBuilder: (context, index) {
            return mycard(foodcart[index]);

          }

    ),),
        RaisedButton(
          onPressed:insertdata ,
          child: Text("checkout"),
        ),

    SizedBox(height: 40)
      ],)
      ,);
  }


  Widget mycard(Product food,
    {
      double imgWidth, onLike, onTapped, bool isProductPage = false})
    {
      return Container(
    height: 100,
    color: Colors.white,
    child: Stack(
      children: <Widget>[
        
          Positioned(
            right: 0,
            left: 200,
            top:15,
            child:
        Container(
            color: Colors.white,
            width : 4000,
            height: 60,
            child: Container(
               color: Colors.white,
                child: Image.asset(food.image,
                        )))),
                        
        Padding(
          padding: EdgeInsets.all(10),
          child:
        Container(
          color: Colors.white,
          child:  Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(food.name, style: foodNameText),
                    Text(food.price, style: priceText),
                    Text('quantity: '+food.quantity.toString(),style: foodNameText)
                  ],
                )
        ),
        ),
      ],
    ),
  );
}

}

