import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class NotificationsProvider with ChangeNotifier {
  List<RemoteMessage> _messages = [];

  NotificationsProvider() {
    loadMessages();
  }

  List<RemoteMessage> get messages => _messages;

  void addMessage(RemoteMessage message) {
    _messages.add(message);
    saveMessages();
    notifyListeners();
  }

  void loadMessages() async {
    final prefs = await SharedPreferences.getInstance();
    final messagesData = prefs.getStringList('notifications') ?? [];
    _messages = messagesData
        .map((e) =>
            RemoteMessage.fromMap(Map<String, dynamic>.from(jsonDecode(e))))
        .toList();
    notifyListeners();
  }

  void saveMessages() async {
    final prefs = await SharedPreferences.getInstance();
    final messagesData = _messages.map((e) => jsonEncode(e.toMap())).toList();
    prefs.setStringList('notifications', messagesData);
  }
}
