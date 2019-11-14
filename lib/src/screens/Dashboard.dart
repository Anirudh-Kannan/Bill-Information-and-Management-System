import 'package:barcode_scan/barcode_scan.dart';
import 'package:flutter/material.dart';
import 'package:fryo/globals.dart' as prefix0;
import 'Cart.dart';
import '../shared/styles.dart';
import '../shared/colors.dart';
import '../shared/fryo_icons.dart';
import 'package:fryo/globals.dart';
import './ProductPage.dart';
import '../shared/Product.dart';
import 'package:http/http.dart' as http;
import 'package:barcode_scan/barcode_scan.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:convert';
import '../shared/partials.dart';
import 'package:fryo/auth.dart';
//import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fryo/globals.dart';
//final DBref = FirebaseDatabase.instance.reference();
List<Product> foods = new List<Product>();
class Dashboard extends StatefulWidget {
  final String pageTitle;
  final BaseAuth auth;
  final VoidCallback onSignOut;
  Cart c = new Cart();


  Dashboard({Key key, this.pageTitle, this.auth, this.onSignOut}) : super(key: key);

  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {

  FirebaseUser currentUser; // not final
  String barcode="";
  int _selectedIndex = 0;

    void signOut() async {
      try {
        await widget.auth.signOut();
        widget.onSignOut();
      } catch (e) {
        print(e);
      }
    }

  @override
  Widget build(BuildContext context) {
    getData();
    process();
    //_loadCurrentUser();
    final _tabs = [
      storeTab(context),
      scan_widget(),
      widget.c,
      Text('comming soon'),
      Text('Comming Soon'),
      Text('Comming Soon'),
    ];

    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          centerTitle: true,
          elevation: 0,
          
          backgroundColor: primaryColor,
          title:
              Text('e Bill', style: logoWhiteStyle, textAlign: TextAlign.center),
          actions: <Widget>[
            
            Tab2(widget.auth),
          ],
        ),
        body: _tabs[_selectedIndex],
        bottomNavigationBar: BottomNavigationBar(
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(
                icon: Icon(Fryo.shop),
                title: Text(
                  'Store',
                  style: tabLinkStyle,
                )),
            BottomNavigationBarItem(
                icon: Icon(Fryo.file_empty),
                title: Text(
                  'My QR-SCAN',
                  style: tabLinkStyle,

                )),
            BottomNavigationBarItem(
                icon: Icon(Fryo.cart),
                title: Text(
                  'My Cart',
                  style: tabLinkStyle,
                )),
            BottomNavigationBarItem(
                icon: Icon(Fryo.heart_1),
                title: Text(
                  'Favourites',
                  style: tabLinkStyle,
                )),
            BottomNavigationBarItem(
                icon: Icon(Fryo.user_1),
                title: Text(
                  'bills',
                  style: tabLinkStyle,
                )),
            BottomNavigationBarItem(
                icon: Icon(Fryo.cog_1),
                title: Text(
                  'Settings',
                  style: tabLinkStyle,
                ))
          ],
          currentIndex: _selectedIndex,
          type: BottomNavigationBarType.fixed,
          fixedColor: Colors.green[600],
          onTap: _onItemTapped,
        ));
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
  void getData() async{

    var url = 'https://jainilandroid.000webhostapp.com/bills_table_get.php';

    http.Response response = await http.get(url);


    data = jsonDecode(response.body);


  }
  Set<bill> blist = new Set<bill>();
  List<bill> flist = new List<bill>();
  bill b = new bill();
var data;
  Future scan() async {
    try {
      String barcode = await BarcodeScanner.scan();
      setState(() => this.barcode = barcode);
    } on PlatformException catch (e) {
      if (e.code == BarcodeScanner.CameraAccessDenied) {
        setState(() {
          this.barcode = 'The user did not grant the camera permission!';
        });
      } else {
        setState(() => this.barcode = 'Unknown error: $e');
      }
    } on FormatException{
      setState(() => this.barcode = 'null (User returned using the "back"-button before scanning anything. Result)');
    } catch (e) {
      setState(() => this.barcode = 'Unknown error: $e');
    }
    prefix0.barcode1=barcode;
  }
  void process()
  {
    try{
      for(int i =0; i<data.length; i++)
      {
        if('101' == data[i]['store_id']){
          b.bill_id = data[i]['bill_id'];
          b.date = data[i]['date'];
          b.amount = data[i]['total_amount'];
          b.items = data[i]['no_items'];
          b.store_id = data[i]['store_id'];
          b.cust_id = data[i]['cust_id'];

          blist.add(b);
          print(b.cust_id);
          print(b.bill_id);
          print(b.amount);
          print("this is a");
          print(blist.length);

        }}}
    catch(e)
    {}


  }
  Widget scan_widget() {

    return Container(
      width: 400,
      height: 180,
      color: Colors.grey[200],
      child: Row(
        children: <Widget>[
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[

              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: RaisedButton(
                    color: Colors.blue,
                    textColor: Colors.white,
                    splashColor: Colors.blueGrey,
                    onPressed: scan,
                    child: const Text('START CAMERA SCAN')
                ),
              )
              ,
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: Text(barcode, textAlign: TextAlign.center,),
              )
              ,

            ],
          )
          ,


        ],
      ),
    );

  }
  Widget getCard(String bill_id,String date, String items, String amount) {

    return Container(
      width: 400,
      height: 180,
      color: Colors.grey[200],
      child: Row(
        children: <Widget>[
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[

              Text(bill_id, style: h4,),
              Text(date, style: foodNameText),
              Text(items, style:h6),                                //I changed something here
              Text(amount, style: priceText),
            ],
          )
          ,


        ],
      ),
    );

  }

  Widget getbills()
  {
    print(blist.length);
    for(int i =0; i<blist.length;i++)
    {
      flist.add(blist.first);
      blist.remove(blist.first);
    }
    print(flist.first);
    return Container(child:ListView.builder(
      // Let the ListView know how many items it needs to build.
        itemCount: flist.length,
        // Provide a builder function. This is where the magic happens.
        // Convert each item into a widget based on the type of item it is.
        itemBuilder: (context, index) {
          print(index);
          return getCard(flist[index].bill_id,flist[index].date,flist[index].items,flist[index].amount);  // I changed something here

        }

    ),);


  }
  Widget Tab2(BaseAuth auth)
{
  return Container(
    child:FlatButton(
              
              onPressed: signOut,
              child: Center(child: Text('Logout', style: new TextStyle(fontSize: 15.0, color: Colors.white)))
          ),
  );
}
/*

Widget DatabaseFun(BuildContext context) {
    return Container(
      child: Row( children: <Widget>[
        RaisedButton(
        child: Text('Write Data'),
        onPressed: ()
        {
           _loadCurrentUser();
          writeData();
          },
       ),
       RaisedButton(
          child: Text('Read Data'),
          onPressed: (){
            readData();
          },
       ),
       
       
       ],)
      
     
      
    );
  }

  void _loadCurrentUser() {
    FirebaseAuth.instance.currentUser().then((FirebaseUser user) {
      setState(() { // call setState to rebuild the view
        this.currentUser = user;
      });
    });
  }

   String _email() {
    if (currentUser != null) {
      return currentUser.email;
    } else {
      return "no current user";
    }
  }


static List encondeToJson(List<Product>list){
    List jsonList = List();
    list.map((item)=>
      jsonList.add(item.toJson())
    ).toList();
    return jsonList;
}

void writeData()
{
List s ;
var sum =0.0;
for(var i =0; i< foodcart.length; i++)
{print(foodcart[i].name);
sum+=double.parse(foodcart[i].price.replaceAll('\$', ''));
}

var json = jsonEncode(foodcart.map((e) => e.toJson()).toList());
json = json.replaceAll('\"', "'");
DBref.child(currentUser.uid).set({
  'email':_email(),
  'products':[json],
  'total':sum
});

}

void readData()
{
DBref.once().then((DataSnapshot dataSnapShot){
print(dataSnapShot.value);

});

}
*/
}

Widget storeTab(BuildContext context) {

  foods = [
    Product(
        name: "Hamburger",
        image: "images/3.png",
        price: "\$25.00",
        discount: 10),
    Product(
        name: "Pasta",
        image: "images/5.png",
        price: "\$150.00",
        discount: 7.8),
    Product(
      name: "Cutlet",
      image: 'images/2.png',
      price: '\$10.99',
    ),
    Product(
        name: "Strawberry",
        image: "images/1.png",
        price: '\$50.00',
        discount: 14)
  ];

  List<Product> drinks = [
    Product(
        name: "Coca-Cola",
        image: "images/6.png",
        price: "\$45.12",
        discount: 2),
    Product(
        name: "Lemonade",
        image: "images/7.png",
        price: "\$28.00",
        discount: 5.2),
    Product(
        name: "Vodka",
        image: "images/8.png",
        price: "\$78.99",
    ),
    Product(
        name: "Tequila",
        image: "images/9.png",
        price: "\$168.99",
        discount: 3.4)
  ];

  return ListView(children: <Widget>[
    
    deals('Food Menu', onViewMore: () {}, items: <Widget>[
      foodItem(foods[0], onTapped: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) {
              return new ProductPage(
                productData: foods[0],
              );
            },
          ),
        );
      }, onLike: () {}),
      foodItem(foods[1], onTapped: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) {
              return new ProductPage(
                productData: foods[1],
              );
            },
          ),
        );
      }, imgWidth: 250, onLike: () {
       
      }),
      foodItem(foods[2], onTapped: () {
         Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) {
              return new ProductPage(
                productData: foods[2],
              );
            },
          ),
        );
      }, imgWidth: 200, onLike: () {
      }),
      foodItem(foods[3], onTapped: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) {
              return new ProductPage(
                productData: foods[3],
              );
            },
          ),
        );
      }, onLike: () {
      }),
    ]),
    deals('Drinks Menu', onViewMore: () {}, items: <Widget>[
      foodItem(drinks[0], onTapped: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) {
              return new ProductPage(
                productData: drinks[0],
              );
            },
          ),
        );
      }, onLike: () {}, imgWidth: 60),
      foodItem(drinks[1], onTapped: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) {
              return new ProductPage(
                productData: drinks[1],
              );
            },
          ),
        );
      }, onLike: () {}, imgWidth: 75),
      foodItem(drinks[2], onTapped: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) {
              return new ProductPage(
                productData: drinks[2],
              );
            },
          ),
        );
      }, imgWidth: 110, onLike: () {}),
      foodItem(drinks[3], onTapped: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) {
              return new ProductPage(
                productData: drinks[3],
              );
            },
          ),
        );
      }, onLike: () {}),
    ])
  ]);
}

Widget sectionHeader(String headerTitle, {onViewMore}) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: <Widget>[
      Container(
        margin: EdgeInsets.only(left: 15, top: 10),
        child: Text(headerTitle, style: h4),
      ),
     
    ],
  );
}

// wrap the horizontal listview inside a sizedBox..
Widget headerTopCategories() {
  return Column(
    mainAxisAlignment: MainAxisAlignment.center,
    crossAxisAlignment: CrossAxisAlignment.center,
    children: <Widget>[
      sectionHeader('All Categories', onViewMore: () {}),
      SizedBox(
        height: 130,
        child: ListView(
          scrollDirection: Axis.horizontal,
          shrinkWrap: true,
          children: <Widget>[
            headerCategoryItem('Frieds', Fryo.dinner, onPressed: () {}),
            headerCategoryItem('Fast Food', Fryo.food, onPressed: () {}),
            headerCategoryItem('Creamery', Fryo.poop, onPressed: () {}),
            headerCategoryItem('Hot Drinks', Fryo.coffee_cup, onPressed: () {}),
            headerCategoryItem('Vegetables', Fryo.leaf, onPressed: () {}),
          ],
        ),
      )
    ],
  );
}

Widget headerCategoryItem(String name, IconData icon, {onPressed}) {
  return Container(
    margin: EdgeInsets.only(left: 15),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Container(
            margin: EdgeInsets.only(bottom: 10),
            width: 86,
            height: 86,
            child: FloatingActionButton(
              shape: CircleBorder(),
              heroTag: name,
              onPressed: onPressed,
              backgroundColor: white,
              child: Icon(icon, size: 35, color: Colors.black87),
            )),
        Text(name + ' ›', style: categoryText)
      ],
    ),
  );
}

Widget deals(String dealTitle, {onViewMore, List<Widget> items}) {
  return Container(
    margin: EdgeInsets.only(top: 5),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        sectionHeader(dealTitle),
        SizedBox(
          height: 250,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: (items != null)
                ? items
                : <Widget>[
                    Container(
                      margin: EdgeInsets.only(left: 15),
                      child: Text('No items available at this moment.',
                          style: taglineText),
                    )
                  ],
          ),
        )
      ],
    ),
  );



}