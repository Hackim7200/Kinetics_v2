import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile_frontend/common/widgets/kinetic_app_bar.dart';
import 'package:mobile_frontend/feature/routine/domain/entities/routine.dart';
import 'package:mobile_frontend/feature/routine/presentation/pages/edit_routine_screen.dart';
import 'package:mobile_frontend/feature/routine_exercise/data/repositories/routine_exercise_repository.dart';
import 'package:mobile_frontend/feature/routine_exercise/presentation/pages/add_exercise_screen.dart';
import 'package:mobile_frontend/feature/routine_exercise/presentation/widgets/exercise_hero_header.dart';
import 'package:mobile_frontend/feature/routine_exercise/presentation/widgets/exercise_list.dart';

class ExerciseListScreen extends ConsumerStatefulWidget {
  final Routine routine;

  const ExerciseListScreen({super.key, required this.routine});

  @override
  ConsumerState<ExerciseListScreen> createState() => _ExerciseListScreenState();
}

class _ExerciseListScreenState extends ConsumerState<ExerciseListScreen> {
  late Routine _routine;

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
  void initState() {
    super.initState();
    _routine = widget.routine;
  }

  @override
  Widget build(BuildContext context) {
    final appTheme = Theme.of(context).colorScheme;
    final routineExerciseRepository = ref.watch(routineExerciseRepositoryProvider);

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
            routineExerciseRepository: routineExerciseRepository,
          ),
          const SizedBox(height: 40),
          ExerciseList(
            routineId: _routine.id,
            routineName: _routine.title,
            onAddExercise: _addExercise,
          ),
        ],
      ),
    );
  }
}
