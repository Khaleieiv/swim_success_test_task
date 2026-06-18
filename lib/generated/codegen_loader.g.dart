// DO NOT EDIT. This is code generated via package:easy_localization/generate.dart

// ignore_for_file: prefer_single_quotes, avoid_renaming_method_parameters, constant_identifier_names

import 'dart:ui';

import 'package:easy_localization/easy_localization.dart' show AssetLoader;

class CodegenLoader extends AssetLoader{
  const CodegenLoader();

  @override
  Future<Map<String, dynamic>?> load(String path, Locale locale) {
    return Future.value(mapLocales[locale.toString()]);
  }

  static const Map<String,dynamic> _en = {
  "pace_selector": {
    "title": "What's your fastest 100m freestyle?",
    "subtitle": "This helps us build a more accurate plan for you.",
    "pace": "YOUR PACE",
    "min": "MIN",
    "sec": "SEC",
    "level_prefix": "THAT PUTS YOU AT",
    "tab_title": "Pace",
    "levels": {
      "beginner": "Beginner",
      "intermediate": "Intermediate",
      "advanced": "Advanced",
      "elite": "Elite"
    },
    "continue": "Continue",
    "skip": "I don't know my pace, skip this",
    "loading": "Loading...",
    "submit_success": "Pace submitted successfully!",
    "network_error": "Network error occurred!"
  },
  "user_list": {
    "title": "Users",
    "tab_title": "Users",
    "search_placeholder": "Search by name...",
    "email": "Email",
    "phone": "Phone",
    "website": "Website",
    "company": "Company",
    "address": "Address",
    "no_users": "No users found",
    "retry": "Retry",
    "catch_phrase": "Catch Phrase",
    "business": "Business",
    "contact_info": "Contact Info",
    "street": "Street",
    "city": "City",
    "zipcode": "Zipcode",
    "coordinates": "Coordinates",
    "company_name": "Company Name",
    "lat": "Lat",
    "lng": "Lng",
    "error_loading_details": "Error loading details"
  }
};
static const Map<String,dynamic> _ru = {
  "pace_selector": {
    "title": "Какой твой самый быстрый результат на 100м вольным стилем?",
    "subtitle": "Это помогает нам составить более точный план для тебя.",
    "pace": "ТВОЙ ТЕМП",
    "min": "МИН",
    "sec": "СЕК",
    "level_prefix": "ЭТО ОПРЕДЕЛЯЕТ ТЕБЯ КАК",
    "tab_title": "Темп",
    "levels": {
      "beginner": "Новичок",
      "intermediate": "Средний уровень",
      "advanced": "Продвинутый уровень",
      "elite": "Элита"
    },
    "continue": "Продолжить",
    "skip": "Я не знаю своего темпа, пропустить",
    "loading": "Загрузка...",
    "submit_success": "Темп успешно отправлен!",
    "network_error": "Произошла ошибка сети!"
  },
  "user_list": {
    "title": "Пользователи",
    "tab_title": "Пользователи",
    "search_placeholder": "Поиск по имени...",
    "email": "Эл. почта",
    "phone": "Телефон",
    "website": "Сайт",
    "company": "Компания",
    "address": "Адрес",
    "no_users": "Пользователей не найдено",
    "retry": "Повторить",
    "catch_phrase": "Девиз",
    "business": "Сфера",
    "contact_info": "Контактная информация",
    "street": "Улица",
    "city": "Город",
    "zipcode": "Почтовый индекс",
    "coordinates": "Координаты",
    "company_name": "Название компании",
    "lat": "Шир",
    "lng": "Долг",
    "error_loading_details": "Ошибка загрузки деталей"
  }
};
static const Map<String,dynamic> _uk = {
  "pace_selector": {
    "title": "Який твій найшвидший результат на 100м вільним стилем?",
    "subtitle": "Це допомагает нам скласти точніший план для тебе.",
    "pace": "ТВІЙ ТЕМП",
    "min": "ХВ",
    "sec": "СЕК",
    "level_prefix": "ЦЕ ВИЗНАЧАЄ ТЕБЕ ЯК",
    "tab_title": "Темп",
    "levels": {
      "beginner": "Початківець",
      "intermediate": "Середній рівень",
      "advanced": "Просунутий рівень",
      "elite": "Еліта"
    },
    "continue": "Продовжити",
    "skip": "Я не знаю свого темпу, пропустити",
    "loading": "Завантаження...",
    "submit_success": "Темп успішно надіслано!",
    "network_error": "Сталася помилка мережі!"
  },
  "user_list": {
    "title": "Користувачі",
    "tab_title": "Користувачі",
    "search_placeholder": "Пошук за ім'ям...",
    "email": "Ел. пошта",
    "phone": "Телефон",
    "website": "Сайт",
    "company": "Компанія",
    "address": "Адреса",
    "no_users": "Користувачів не знайдено",
    "retry": "Повторити",
    "catch_phrase": "Девіз",
    "business": "Сфера",
    "contact_info": "Контактна інформація",
    "street": "Вулиця",
    "city": "Місто",
    "zipcode": "Поштовий індекс",
    "coordinates": "Координати",
    "company_name": "Назва компанії",
    "lat": "Шир",
    "lng": "Довг",
    "error_loading_details": "Помилка завантаження деталей"
  }
};
static const Map<String, Map<String,dynamic>> mapLocales = {"en": _en, "ru": _ru, "uk": _uk};
}
