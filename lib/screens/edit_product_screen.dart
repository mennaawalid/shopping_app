import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopping/providers/products.dart';
import 'package:shopping/providers/products_provider.dart';

class EditProductScreen extends StatefulWidget {
  static const routeName = '/edit_product_screen';
  const EditProductScreen({Key? key}) : super(key: key);

  @override
  State<EditProductScreen> createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final _imageUrlConroller = TextEditingController();
  final _imageUrlFocusNode = FocusNode();
  final _form = GlobalKey<FormState>();
  var _editedProduct =
      ProductInfo(id: null, name: '', description: '', price: 0, imageURl: '');
  var _initalValues = {
    'title': '',
    'price': '',
    'imageURL': '',
    'description': ''
  };
  var _isInit = true;
  var _isLoading = false;

  @override
  void initState() {
    _imageUrlFocusNode.addListener(_updateImageUrl);
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      final productId = ModalRoute.of(context)?.settings.arguments as String?;
      if (productId != null) {
        _editedProduct =
            Provider.of<Products>(context, listen: false).findById(productId);
        _initalValues = {
          'title': _editedProduct.name!,
          'price': _editedProduct.price.toString(),
          'imageURL': _editedProduct.imageURl!,
          'description': _editedProduct.description!
        };
        _imageUrlConroller.text = _editedProduct.imageURl!;
      }
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _imageUrlFocusNode.removeListener(_updateImageUrl);
    _imageUrlConroller.dispose();
    _imageUrlFocusNode.dispose();
    super.dispose();
  }

  void _updateImageUrl() {
    if (!_imageUrlFocusNode.hasFocus) {
      setState(() {});
    }
  }

  Future<void> _saveForm() async {
    final isValid = _form.currentState!.validate();
    if (!isValid) {
      return;
    }
    _form.currentState!.save();
    setState(() {
      _isLoading = true;
    });
    if (_editedProduct.id != null) {
      try {
        await Provider.of<Products>(context, listen: false)
            .editProduct(_editedProduct);
      } catch (error) {
        await showDialog<Null>(
          context: context,
          builder: (ctx) => AlertDialog(
            title: const Text(
              'Error!',
            ),
            content: const Text('Something went wrong!'),
            actions: [
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('okay'),
              ),
            ],
          ),
        );
      }
    } else {
      try {
        await Provider.of<Products>(context, listen: false)
            .addProduct(_editedProduct);
      } catch (error) {
        await showDialog<Null>(
          context: context,
          builder: (ctx) => AlertDialog(
            title: const Text(
              'Error!',
            ),
            content: const Text('Something went wrong!'),
            actions: [
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('okay'),
              ),
            ],
          ),
        );
      }
    }
    setState(() {
      _isLoading = false;
    });

    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Product'),
        actions: [
          IconButton(
            onPressed: () {
              _imageUrlFocusNode.unfocus();
              _saveForm();
            },
            icon: const Icon(Icons.save),
          ),
        ],
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: const EdgeInsets.all(15.0),
              child: Form(
                key: _form,
                child: SingleChildScrollView(
                  child: Column(
                    children: <Widget>[
                      TextFormField(
                        initialValue: _initalValues['title'],
                        decoration: const InputDecoration(
                          labelText: 'Title',
                        ),
                        textInputAction: TextInputAction.next,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter the title.';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          _editedProduct = ProductInfo(
                              id: _editedProduct.id,
                              isFavorite: _editedProduct.isFavorite,
                              name: value,
                              description: _editedProduct.description,
                              price: _editedProduct.price,
                              imageURl: _editedProduct.imageURl);
                        },
                      ),
                      TextFormField(
                        initialValue: _initalValues['price'],
                        decoration: const InputDecoration(labelText: 'Price'),
                        textInputAction: TextInputAction.next,
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter the price.';
                          }
                          if (double.tryParse(value) == null) {
                            return 'Please enter a valid number.';
                          }
                          if (double.parse(value) <= 0) {
                            return 'Please enter a number greater than zero.';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          _editedProduct = ProductInfo(
                              id: _editedProduct.id,
                              isFavorite: _editedProduct.isFavorite,
                              name: _editedProduct.name,
                              description: _editedProduct.description,
                              price: double.parse(value!),
                              imageURl: _editedProduct.imageURl);
                        },
                      ),
                      TextFormField(
                        initialValue: _initalValues['description'],
                        decoration:
                            const InputDecoration(labelText: 'Description'),
                        textInputAction: TextInputAction.next,
                        maxLines: 3,
                        keyboardType: TextInputType.multiline,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter the description!';
                          }
                          if (value.length < 10) {
                            return 'Description should be at least 10 characters long';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          _editedProduct = ProductInfo(
                              id: _editedProduct.id,
                              isFavorite: _editedProduct.isFavorite,
                              name: _editedProduct.name,
                              description: value,
                              price: _editedProduct.price,
                              imageURl: _editedProduct.imageURl);
                        },
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Container(
                            margin: const EdgeInsets.only(right: 10, top: 16),
                            height: 130,
                            width: 130,
                            decoration: BoxDecoration(
                              border: Border.all(width: 1, color: Colors.grey),
                            ),
                            child: _imageUrlConroller.text.isEmpty
                                ? const Center(child: Text("Enter a URL"))
                                : CachedNetworkImage(
                                    errorWidget: (context, url, error) {
                                      return const Icon(
                                        Icons.error,
                                        color: Colors.red,
                                      );
                                    },
                                    fit: BoxFit.cover,
                                    imageUrl: _imageUrlConroller.text,
                                  ),
                          ),
                          Expanded(
                            child: TextFormField(
                              decoration:
                                  const InputDecoration(labelText: "Image URL"),
                              textInputAction: TextInputAction.done,
                              keyboardType: TextInputType.url,
                              controller: _imageUrlConroller,
                              focusNode: _imageUrlFocusNode,
                              onEditingComplete: () {
                                setState(() {});
                              },
                              onFieldSubmitted: (_) {
                                _imageUrlFocusNode.unfocus();
                                _saveForm();
                              },
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Please enter the image url.';
                                }
                                if ((!value.startsWith('http') &&
                                        !value.startsWith('https')) ||
                                    ((!value.endsWith('jpg')) &&
                                        (!value.endsWith('jepg')) &&
                                        (!value.endsWith('png')))) {
                                  return 'Please enter a valid image url.';
                                }
                                return null;
                              },
                              onSaved: (value) {
                                _editedProduct = ProductInfo(
                                    id: _editedProduct.id,
                                    isFavorite: _editedProduct.isFavorite,
                                    name: _editedProduct.name,
                                    description: _editedProduct.description,
                                    price: _editedProduct.price,
                                    imageURl: value);
                              },
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}
