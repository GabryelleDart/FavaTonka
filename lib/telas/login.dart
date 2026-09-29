import 'package:favatonka/autenticador.dart';
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
      messenger.showSnackBar(
        const SnackBar(
          content: Text('E-mail ou senha inválidos'),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    estado.login(usuario);
    navegador.pop();
    messenger.hideCurrentSnackBar();
    messenger.showSnackBar(
      SnackBar(
        content: Text('Bem-vinda(o), ${usuario.nome}!'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 16),
          child: Form(
            key: _chave,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 96,
                  height: 96,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      colors: [Cores.dourado, Cores.vinho],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  alignment: Alignment.center,
                  child: const Text('🌰', style: TextStyle(fontSize: 44)),
                ),
                const SizedBox(height: 16),
                const Text(
                  'FavaTonka',
                  style: TextStyle(
                    fontFamily: fonteTitulo,
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Cores.vinho,
                    letterSpacing: 1.5,
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  'Entre para favoritar e comentar',
                  style: TextStyle(color: Colors.black54),
                ),
                const SizedBox(height: 28),
                TextFormField(
                  controller: _email,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                    labelText: 'E-mail',
                    prefixIcon: Icon(Icons.mail_outline),
                    border: OutlineInputBorder(),
                  ),
                  validator: (v) =>
                      (v == null || !v.contains('@')) ? 'Informe um e-mail válido' : null,
                ),
                const SizedBox(height: 14),
                TextFormField(
                  controller: _senha,
                  obscureText: _ocultarSenha,
                  decoration: InputDecoration(
                    labelText: 'Senha',
                    prefixIcon: const Icon(Icons.lock_outline),
                    border: const OutlineInputBorder(),
                    suffixIcon: IconButton(
                      onPressed: () => setState(() => _ocultarSenha = !_ocultarSenha),
                      icon: Icon(
                        _ocultarSenha ? Icons.visibility : Icons.visibility_off,
                      ),
                    ),
                  ),
                  validator: (v) =>
                      (v == null || v.isEmpty) ? 'Informe a senha' : null,
                ),
                const SizedBox(height: 22),
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: FilledButton(
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
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Continuar sem entrar'),
                ),
                const SizedBox(height: 12),
                const Text(
                  'Demonstração: fava@tonka.com / 123456',
                  style: TextStyle(fontSize: 12, color: Colors.black45),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
