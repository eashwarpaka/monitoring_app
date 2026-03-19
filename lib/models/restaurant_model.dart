class RestaurantModel {
  final String restaurantId;
  final String name;
  final String ownerId;

  RestaurantModel({
    required this.restaurantId,
    required this.name,
    required this.ownerId,
  });

  factory RestaurantModel.fromJson(Map<String, dynamic> json, String id) {
    return RestaurantModel(
      restaurantId: id,
      name: json['name'] ?? 'Unknown Restaurant',
      ownerId: json['owner_id'] ?? '',
    );
  }
}

class BranchModel {
  final String branchId;
  final String restaurantId;
  final String branchName;
  final String location;

  BranchModel({
    required this.branchId,
    required this.restaurantId,
    required this.branchName,
    required this.location,
  });

  factory BranchModel.fromJson(Map<String, dynamic> json, String id) {
    return BranchModel(
      branchId: id,
      restaurantId: json['restaurant_id'] ?? '',
      branchName: json['branch_name'] ?? 'Unknown Branch',
      location: json['location'] ?? '',
    );
  }
}
