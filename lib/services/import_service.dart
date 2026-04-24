import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:excel/excel.dart';
import '../database/database_helper.dart';

class ImportService {
  static Future<void> importarAlunos() async {
    try {
      // Abre a janela para escolher o arquivo Excel
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['xlsx'],
      );

      if (result != null && result.files.single.path != null) {
        var bytes = File(result.files.single.path!).readAsBytesSync();
        var excel = Excel.decodeBytes(bytes);
        final db = DatabaseHelper();

        for (var table in excel.tables.keys) {
          var rows = excel.tables[table]!.rows;
          // Pula o cabeçalho (Linha 1)
          for (var i = 1; i < rows.length; i++) {
            var row = rows[i];
            // Verifica se a primeira célula (Nome) não está vazia
            if (row.isNotEmpty && row[0] != null) {
              await db.insertAluno({
                'nome': row[0]?.value.toString() ?? 'Sem Nome',
                'matricula': row.length > 1 ? row[1]?.value.toString() ?? 'S/M' : 'S/M',
                'presenca': 0
              });
            }
          }
        }
        print("Importação concluída com sucesso!");
      }
    } catch (e) {
      print("Erro ao importar Excel: $e");
    }
  }
}