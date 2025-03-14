import 'dart:io';

class Product {
  String name;
  int price;

  Product(this.name, this.price);
}

class ShoppingMall {
  List<Product> products;
  Map<String, int> cart = {};
  int totalPrice = 0;

  ShoppingMall(this.products);

  void showProducts() {
    print("\n[상품 목록]");
    for (var product in products) {
      print("${product.name} / ${product.price}원");
    }
  }

  void addToCart() {
    print("\n추가할 상품명을 입력하세요:");
    String? productName = stdin.readLineSync();

    var product = products.firstWhere(
      (p) => p.name == productName,
      orElse: () => Product("", 0),
    );

    if (product.name.isEmpty) {
      print("입력값이 올바르지 않아요!");
      return;
    }

    print("추가할 개수를 입력하세요:");
    String? quantityInput = stdin.readLineSync();
    int quantity;
    try {
      quantity = int.parse(quantityInput!);
      if (quantity <= 0) {
        print("0개보다 많은 개수의 상품만 담을 수 있어요!");
        return;
      }
    } catch (e) {
      print("입력값이 올바르지 않아요!");
      return;
    }

    cart[product.name] = (cart[product.name] ?? 0) + quantity;
    totalPrice += product.price * quantity;
    print("장바구니에 상품이 담겼어요!");
  }

  void showTotal() {
    if (cart.isEmpty) {
      print("장바구니에 담긴 상품이 없습니다.");
      return;
    }
    print("\n[장바구니 목록]");
    cart.forEach((name, quantity) {
      var price = products.firstWhere((p) => p.name == name).price;
      print("$name x $quantity = ${price * quantity}원");
    });
    print("총 가격: ${totalPrice}원");
  }

  void clearCart() {
    if (cart.isEmpty) {
      print("이미 장바구니가 비어있습니다.");
    } else {
      cart.clear();
      totalPrice = 0;
      print("장바구니를 초기화합니다.");
    }
  }

  bool confirmExit() {
    print("정말 종료하시겠습니까? (5 입력 시 종료)");
    String? input = stdin.readLineSync();
    return input == "5";
  }
}

void main() {
  ShoppingMall mall = ShoppingMall([
    Product("셔츠", 45000),
    Product("원피스", 30000),
    Product("반팔티", 35000),
    Product("반바지", 38000),
    Product("양말", 5000),
  ]);

  bool isRunning = true;
  while (isRunning) {
    print(
      "\n[1] 상품 목록 보기 / [2] 장바구니에 담기 / [3] 장바구니 보기 / [4] 프로그램 종료 / [6] 장바구니 초기화",
    );
    String? input = stdin.readLineSync();

    switch (input) {
      case "1":
        mall.showProducts();
        break;
      case "2":
        mall.addToCart();
        break;
      case "3":
        mall.showTotal();
        break;
      case "4":
        if (mall.confirmExit()) {
          print("이용해 주셔서 감사합니다 ~ 안녕히 가세요!");
          isRunning = false;
        } else {
          print("종료하지 않습니다.");
        }
        break;
      case "6":
        mall.clearCart();
        break;
      default:
        print("지원하지 않는 기능입니다! 다시 시도해 주세요..");
    }
  }
}
