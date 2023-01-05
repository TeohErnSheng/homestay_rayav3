// ignore_for_file: public_member_api_docs, sort_constructors_first
class Homestay {
  String? homestayId;
  String? name;
  String? address;
  String? pax;
  String? facility;
  String? price;
  String? state;
  String? locality;
  String? latitude;
  String? longitude;
  Homestay({
    this.homestayId,
    this.name,
    this.address,
    this.pax,
    this.facility,
    this.price,
    this.state,
    this.locality,
    this.latitude,
    this.longitude,
  });

  Homestay.fromJson(Map<String, dynamic> json) {
    homestayId = json['HomestayId'];
    name = json['Name'];
    address = json['Address'];
    pax = json['Pax'];
    facility = json['Facilities'];
    price = json['Price'];
    state = json['State'];
    locality = json['Locality'];
    latitude = json['Latitude'];
    longitude = json['Longitude'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['HomestayId'] = homestayId;
    data['Name'] = name;
    data['Address'] = address;
    data['Pax'] = pax;
    data['Facilities'] = facility;
    data['Price'] = price;
    data['State'] = state;
    data['Locality'] = locality;
    data['Latitude'] = latitude;
    data['Longitude'] = longitude;
    return data;
  }
}
