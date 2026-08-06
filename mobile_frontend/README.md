# mobile_frontend

# Project structure

I have utilised SoC principle to make the code easier to read when directory grows and technical dept grows especially when using agentic tools.

.
├── app
│   ├── navigation
│   │   ├── app_router.dart
│   │   └── app_shell.dart
│   └── themes
│       └── app_theme.dart
├── common
│   ├── utils
│   │   ├── timer_routine_target.dart
│   │   └── training_target_input.dart
│   └── widgets
│       ├── detail_hero_header.dart
│       ├── empty_state_widget.dart
│       ├── kinetic_app_bar.dart
│       ├── metric_pill.dart
│       └── placeholder_screen.dart
├── database
│   ├── database.dart
│   ├── database.g.dart
│   ├── database_provider.dart
│   ├── database_provider.g.dart
│   ├── soft_delete_writer.dart
│   └── tables
│       ├── circuit_tables
│       │   ├── circuit_exercise_table.dart
│       │   └── circuit_table.dart
│       ├── sync_metadata_mixin.dart
│       └── workout_tables
│           ├── routine_exercise_table.dart
│           ├── routine_table.dart
│           ├── set_entry_table.dart
│           └── workout_log_table.dart
├── feature
│   ├── auth
│   │   ├── data
│   │   │   ├── repositories
│   │   │   │   ├── onboarding_repository.dart
│   │   │   │   └── onboarding_repository.g.dart
│   │   │   └── sources
│   │   │       └── onboarding_local_source.dart
│   │   ├── domain
│   │   │   └── use_cases
│   │   │       └── validate_sign_in.dart
│   │   └── presentation
│   │       └── pages
│   │           ├── onboarding_screen.dart
│   │           └── sign_in_screen.dart
│   ├── circuit
│   │   ├── data
│   │   │   ├── repositories
│   │   │   │   ├── circuit_exercise_repository.dart
│   │   │   │   ├── circuit_exercise_repository.g.dart
│   │   │   │   ├── circuit_repository.dart
│   │   │   │   └── circuit_repository.g.dart
│   │   │   └── sources
│   │   │       ├── circuit_exercise_local_source.dart
│   │   │       └── circuit_local_source.dart
│   │   ├── domain
│   │   │   ├── entities
│   │   │   │   ├── circuit.dart
│   │   │   │   └── circuit_exercise.dart
│   │   │   └── use_cases
│   │   │       ├── circuit_display.dart
│   │   │       ├── validate_circuit_exercise.dart
│   │   │       └── validate_circuit_form.dart
│   │   ├── presentation
│   │   │   ├── pages
│   │   │   │   ├── add_circuit_exercise_screen.dart
│   │   │   │   ├── circuit_dashboard_screen.dart
│   │   │   │   ├── circuit_detail_screen.dart
│   │   │   │   ├── circuit_play_screen.dart
│   │   │   │   ├── create_circuit_screen.dart
│   │   │   │   ├── edit_circuit_exercise_screen.dart
│   │   │   │   └── edit_circuit_screen.dart
│   │   │   └── widgets
│   │   │       ├── circuit_list_card.dart
│   │   │       └── create_circuit_card.dart
│   │   └── state
│   │       ├── circuit_play_notifier.dart
│   │       ├── circuit_play_notifier.g.dart
│   │       └── circuit_play_state.dart
│   ├── counter
│   │   └── state
│   │       ├── counter_notifier.dart
│   │       └── counter_notifier.g.dart
│   ├── exercise_analytics
│   │   ├── data
│   │   │   ├── repositories
│   │   │   │   ├── workout_repository.dart
│   │   │   │   └── workout_repository.g.dart
│   │   │   └── sources
│   │   │       └── workout_local_source.dart
│   │   ├── domain
│   │   │   ├── entities
│   │   │   │   ├── exercise.dart
│   │   │   │   ├── progress_graph_data.dart
│   │   │   │   ├── set.dart
│   │   │   │   └── workout.dart
│   │   │   └── use_cases
│   │   │       ├── map_routine_exercise_for_session.dart
│   │   │       ├── parse_strength_set_input.dart
│   │   │       ├── training_load.dart
│   │   │       ├── validate_strength_set.dart
│   │   │       ├── validate_timer_set.dart
│   │   │       └── workout_metrics.dart
│   │   ├── presentation
│   │   │   ├── pages
│   │   │   │   ├── exercise_analytics_screen.dart
│   │   │   │   ├── timer_exercise_dashboard.dart
│   │   │   │   └── weight_exercise_dashboard.dart
│   │   │   └── widgets
│   │   │       ├── history_table
│   │   │       │   ├── timer_table.dart
│   │   │       │   ├── weight_and_reps_table2.dart
│   │   │       │   └── workout_history_table.dart
│   │   │       ├── progress_graph.dart
│   │   │       ├── set_entry_table
│   │   │       │   ├── set_entry_editable_row.dart
│   │   │       │   ├── set_entry_primary_action_button.dart
│   │   │       │   ├── set_entry_read_only_row.dart
│   │   │       │   ├── set_entry_table_header.dart
│   │   │       │   ├── set_entry_table_header_timer.dart
│   │   │       │   ├── set_entry_table_layout.dart
│   │   │       │   ├── set_entry_table_timer.dart
│   │   │       │   ├── set_entry_table_weight.dart
│   │   │       │   └── set_entry_timer_read_only_row.dart
│   │   │       ├── set_entry_table_add_time_sheet.dart
│   │   │       └── small_stat_card.dart
│   │   └── state
│   │       ├── strength_session_notifier.dart
│   │       ├── strength_session_notifier.g.dart
│   │       ├── strength_session_state.dart
│   │       ├── timer_session_notifier.dart
│   │       ├── timer_session_notifier.g.dart
│   │       └── timer_session_state.dart
│   ├── routine
│   │   ├── data
│   │   │   ├── repositories
│   │   │   │   ├── routine_repository.dart
│   │   │   │   └── routine_repository.g.dart
│   │   │   └── sources
│   │   │       └── routine_local_source.dart
│   │   ├── domain
│   │   │   ├── entities
│   │   │   │   └── routine.dart
│   │   │   └── use_cases
│   │   │       ├── routine_display.dart
│   │   │       └── validate_routine_form.dart
│   │   └── presentation
│   │       ├── pages
│   │       │   ├── create_routine_screen.dart
│   │       │   ├── edit_routine_screen.dart
│   │       │   └── routine_list_screen.dart
│   │       └── widgets
│   │           ├── create_routine_button.dart
│   │           └── routine_card.dart
│   └── routine_exercise
│       ├── data
│       │   ├── repositories
│       │   │   ├── routine_exercise_repository.dart
│       │   │   └── routine_exercise_repository.g.dart
│       │   └── sources
│       │       └── routine_exercise_local_source.dart
│       ├── domain
│       │   ├── entities
│       │   │   ├── exercise_session_log.dart
│       │   │   └── routine_exercise.dart
│       │   └── use_cases
│       │       ├── exercise_stats.dart
│       │       └── validate_exercise_form.dart
│       └── presentation
│           ├── pages
│           │   ├── add_exercise_screen.dart
│           │   ├── edit_exercise_screen.dart
│           │   └── exercise_list_screen.dart
│           └── widgets
│               ├── add_exercise_button.dart
│               ├── exercise_form_fields.dart
│               ├── exercise_hero_header.dart
│               ├── exercise_list.dart
│               ├── exercise_tile.dart
│               └── timer_exercise_fields.dart
└── main.dart