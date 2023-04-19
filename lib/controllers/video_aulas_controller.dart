import 'package:bicjr_app/data/models/postagem_model.dart';
import 'package:bicjr_app/data/models/usuario_model.dart';
import 'package:bicjr_app/data/providers/fire_base_auth_provider.dart';
import 'package:bicjr_app/data/repositories/post_repository.dart';
import 'package:bicjr_app/data/repositories/usuario_repository.dart';
import 'package:bicjr_app/views/components/flushbar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class VideoAulasPageController{
  final _postRepository = PostRepository();
  final _usuarioRepository = UsuarioRepository();
  final textoController = TextEditingController();
  final urlVideo = TextEditingController();
  final currentUserId = FireBaseAuthProvider().getUserAuthData()['id'];
  bool controlarProblema = true;
  List<PostModel> posts = new List<PostModel>();
  List<UsuarioModel> usuarios = new List<UsuarioModel>();

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

  Future<bool> fazerPostagem(BuildContext context, String colecao, int ref) async {
    String idVideo;

    if(urlVideo.text.contains("http")) idVideo = YoutubePlayer.convertUrlToId(urlVideo.text);

    if(idVideo == null){
      FlushbarExt().mostrarErro(context, "URL inválida");
      return false;
    }

    var post = new PostModel(
      ref: ref,
      data: Timestamp.now(),
      filePath: idVideo,
      // texto: textoController.text
      texto: urlVideo.text
    );

    try{
      if (!controlarProblema) return false;
      controlarProblema = false;
      await _postRepository.incluir(colecao, post);
      controlarProblema = true;
      return controlarProblema;
    }
    catch (ex) {
      print('******* ERRO *******');
      print(ex.toString());
      String erro = FlushbarExt().erro(ex.toString());
      FlushbarExt().mostrarErro(context, erro);
      return false;
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