import 'dart:io';
import 'package:intl/intl.dart'; 
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:file_picker/file_picker.dart';
import '../models/aluno_model.dart';

class PdfService {
  static Future<void> gerarRelatorioFrequencia(List<Aluno> alunos) async {
    final pdf = pw.Document();
    final DateTime agora = DateTime.now();
    final String dataHoraRodape = DateFormat('dd/MM/yyyy HH:mm:ss').format(agora);

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(32),
        footer: (pw.Context context) {
          return pw.Container(
            alignment: pw.Alignment.centerRight,
            margin: const pw.EdgeInsets.only(top: 10),
            child: pw.Text(
              "Documento gerado pelo sistema BusEscolar - $dataHoraRodape",
              style: const pw.TextStyle(fontSize: 8, color: PdfColors.grey600),
            ),
          );
        },
        build: (pw.Context context) {
          return [
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text("PREFEITURA DE CONCEICAO DO ARAGUAIA",
                        style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 14)),
                    pw.Text("SECRETARIA MUNICIPAL DE EDUCACAO - SEMEC",
                        style: pw.TextStyle(fontSize: 12)),
                    pw.Text("Sistema BusEscolar - Monitoramento de Transporte",
                        style: pw.TextStyle(fontSize: 10, color: PdfColors.grey700)),
                  ],
                ),
                pw.Text(DateFormat('dd/MM/yyyy').format(agora), style: const pw.TextStyle(fontSize: 10)),
              ],
            ),
            pw.SizedBox(height: 10),
            pw.Divider(thickness: 1),
            pw.SizedBox(height: 20),
            pw.Center(
              child: pw.Text("RELATORIO DE FREQUENCIA DOS ALUNOS",
                  style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 16)),
            ),
            pw.SizedBox(height: 20),
            pw.TableHelper.fromTextArray(
              border: pw.TableBorder.all(color: PdfColors.grey300),
              headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold, color: PdfColors.white),
              headerDecoration: const pw.BoxDecoration(color: PdfColors.blueGrey800),
              headers: ['Matricula', 'Nome do Aluno', 'Presenca', 'Horario de Embarque'],
              data: alunos.map((a) => [
                a.matricula,
                a.nome,
                a.presente ? "SIM" : "NAO",
                a.presente ? a.dataHoraFormatada : "---" 
              ]).toList(),
            ),
          ];
        },
      ),
    );

    try {
      String? outputFile = await FilePicker.platform.saveFile(
        dialogTitle: 'Salvar Relatório BusEscolar',
        fileName: 'Relatorio_BusEscolar_CDA_${agora.millisecondsSinceEpoch}.pdf',
        type: FileType.custom,
        allowedExtensions: ['pdf'],
      );

      if (outputFile != null) {
        final file = File(outputFile);
        await file.writeAsBytes(await pdf.save());
      }
    } catch (e) {
      print("Erro ao salvar o PDF: $e");
    }
  }
}