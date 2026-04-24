import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

// Importação das suas telas
import 'screens/login_screen.dart';
import 'screens/home_screen.dart';

void main() {
  // Inicialização obrigatória para garantir que o Flutter suba os plugins antes do app
  WidgetsFlutterBinding.ensureInitialized();

  // Configuração do SQLite para rodar nativamente no Windows
  if (!kIsWeb && Platform.isWindows) {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Monitoramento SEMEC - CDA',
      debugShowCheckedModeBanner: false,
      
      // Definição da Identidade Visual Institucional
      theme: ThemeData(
        useMaterial3: true,
        primaryColor: const Color(0xFF003366), // Azul Marinho Oficial
        
        // Paleta de cores global
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF003366),
          primary: const Color(0xFF003366),
          secondary: const Color(0xFF006633), // Verde SEMEC
          surface: Colors.white,
        ),

        // Estilização padrão das AppBars
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF003366),
          foregroundColor: Colors.white,
          centerTitle: true,
          elevation: 2,
        ),

        // Estilização global de botões
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF003366),
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
      ),

      // O App agora inicia obrigatoriamente pela tela de Login
      home: const LoginScreen(),
      
      // Rotas nomeadas caso queira expandir a navegação depois
      routes: {
        '/home': (context) => const HomeScreen(),
        '/login': (context) => const LoginScreen(),
      },
    );
  }
}