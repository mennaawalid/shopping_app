import 'package:flutter_test/flutter_test.dart';
import 'package:shopping/providers/cart.dart';

void main() {
  test(
      'given cart item when user adds item to cart then the cart list length gets longer',
      () async {
    //ARRANGE
    final cart = Cart();

    // ACT
    cart.addToCart(
      imageURL:
          'https://live.staticflickr.com/4043/4438260868_cc79b3369d_z.jpg',
      name: 'laptop',
      price: 500,
      productId: '123456',
      
    );

    // ASSERT
    expect(cart.items.length, 1);
  });
}
