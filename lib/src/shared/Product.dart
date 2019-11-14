class Product
{
  String name,
        price,
        image;
  double discount;
  int quantity;

  Product({
    this.name,
    this.price,
    this.discount,
    this.image,
    this.quantity,
  });



}


class bill
{
  String bill_id,store_id,amount, items, date, cust_id;

  bill({
    this.bill_id,
    this.store_id,
    this.amount,
    this.items,
    this.date,
    this.cust_id,
  });

}