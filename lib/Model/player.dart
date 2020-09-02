class Player {
  String name;
  int points;
  String time;

  static Player fromJson(Map<String, dynamic> json) {
    var player = new Player();

    player.name = json['name'];
    player.points = int.tryParse(json['points']);
    player.time = json['time'];

    return player;
  }

  Map<String, dynamic> toJson() => {
        'name': name,
        'points': points.toString(),
        'time': time.toString(),
      };
}
