import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shoppo/providers/products.dart';
import 'package:shoppo/providers/products_Provider.dart';

class EditProducts extends StatefulWidget {
  static const routeName = "/edit";
  EditProducts({Key? key}) : super(key: key);

  @override
  _EditProductsState createState() => _EditProductsState();
}

class _EditProductsState extends State<EditProducts> {
  final _priceFocusNode = FocusNode();
  final _discriptionFocusNode = FocusNode();
  final _imageUrlFocusNode = FocusNode();
  final _imageUrlTextEditingController = TextEditingController();
  final _form = GlobalKey<FormState>();
  var _isInIt = true;
  bool _isloading = false;

  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  final priceController = TextEditingController();
  String title = "";
  var pd = Product(id: "", title: "", description: "", price: 0, imageUrl: "");

  @override
  void initState() {
    _imageUrlFocusNode.addListener(_updateImage);

   
    super.initState();
  }

  // @override
  // void didChangeDependencies() {
  //   getData();

  //   super.didChangeDependencies();
  // }

  // getData() {
  //   if (_isInIt) {
  //     final id = ModalRoute.of(context)!.settings.arguments as String;
  //     print("Id for Update : " + id);

  //     // ignore: unnecessary_null_comparison
  //     assert(id != null);
  //     // ignore: unnecessary_null_comparison
  //     if (id.isNotEmpty) {
  //       pd = Provider.of<Products>(context, listen: false).findById(id);
  //       print("updated id" + pd.id);
  //       titleController.text = pd.title;
  //       descriptionController.text = pd.description;
  //       priceController.text = pd.price.toString();
  //       _imageUrlTextEditingController.text = pd.imageUrl;
  //     }
  //   }

  //   _isInIt = false;
  // }

  void _updateImage() {
    if (!_imageUrlFocusNode.hasFocus) {
      setState(() {});
    }
  }

  @override
  void dispose() {
    _imageUrlFocusNode.removeListener(_updateImage);

    _priceFocusNode.dispose();
    _discriptionFocusNode.dispose();
    _imageUrlTextEditingController.dispose();
    titleController.dispose();
    descriptionController.dispose();
    priceController.dispose();

    super.dispose();
  }

//!Save Data
  Future<void> _saveForm() async {
    if (_form.currentState!.validate()) {
      _form.currentState!.save();
      setState(() {
        _isloading = true;
      });

      print("saveform" + pd.id);
      //ignore: unnecessary_null_comparison
      if (pd.id.isEmpty) {
        try {
          await Provider.of<Products>(context, listen: false).addProducts(pd);
        } catch (e) {
          await showDialog(
            context: context,
            builder: (context) => AlertDialog(
                title: Text("WARNING"),
                content: Text("Something Went Wrong !!"),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text("OK"),
                  )
                ]),
          );
        } finally {
          setState(() {
            _isloading = false;
          });

          Navigator.of(context).pop();
        }

        print("Added products");
      } else {
        Provider.of<Products>(context, listen: false).updateProducts(pd.id, pd);
        print("updated products" + pd.id);
        setState(() {
          _isloading = false;
        });
        Navigator.of(context).pop();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [IconButton(onPressed: _saveForm, icon: Icon(Icons.save))],
      ),
      body: _isloading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: const EdgeInsets.all(8.0),
              child: Form(
                key: _form,
                child: Column(children: [
                  //!title
                  TextFormField(
                    // initialValue: _initvalues["title"],
                    decoration: InputDecoration(
                      hintText: "Title",
                      labelText: "Title",
                      border: UnderlineInputBorder(
                        borderSide:
                            BorderSide(color: Theme.of(context).primaryColor),
                      ),
                    ),
                    textInputAction: TextInputAction.next,
                    onFieldSubmitted: (_) {
                      FocusScope.of(context).requestFocus(_priceFocusNode);
                    },
                    controller: titleController,

                    onSaved: (value) {
                      pd = Product(
                        id: pd.id,
                        title: titleController.text,
                        description: pd.description,
                        price: pd.price,
                        imageUrl: pd.imageUrl,
                        isFavourate: pd.isFavourate,
                      );
                    },
                    validator: (value) =>
                        value!.isEmpty ? "Enter a title" : null,
                  ),

                  //!Price
                  TextFormField(
                    // initialValue: _initvalues["price"],
                    decoration: InputDecoration(
                      hintText: "Price",
                      labelText: "Price",
                      border: UnderlineInputBorder(
                        borderSide:
                            BorderSide(color: Theme.of(context).primaryColor),
                      ),
                    ),
                    textInputAction: TextInputAction.next,
                    keyboardType: TextInputType.number,
                    focusNode: _priceFocusNode,
                    onFieldSubmitted: (_) {
                      FocusScope.of(context)
                          .requestFocus(_discriptionFocusNode);
                    },
                    controller: priceController,
                    onSaved: (value) {
                      pd = Product(
                        id: pd.id,
                        title: pd.title,
                        description: pd.description,
                        price: double.parse(priceController.text),
                        imageUrl: pd.imageUrl,
                        isFavourate: pd.isFavourate,
                      );
                    },
                    validator: (value) {
                      if (value!.isEmpty) return "enter a Price";

                      if (double.tryParse(value) == null)
                        return "enter a valis price";

                      if (double.tryParse(value)! <= 0)
                        return "Please enter 0+ price";
                      return null;
                    },
                  ),
                  //*Description
                  TextFormField(
                      // initialValue: _initvalues["description"],
                      decoration: InputDecoration(
                        hintText: "Description",
                        labelText: "Description",
                        border: UnderlineInputBorder(
                          borderSide:
                              BorderSide(color: Theme.of(context).primaryColor),
                        ),
                      ),
                      maxLines: 3,
                      keyboardType: TextInputType.multiline,
                      focusNode: _discriptionFocusNode,
                      controller: descriptionController,
                      onSaved: (value) {
                        pd = Product(
                          id: pd.id,
                          title: pd.title,
                          description: descriptionController.text,
                          price: pd.price,
                          imageUrl: pd.imageUrl,
                          isFavourate: pd.isFavourate,
                        );
                      },
                      validator: (value) {
                        if (value!.isEmpty) return "enter the description";
                        if (value.length < 10)
                          return "Please enter the 10+ chars  ";
                      }),
                  //! Add Image
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Container(
                        width: 30,
                        height: 30,
                        decoration: BoxDecoration(
                          border:
                              Border.all(color: Theme.of(context).primaryColor),
                          borderRadius: BorderRadius.circular(3),
                        ),
                        child: _imageUrlTextEditingController.text.isEmpty
                            ? Text("URL")
                            : FittedBox(
                                child: Image.network(
                                  _imageUrlTextEditingController.text,
                                  height: 30,
                                ),
                              ),
                      ),
                      SizedBox(width: 10),
                      Expanded(
                        child: TextFormField(
                          decoration: InputDecoration(
                            hintText: " enter here imageUrl",
                            labelText: "imageUrl",
                            border: UnderlineInputBorder(
                              borderSide: BorderSide(
                                  color: Theme.of(context).primaryColor),
                            ),
                          ),
                          keyboardType: TextInputType.url,
                          controller: _imageUrlTextEditingController,
                          textInputAction: TextInputAction.done,
                          focusNode: _imageUrlFocusNode,
                          onFieldSubmitted: (context) {
                            _updateImage();
                            _saveForm();
                          },
                          onSaved: (value) {
                            pd = Product(
                              id: pd.id,
                              title: pd.title,
                              description: pd.description,
                              price: pd.price,
                              imageUrl: _imageUrlTextEditingController.text,
                              isFavourate: pd.isFavourate,
                            );
                          },
                          validator: (value) {
                            if (value!.isEmpty) return "please enter a URL";

                            if (!value.startsWith("http") ||
                                !value.startsWith("https"))
                              return "enter a valid URL";

                            return null;
                          },
                        ),
                      ),
                    ],
                  ),
                ]),
              ),
            ),
    );
  }
}
