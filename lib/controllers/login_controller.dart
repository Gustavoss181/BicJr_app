import 'package:bicjr_app/data/repositories/login_repository.dart';
import 'package:bicjr_app/routes/app_routes.dart';
import 'package:bicjr_app/views/components/flushbar.dart';
import 'package:flutter/material.dart';

class LoginController{
  final _repository = LoginRepository();

  final emailController = TextEditingController();
  final senhaController = TextEditingController();

  void entrar(BuildContext context) async{
    try{
      await _repository.efetuarLogin(emailController.text.trim(), senhaController.text);
      Navigator.of(context).pushReplacementNamed(AppRoutes.HOME);
    }
    catch (ex) {
      print('******* ERRO *******');
      print(ex.toString());
      String erro = FlushbarExt().erro(ex.toString());
      FlushbarExt().mostrarErro(context, erro);
    }
  }
  void recuperarSenha(BuildContext context) async {
    try{
      _repository.recuperarSenha(emailController.text.trim());
      FlushbarExt().mostrarErro(context, 'Um e-mail foi enviado para alteração da senha');
    }
    catch (ex) {
      print('******* ERRO *******');
      print(ex.toString());
      String erro = FlushbarExt().erro(ex.toString());
      FlushbarExt().mostrarErro(context, erro);
    }
  }
}