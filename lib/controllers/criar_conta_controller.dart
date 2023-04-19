import 'package:bicjr_app/data/models/usuario_model.dart';
import 'package:bicjr_app/data/repositories/usuario_repository.dart';
import 'package:bicjr_app/routes/app_routes.dart';
import 'package:bicjr_app/views/components/flushbar.dart';
import 'package:flutter/cupertino.dart';

class CriarContaController{
  final _usuarioRepository = UsuarioRepository();
  
  final nomeController = TextEditingController();
  final emailController = TextEditingController();
  final senhaController = TextEditingController();
  final instituicaoController = TextEditingController();
  final fotoController = TextEditingController();

  bool controlarProblema = true;

  void criarConta(BuildContext context) async {
    var usuario = new UsuarioModel(
      nome: nomeController.text, 
      email: emailController.text.trim(),
      instituicao: instituicaoController.text,
      foto: fotoController.text,
    );
    try{
      if(controlarProblema){
        controlarProblema = false;
        await _usuarioRepository.incluir(usuario, senhaController.text); 
        Navigator.of(context).pushNamedAndRemoveUntil(AppRoutes.HOME, (route) => false);
        controlarProblema = true;
      }
    }
    catch (ex) {
      controlarProblema = true;
      print('******* ERRO *******');
      print(ex.toString());
      String erro = FlushbarExt().erro(ex.toString());
      FlushbarExt().mostrarErro(context, erro);
    }
  }
}