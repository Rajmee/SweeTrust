class Food {
  final String id;
  final String name;
  final String imagePath;
  final String description;
  final String category;
  final double price;
  final double discount;
  final double ratings;
  final String district;
  final String area;
  bool userLiked;

  Food(
      {this.id,
      this.name,
      this.imagePath,
      this.description,
      this.category,
      this.price,
      this.discount,
      this.ratings,
      this.district,
      this.area,
      this.userLiked});
}
