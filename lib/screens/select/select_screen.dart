import 'package:flutter/material.dart';
import 'package:times/data/teams_repository.dart';
import 'package:times/data/user_settings_repository.dart';
import 'package:times/model/team.dart';

class SelectScreen extends StatelessWidget {
  const SelectScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Cria a instancia do repositorio
    final userSettingsRepository = UserSettingsRepository();
    // Cria a instancia do repositorio
    final teamsRepository = TeamsRepository();

    return Scaffold(
      appBar: AppBar(title: const Text('Escolha seu time')),
      body: FutureBuilder<List<Team>>(
        future: teamsRepository.load(),
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(
              child: Text('Erro ao carregar times: ${snapshot.error}'),
            );
          }
          final teams = snapshot.data ?? [];
          if (teams.isEmpty) {
            return const Center(child: Text('Nenhum time encontrado.'));
          }
          return ListView.separated(
            padding: const EdgeInsets.all(12),
            itemCount: teams.length,
            separatorBuilder: (_, __) => const SizedBox(height: 8),
            itemBuilder: (context, index) {
              final t = teams[index];
              return Card(
                clipBehavior: Clip.antiAlias,
                child: InkWell(
                  onTap: () async {
                    await userSettingsRepository.setTeam(t);
                    if (context.mounted) Navigator.pop(context);
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Row(
                      children: [
                        Image.asset(
                          t.logo,
                          width: 56,
                          height: 56,
                          fit: BoxFit.contain,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            t.name,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        const Icon(Icons.chevron_right),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
