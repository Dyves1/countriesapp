class CountrySummary {
  final String code;
  final String common;
  final String flagUrl;
  final int population;
  final String? capital;
  final bool isFavorite;

  CountrySummary({
    required this.code,
    required this.common,
    required this.flagUrl,
    required this.population,
    this.capital,
    this.isFavorite = false,
  });

  factory CountrySummary.fromJson(Map<String, dynamic> json) {
    return CountrySummary(
      code: json['cca2'] ?? '',
      common: json['name']?['common'] ?? '',
      flagUrl: json['flags']?['png'] ?? '',
      population: json['population'] ?? 0,
      capital: (json['capital'] != null && json['capital'] is List && json['capital'].isNotEmpty)
          ? json['capital'][0]
          : 'N/A',
    );
  }

  CountrySummary copyWith({
    String? code,
    String? common,
    String? flagUrl,
    int? population,
    String? capital,
    bool? isFavorite,
  }) {
    return CountrySummary(
      code: code ?? this.code,
      common: common ?? this.common,
      flagUrl: flagUrl ?? this.flagUrl,
      population: population ?? this.population,
      capital: capital ?? this.capital,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }
}
