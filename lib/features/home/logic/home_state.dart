import 'package:equatable/equatable.dart';
import '../data/models/country_summary_model.dart';

enum HomeStatus { initial, loading, success, failure }

class HomeState extends Equatable {
  final HomeStatus status;
  final List<CountrySummary> countries;
  final String errorMessage;

  const HomeState({
    this.status = HomeStatus.initial,
    this.countries = const [],
    this.errorMessage = '',
  });

  HomeState copyWith({
    HomeStatus? status,
    List<CountrySummary>? countries,
    String? errorMessage,
  }) {
    return HomeState(
      status: status ?? this.status,
      countries: countries ?? this.countries,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

@override
List<Object?> get props => [status, countries, errorMessage];

}
