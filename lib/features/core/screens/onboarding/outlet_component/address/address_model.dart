class AddressModel {
  double latitude;
  double longitude;

  String houseNo;
  String street;
  String landmark;
  String city;
  String state;
  String postalCode;
  String country;

  AddressModel({
    required this.latitude,
    required this.longitude,
    this.houseNo = '',
    this.street = '',
    this.landmark = '',
    this.city = '',
    this.state = '',
    this.postalCode = '',
    this.country = 'India',
  });
}
