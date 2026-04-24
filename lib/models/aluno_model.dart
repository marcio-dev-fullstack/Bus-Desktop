class Aluno {
  final int? id;
  final String nome;
  final String matricula;
  final bool presente;
  final String? dataHoraPresenca;

  Aluno({
    this.id,
    required this.nome,
    required this.matricula,
    this.presente = false,
    this.dataHoraPresenca,
  });

  // Converte um Aluno num Map para inserir no SQLite
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nome': nome,
      'matricula': matricula,
      'presenca': presente ? 1 : 0,
      'data_hora_presenca': dataHoraPresenca,
    };
  }

  // Cria um objeto Aluno a partir de um Map vindo do SQLite
  factory Aluno.fromMap(Map<String, dynamic> map) {
    return Aluno(
      id: map['id'] as int?,
      nome: map['nome'] as String? ?? 'Sem Nome',
      matricula: map['matricula'] as String? ?? 'S/M',
      presente: (map['presenca'] as int?) == 1,
      dataHoraPresenca: map['data_hora_presenca'] as String?,
    );
  }

  // Método auxiliar para formatar a data/hora de forma legível no PDF ou na tela
  String get dataHoraFormatada {
    if (dataHoraPresenca == null) return "---";
    try {
      DateTime dt = DateTime.parse(dataHoraPresenca!);
      return "${dt.day.toString().padLeft(2, '0')}/${dt.month.toString().padLeft(2, '0')} ${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}";
    } catch (e) {
      return "Erro na data";
    }
  }
}