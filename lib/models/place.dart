class Flat {
  final int id;
  final String name;
  final String description;
  final String pictureUrl;
  final String? hostName;
  final String? hostPictureUrl;
  final String? neighbourhood;
  final double latitude;
  final double longitude;
  final int? accommodates;
  final double? bathrooms;
  final int? bedrooms;
  final String? city;

  Flat(
      {required this.id,
      required this.name,
      required this.description,
      required this.pictureUrl,
      this.hostName,
      this.hostPictureUrl,
      this.neighbourhood,
      required this.latitude,
      required this.longitude,
      this.accommodates,
      this.bathrooms,
      this.bedrooms,
      this.city});
}
