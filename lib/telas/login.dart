import 'package:favatonka/autenticador.dart';
import 'package:favatonka/componentes/logo.dart';
import 'package:favatonka/gerenciador_estado.dart';
import 'package:favatonka/tema.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TelaLogin extends StatefulWidget {
  const TelaLogin({super.key});

  @override
  State<TelaLogin> createState() => _TelaLoginState();
}

class _TelaLoginState extends State<TelaLogin> {
  final _chave = GlobalKey<FormState>();
  final _email = TextEditingController();
  final _senha = TextEditingController();
  bool _entrando = false;
  bool _ocultarSenha = true;

  @override
  void dispose() {
    _email.dispose();
    _senha.dispose();
    super.dispose();
  }

  Future<void> _entrar() async {
    if (!(_chave.currentState?.validate() ?? false)) return;

    final estado = context.read<GerenciadorEstado>();
    final navegador = Navigator.of(context);
    final messenger = ScaffoldMessenger.of(context);

    setState(() => _entrando = true);
    final usuario = await Autenticador.login(_email.text, _senha.text);
    if (!mounted) return;
    setState(() => _entrando = false);

    if (usuario == null) {
      messenger.hideCurrentSnackBar();
      messenger.showSnackBar(const SnackBar(content: Text('E-mail ou senha inválidos')));
      return;
    }

    estado.login(usuario);
    navegador.pop();
    messenger.hideCurrentSnackBar();
    messenger.showSnackBar(SnackBar(content: Text('Bem-vinda(o), ${usuario.nome}!')));
  }

  InputDecoration _decoracao(String rotulo, IconData icone, {Widget? sufixo}) {
    final p = context.paleta;
    OutlineInputBorder borda(Color cor, [double largura = 1]) => OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: cor, width: largura),
        );

    return InputDecoration(
      labelText: rotulo,
      labelStyle: TextStyle(color: p.textoSuave),
      prefixIcon: Icon(icone, color: p.textoSuave),
      suffixIcon: sufixo,
      border: borda(p.borda),
      enabledBorder: borda(p.borda),
      focusedBorder: borda(p.destaque, 1.4),
    );
  }

  @override
  Widget build(BuildContext context) {
    final p = context.paleta;

    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 420),
            child: Container(
              padding: const EdgeInsets.fromLTRB(28, 36, 28, 24),
              decoration: BoxDecoration(
                color: p.superficie,
                borderRadius: BorderRadius.circular(28),
                border: Border.all(color: p.borda),
              ),
              child: Form(
                key: _chave,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Logo(tamanho: 40),
                    const SizedBox(height: 8),
                    Text(
                      'Entre para favoritar e comentar',
                      style: TextStyle(color: p.textoSuave, fontSize: 13),
                    ),
                    const SizedBox(height: 28),
                    TextFormField(
                      controller: _email,
                      keyboardType: TextInputType.emailAddress,
                      style: TextStyle(color: p.texto),
                      decoration: _decoracao('E-mail', Icons.mail_outline),
                      validator: (v) =>
                          (v == null || !v.contains('@')) ? 'Informe um e-mail válido' : null,
                    ),
                    const SizedBox(height: 14),
                    TextFormField(
                      controller: _senha,
                      obscureText: _ocultarSenha,
                      style: TextStyle(color: p.texto),
                      onFieldSubmitted: (_) => _entrar(),
                      decoration: _decoracao(
                        'Senha',
                        Icons.lock_outline,
                        sufixo: IconButton(
                          onPressed: () => setState(() => _ocultarSenha = !_ocultarSenha),
                          icon: Icon(
                            _ocultarSenha ? Icons.visibility : Icons.visibility_off,
                            color: p.textoSuave,
                          ),
                        ),
                      ),
                      validator: (v) => (v == null || v.isEmpty) ? 'Informe a senha' : null,
                    ),
                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: FilledButton(
                        style: FilledButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        onPressed: _entrando ? null : _entrar,
                        child: _entrando
                            ? const SizedBox(
                                width: 22,
                                height: 22,
                                child: CircularProgressIndicator(strokeWidth: 2.5),
                              )
                            : const Text('Entrar'),
                      ),
                    ),
                    const SizedBox(height: 6),
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: Text('Continuar sem entrar', style: TextStyle(color: p.titulo)),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Demonstração: fava@tonka.com / 123456',
                      style: TextStyle(fontSize: 12, color: p.textoSuave),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
