import 'dart:math';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:shoppo/providers/order.dart' as ord;

class OrderShownData extends StatefulWidget {
  final ord.OrderItems order;
  const OrderShownData({
    Key? key,
    required this.order,
  }) : super(key: key);

  @override
  _OrderShownDataState createState() => _OrderShownDataState();
}

class _OrderShownDataState extends State<OrderShownData> {
  bool isExpanded = false;
  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 200),
      height:
          isExpanded ? min(widget.order.products.length * 20.0 + 130, 200) : 95,
      child: Card(
          // margin: EdgeInsets.only(left:8,right:8),
          child: Column(
            children: [
              ListTile(
                title: Text("\$${widget.order.amount}"),
                subtitle: Text(
                  DateFormat("dd/mm/yyyy hh:mm").format(widget.order.dateTime),
                ),
                trailing:
                    Icon(isExpanded ? Icons.expand_less : Icons.expand_more),
                onTap: () {
                  setState(() {
                    isExpanded = !isExpanded;
                  });
                  print(isExpanded);
                },
              ),
              AnimatedContainer(
                duration: Duration(milliseconds: 200),
                height: isExpanded
                    ? min(widget.order.products.length * 20.0 + 40, 100)
                    : 0,
                child: ListView(
                  children: widget.order.products.map((prod) {
                    return ListTile(
                      title: Text(prod.title,
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 13)),
                      subtitle: Text(prod.id,
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 10)),
                      trailing: Text("${prod.quantity} x",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 13)),
                      leading: Container(
                        width: 80,
                        height: 50,
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Theme.of(context).primaryColor,
                            width: 3,
                          ),
                        ),
                        alignment: Alignment.center,
                        child: Text(prod.price.toString(),
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 13)),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ],
          )),
    );
  }
}
