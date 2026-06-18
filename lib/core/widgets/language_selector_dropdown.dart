import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class LanguageSelectorDropdown extends StatelessWidget {
  const LanguageSelectorDropdown({super.key});

  @override
  Widget build(BuildContext context) {
    return DropdownButton<Locale>(
      value: context.locale,
      icon: const Padding(
        padding: EdgeInsets.only(left: 4.0),
        child: Icon(Icons.language_rounded, size: 20),
      ),
      underline: const SizedBox(),
      alignment: Alignment.centerRight,
      onChanged: (Locale? newLocale) {
        if (newLocale != null) {
          context.setLocale(newLocale);
        }
      },
      items: const [
        DropdownMenuItem(
          value: Locale('en'),
          child: Text('EN', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
        ),
        DropdownMenuItem(
          value: Locale('uk'),
          child: Text('UA', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
        ),
        DropdownMenuItem(
          value: Locale('ru'),
          child: Text('RU', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
        ),
      ],
    );
  }
}
