import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('notas_app.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    // Tabela de usuários
    await db.execute('''
      CREATE TABLE usuarios (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        username TEXT UNIQUE NOT NULL,
        password TEXT NOT NULL
      )
    ''');

    // Tabela de disciplinas
    await db.execute('''
      CREATE TABLE disciplinas (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        usuario_id INTEGER NOT NULL,
        nome TEXT NOT NULL,
        nota REAL,
        presenca TEXT,
        descricao TEXT,
        FOREIGN KEY (usuario_id) REFERENCES usuarios (id) ON DELETE CASCADE
      )
    ''');

    // Tabela de provas
    await db.execute('''
      CREATE TABLE provas (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        disciplina_id INTEGER NOT NULL,
        data TEXT NOT NULL,
        FOREIGN KEY (disciplina_id) REFERENCES disciplinas (id) ON DELETE CASCADE
      )
    ''');

    // Tabela de trabalhos
    await db.execute('''
      CREATE TABLE trabalhos (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        disciplina_id INTEGER NOT NULL,
        data TEXT NOT NULL,
        FOREIGN KEY (disciplina_id) REFERENCES disciplinas (id) ON DELETE CASCADE
      )
    ''');

    // Tabela de anotações
    await db.execute('''
      CREATE TABLE anotacoes (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        disciplina_id INTEGER NOT NULL,
        texto TEXT,
        FOREIGN KEY (disciplina_id) REFERENCES disciplinas (id) ON DELETE CASCADE
      )
    ''');

    // Inserir usuário de teste
    await _insertTestUser(db);
  }

  Future<void> _insertTestUser(Database db) async {
    // Inserir usuário de teste
    final userId = await db.insert('usuarios', {
      'username': 'teste',
      'password': '123456', // Senha simples para teste
    });

    // Disciplinas do usuário de teste
    final disciplinas = [
      {
        'nome': 'Matemática',
        'nota': 8.5,
        'presenca': '90%',
        'descricao': 'Álgebra, geometria e cálculos.',
      },
      {
        'nome': 'Português',
        'nota': 7.8,
        'presenca': '85%',
        'descricao': 'Gramática, literatura e redação.',
      },
      {
        'nome': 'Inglês',
        'nota': 9.2,
        'presenca': '95%',
        'descricao': 'Gramática, conversação e escrita.',
      },
      {
        'nome': 'Geografia',
        'nota': 8.0,
        'presenca': '88%',
        'descricao': 'Estudo da Terra e suas características.',
      },
      {
        'nome': 'História',
        'nota': 7.5,
        'presenca': '82%',
        'descricao': 'Estudo de eventos passados e civilizações.',
      },
      {
        'nome': 'Física',
        'nota': 8.7,
        'presenca': '91%',
        'descricao': 'Estudo de matéria, energia e suas interações.',
      },
      {
        'nome': 'Química',
        'nota': 8.3,
        'presenca': '89%',
        'descricao': 'Estudo da composição e propriedades da matéria.',
      },
    ];

    for (var disciplina in disciplinas) {
      final disciplinaId = await db.insert('disciplinas', {
        'usuario_id': userId,
        'nome': disciplina['nome'],
        'nota': disciplina['nota'],
        'presenca': disciplina['presenca'],
        'descricao': disciplina['descricao'],
      });

      // Inserir provas e trabalhos para cada disciplina
      if (disciplina['nome'] == 'Matemática') {
        await db.insert('provas', {
          'disciplina_id': disciplinaId,
          'data': '15/04/2025',
        });
        await db.insert('trabalhos', {
          'disciplina_id': disciplinaId,
          'data': '20/04/2025',
        });
      } else if (disciplina['nome'] == 'Português') {
        await db.insert('provas', {
          'disciplina_id': disciplinaId,
          'data': '20/03/2025',
        });
        await db.insert('provas', {
          'disciplina_id': disciplinaId,
          'data': '15/04/2025',
        });
        await db.insert('trabalhos', {
          'disciplina_id': disciplinaId,
          'data': '30/03/2025',
        });
      } else if (disciplina['nome'] == 'Inglês') {
        await db.insert('provas', {
          'disciplina_id': disciplinaId,
          'data': '10/04/2025',
        });
        await db.insert('trabalhos', {
          'disciplina_id': disciplinaId,
          'data': '25/04/2025',
        });
      } else if (disciplina['nome'] == 'Geografia') {
        await db.insert('provas', {
          'disciplina_id': disciplinaId,
          'data': '12/04/2025',
        });
        await db.insert('trabalhos', {
          'disciplina_id': disciplinaId,
          'data': '22/04/2025',
        });
      } else if (disciplina['nome'] == 'História') {
        await db.insert('provas', {
          'disciplina_id': disciplinaId,
          'data': '18/04/2025',
        });
        await db.insert('trabalhos', {
          'disciplina_id': disciplinaId,
          'data': '28/04/2025',
        });
      } else if (disciplina['nome'] == 'Física') {
        await db.insert('provas', {
          'disciplina_id': disciplinaId,
          'data': '14/04/2025',
        });
        await db.insert('trabalhos', {
          'disciplina_id': disciplinaId,
          'data': '24/04/2025',
        });
      } else if (disciplina['nome'] == 'Química') {
        await db.insert('provas', {
          'disciplina_id': disciplinaId,
          'data': '16/04/2025',
        });
        await db.insert('trabalhos', {
          'disciplina_id': disciplinaId,
          'data': '26/04/2025',
        });
      }

      // Inserir anotação vazia para cada disciplina
      await db.insert('anotacoes', {
        'disciplina_id': disciplinaId,
        'texto': '',
      });
    }
  }

  // Métodos para interagir com o banco de dados
  Future<Map<String, dynamic>?> login(String username, String password) async {
    final db = await instance.database;
    final result = await db.query(
      'usuarios',
      where: 'username = ? AND password = ?',
      whereArgs: [username, password],
    );

    if (result.isNotEmpty) {
      return result.first;
    }
    return null;
  }

  Future<List<Map<String, dynamic>>> getDisciplinas(int usuarioId) async {
    final db = await instance.database;
    return await db.query(
      'disciplinas',
      where: 'usuario_id = ?',
      whereArgs: [usuarioId],
    );
  }

  Future<List<Map<String, dynamic>>> getProvas(int disciplinaId) async {
    final db = await instance.database;
    return await db.query(
      'provas',
      where: 'disciplina_id = ?',
      whereArgs: [disciplinaId],
    );
  }

  Future<List<Map<String, dynamic>>> getTrabalhos(int disciplinaId) async {
    final db = await instance.database;
    return await db.query(
      'trabalhos',
      where: 'disciplina_id = ?',
      whereArgs: [disciplinaId],
    );
  }

  Future<Map<String, dynamic>?> getAnotacao(int disciplinaId) async {
    final db = await instance.database;
    final result = await db.query(
      'anotacoes',
      where: 'disciplina_id = ?',
      whereArgs: [disciplinaId],
    );
    return result.isNotEmpty ? result.first : null;
  }

  Future<int> updateAnotacao(int disciplinaId, String texto) async {
    final db = await instance.database;
    return await db.update(
      'anotacoes',
      {'texto': texto},
      where: 'disciplina_id = ?',
      whereArgs: [disciplinaId],
    );
  }

  Future<int> insertProva(int disciplinaId, String data) async {
    final db = await instance.database;
    return await db.insert('provas', {
      'disciplina_id': disciplinaId,
      'data': data,
    });
  }

  Future<int> deleteProva(int id) async {
    final db = await instance.database;
    return await db.delete('provas', where: 'id = ?', whereArgs: [id]);
  }

  Future<int> updateProva(int id, String data) async {
    final db = await instance.database;
    return await db.update(
      'provas',
      {'data': data},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<int> insertTrabalho(int disciplinaId, String data) async {
    final db = await instance.database;
    return await db.insert('trabalhos', {
      'disciplina_id': disciplinaId,
      'data': data,
    });
  }

  Future<int> deleteTrabalho(int id) async {
    final db = await instance.database;
    return await db.delete('trabalhos', where: 'id = ?', whereArgs: [id]);
  }

  Future<int> updateTrabalho(int id, String data) async {
    final db = await instance.database;
    return await db.update(
      'trabalhos',
      {'data': data},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<void> insertMissingDisciplinas() async {
    final db = await database;

    // 1. Buscar o ID do usuário "teste"
    final usuario = await db.query(
      'usuarios',
      where: 'username = ?',
      whereArgs: ['teste'],
      limit: 1,
    );

    if (usuario.isEmpty) {
      print('Usuário teste não encontrado');
      return;
    }

    final userId = usuario.first['id'] as int;

    // 2. Verificar quais disciplinas já existem para esse usuário
    final disciplinasExistentes = await db.query(
      'disciplinas',
      where: 'usuario_id = ?',
      whereArgs: [userId],
      columns: ['nome'],
    );

    final nomesExistentes =
        disciplinasExistentes.map((d) => d['nome'] as String).toList();

    // 3. Disciplinas que precisam ser inseridas
    final disciplinasParaInserir =
        [
          {
            'nome': 'Geografia',
            'nota': 8.0,
            'presenca': '88%',
            'descricao': 'Estudo da Terra e suas características.',
          },
          {
            'nome': 'História',
            'nota': 7.5,
            'presenca': '82%',
            'descricao': 'Estudo de eventos passados e civilizações.',
          },
          {
            'nome': 'Física',
            'nota': 8.7,
            'presenca': '91%',
            'descricao': 'Estudo de matéria, energia e suas interações.',
          },
          {
            'nome': 'Química',
            'nota': 8.3,
            'presenca': '89%',
            'descricao': 'Estudo da composição e propriedades da matéria.',
          },
        ].where((d) => !nomesExistentes.contains(d['nome'])).toList();

    // 4. Inserir as disciplinas faltantes
    for (var disciplina in disciplinasParaInserir) {
      final disciplinaId = await db.insert('disciplinas', {
        'usuario_id': userId,
        'nome': disciplina['nome'],
        'nota': disciplina['nota'],
        'presenca': disciplina['presenca'],
        'descricao': disciplina['descricao'],
      });

      // Inserir provas e trabalhos padrão
      await db.insert('provas', {
        'disciplina_id': disciplinaId,
        'data': '01/05/2025', // Data genérica
      });

      await db.insert('trabalhos', {
        'disciplina_id': disciplinaId,
        'data': '10/05/2025', // Data genérica
      });

      // Inserir anotação vazia
      await db.insert('anotacoes', {
        'disciplina_id': disciplinaId,
        'texto': '',
      });
    }

    print('Disciplinas adicionadas com sucesso para o usuário teste');
  }
  
}
