import 'package:flutter/material.dart';
import 'package:times/data/user_settings_repository.dart';
import 'package:times/model/team.dart';
import 'package:times/routes.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // Cria a instancia do repositorio
  final userSettingsRepository = UserSettingsRepository();

  // Cria a instancia do repositorio
  Future<Team?>? _future;

  @override
  void initState() {
    super.initState();
    _reload();
  }

  void _reload() {
    _future = userSettingsRepository.getTeam();
  }

  Future<void> _goSelect() async {
    await Navigator.pushNamed(context, Routes.select);
    setState(_reload);
  }

  Future<void> _removeFavorite() async {
    await userSettingsRepository.clearTeam();
    setState(_reload);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Meu Time Favorito'),
        actions: [
          IconButton(
            tooltip: 'Trocar time',
            icon: const Icon(Icons.swap_horiz),
            onPressed: _goSelect,
          ),
        ],
      ),
      body: FutureBuilder<Team?>(
        future: _future,
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }
          final team = snapshot.data;
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(
              child: Column(
                children: [
                  Card(
                    elevation: 2,
                    clipBehavior: Clip.antiAlias,
                    child: InkWell(
                      onTap: _goSelect,
                      child: Stack(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Image.asset(
                              team == null
                                  ? 'assets/images/generico.png'
                                  : team.logo,
                              width: 160,
                              height: 160,
                              fit: BoxFit.contain,
                            ),
                          ),
                          if (team != null)
                            Positioned(
                              top: 8,
                              right: 8,
                              child: Container(
                                padding: EdgeInsets.all(4.0),
                                decoration: const BoxDecoration(
                                  color: Colors.black54,
                                  shape: BoxShape.circle,
                                ),
                                child: IconButton(
                                  icon: const Icon(
                                    Icons.delete,
                                    color: Colors.white,
                                    size: 18,
                                  ),
                                  padding: EdgeInsets.zero,
                                  constraints: const BoxConstraints(),
                                  onPressed: _removeFavorite,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    team == null
                        ? 'Você ainda não escolheu seu time\nfavorito.\nClique na imagem acima.'
                        : team.name,
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 16),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
