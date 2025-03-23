import 'dart:io';
import 'dart:math';

// 캐릭터 클래스
class Character {
  String name;
  int health;
  int attack;
  int defense;

  Character(this.name, this.health, this.attack, this.defense);

  void attackMonster(Monster monster) {
    monster.health -= attack;
    print('$name 이(가) ${monster.name}에게 $attack 데미지를 입혔습니다.');
  }

  void defend(int damage) {
    print('$name 이(가) 방어 자세를 취합니다.');
    health += damage;
    print('$damage 만큼 체력을 회복했습니다!');
  }

  void showStatus() {
    print('\n[$name] 체력: $health | 공격력: $attack | 방어력: $defense');
  }
}

// 몬스터 클래스
class Monster {
  String name;
  int health;
  int maxAttack;
  int attack;
  int defense = 0;

  Monster(this.name, this.health, this.maxAttack, int characterDefense) {
    attack = max(characterDefense, Random().nextInt(maxAttack + 1));
  }

  void attackCharacter(Character character) {
    int damage = max(0, attack - character.defense);
    character.health -= damage;
    print('$name 이(가) ${character.name}에게 $damage 데미지를 입혔습니다!');
  }

  void showStatus() {
    print('[$name] 체력: $health | 공격력: $attack');
  }
}

// 게임 클래스
class Game {
  Character character;
  List<Monster> monsters = [];
  int defeated = 0;

  Game() : character = Character('', 0, 0, 0);

  void startGame() {
    _loadCharacterStats();
    _loadMonsterStats();

    print('\n게임을 시작합니다!');
    while (character.health > 0 && defeated < monsters.length) {
      Monster monster = getRandomMonster();
      print('\n새로운 몬스터가 등장했습니다!');
      monster.showStatus();

      while (character.health > 0 && monster.health > 0) {
        character.showStatus();
        print('행동을 선택하세요: 공격(1), 방어(2)');
        String? input = stdin.readLineSync();

        if (input == '1') {
          character.attackMonster(monster);
        } else if (input == '2') {
          monster.attackCharacter(character);
          character.defend(monster.attack - character.defense);
          continue;
        } else {
          print('잘못된 입력입니다.');
          continue;
        }

        if (monster.health > 0) {
          monster.attackCharacter(character);
        }
      }

      if (character.health <= 0) {
        print('\n당신은 쓰러졌습니다. 게임 오버!');
        _saveResult('패배');
        break;
      }

      print('${monster.name} 을(를) 물리쳤습니다!');
      monsters.remove(monster);
      defeated++;

      if (defeated == 3) {
        print('\n모든 몬스터를 물리쳤습니다! 당신의 승리입니다!');
        _saveResult('승리');
        break;
      }

      print('다음 몬스터와 대결하시겠습니까? (y/n)');
      String? next = stdin.readLineSync();
      if (next?.toLowerCase() != 'y') {
        print('게임을 종료합니다.');
        _saveResult('도중 종료');
        break;
      }
    }
  }

  Monster getRandomMonster() {
    return monsters[Random().nextInt(monsters.length)];
  }

  void _loadCharacterStats() {
    try {
      final file = File('characters.txt');
      final contents = file.readAsStringSync().trim();
      final stats = contents.split(',');

      if (stats.length != 3) throw FormatException('Invalid character data');

      print('캐릭터 이름을 입력하세요 (한글/영문만):');
      String? name = stdin.readLineSync();
      if (name == null || !RegExp(r'^[a-zA-Z가-힣]+$').hasMatch(name)) {
        print('이름이 유효하지 않습니다.');
        exit(1);
      }

      character = Character(
        name,
        int.parse(stats[0]),
        int.parse(stats[1]),
        int.parse(stats[2]),
      );
    } catch (e) {
      print('캐릭터 데이터를 불러오는 데 실패했습니다: $e');
      exit(1);
    }
  }

  void _loadMonsterStats() {
    try {
      final file = File('monsters.txt');
      final lines = file.readAsLinesSync();

      for (var line in lines) {
        final parts = line.split(',');
        if (parts.length != 3) continue;
        String name = parts[0];
        int health = int.parse(parts[1]);
        int maxAtk = int.parse(parts[2]);
        monsters.add(Monster(name, health, maxAtk, character.defense));
      }
    } catch (e) {
      print('몬스터 데이터를 불러오는 데 실패했습니다: $e');
      exit(1);
    }
  }

  void _saveResult(String result) {
    print('결과를 저장하시겠습니까? (y/n)');
    String? input = stdin.readLineSync();
    if (input?.toLowerCase() == 'y') {
      final file = File('result.txt');
      file.writeAsStringSync(
        '캐릭터 이름: ${character.name}\n남은 체력: ${character.health}\n게임 결과: $result',
      );
      print('결과가 result.txt에 저장되었습니다.');
    }
  }
}

// main 함수
void main() {
  Game game = Game();
  game.startGame();
}
