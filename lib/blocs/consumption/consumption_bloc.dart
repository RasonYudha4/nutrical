import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../data/models/consumption.dart';
import '../../data/models/nutrition_summary.dart';
import '../../data/repositories/consumption_repo.dart';

part 'consumption_event.dart';
part 'consumption_state.dart';

class ConsumptionBloc extends Bloc<ConsumptionEvent, ConsumptionState> {
  final ConsumptionRepo _consumptionRepo = ConsumptionRepo();

  StreamSubscription<List<Consumption>>? _consumptionSubscription;

  ConsumptionBloc() : super(HomeInitial()) {
    on<SaveConsumption>(_onSaveConsumption);
    on<LoadConsumptions>(_onLoadConsumptions);
    on<StreamConsumptions>(_onStreamConsumptions);
    on<ConsumptionsUpdated>(_onConsumptionsUpdated);
  }

  @override
  Future<void> close() {
    _consumptionSubscription?.cancel();
    return super.close();
  }

  Future<void> _onSaveConsumption(
    SaveConsumption event,
    Emitter<ConsumptionState> emit,
  ) async {
    emit(ConsumptionGenerateLoading());
    try {
      await _consumptionRepo.saveConsumption(
        event.userId,
        event.date,
        event.consumption,
      );
      emit(ConsumptionSaveSuccess());
    } catch (e) {
      emit(ConsumptionSaveError("Failed to save consumption: ${e.toString()}"));
    }
  }

  Future<void> _onLoadConsumptions(
    LoadConsumptions event,
    Emitter<ConsumptionState> emit,
  ) async {
    emit(ConsumptionLoading());
    try {
      final dateKey = _formatDate(event.date);
      final consumptions = await _consumptionRepo.getInitialConsumptions(
        event.userId,
        dateKey,
      );
      final summary = NutritionSummary.fromConsumptions(consumptions);
      emit(
        ConsumptionLoaded(
          consumptions: consumptions,
          nutritionSummary: summary,
        ),
      );
    } catch (e) {
      emit(
        ConsumptionLoadError("Failed to load consumptions: ${e.toString()}"),
      );
    }
  }

  Future<void> _onStreamConsumptions(
    StreamConsumptions event,
    Emitter<ConsumptionState> emit,
  ) async {
    final dateKey = _formatDate(event.date);
    print('📅 Subscribing to consumptions for: $dateKey');

    await emit.forEach<List<Consumption>>(
      _consumptionRepo.getStreamConsumptions(event.userId, dateKey),
      onData: (consumptions) {
        print('📦 Received ${consumptions.length} consumptions from stream');
        final summary = NutritionSummary.fromConsumptions(consumptions);
        return ConsumptionLoaded(
          consumptions: consumptions,
          nutritionSummary: summary,
        );
      },
      onError: (error, _) {
        print('❌ Stream error: $error');
        return ConsumptionLoadError("Stream error: $error");
      },
    );
  }

  void _onConsumptionsUpdated(
    ConsumptionsUpdated event,
    Emitter<ConsumptionState> emit,
  ) {
    emit(
      ConsumptionLoaded(
        consumptions: event.consumptions,
        nutritionSummary: event.nutritionSummary,
      ),
    );
  }

  String _formatDate(DateTime date) => date.toIso8601String().split('T')[0];
}
