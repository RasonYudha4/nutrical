part of 'consumption_bloc.dart';

sealed class ConsumptionEvent extends Equatable {
  const ConsumptionEvent();

  @override
  List<Object> get props => [];
}

class SaveConsumption extends ConsumptionEvent {
  final String userId;
  final DateTime date;
  final Consumption consumption;

  const SaveConsumption({
    required this.userId,
    required this.date,
    required this.consumption,
  });

  @override
  List<Object> get props => [userId, date, consumption];
}

class LoadConsumptions extends ConsumptionEvent {
  final String userId;
  final DateTime date;

  const LoadConsumptions({required this.userId, required this.date});

  @override
  List<Object> get props => [userId, date];
}

class StreamConsumptions extends ConsumptionEvent {
  final String userId;
  final DateTime date;

  const StreamConsumptions({required this.userId, required this.date});

  @override
  List<Object> get props => [userId, date];
}

class ConsumptionsUpdated extends ConsumptionEvent {
  final List<Consumption> consumptions;
  final NutritionSummary nutritionSummary;

  const ConsumptionsUpdated({
    required this.consumptions,
    required this.nutritionSummary,
  });

  @override
  List<Object> get props => [consumptions, nutritionSummary];
}
