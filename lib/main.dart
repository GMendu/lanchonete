import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

void main() => runApp(MaterialApp(
      home: MyHomePage(),
    ));

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  _recuperarBancoDados() async {
    final caminhoBancoDados = await getDatabasesPath();
    final localBancoDados = join(caminhoBancoDados, "Lanchonetinha.db");
    var db = await openDatabase(localBancoDados, version: 1,
        onCreate: (db, dbVersaoRecente) {
      String sqlClientes =
          "CREATE TABLE clientes(id INTEGER PRIMARY KEY AUTOINCREMENT, nome VARCHAR, cpf INTEGER)";
      db.execute(sqlClientes);
      String sqlProdutos =
          "CREATE TABLE produtos(id INTEGER PRIMARY KEY AUTOINCREMENT, desc VARCHAR, valor FLOAT)";
      db.execute(sqlProdutos);
      String sqlPedidos =
          "CREATE TABLE pedidos(id INTEGER PRIMARY KEY AUTOINCREMENT, data DATE, qtd INTEGER, valorTotal FLOAT, categoria VARCHAR, idCliente INTEGER, FOREIGN KEY(idCliente) REFERENCES clientes(id))";
      db.execute(sqlPedidos);
      String sqlItemPedido =
          "CREATE TABLE itempedidos(id INTEGER PRIMARY KEY AUTOINCREMENT, idProduto INTEGER, idPedido INTEGER, FOREIGN KEY(idProduto) REFERENCES produtos(id), FOREIGN KEY(idPedido) REFERENCES pedidos(id))";
      db.execute(sqlItemPedido);
    });
    return db;
  }

  _listarClientes() async {
    Database bd = await _recuperarBancoDados();
    String sql = "SELECT * FROM clientes";
    List clientes = await bd.rawQuery(sql);

    for (var cliente in clientes) {
      print("cliente id: " +
          cliente['id'].toString() +
          " - nome: " +
          cliente['nome'].toString() +
          " - cpf: " +
          cliente['cpf'].toString());
    }
    print("Clientes: " + clientes.toString());
  }

  _listarClienteId(int id) async {
    Database bd = await _recuperarBancoDados();
    List clientes = await bd.query("clientes",
        columns: ['id', "nome", "cpf"], where: "id=?", whereArgs: [id]);

    for (var cliente in clientes) {
      print("cliente id: " +
          cliente['id'].toString() +
          " - nome: " +
          cliente['nome'].toString() +
          " - cpf: " +
          cliente['cpf'].toString());
    }
    print("Clientes: " + clientes.toString());
  }

  _atualizarCliente(int id, String nome, dynamic cpf) async {
    Database db = await _recuperarBancoDados();

    Map<String, dynamic> dadosClientes = {"nome": nome, "cpf": cpf};
    int retorno = await db
        .update("clientes", dadosClientes, where: "id = ?", whereArgs: [id]);
    print("Clientes atualizadas: $retorno");
  }

  _excluirCliente(int id) async {
    Database db = await _recuperarBancoDados();
    int retorno = await db.delete("clientes", where: "id = ?", whereArgs: [id]);
    print("Cliente removido: $retorno");
  }

  _salvarCliente(String nome, dynamic cpf) async {
    Database db = await _recuperarBancoDados();

    Map<String, dynamic> dadosClientes = {"nome": nome, "cpf": cpf};
    int id = await db.insert("clientes", dadosClientes);
    print("Cliente salvo: $id");
  }

  _listarProdutos() async {
    Database bd = await _recuperarBancoDados();
    String sql = "SELECT * FROM produtos";
    List produtos = await bd.rawQuery(sql);

    for (var produto in produtos) {
      print("Produto id: " +
          produto['id'].toString() +
          " - desc: " +
          produto['desc'].toString() +
          " - valor: " +
          produto['valor'].toString());
    }
    print("Produtos: " + produtos.toString());
  }

  _listarProdutoId(int id) async {
    Database bd = await _recuperarBancoDados();
    List produtos = await bd.query("produtos",
        columns: ['id', "desc", "valor"], where: "id=?", whereArgs: [id]);

    for (var produto in produtos) {
      print("Produto id: " +
          produto['id'].toString() +
          " - desc: " +
          produto['desc'].toString() +
          " - valor: " +
          produto['valor'].toString());
    }
    print("Produtos: " + produtos.toString());
  }

  _atualizarProduto(int id, String desc, dynamic valor) async {
    Database db = await _recuperarBancoDados();

    Map<String, dynamic> dadosClientes = {"desc": desc, "valor": valor};
    int retorno = await db
        .update("Produtos", dadosClientes, where: "id = ?", whereArgs: [id]);
    print("Produtos atualizados: $retorno");
  }

  _excluirProduto(int id) async {
    Database db = await _recuperarBancoDados();
    int retorno = await db.delete("produtos", where: "id = ?", whereArgs: [id]);
    print("Produtos removidos: $retorno");
  }

  _salvarProduto(String desc, dynamic valor) async {
    Database db = await _recuperarBancoDados();

    Map<String, dynamic> dadosClientes = {"desc": desc, "valor": valor};
    int id = await db.insert("produtos", dadosClientes);
    print("Produtos salvo: $id");
  }

  _listarPedidos() async {
    Database bd = await _recuperarBancoDados();
    String sql = "SELECT * FROM pedidos";
    List pedidos = await bd.rawQuery(sql);

    for (var pedido in pedidos) {
      print("Pedido id: " +
          pedido['id'].toString() +
          " - data: " +
          pedido['data'].toString() +
          " - qtd: " +
          pedido['qtd'].toString() +
          " - valorTotal: " +
          pedido['valorTotal'].toString() +
          " - categoria: " +
          pedido['categoria'].toString() +
          " - idCliente: " +
          pedido['idCliente'].toString());
    }
    print("Pedidos: " + pedidos.toString());
  }

  _listarPedidoId(int id) async {
    Database bd = await _recuperarBancoDados();
    List pedidos = await bd.query("pedidos",
        columns: ['id', "data", "qtd", "valorTotal", "categoria", "idCliente"],
        where: "id=?",
        whereArgs: [id]);

    for (var pedido in pedidos) {
      print("Pedido id: " +
          pedido['id'].toString() +
          " - data: " +
          pedido['data'].toString() +
          " - qtd: " +
          pedido['qtd'].toString() +
          " - valorTotal: " +
          pedido['valorTotal'].toString() +
          " - categoria: " +
          pedido['categoria'].toString() +
          " - idCliente: " +
          pedido['idCliente'].toString());
    }
    print("Produtos: " + pedidos.toString());
  }

  _atualizarPedido(int id, DateTime data, int qtd, double valorTotal,
      String categoria, int idCliente) async {
    Database db = await _recuperarBancoDados();

    Map<String, dynamic> dadosPedidos = {
      "data": data,
      "qtd": qtd,
      "valorTotal": valorTotal,
      "categoria": categoria,
      "idCliente": idCliente
    };
    int retorno = await db
        .update("pedidos", dadosPedidos, where: "id = ?", whereArgs: [id]);
    print("Pedidos atualizados: $retorno");
  }

  _excluirPedido(int id) async {
    Database db = await _recuperarBancoDados();
    int retorno = await db.delete("pedidos", where: "id = ?", whereArgs: [id]);
    print("Pedidos removidos: $retorno");
  }

  _salvarPedido(DateTime data, int qtd, double valorTotal, String categoria,
      int idCliente) async {
    Database db = await _recuperarBancoDados();

    Map<String, dynamic> dadosPedidos = {
      "data": data,
      "qtd": qtd,
      "valorTotal": valorTotal,
      "categoria": categoria,
      "idCliente": idCliente
    };
    int id = await db.insert("pedidos", dadosPedidos);
    print("Produtos salvo: $id");
  }

  _verTabelas() async {
    Database db = await _recuperarBancoDados();
    String sql = "SELECT * FROM sqlite_master";
    final result = await db.rawQuery(sql);
    print('$result');
  }

  @override
  Widget build(BuildContext context) {
    // _salvarCliente("Gabriel", 17188960771); // String nome, dynamic cpf
    // _listarClienteId(1); // id
    // _listarClientes();
    // _excluirCliente(2); // id
    // _atualizarCliente(2, "Rhuan", 20); // int id, String nome, dynamic cpf

    // _salvarProduto("Agua mineral", 5.0); // String desc, dynamic valor
    // _listarProdutoId(1); // id
    // _listarProdutos();
    // _excluirProduto(2); // id
    // _atualizarProduto(,,); // int id, String desc, dynamic valor

    _salvarPedido(DateTime.now(), 2, 10.0, "bebida",
        1); // DateTime data, int qtd, double valorTotal, String categoria, int idCliente
    // _listarPedidoId(1); // id
    // _listarPedidos();
    // _excluirPedido(2); // id
    // _atualizarPedido(,,,,,); // int id, DateTime data, int qtd, double valorTotal,String categoria, int idCliente

    // _verTabelas();
    return Container();
  }
}
