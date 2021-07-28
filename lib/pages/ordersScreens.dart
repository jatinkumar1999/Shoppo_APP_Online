import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shoppo/providers/order.dart';
import 'package:shoppo/widgets/app_Drawer.dart';
import 'package:shoppo/widgets/orderShownData.dart';

class OrdersScreens extends StatefulWidget {
  static const String routeName = "/orders";
  const OrdersScreens({Key? key}) : super(key: key);

  @override
  _OrdersScreensState createState() => _OrdersScreensState();
}

class _OrdersScreensState extends State<OrdersScreens> {
  bool _isLoading = false;
  @override
  void initState() {
    Future.delayed(Duration.zero).then((_) async{
      setState(() {
        _isLoading = true;
      });

     await Provider.of<Order>(context, listen: false).ftechAnssetOrders();
      setState(() {
        _isLoading = false;
      });
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final orderData = Provider.of<Order>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("Your Orders"),
      ),
      drawer: AppDrawer(),
      body: (orderData.order.isEmpty || _isLoading)
          ? Center(
              child: _isLoading
                  ? CircularProgressIndicator()
                  : Text("No Orders yet !!"))
          : ListView.builder(
              itemCount: orderData.order.length,
              itemBuilder: (context, index) {
                return OrderShownData(order: orderData.order[index]);
              }),
    );
  }
}
