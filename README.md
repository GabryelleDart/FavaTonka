# FavaTonka

Vitrine olfativa de perfumes feita em **Flutter/Dart**. O app apresenta dez perfumes
e, para cada um, a descrição e a **pirâmide olfativa** (notas de topo, coração e fundo)
em círculos ilustrados, com busca, filtro por família olfativa, tema claro/escuro,
login simulado, favoritos e comentários.

Trabalho da **Avaliação I (Front-end)** da disciplina **Programação Móvel** do
IFBA, Campus de Vitória da Conquista. Professor: Luis Paulo da Silva Carvalho.

---

## 1. Proposta

Em vez de apresentar um catálogo de preços e compras, o FavaTonka ajuda a
**entender um perfume pelas suas notas**: o que se sente na saída (topo), no meio (coração) e
no que permanece na pele (fundo). Tocando em uma nota, o usuário descobre em quais outros
perfumes da vitrine ela aparece. O foco é a descoberta olfativa, não a venda.

### Perfumes da vitrine

Scandal, Good Girl, Nº 5, J'adore, Sabah Al Ward, Lily Absolu, Atheri, Eclaire,
India Misteriosa e Her Confession.

## 2. Funcionalidades

| Recurso | Sem login | Com login |
|---|:---:|:---:|
| Ver a lista de perfumes | ✅ | ✅ |
| Buscar por perfume, marca ou nota | ✅ | ✅ |
| Filtrar por família olfativa | ✅ | ✅ |
| Ver descrição e pirâmide olfativa | ✅ | ✅ |
| Tocar numa nota e ver onde mais ela aparece | ✅ | ✅ |
| Compartilhar um perfume | ✅ | ✅ |
| Alternar tema claro/escuro | ✅ | ✅ |
| Ler comentários | ✅ | ✅ |
| Favoritar e ver a tela de favoritos | ❌ | ✅ |
| Comentar e apagar os próprios comentários | ❌ | ✅ |

Extras: layout responsivo (celular, tablet, desktop e web), arrastar listas com o mouse
no desktop, puxar para atualizar, estados de carregamento e de erro.

## 3. Telas

1. **Catálogo** (`lib/telas/catalogo.dart`): lista/grade de perfumes, busca e filtros.
2. **Detalhes** (`lib/telas/detalhes.dart`): foto, descrição, pirâmide olfativa e comentários.
3. **Login** (`lib/telas/login.dart`): entrada com credenciais fictícias.
4. **Favoritos** (`lib/telas/favoritos.dart`): perfumes favoritados (exige login).

## 4. Atendimento ao descritivo da avaliação

| Item do descritivo | Como o app atende |
|---|---|
| 7. Dart e Flutter | Todo o código em Dart, com Flutter. |
| 11. Duas ou mais telas, uma com lista | 4 telas; o catálogo e os favoritos são listas. |
| 12. Login e logoff, com modo sem login | Botão de entrar/sair no topo do catálogo. Sem login, o app é navegável; favoritar e comentar exigem login. |
| 13. Login mockado | Usuários fixos no código, em `lib/autenticador.dart`. |
| 14. Dados em JSON estáticos | `recursos/jsons/perfumes.json`, `notas.json` e `comentarios.json`. |
| 15. Entrega em plataforma Git | Repositório no GitHub; o link vai pelo Classroom no dia da entrega. |
| 10. Instruções para rodar fora do emulador | Seção 7 deste README (web, Windows, etc.). |
| 8 e 9. Vídeo de até 3 minutos | Entregue à parte, com link testado. |

## 5. Tecnologias

- **Flutter** 3.47 ou superior (Dart 3.13.2 ou superior, conforme o `pubspec.yaml`).
- **provider**: gerenciamento de estado.
- **share_plus**: compartilhamento.
- **intl**: formatação de datas.
- Fontes **Lora** (títulos e logotipo) e **Poppins** (texto), incluídas em `recursos/fontes/`.

## 6. Estrutura do projeto

```
lib/
  main.dart                    ponto de entrada e configuração dos temas
  tema.dart                    paleta clara/escura, fontes e utilitários
  gerenciador_estado.dart      estado: dados, login, favoritos, comentários, tema, busca
  autenticador.dart            login/logoff simulados
  usuario.dart
  modelos/                     Perfume, Nota, Comentario
  telas/                       catalogo, detalhes, login, favoritos
  componentes/                 logo, cartão de perfume, pirâmide, avatar de nota, etc.
recursos/
  jsons/                       perfumes.json, notas.json, comentarios.json
  imagens/perfumes/            uma foto por perfume (<slug>.jpg)
  fontes/                      Lora e Poppins
  icone/icone_1024.png         ícone original do app
android/ ios/ web/ windows/ linux/ macos/   pastas de cada plataforma (geradas pelo Flutter)
```

## 7. Como executar

### 7.1 Pré-requisitos

1. Instale o **Flutter** (https://docs.flutter.dev/get-started/install) e confira com:
   ```bash
   flutter --version      # precisa ser 3.47 ou superior
   flutter doctor -v
   ```
2. Instale o que o `flutter doctor` pedir para a plataforma que você quer usar:

| Plataforma | O que precisa | Roda em |
|---|---|---|
| Android | Android Studio, Android SDK, licenças aceitas, emulador ou celular | Windows, Linux, macOS |
| Web | Google Chrome ou Edge | qualquer sistema |
| Windows | Visual Studio com "Desenvolvimento para desktop com C++" e **Modo de Desenvolvedor** ativado | Windows |
| Linux | `sudo apt install clang cmake ninja-build pkg-config libgtk-3-dev` | Linux |
| macOS / iOS | Xcode e CocoaPods | **somente macOS** |

### 7.2 Baixar e preparar

```bash
git clone <URL-DO-REPOSITORIO>
cd FavaTonka
flutter pub get
```

### 7.3 Rodar

Veja os dispositivos disponíveis com `flutter devices` e rode com `flutter run -d <id>`.

**Navegador (o jeito mais rápido, não precisa de emulador):**
```bash
flutter run -d chrome
```

**Windows (desktop):**
```bash
flutter run -d windows
```

**Emulador Android:**
```bash
flutter emulators                       # lista os emuladores
flutter emulators --launch <id>         # abre um
flutter run
```

**Celular Android com cabo USB:** ative as *Opções do desenvolvedor* e a *Depuração USB*,
conecte o cabo, aceite a autorização no celular, confira com `adb devices` e rode `flutter run`.

**iPhone / simulador iOS (somente macOS):**
```bash
cd ios && pod install && cd ..
open -a Simulator
flutter run
```

**Linux ou macOS (desktop):** `flutter run -d linux` ou `flutter run -d macos`.

### 7.4 Gerar o aplicativo instalável (opcional)

```bash
flutter build apk --release        # Android: build/app/outputs/flutter-apk/app-release.apk
flutter build web                  # Web: pasta build/web
flutter build windows              # Windows: build/windows/x64/runner/Release
```

### 7.5 Credenciais de teste

| E-mail | Senha | Nome |
|---|---|---|
| `fava@tonka.com` | `123456` | Ana Tonka |
| `carlos@tonka.com` | `123456` | Carlos Âmbar |

Para usar sem login, basta não entrar: a tela de login tem o botão "Continuar sem entrar".

## 8. Solução de problemas

| Mensagem ou sintoma | Causa e solução |
|---|---|
| `SDK location not found` | O Gradle não achou o Android SDK. Rode `flutter config --android-sdk "<caminho do SDK>"` e depois `flutter pub get`. No Windows o caminho costuma ser `C:\Users\<usuário>\AppData\Local\Android\Sdk`. |
| `Some Android licenses not accepted` | Rode `flutter doctor --android-licenses` e aceite tudo com `y`. |
| `The Android emulator exited with code 1` | Virtualização desligada ou emulador travado. Ative VT-x/SVM na BIOS, ative a *Plataforma do Hipervisor do Windows*, use *Cold Boot Now* no Device Manager ou troque Graphics para *Software*. Para ver a causa: `emulator -avd <nome> -verbose`. |
| `Plugin with id 'com.android.library' not found` (projetos `jni` ou `share_plus`) | Aviso do editor, que importa cada pasta `android` de plugin isoladamente. Não afeta o app. Se `flutter run` funciona, ignore. O arquivo `.vscode/settings.json` já desliga essa importação no VS Code. |
| `Building with plugins requires symlink support` (Windows) | Ative o Modo de Desenvolvedor: execute `start ms-settings:developers`, ative a opção e reinicie o terminal. |
| `Because favatonka requires SDK version ^3.13.2...` | Flutter desatualizado. Rode `flutter upgrade`. |
| Chrome ou Windows não aparecem em `flutter devices` | `flutter config --enable-web` ou `--enable-windows-desktop`, depois `flutter doctor`. |
| Celular não aparece | Confira o cabo, a depuração USB, o driver do fabricante e `adb devices`. |
| Fotos ou fontes não mudam depois de editar | Arquivos de recursos só são lidos ao iniciar o app. Pare e rode `flutter run` de novo (hot reload não basta). Se persistir: `flutter clean` e `flutter pub get`. |
| Aparece um frasco desenhado no lugar da foto | O arquivo da foto não foi achado. Veja a seção 9. |
| Erro de Gradle após atualizar o Flutter | `flutter clean`, apague `android/.gradle` e rode `flutter run` de novo. |
| Qualquer erro estranho de build | `flutter clean`, `flutter pub get`, `flutter run`. Se continuar, rode `flutter run -v` e veja o primeiro erro. |

## 9. Editando os dados e as fotos

**Fotos dos perfumes:** `recursos/imagens/perfumes/<slug>.jpg`, onde `slug` é o campo do
`perfumes.json`: `scandal`, `good-girl`, `chanel-no5`, `jadore`, `sabah-al-ward`,
`lily-absolute`, `atheeri`, `eclaire`, `india-misteriosa`, `her-confession`.
Para usar outra extensão, mude a linha `caminhoFoto` em `lib/modelos/perfume.dart`.

**Perfumes:** `recursos/jsons/perfumes.json`. Cada perfume tem `nome`, `marca`, `ano`,
`genero`, `familias`, `descricao` e `notas` com `topo`, `coracao` e `fundo`.

**Notas:** cada nota usada nas listas precisa existir em `recursos/jsons/notas.json`
com `nome`, `emoji`, `cor1` e `cor2`. Notas sem cadastro aparecem com ✨ e o nome da chave.

**Comentários iniciais:** `recursos/jsons/comentarios.json`. O campo `email` deve ser o mesmo
do usuário em `lib/autenticador.dart` para que ele possa apagar o próprio comentário.

**Busca:** ignora acentos e maiúsculas, funciona por palavra (por exemplo, "mel" encontra
quem tem mel, mas não melão) e aceita o nome da nota em português ou em inglês
(baunilha ou vanilla).

## 10. Limitações conhecidas

- O login é **simulado**: os usuários estão fixos no código, sem servidor.
- Favoritos, comentários novos e a escolha do tema ficam **só na memória** e se perdem
  ao fechar o app. Os dados vêm de JSON estáticos, como pede a avaliação.
- O botão de compartilhar depende do sistema (no desktop e na web, o comportamento varia).
- No Linux, o emoji só aparece colorido se houver uma fonte de emoji instalada.

## 11. Créditos e avisos

- Notas olfativas conforme informações públicas (como Fragrantica e Parfumo) e de lojas. Podem
  diferir entre versões e concentrações do perfume. As descrições foram escritas para este projeto.
- As fotos dos frascos pertencem às respectivas marcas e são usadas apenas para fins
  educacionais neste trabalho acadêmico.
- Fontes **Lora** e **Poppins** sob a licença SIL Open Font License.
- Ícone do app criado para o projeto.
- Projeto acadêmico, sem fins comerciais e sem vínculo com as marcas citadas.
