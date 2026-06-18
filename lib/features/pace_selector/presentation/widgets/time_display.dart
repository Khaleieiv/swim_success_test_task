import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../core/constants/swimmer_levels.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../generated/locale_keys.g.dart';

class TimeDisplay extends StatelessWidget {
  final int minutes;
  final int seconds;
  final ValueChanged<int> onMinutesChanged;
  final ValueChanged<int> onSecondsChanged;

  const TimeDisplay({
    super.key,
    required this.minutes,
    required this.seconds,
    required this.onMinutesChanged,
    required this.onSecondsChanged,
  });

  @override
  Widget build(BuildContext context) {
    const distance = '100M';
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _TimeDigitSelector(
              value: minutes,
              onChanged: onMinutesChanged,
              maxValue: PaceConstants.maxMinutes,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 16, right: 16, top: 52),
              child: Text(
                ':',
                style: context.textTheme.headlineMedium?.copyWith(
                  fontSize: 64,
                  color: context.colorScheme.onSurface,
                ),
              ),
            ),
            _TimeDigitSelector(
              value: seconds,
              onChanged: onSecondsChanged,
              maxValue: PaceConstants.maxSeconds,
            ),
          ],
        ),
        RichText(
          text: TextSpan(
            style: context.textTheme.bodyMedium?.copyWith(
              fontSize: 11,
              letterSpacing: 2,
              color: context.colorScheme.onSurfaceVariant,
            ),
            children: [
              TextSpan(text: 'MIN'),
              TextSpan(text: '    :    '),
              TextSpan(text: 'SEC'),
              TextSpan(text: '    /    '),
              TextSpan(text: distance),
            ],
          ),
        ),
      ],
    );
  }
}

class _TimeDigitSelector extends StatefulWidget {
  final int value;
  final ValueChanged<int> onChanged;
  final int maxValue;

  const _TimeDigitSelector({
    required this.value,
    required this.onChanged,
    required this.maxValue,
  });

  @override
  State<_TimeDigitSelector> createState() => _TimeDigitSelectorState();
}

class _TimeDigitSelectorState extends State<_TimeDigitSelector> {
  bool _isEditing = false;
  late TextEditingController _controller;
  late FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.value.toString().padLeft(2, '0'));
    _focusNode = FocusNode();
    _focusNode.addListener(() {
      if (!_focusNode.hasFocus) {
        _saveEdit();
      }
    });
  }

  @override
  void didUpdateWidget(covariant _TimeDigitSelector oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.value != widget.value) {
      _controller.text = widget.value.toString().padLeft(2, '0');
      if (_isEditing) {
        setState(() {
          _isEditing = false;
        });
        _focusNode.unfocus();
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _saveEdit() {
    setState(() {
      _isEditing = false;
    });
    final val = int.tryParse(_controller.text);
    if (val != null) {
      final clampedVal = val.clamp(0, widget.maxValue);
      widget.onChanged(clampedVal);
      _controller.text = clampedVal.toString().padLeft(2, '0');
    } else {
      _controller.text = widget.value.toString().padLeft(2, '0');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          onPressed: () {
            if (widget.value < widget.maxValue) {
              widget.onChanged(widget.value + 1);
            }
          },
          icon: Icon(
            Icons.keyboard_arrow_up_rounded,
            size: 40,
            color: context.colorScheme.onSurfaceVariant,
          ),
          splashRadius: 24,
        ),
        GestureDetector(
          onTap: () {
            setState(() {
              _isEditing = true;
            });
            _focusNode.requestFocus();
          },
          child: SizedBox(
            width: 100,
            height: 90,
            child: Center(
              child: _isEditing
                  ? TextField(
                      controller: _controller,
                      focusNode: _focusNode,
                      keyboardType: TextInputType.number,
                      textAlign: TextAlign.center,
                      maxLength: 2,
                      autofocus: true,
                      style: context.textTheme.headlineMedium?.copyWith(
                        fontSize: 64,
                        color: context.colorScheme.onSurface,
                      ),
                      decoration: const InputDecoration(
                        counterText: '',
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.zero,
                      ),
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                      ],
                      onChanged: (text) {
                        if (text.isEmpty) return;
                        final val = int.tryParse(text);
                        if (val != null && val > widget.maxValue) {
                          _controller.text = widget.maxValue.toString().padLeft(2, '0');
                          _controller.selection = TextSelection.fromPosition(
                            TextPosition(offset: _controller.text.length),
                          );
                        }
                      },
                      onSubmitted: (_) => _saveEdit(),
                    )
                  : Text(
                      widget.value.toString().padLeft(2, '0'),
                      style: context.textTheme.headlineMedium?.copyWith(
                        fontSize: 64,
                        color: context.colorScheme.onSurface,
                      ),
                    ),
            ),
          ),
        ),
        IconButton(
          onPressed: () {
            if (widget.value > 0) {
              widget.onChanged(widget.value - 1);
            }
          },
          icon: Icon(
            Icons.keyboard_arrow_down_rounded,
            size: 40,
            color: context.colorScheme.onSurfaceVariant,
          ),
          splashRadius: 24,
        ),
      ],
    );
  }
}
