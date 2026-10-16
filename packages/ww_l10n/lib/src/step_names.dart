import 'generated/ww_localizations.dart';

/// The job steps' names (ARCHITECTURE §6.11), for both apps.
extension StepNames on WWLocalizations {
  String stepName(String step) => switch (step) {
        'ON_THE_WAY' => stepOnTheWay,
        'REACHED_PATIENT' => stepReachedPatient,
        'PICKED_UP' => stepPickedUp,
        'REACHED_HOSPITAL' => stepReachedHospital,
        'VISIT_DONE' => stepVisitDone,
        'DROPPED_HOME' => stepDroppedHome,
        'REACHED_HOME' => stepReachedHome,
        'STARTED' => stepStarted,
        'CARE_DONE' => stepCareDone,
        'AT_PLACE' => stepAtPlace,
        'TASK_DONE' => stepTaskDone,
        'DELIVERED' => stepDelivered,
        'COMPLETED' => stepCompleted,
        _ => step,
      };
}
