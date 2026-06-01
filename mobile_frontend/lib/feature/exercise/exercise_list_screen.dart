import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile_frontend/common/widgets/kinetic_app_bar.dart';
import 'package:mobile_frontend/database/database.dart';
import 'package:mobile_frontend/database/database_provider.dart';
import 'package:mobile_frontend/feature/routine/data/routine_exercise_service.dart';
import 'package:mobile_frontend/feature/exercise/screens/add_exercise_screen.dart';
import 'package:mobile_frontend/feature/routine/screens/edit_routine_screen.dart';
import 'package:mobile_frontend/feature/exercise/widgets/exercise_hero_header.dart';
import 'package:mobile_frontend/feature/exercise/widgets/exercise_list.dart';

class ExerciseListScreen extends ConsumerStatefulWidget {
  final Routine routine;

  const ExerciseListScreen({super.key, required this.routine});

  @override
  ConsumerState<ExerciseListScreen> createState() => _ExerciseListScreenState();
}

class _ExerciseListScreenState extends ConsumerState<ExerciseListScreen> {
  late Routine _routine;
  late final RoutineExerciseService _routineExerciseService;

  @override
  void initState() {
    super.initState();
    _routine = widget.routine;
    _routineExerciseService = RoutineExerciseService(
      ref.read(appDatabaseProvider),
    );
  }

  Future<void> _openEdit() async {
    final updated = await Navigator.of(context).push<Routine>(
      MaterialPageRoute(builder: (_) => EditRoutineScreen(routine: _routine)),
    );
    if (updated != null && mounted) setState(() => _routine = updated);
  }

  Future<void> _addExercise() async {
    await Navigator.of(context).push<void>(
      MaterialPageRoute<void>(
        builder: (_) => AddExerciseScreen(
          routineId: _routine.id,
          routineName: _routine.title,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final appTheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: KineticAppBar(
        showBackButton: true,
        actions: [
          GestureDetector(
            onTap: _openEdit,
            child: Padding(
              padding: const EdgeInsets.only(right: 8),
              child: Icon(Icons.edit_outlined, color: appTheme.primary, size: 22),
            ),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(24, 8, 24, 120),
        children: [
          ExerciseHeroHeader(
            routine: _routine,
            routineExerciseService: _routineExerciseService,
          ),
          const SizedBox(height: 40),
          ExerciseList(
            routineId: _routine.id,
            routineName: _routine.title,
            routineExerciseService: _routineExerciseService,
            onAddExercise: _addExercise,
          ),
        ],
      ),
    );
  }
}
