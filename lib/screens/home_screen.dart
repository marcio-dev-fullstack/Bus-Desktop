import 'package:flutter/material.dart';
import '../database/database_helper.dart';
import 'frequencia_screen.dart'; // Certifique-se de que este arquivo existe
import '../services/pdf_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _alunosTotal = 0;
  int _presenteshoje = 0;

  @override
  void initState() {
    super.initState();
    _carregarEstatisticas();
  }

  // Carrega os números para o Dashboard da SEMEC
  Future<void> _carregarEstatisticas() async {
    final db = DatabaseHelper();
    final alunos = await db.fetchAlunos();
    if (mounted) {
      setState(() {
        _alunosTotal = alunos.length;
        _presenteshoje = alunos.where((a) => a.presente).length;
      });
    }
  }

  // Função de Logout para segurança dos dados
  void _confirmarSaida() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Encerrar Sessão'),
        content: const Text('Deseja realmente sair do sistema BusEscolar?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('CANCELAR'),
          ),
          ElevatedButton(
            onPressed: () {
              // Retorna para a tela de login e limpa a pilha de navegação
              Navigator.pushReplacementNamed(context, '/login');
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('SAIR', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard - BusEscolar'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _carregarEstatisticas,
            tooltip: 'Atualizar Dados',
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: _confirmarSaida,
            tooltip: 'Sair',
          ),
          const SizedBox(width: 10),
        ],
      ),
      body: Row(
        children: [
          // Menu Lateral de Navegação
          NavigationRail(
            selectedIndex: 0,
            extended: true,
            onDestinationSelected: (int index) {
              if (index == 1) {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const FrequenciaScreen()),
                ).then((_) => _carregarEstatisticas());
              }
            },
            destinations: const [
              NavigationRailDestination(
                icon: Icon(Icons.dashboard),
                label: Text('Início'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.how_to_reg),
                label: Text('Frequência'),
              ),
            ],
          ),
          const VerticalDivider(thickness: 1, width: 1),
          
          // Área de Conteúdo Principal
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Monitoramento SEMEC - CDA',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 30),
                  
                  // Cards de Estatísticas
                  Row(
                    children: [
                      _buildStatCard(
                        'Total de Alunos',
                        '$_alunosTotal',
                        Icons.people,
                        Colors.blue.shade800,
                      ),
                      const SizedBox(width: 20),
                      _buildStatCard(
                        'Presentes no Ônibus',
                        '$_presenteshoje',
                        Icons.directions_bus,
                        Colors.green.shade800,
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 40),
                  const Text(
                    'Ações Rápidas',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 20),
                  
                  Wrap(
                    spacing: 20,
                    children: [
                      ElevatedButton.icon(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const FrequenciaScreen()),
                          ).then((_) => _carregarEstatisticas());
                        },
                        icon: const Icon(Icons.list_alt),
                        label: const Text('Abrir Lista de Chamada'),
                        style: ElevatedButton.styleFrom(padding: const EdgeInsets.all(20)),
                      ),
                      OutlinedButton.icon(
                        onPressed: () async {
                          final db = DatabaseHelper();
                          final alunos = await db.fetchAlunos();
                          await PdfService.gerarRelatorioFrequencia(alunos);
                        },
                        icon: const Icon(Icons.picture_as_pdf),
                        label: const Text('Gerar Relatório Diário'),
                        style: OutlinedButton.styleFrom(padding: const EdgeInsets.all(20)),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon, Color color) {
    return Container(
      width: 250,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 4, offset: Offset(2, 2))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: Colors.white, size: 40),
          const SizedBox(height: 15),
          Text(title, style: const TextStyle(color: Colors.white70, fontSize: 16)),
          Text(value, style: const TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}