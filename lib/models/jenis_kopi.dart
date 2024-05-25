class JenisKopi {
  final String? id;
  final int? idInt;
  final String? name;
  final String? description;
  final double? price;
  final String? region;
  final int? weight;
  final List<String>? flavorProfile;
  final List<String>? grindOption;
  final int? roastLevel;
  final String? imageUrl;

  JenisKopi({
    this.id,
    this.idInt,
    this.name,
    this.description,
    this.price,
    this.region,
    this.weight,
    this.flavorProfile,
    this.grindOption,
    this.roastLevel,
    this.imageUrl,
  });

  factory JenisKopi.fromJson(Map<String, dynamic> json) {
    return JenisKopi(
      id: json['_id'] as String?,
      idInt: json['id'] as int?,
      name: json['name'] as String?,
      description: json['description'] as String?,
      price: json['price'] as double?,
      region: json['region'] as String?,
      weight: json['weight'] as int?,
      flavorProfile: (json['flavor_profile'] as List?)?.map((e) => e as String).toList(),
      grindOption: (json['grind_option'] as List?)?.map((e) => e as String).toList(),
      roastLevel: json['roast_level'] as int?,
      imageUrl: json['image_url'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'id': idInt,
      'name': name,
      'description': description,
      'price': price,
      'region': region,
      'weight': weight,
      'flavor_profile': flavorProfile,
      'grind_option': grindOption,
      'roast_level': roastLevel,
      'image_url': imageUrl,
    };
  }
}
