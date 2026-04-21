class PlacesModel {
  List<Place>? place;
  String? sessionId;

  PlacesModel({this.place, this.sessionId});

  factory PlacesModel.fromJson(Map<String, dynamic> json) {
    List list = json['places'] ?? [];
    List<Place> place = list.map((e) => Place.fromJson(e)).toList();
    return PlacesModel(
      place: place,
      sessionId: json['session_id']
    );
  }
}

class Place {
  double? latitude;
  double? longitude;
  String? address;
  String? name;
  String? id;

  Place({this.latitude, this.longitude, this.address, this.name, this.id});

  factory Place.fromJson(Map<String, dynamic> json) {
    return Place(
      latitude: json['location'][0],
      longitude: json['location'][1],
      address: json['address'],
      name: json['name'],
      id: json['id'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['address'] = address;
    data['location'] = [latitude, longitude];
    return data;
  }
}