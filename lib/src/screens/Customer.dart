import 'package:flutter/material.dart';
import 'package:fryo/auth.dart';
import 'package:fryo/globals.dart' ;
import 'package:fryo/src/shared/buttons.dart';
import '../shared/styles.dart';
import '../shared/colors.dart';
import '../shared/fryo_icons.dart';
import './ProductPage.dart';
import '../shared/Product.dart';
import '../shared/partials.dart';
import 'package:fryo/auth.dart';
//import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fryo/globals.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';




class Customer extends StatefulWidget {

  final String pageTitle;
  final BaseAuth auth;
  final VoidCallback onSignOut;

  Customer({Key key, this.pageTitle, this.auth, this.onSignOut}) : super(key: key);


  @override
  _CustomerState createState() => _CustomerState();
}

class _CustomerState extends State<Customer> {

  FirebaseUser currentUser; // not final
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
    getuid();
    getuid();

    getData();

    process();
    //_loadCurrentUser();
    final _tabs = [
      makeQR(),
      getbills(),
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
                icon: Icon(Fryo.camera),
                title: Text(
                  'QR',
                  style: tabLinkStyle,
                )),
            BottomNavigationBarItem(
                icon: Icon(Fryo.file_empty),
                title: Text(
                  'My Bills',
                  style: tabLinkStyle,

                )),

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


  Widget Tab2(BaseAuth auth)
  {
    return Container(
      child:FlatButton(

          onPressed: signOut,
          child: Center(child: Text('Logout', style: new TextStyle(fontSize: 15.0, color: Colors.white)))
      ),
    );
  }


  Widget makeQR() {
    getuid();
    for(int i = 0; i<1000; i++);
    getuid();
    String s = uid;
    print(s);
    return Center(child: QrImage(
      data: s,
      gapless: true,
      size: 250,
      errorCorrectionLevel: QrErrorCorrectLevel.H,
    ));

  }

  Set<bill> blist = new Set<bill>();
  List<bill> flist = new List<bill>();
  bill b = new bill();

  var data;
  void getData() async{

    var url = 'https://jainilandroid.000webhostapp.com/bills_table_get.php';

    http.Response response = await http.get(url);


    data = jsonDecode(response.body);


  }

  void process()
  {
    try{
      for(int i =0; i<data.length; i++)
      {
        if('1001' == data[i]['cust_id']){
          b.bill_id = data[i]['bill_id'];
          b.date = data[i]['date'];
          b.amount = data[i]['total_amount'];
          b.items = data[i]['no_items'];
          b.store_id = data[i]['store_id'];
          b.cust_id = data[i]['cust_id'];

          blist.add(b);
          print(b.cust_id);
        }}}
    catch(e)
    {}


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
              Text(items, style:h6),
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
    for(int i =0; i<blist.length;i++)
    {
      flist.add(blist.first);
      blist.remove(blist.first);
    }

    print(flist);
    return Container(child:ListView.builder(
      // Let the ListView know how many items it needs to build.
        itemCount: flist.length,

        // Provide a builder function. This is where the magic happens.
        // Convert each item into a widget based on the type of item it is.
        itemBuilder: (context, index) {
          return getCard(flist[index].cust_id,flist[index].date,flist[index].items,flist[index].amount);

        }

    ),);


  }

}