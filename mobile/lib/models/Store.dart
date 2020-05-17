class Store {
  final String name;
  final String owner;
  final String location;
  final String storeType;
  final String description;
  final String logo;

  Store(this.name, this.owner, this.location, this.storeType, this.description, this.logo);

  Map<String, dynamic> toJson() =>
    {
      'name': "\""+ name + "\"",
      'location': "\""+ location + "\"",
      'owner': "\""+ owner + "\"",
      'store_type': "\""+ storeType + "\"",
      'description': "\""+ description + "\""
    };

}