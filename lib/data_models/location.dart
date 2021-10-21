class Location{
  final double latitude; //緯度
  final double longitude; //経度
  final String country;
  final String state;
  final String city;

//<editor-fold desc="Data Methods">

  const Location({
    required this.latitude,
    required this.longitude,
    required this.country,
    required this.state,
    required this.city,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Location &&
          runtimeType == other.runtimeType &&
          latitude == other.latitude &&
          longitude == other.longitude &&
          country == other.country &&
          state == other.state &&
          city == other.city);

  @override
  int get hashCode =>
      latitude.hashCode ^
      longitude.hashCode ^
      country.hashCode ^
      state.hashCode ^
      city.hashCode;

  @override
  String toString() {
    return 'Location{' +
        ' latitude: $latitude,' +
        ' longitude: $longitude,' +
        ' country: $country,' +
        ' state: $state,' +
        ' city: $city,' +
        '}';
  }

  Location copyWith({
    double? latitude,
    double? longitude,
    String? country,
    String? state,
    String? city,
  }) {
    return Location(
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      country: country ?? this.country,
      state: state ?? this.state,
      city: city ?? this.city,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'latitude': this.latitude,
      'longitude': this.longitude,
      'country': this.country,
      'state': this.state,
      'city': this.city,
    };
  }

  factory Location.fromMap(Map<String, dynamic> map) {
    return Location(
      latitude: map['latitude'] as double,
      longitude: map['longitude'] as double,
      country: map['country'] as String,
      state: map['state'] as String,
      city: map['city'] as String,
    );
  }

//</editor-fold>
}
