import 'dart:ui';
import 'package:flutter/material.dart';
// import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

class KineticAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool showBackButton;
  final VoidCallback? onBackPressed;
  final List<Widget>? actions;

  /// When the default profile avatar is shown, called on tap. Defaults to
  /// opening `/sign-in`.
  final VoidCallback? onProfileTap;

  const KineticAppBar({
    super.key,
    this.title = 'KINETIC',
    this.showBackButton = false,
    this.onBackPressed,
    this.actions,
    this.onProfileTap,
  });

  @override
  Size get preferredSize => const Size.fromHeight(64);

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return ClipRRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
        child: Container(
          color: cs.surface.withValues(alpha: 0.8),
          child: SafeArea(
            bottom: false,
            child: SizedBox(
              height: 64,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    if (showBackButton)
                      GestureDetector(
                        onTap:
                            onBackPressed ?? () => Navigator.of(context).pop(),
                        child: Icon(
                          Icons.arrow_back_ios_new,
                          size: 20,
                          color: cs.onSurface,
                        ),
                      )
                    else
                      // Icon(Icons.menu, color: cs.onSurface), // TODO: Add menu feature
                      SizedBox(width: 24),
                    Text(
                      title,
                      style: GoogleFonts.inter(
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                        letterSpacing: -0.5,
                        color: cs.onSurface,
                      ),
                    ),
                    if (actions != null)
                      Row(children: actions!)
                    else
                      // InkWell(
                      //   onTap: onProfileTap ?? () => context.push('/sign-in'),
                      //   customBorder: const CircleBorder(),
                      //   child: CircleAvatar(
                      //     radius: 16,
                      //     backgroundColor: cs.surfaceContainerHighest,
                      //     child: Icon(
                      //       Icons.person,
                      //       size: 18,
                      //       color: cs.onSurfaceVariant,
                      //     ),
                      //   ),
                      // ),
                      SizedBox(width: 24),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
