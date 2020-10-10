class Order {
  final String name;
  final String areaName;
  final String status;
  final int orderId;
  final String quantity;
  final String price;
  final String carierPhn;
  final String carierCharge;

  Order(this.name, this.areaName, this.status, this.orderId, this.quantity,
      this.price, this.carierPhn, this.carierCharge);
}
