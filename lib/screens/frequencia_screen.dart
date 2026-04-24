import 'package:flutter/material.dart';
import '../models/aluno_model.dart';
import '../services/pdf_service.dart';
import '../services/import_service.dart';
import '../database/database_helper.dart';

class FrequenciaScreen extends StatefulWidget {
  const FrequenciaScreen({super.key});

  @override
  State<FrequenciaScreen> createState() => _FrequenciaScreenState();
}

class _FrequenciaScreenState extends State<FrequenciaScreen> {
  final DatabaseHelper _dbHelper = DatabaseHelper();
  List<Aluno> _alunos = [];
  List<Aluno> _alunosFiltrados = [];
  bool _loading = true;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _atualizarLista();
  }

  // Carrega os alunos do banco de dados real
  Future<void> _atualizarLista() async {
    setState(() => _loading = true);
    final dados = await _dbHelper.fetchAlunos();
    setState(() {
      _alunos = dados;
      _alunosFiltrados = dados;
      _loading = false;
    });
  }

  // Filtra a lista conforme a busca por nome
  void _filtrarAlunos(String query) {
    setState(() {
      _alunosFiltrados = _alunos
          .where((aluno) => aluno.nome.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Frequência Escolar - SEMEC'),
        backgroundColor: const Color(0xFF004A99),
        foregroundColor: Colors.white,
        actions: [
          // ESTE É O BOTÃO DE UPLOAD (EXCEL)
          IconButton(
            tooltip: "Importar do Excel (.xlsx)",
            icon: const Icon(Icons.upload_file),
            onPressed: () async {
              await ImportService.importarAlunos();
              _atualizarLista(); // Recarrega a lista após importar
            },
          ),
          // Botão de Adicionar Manual (O que você já tem)
          IconButton(
            tooltip: "Adicionar Aluno Manual",
            icon: const Icon(Icons.person_add),
            onPressed: () async {
              await _dbHelper.insertAluno({
                'nome': 'Aluno Teste ${DateTime.now().second}',
                'matricula': '2026${_alunos.length + 100}',
                'presenca': 0
              });
              _atualizarLista();
            },
          ),
          // Botão de Atualizar
          IconButton(
            tooltip: "Recarregar Lista",
            icon: const Icon(Icons.refresh),
            onPressed: _atualizarLista,
          ),
        ],
      ),

      body: Column(
        children: [
          // Barra de Busca
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              onChanged: _filtrarAlunos,
              decoration: InputDecoration(
                labelText: 'Pesquisar por nome do aluno...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                filled: true,
                fillColor: Colors.grey[100],
              ),
            ),
          ),
          
          // Lista de Alunos
          Expanded(
            child: _loading
                ? const Center(child: CircularProgressIndicator())
                : _alunosFiltrados.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.person_off, size: 64, color: Colors.grey[400]),
                            const SizedBox(height: 16),
                            Text(
                              "Nenhum aluno encontrado.",
                              style: TextStyle(color: Colors.grey[600], fontSize: 18),
                            ),
                          ],
                        ),
                      )
                    : ListView.separated(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        itemCount: _alunosFiltrados.length,
                        separatorBuilder: (context, index) => const Divider(),
                        itemBuilder: (context, index) {
                          final aluno = _alunosFiltrados[index];
                          return ListTile(
                            contentPadding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                            leading: CircleAvatar(
                              backgroundColor: aluno.presente ? Colors.green[100] : Colors.blue[100],
                              child: Text(
                                aluno.nome[0].toUpperCase(),
                                style: TextStyle(color: aluno.presente ? Colors.green[800] : Colors.blue[800]),
                              ),
                            ),
                            title: Text(
                              aluno.nome,
                              style: const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            subtitle: Text('Matrícula: ${aluno.matricula}'),
                            trailing: Transform.scale(
                              scale: 1.2,
                              child: Checkbox(
                                value: aluno.presente,
                                activeColor: Colors.green[700],
                                onChanged: (bool? value) async {
                                  if (aluno.id != null) {
                                    await _dbHelper.alternarPresenca(aluno.id!, value!);
                                    _atualizarLista(); // Sincroniza com o banco
                                  }
                                },
                              ),
                            ),
                          );
                        },
                      ),
          ),
        ],
      ),
      
      // Botão de PDF
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          if (_alunos.isEmpty) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("A lista está vazia para gerar o PDF.")),
            );
            return;
          }
          PdfService.gerarRelatorioFrequencia(_alunos);
        },
        label: const Text('Exportar PDF'),
        icon: const Icon(Icons.picture_as_pdf),
        backgroundColor: Colors.red[800],
        foregroundColor: Colors.white,
      ),
    );
  }
}