///////////////////////// Suppliers List  /////////////////////////////
class GetVendorsList {
  String sellerid;
  String address,city,post,country,zone;
  String first;
  String last;
  String color;
  String size;
  String customText;
  String textColor;
  String font;
  String designType;
  String printType;
  String shirtStyle;
  String textType;
  String cost;
  String piece;
  String totalCost;
  String rating;
  String review;
  String image;
  String imageName;
  String weight,shape,ssName,ssImage;
  GetVendorsList(
      {this.sellerid,
      this.address,this.city,this.post,this.country,this.zone,
      this.first,
      this.last,
      this.color,
      this.size,
      this.customText,
      this.textColor,
      this.font,
      this.designType,
      this.printType,
      this.shirtStyle,
      this.textType,
      this.cost,
      this.piece,
      this.totalCost,
      this.rating,
      this.review,
      this.image,
      this.imageName,
      this.weight,this.shape,this.ssName,this.ssImage});

  factory GetVendorsList.fromJson(Map<String, dynamic> json) {
    return GetVendorsList(
        sellerid: json['seller_id'],
        address: json['address'],
        city: json['city'],
        post: json['post'],
        country: json['country'],
        zone: json['zone'],
        first: json['firstname'],
        last: json['lastname'],
        color: json['shirtColor'],
        size: json['shirtSize'],
        customText: json['customText'],
        textColor: json['textColor'],
        font: json['font'],
        designType: json['designType'],
        printType: json['print_type'],
        shirtStyle: json['shirt_style'],
        textType: json['text_type'],
        totalCost: json['totalCost'].toString(),
        piece: json['piece'],
        cost: json['cost'].toString(),
        rating: json['rating'].toStringAsFixed(2),
        review: json['review'].toString(),
        image: json['image'],
        imageName: json['imageName'],
        weight: json['weight'],
        shape:json['shape'],
        ssName:json['ssName'],
        ssImage:json['ssImage']);
        
  }
}

///////////////////////////////////////
class Adress {
  String addressid;
  String address;
  String city;
  String postcode;
  String countryName;
  String countryCode;
  String zoneName;
  Adress(
      {this.addressid,
      this.address,
      this.city,
      this.postcode,
      this.countryCode,
      this.countryName,
      this.zoneName});

  factory Adress.fromJson(Map<String, dynamic> json) {
    return Adress(
        addressid: json['address_id'],
        address: json['address'],
        city: json['city'],
        postcode: json['postcode'],
        countryName: json['country_name'],
        zoneName: json['zone_name'],
        countryCode: json['country_code']);
  }
}

/////////////////////////Cart/////////////////////////////
class CartModel {
  String cartid;
  String sellerid;
  String address,city,post,country,zone;
  String quantity;
  String cost;
  String subTotal;
  String sub, totalShip, totalCost;
  String total;
  String size;
  String shirtStyle;
  String color;
  String designType;
  String printType;
  String customText;
  String font;
  String textColor;
  String textType;
  String ss;
  String date;

  CartModel(
      {this.cartid,
      this.sellerid,this.address,this.city,this.post,this.country,this.zone,
      this.quantity,
      this.cost,
      this.subTotal,
      this.sub,
      this.totalShip,
      this.totalCost,
      this.total,
      this.size,
      this.shirtStyle,
      this.color,
      this.designType,
      this.printType,
      this.customText,
      this.font,
      this.textColor,
      this.textType,
      this.ss,
      this.date});

  factory CartModel.fromJson(Map<String, dynamic> json) {
    return CartModel(
        cartid: json['cart_id'],
        sellerid: json['seller_id'],
        address: json['address'],
        city: json['city'],
        post: json['post'],
        country: json['country'],
        zone: json['zone'],
        quantity: json['quantity'].toString(),
        cost: json['cost'].toString(), //.toStringAsFixed(3),
        sub: json['sub_total'].toString(),
        subTotal: json['subTotal'].toString(),
        totalShip: json['totalShip'].toString(),
        totalCost: json['totalCost'].toString(),
        size: json['shirt_size'],
        shirtStyle: json['shirt_style'],
        color: json['shirt_color'],
        designType: json['design_type'],
        printType: json['print_type'],
        customText: json['custom_text'],
        font: json['text_font'],
        textColor: json['text_color'],
        textType: json['text_type'],
        ss: json['shirt_preview'],
        date: json['date']);
  }
}

/////////////////////////Cart/////////////////////////////
class PrintTypeModel {
  String shirtSize;
  String shirtPrice;

  PrintTypeModel({
    this.shirtSize,
    this.shirtPrice,
  });

  factory PrintTypeModel.fromJson(Map<String, dynamic> json) {
    return PrintTypeModel(
      shirtSize: json['shirtSize'],
      shirtPrice: json['shirtPrice'],
    );
  }
}

/////////////////////////RATING /////////////////////////////
class RatingModel {
  String customername;
  String rate;
  String comment;
  String date;

  RatingModel({
    this.customername,
    this.rate,
    this.comment,
    this.date,
  });

  factory RatingModel.fromJson(Map<String, dynamic> json) {
    return RatingModel(
      customername: json['customer_name'],
      rate: json['rate'],
      comment: json['comment'],
      date: json['date'],
    );
  }
}

/////////////////////////RATING /////////////////////////////
class HolidayModel {
  String holidaysid;
  String name;
  String from;
  String to;
  String date;

  HolidayModel({this.holidaysid,
    this.name,
    this.from,
    this.to,
    this.date,
  });

  factory HolidayModel.fromJson(Map<String, dynamic> json) {
    return HolidayModel(
      holidaysid: json['holidays_id'],
      name: json['name'],
      from: json['from_date'],
      to: json['to_date'],
      date: json['date'],
    );
  }
}
/////////////////////////RATING /////////////////////////////
class SellerPaymentsModule {
  String txn;
  String payment;
  String currency;
  String email;
  String status,total;

  SellerPaymentsModule({this.txn,
    this.payment,
    this.currency,
    this.email,
    this.status,this.total
  });

  factory SellerPaymentsModule.fromJson(Map<String, dynamic> json) {
    return SellerPaymentsModule(
      txn: json['txn'],
      payment: json['payment'],
      currency: json['currency'],
      email: json['email'],
      status: json['status'],
      total: json['total'].toString(),
    );
  }
}
///////////////////////////////////////
class OrderHist {
  String orderId, shipping, sub;
  String customerId,firstname, lastname, email;
  String track;
  String totalCost;
  String date;
  String address, country;
  String city, zone, postcode;
  String quantity;
  String shirtColor;
  String text;
  String image,shape,ss;
  String designType;
  String printType;
  String textType, shirtStyle;
  String size;
  String textColor;
  String font;
  String sellerf;
  String sellerl;
  String sellerEm;
  String sellerNumb;
  String cost;
  String rate;
  String comment;
  String sellerId;
  OrderHist(
      {this.orderId,
      this.shipping,
      this.sub,this.customerId,
      this.firstname,
      this.lastname,this.email,
      this.textType,
      this.shirtStyle,
      this.printType,
      this.track,
      this.totalCost,
      this.date,
      this.address,
      this.country,
      this.city,
      this.zone,
      this.postcode,
      this.quantity,
      this.shirtColor,
      this.text,
      this.image,
      this.designType,
      this.size,
      this.textColor,
      this.font,
      this.sellerf,
      this.sellerl,
      this.sellerEm,
      this.sellerNumb,
      this.cost,
      this.rate,
      this.comment,
      this.sellerId,this.shape,this.ss});

  factory OrderHist.fromJson(Map<String, dynamic> json) {
    return OrderHist(
        orderId: json['order_id'],
        track: json['status'],
        customerId :json['customerId'],
        firstname: json['customer_firstname'],
        lastname: json['customer_lastname'],
        email: json['customer_email'],
        address: json['address'],
        city: json['city'],
        postcode: json['postcode'],
        country: json['country_name'],
        zone: json['zone_name'],
        // shipping: json['shipping_method'],
        // payment: json['payment_method'],
        shape: json['shapes'],
        ss: json['shirt_preview'],
        totalCost: json['total_cost'],
        sub: json['sub_total'],
        shipping: json['shipping'],
        cost: json['cost'],
        date: json['date'],
        quantity: json['quantity'],
        shirtColor: json['shirtColor'],
        text: json['text'],
        image: json['image'],
        designType: json['design_type'],
        size: json['size'],
        textColor: json['text_color'],
        font: json['font'],
        printType: json['print_type'],
        textType: json['text_type'],
        shirtStyle: json['shirt_style'],
        sellerId: json['seller_id'],
        sellerf: json['seller_first'],
        sellerl: json['seller_last'],
        sellerEm: json['seller_email'],
        sellerNumb: json['seller_number'],
        rate: json['rate'],
        comment: json['comment']);
  }
}


/////////////////////////VIEW PRODUCT/////////////////////////////
class ViewNotification {
  String nid;
  String sender;
  String receiver,title;
  String detail;
  String date;

  ViewNotification({
    this.nid,
    this.sender,
    this.receiver,this.title,
    this.detail,
    this.date,
  });

  factory ViewNotification.fromJson(Map<String, dynamic> json) {
    return ViewNotification(
      nid: json['notification_id'],
      sender: json['sender'],
      receiver: json['receiver'],
      title: json['title'],
      detail: json['detail'],
      date: json['date'],
    );
  }
}

class OrderStatus {
  String statusid;
  String name;

  OrderStatus({
    this.statusid,
    this.name,
  });

  factory OrderStatus.fromJson(Map<String, dynamic> json) {
    return OrderStatus(
      statusid: json['status_id'],
      name: json['name'],
    );
  }
}
