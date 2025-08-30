
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

import '../model/team.dart';

class UserSettingsRepository {
  static const _key = 'favorite_team';

  Future<Team?> getTeam() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonStr = prefs.getString(_key);
    if (jsonStr == null) return null;
    try {
      final map = jsonDecode(jsonStr) as Map<String, dynamic>;
      return Team.fromJson(map);
    } catch (_) {
      return null;
    }
  }

  Future<void> setTeam(Team team) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_key, jsonEncode(team.toJson()));
  }

  Future<void> clearTeam() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_key);
  }
}
