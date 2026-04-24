import 'dart:io';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/foundation.dart' show kIsWeb; 
import '../models/aluno_model.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  static Database? _database;

  factory DatabaseHelper() => _instance;
  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    // PROTEÇÃO PARA WEB: Impede que o driver de Windows trave o navegador
    if (!kIsWeb && Platform.isWindows) {
      sqfliteFfiInit();
      databaseFactory = databaseFactoryFfi;
    }

    String path;
    if (kIsWeb) {
      path = 'bus_cda_web.db';
    } else {
      Directory documentsDirectory = await getApplicationDocumentsDirectory();
      path = join(documentsDirectory.path, 'bus_cda.db');
    }

    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE alunos (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        nome TEXT NOT NULL,
        matricula TEXT,
        presenca INTEGER DEFAULT 0,
        data_hora_presenca TEXT
      )
    ''');
  }

  Future<List<Aluno>> fetchAlunos() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('alunos', orderBy: 'nome');
    return List.generate(maps.length, (i) => Aluno.fromMap(maps[i]));
  }

  Future<int> insertAluno(Map<String, dynamic> row) async {
    final db = await database;
    return await db.insert('alunos', row, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  // CORREÇÃO DAS LINHAS 67-80 DO SEU PRINT:
  Future<int> alternarPresenca(int id, bool presente) async {
    final db = await database;
    String? dataHora = presente ? DateTime.now().toIso8601String() : null;
    
    return await db.update(
      'alunos',
      {
        'presenca': presente ? 1 : 0,
        'data_hora_presenca': dataHora
      },
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<void> limparTodosAlunos() async {
    final db = await database;
    await db.delete('alunos');
  }

  Future close() async {
    final db = await database;
    db.close();
  }
}