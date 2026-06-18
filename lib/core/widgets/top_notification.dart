import 'dart:async';
import 'package:flutter/material.dart';
import 'package:swim_success/core/constants/app_colors.dart';

enum TopNotificationType {
  success(
    color: AppColors.successStatus,
    icon: Icons.check_circle_outline_rounded,
  ),
  error(
    color: AppColors.errorStatus,
    icon: Icons.error_outline_rounded,
  );

  const TopNotificationType({required this.color, required this.icon});

  final Color color;
  final IconData icon;
}

void showTopNotification(
    BuildContext context,
    String message, {
      TopNotificationType type = TopNotificationType.success,
    }) {
  final overlay = Overlay.of(context);
  late OverlayEntry entry;
  Timer? timer;

  void dismiss() {
    timer?.cancel();
    if (entry.mounted) entry.remove();
  }

  entry = OverlayEntry(
    builder: (context) => _TopNotificationWidget(
      message: message,
      type: type,
      onDismiss: dismiss,
    ),
  );

  overlay.insert(entry);
  timer = Timer(const Duration(seconds: 3), dismiss);
}

class _TopNotificationWidget extends StatefulWidget {
  const _TopNotificationWidget({
    required this.message,
    required this.type,
    required this.onDismiss,
  });

  final String message;
  final TopNotificationType type;
  final VoidCallback onDismiss;

  @override
  State<_TopNotificationWidget> createState() => _TopNotificationWidgetState();
}

class _TopNotificationWidgetState extends State<_TopNotificationWidget> with SingleTickerProviderStateMixin {
  late final _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 350),
  )..forward();

  late final _slideAnimation = Tween<Offset>(
    begin: const Offset(0.0, -1.5),
    end: Offset.zero,
  ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutBack));

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _dismiss() {
    _controller.reverse().then((_) {
      if (mounted) widget.onDismiss();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: MediaQuery.of(context).padding.top + 16,
      left: 16,
      right: 16,
      child: SlideTransition(
        position: _slideAnimation,
        child: Material(
          color: Colors.transparent,
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: widget.type.color,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.25),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              child: Row(
                children: [
                  Icon(widget.type.icon, color: Colors.white, size: 22),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      widget.message,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton(
                    icon: const Icon(Icons.close_rounded, color: Colors.white70, size: 20),
                    onPressed: _dismiss,
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                    splashRadius: 16,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
