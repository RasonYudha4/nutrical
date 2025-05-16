part of 'consumption_bloc.dart';

sealed class ConsumptionState extends Equatable {
  const ConsumptionState();

  @override
  List<Object> get props => [];
}

class HomeInitial extends ConsumptionState {}

class ConsumptionGenerateLoading extends ConsumptionState {}

class ConsumptionSaveSuccess extends ConsumptionState {}

class ConsumptionSaveError extends ConsumptionState {
  final String message;

  const ConsumptionSaveError(this.message);

  @override
  List<Object> get props => [message];
}

class ConsumptionLoading extends ConsumptionState {}

class ConsumptionLoaded extends ConsumptionState {
  final List<Consumption> consumptions;
  final NutritionSummary nutritionSummary;

  const ConsumptionLoaded({
    required this.consumptions,
    required this.nutritionSummary,
  });

  @override
  List<Object> get props => [consumptions, nutritionSummary];
}

class ConsumptionLoadError extends ConsumptionState {
  final String message;

  const ConsumptionLoadError(this.message);

  @override
  List<Object> get props => [message];
}
