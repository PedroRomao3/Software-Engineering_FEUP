import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_lobby/CustomUser.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('CustomUser tests', ()
  {
    test('Convert CustomUser to map', () {
      final birthday = DateTime(2023, 4, 20, 12, 0, 0);
      const discordId = 'discord123';
      const email = 'user@example.com';
      const isAdmin = true;
      const language = 'english';
      const username = 'user123';
      final ranks = [0, 0];

      final customUser = CustomUser(
        birthday,
        discordId,
        email,
        isAdmin,
        language,
        username,
        ranks,
      );

      final map = customUser.toMap();

      expect(map['username'], username);
      expect(map['email'], email);
      expect(map['isAdmin'], isAdmin);
      expect(map['discordId'], discordId);
      expect(map['birthday'], birthday);
      expect(map['language'], language);
      expect(map['ranks'], ranks);
    });

    test('Create CustomUser with all arguments', () {
      final birthday = DateTime(2023, 4, 20, 12, 0, 0);
      const discordId = 'discord123';
      const email = 'user@example.com';
      const isAdmin = true;
      const language = 'english';
      const username = 'user123';
      final ranks = [0, 0];

      final customUser = CustomUser(
        birthday,
        discordId,
        email,
        isAdmin,
        language,
        username,
        ranks,
      );

      expect(customUser.birthday, birthday);
      expect(customUser.discordId, discordId);
      expect(customUser.email, email);
      expect(customUser.isAdmin, isAdmin);
      expect(customUser.language, language);
      expect(customUser.username, username);
      expect(customUser.ranks, ranks);
    });

    test('Create CustomUser with info constructor', () {
      final birthday = DateTime(2023, 4, 20, 12, 0, 0);
      const discordId = 'discord123';
      const language = 'english';
      const username = 'user123';
      final ranks = [0, 0];

      final customUser = CustomUser.info(
        username,
        birthday,
        discordId,
        language,
        ranks,
      );

      expect(customUser.birthday, birthday);
      expect(customUser.discordId, discordId);
      expect(customUser.isAdmin, false);
      expect(customUser.language, language);
      expect(customUser.username, username);
      expect(customUser.ranks, ranks);
    });

    test('Create CustomUser with noArgs constructor', () {
      const username = 'user123';

      final customUser = CustomUser.noArgs(username);

      expect(customUser.birthday, DateTime(2023, 4, 20, 12, 0, 0));
      expect(customUser.discordId, '');
      expect(customUser.email, '');
      expect(customUser.isAdmin, false);
      expect(customUser.language, 'english');
      expect(customUser.username, username);
      expect(customUser.ranks, [0, 0]);
    });

    test('Create CustomUser with userEmail constructor', () {
      const username = 'user123';
      const email = 'user@example.com';

      final customUser = CustomUser.userEmail(username, email);

      expect(customUser.birthday, DateTime(2023, 4, 20, 12, 0, 0));
      expect(customUser.discordId, '');
      expect(customUser.email, email);
      expect(customUser.isAdmin, false);
      expect(customUser.language, 'english');
      expect(customUser.username, username);
      expect(customUser.ranks, [0, 0]);
    });

    test('Create CustomUser from map', () {
      final birthday = DateTime(2023, 4, 20, 12, 0, 0);
      const discordId = 'discord123';
      const email = 'user@example.com';
      const isAdmin = true;
      const language = 'english';
      const username = 'user123';
      final ranks = [0, 0];

      final map = {
        'username': username,
        'email': email,
        'isAdmin': isAdmin,
        'discordUserId': discordId,
        'birthday': Timestamp.fromDate(birthday),
        'language': language,
        'ranks': ranks,
      };

      final customUser = CustomUser.fromMap(map);

      expect(customUser.birthday, birthday);
      expect(customUser.discordId, discordId);
      expect(customUser.email, email);
      expect(customUser.isAdmin, isAdmin);
      expect(customUser.language, language);
      expect(customUser.username, username);
      expect(customUser.ranks, ranks);
    });
  });
}

