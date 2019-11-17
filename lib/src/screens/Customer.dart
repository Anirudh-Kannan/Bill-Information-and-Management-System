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
process();
    getData();

    //_loadCurrentUser();
    final _tabs = [
      makeQR(),
      getbills()
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


  var data;
  void getData() async{

    var url = 'https://jainilandroid.000webhostapp.com/bills_table_get.php';

    http.Response response = await http.get(url);


    data = jsonDecode(response.body);


  }

  List<bill> process()
  {
    List<bill> blist = new List<bill>();
    print("the value is");
    print(data);
    try{
      for(int i =0; i<data.length; i++)
      {
        bill b = new bill();
        if(uid == data[i]['cust_id']){
          b.bill_id = data[i]['bill_id'];
          b.date = data[i]['date'];
          b.amount = data[i]['total_amount'];
          b.items = data[i]['no_items'];
          b.store_id = data[i]['store_id'];
          b.cust_id = data[i]['cust_id'];
          print(b.cust_id);
          print(b.amount);
          blist.add(b);
          print(i);
          print(blist.length.toString());

        }}}
    catch(e)
    {}
return blist;
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
    List<bill> blist = new List<bill>();
    List<bill> flist = new List<bill>();
    blist=process();
    if(blist!=null) {
      for (int i = 0; i < blist.length; i++) {
        flist.add(blist[i]);
        print(blist[0].amount.toString());
      }
    }
    print("the list is");
    print(flist);
    if(flist == null){
      return new Container(width: 10.0,height:  10.0);
    }else {
      return Container(child: ListView.builder(
        // Let the ListView know how many items it needs to build.
          itemCount: flist.length,

          // Provide a builder function. This is where the magic happens.
          // Convert each item into a widget based on the type of item it is.
          itemBuilder: (context, index) {
            print(index.toString());
            return getCard(
                flist[index].cust_id, flist[index].date, flist[index].items,
                flist[index].amount);
          }

      ),);
    }
    }


}