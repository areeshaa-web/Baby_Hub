class AddressModel {
  const AddressModel({
    required this.name,
    required this.line1,
    required this.city,
    required this.state,
    required this.zipCode,
    required this.country,
    this.line2,
    this.phone,
  });

  final String name;
  final String line1;
  final String? line2;
  final String city;
  final String state;
  final String zipCode;
  final String country;
  final String? phone;

  String get formattedAddress {
    final buffer = StringBuffer(line1);
    if (line2 != null && line2!.isNotEmpty) {
      buffer.write(', $line2');
    }
    buffer.write(', $city, $state $zipCode, $country');
    return buffer.toString();
  }
}
