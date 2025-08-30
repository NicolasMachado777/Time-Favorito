class Team {
final int id;
final String name;
final String logo;
Team({required this.id, required this.name, required
this.logo});
factory Team.fromJson(Map<String, dynamic> json) =>
Team(
 id: json['id'] as int,
 name: json['name'] as String,
 logo: json['logo'] as String,
 );
Map<String, dynamic> toJson() => {'id': id, 'name':
name, 'logo': logo};
}