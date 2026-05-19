import 'package:flutter/material.dart';
import 'package:mobile_frontend/common/widgets/empty_state_widget.dart';
import 'package:mobile_frontend/common/widgets/kinetic_app_bar.dart';

class StretchScreen extends StatelessWidget {
  const StretchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: KineticAppBar(),
      body: EmptyStateWidget(
        icon: Icons.self_improvement_outlined,
        title: 'Coming Soon',
        subtitle:
            'Stretching content is under development.\nStay tuned for updates.',
      ),
    );
  }
}
