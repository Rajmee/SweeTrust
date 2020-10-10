class Request {
  final String areaName;
  final String phn;
  final String notes;
  final String quantity;
  final String price;
  final String orderStatus;
  final int orderId;
  final String expectedTime;

  Request(this.areaName, this.phn, this.notes, this.quantity, this.price,
      this.orderStatus, this.orderId, this.expectedTime);
}
