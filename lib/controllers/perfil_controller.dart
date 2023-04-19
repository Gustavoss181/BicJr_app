import 'package:bicjr_app/data/models/usuario_model.dart';
import 'package:bicjr_app/data/providers/fire_base_auth_provider.dart';
import 'package:bicjr_app/data/repositories/usuario_repository.dart';
import 'package:bicjr_app/routes/app_routes.dart';
import 'package:bicjr_app/views/components/flushbar.dart';
import 'package:bicjr_app/views/components/foto_convert.dart';
import 'package:flutter/cupertino.dart';

class PerfilController {
  final _repository = new UsuarioRepository();
  final _auth = new FireBaseAuthProvider();

  String nome;
  String email;
  dynamic image;
  final fotoController = new TextEditingController();
  final cursoController = new TextEditingController();
  final instituicaoController = new TextEditingController();
  final descricaoController = new TextEditingController();
  final telegramController = new TextEditingController();

  UsuarioModel userData;
  String fotoAntiga;

  Future<void> loadUserData(BuildContext context) async {
    try{
      userData = await _repository.getUserData();
      nome = userData.nome;
      email = userData.email;
      fotoController.text = userData.foto;
      fotoAntiga = userData.foto;
      instituicaoController.text = userData.instituicao;
      descricaoController.text = userData.descricao;
      telegramController.text = userData.telegram;
      image = FotoConvert().retornaFoto(fotoController.text);
    }
    catch (ex) {
      print('******* ERRO *******');
      print(ex.toString());
      String erro = FlushbarExt().erro(ex.toString());
      FlushbarExt().mostrarErro(context, erro);      
    }
  }

  void salvar(BuildContext context) async {

    var usuario = new UsuarioModel(
      email: email,
      foto: fotoController.text,
      nome: nome,
      instituicao: instituicaoController.text,
      descricao: descricaoController.text,
      telegram: telegramController.text
    );
    if (usuario.foto == fotoAntiga) fotoAntiga = "";
    try{
      await _repository.alterar(usuario, fotoAntiga);
      fotoAntiga = usuario.foto;
      FlushbarExt().mostrarErro(context, 'Dados salvos');
    }
    catch (ex){
      print('******* ERRO *******');
      print(ex.toString());
      String erro = FlushbarExt().erro(ex.toString());
      FlushbarExt().mostrarErro(context, erro);
    }
      
  }

  Future<void> apagarUsuario(BuildContext context, String senha) async {
    try{
      await _repository.excluir(fotoController.text, senha);
      Navigator.of(context).pushNamedAndRemoveUntil(AppRoutes.TELAINICIAL, (route) => false);
    }
    catch (ex) {
      print('******* ERRO *******');
      print(ex.toString());
      String erro = FlushbarExt().erro(ex.toString());
      FlushbarExt().mostrarErro(context, erro);
    }
  }

  void sair(BuildContext context){
    try{
      _auth.efetuarLogoff();
      Navigator.of(context).pushNamedAndRemoveUntil(AppRoutes.LOGIN, (route) => false);
    }
    catch (ex) {
      print('******* ERRO *******');
      print(ex.toString());
      String erro = FlushbarExt().erro(ex.toString());
      FlushbarExt().mostrarErro(context, erro);
    }
  }
}