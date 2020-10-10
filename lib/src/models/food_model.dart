class Food {
  final String id;
  final String name;
  final String imagePath;
  final String description;
  final String lat;
  final String lng;
  final double price;
  final double ratings;
  final String area;
  final String discount;
  bool userLiked;

  Food(
      {this.id,
      this.name,
      this.imagePath,
      this.description,
      this.price,
      this.ratings,
      this.lat,
      this.lng,
      this.area,
      this.discount,
      this.userLiked});
}
