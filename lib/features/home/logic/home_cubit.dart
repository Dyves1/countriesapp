import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../data/models/country_summary_model.dart';
import '../../../core/network/app_client.dart';
import 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  final ApiClient apiClient;
  List<CountrySummary> _allCountries = [];
  Set<String> _favorites = {};
  Timer? _debounce;

  HomeCubit(this.apiClient) : super(const HomeState());

  /// Fetch all countries from the API
  Future<void> fetchCountries() async {
    emit(state.copyWith(status: HomeStatus.loading));

    try {
      final data = await apiClient.getAllCountries();

      _allCountries = data
          .map<CountrySummary>((json) => CountrySummary.fromJson(json))
          .toList();

      await _loadFavorites();

      // Apply favorites to all countries
      final countries = _allCountries
          .map((c) => c.copyWith(isFavorite: _favorites.contains(c.code)))
          .toList();

      emit(state.copyWith(status: HomeStatus.success, countries: countries));
    } catch (e) {
      emit(state.copyWith(
        status: HomeStatus.failure,
        errorMessage: 'Failed to load countries. Please try again.',
      ));
    }
  }

  /// Load favorite countries from local storage
  Future<void> _loadFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    _favorites = prefs.getStringList('favorites')?.toSet() ?? {};
  }

  /// Save favorite countries locally
  Future<void> _saveFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('favorites', _favorites.toList());
  }

  /// Toggle a country’s favorite status
  void toggleFavorite(String code) async {
    if (_favorites.contains(code)) {
      _favorites.remove(code);
    } else {
      _favorites.add(code);
    }

    await _saveFavorites();

    // Update both the current and master lists
    final updatedCountries = state.countries
        .map((c) => c.copyWith(isFavorite: _favorites.contains(c.code)))
        .toList();

    final updatedAllCountries = _allCountries
        .map((c) => c.copyWith(isFavorite: _favorites.contains(c.code)))
        .toList();

    _allCountries = updatedAllCountries;
    emit(state.copyWith(countries: updatedCountries));
  }

  /// ✅ Debounced and working search
void searchCountry(String query) {
  // Filter instantly — no debounce
  if (query.isEmpty) {
    emit(state.copyWith(countries: _allCountries));
  } else {
    final filtered = _allCountries
        .where((country) =>
            country.common.toLowerCase().contains(query.toLowerCase()))
        .map((country) =>
            country.copyWith(isFavorite: _favorites.contains(country.code)))
        .toList();

    emit(state.copyWith(countries: List.from(filtered))); // ensure new reference
  }
}

  @override
  Future<void> close() {
    _debounce?.cancel();
    return super.close();
  }
}
