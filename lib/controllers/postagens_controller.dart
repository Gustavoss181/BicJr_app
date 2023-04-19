import 'package:bicjr_app/data/models/postagem_model.dart';
import 'package:bicjr_app/data/models/usuario_model.dart';
import 'package:bicjr_app/data/providers/fire_base_auth_provider.dart';
import 'package:bicjr_app/data/repositories/post_repository.dart';
import 'package:bicjr_app/data/repositories/usuario_repository.dart';
import 'package:bicjr_app/views/components/flushbar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class PostagensPageController{
  final _postRepository = PostRepository();
  final _usuarioRepository = UsuarioRepository();
  final textoController = TextEditingController();
  String filePath;
  bool controlarProblema = true;
  List<PostModel> posts = new List<PostModel>();
  List<UsuarioModel> usuarios = new List<UsuarioModel>();
  final currentUserId = FireBaseAuthProvider().getUserAuthData()['id'];

  Future<void> atualizarPosts(BuildContext context, String colecao, int ref) async {
    try{
      posts = await _postRepository.listarPosts(colecao, ref);
      for(var index = 0; index < posts.length; index++){
        var user = await _usuarioRepository.getUserData(userId: posts[index].idUser);
        user.id = posts[index].idUser;
        usuarios.insert(index, user);
      }
    }
    catch (ex) {
      print('******* ERRO *******');
      print(ex.toString());
      String erro = FlushbarExt().erro(ex.toString());
      FlushbarExt().mostrarErro(context, erro);
    }
  }

  Future<void> fazerPostagem(BuildContext context, String colecao, int ref) async {
    var post = new PostModel(
      ref: ref,
      data: Timestamp.now(),
      filePath: filePath,
      texto: textoController.text
    );
    try{
      if (!controlarProblema) return;
      controlarProblema = false;
      await _postRepository.incluir(colecao, post);
      controlarProblema = true;
    }catch (ex) {
      print('******* ERRO *******');
      print(ex.toString());
      String erro = FlushbarExt().erro(ex.toString());
      FlushbarExt().mostrarErro(context, erro);
    }
  }

  Future<void> excluirPost(String colecao, String idPost) async{
    try{
      await _postRepository.excluir(colecao, idPost);
    }catch(e){
      // arrumar
      print(e);
    }
  }
}