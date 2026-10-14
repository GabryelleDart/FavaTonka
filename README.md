<p align="center">
  <img src="docs/logo-favatonka.png" alt="FavaTonka - Descubra o perfume pelas suas notas" width="100%">
</p>

<p align="center">
  Aplicativo <b>Flutter/Dart</b> de descoberta olfativa: dez perfumes, cada um com descrição e <b>pirâmide olfativa</b>
  (notas de topo, coração e fundo) em círculos ilustrados, busca em tempo real, filtro por família olfativa,
  tema claro e escuro, login simulado, favoritos e comentários.
</p>

Trabalho da **Avaliação I (Front-end)** da disciplina **Programação Móvel** do
IFBA, Campus de Vitória da Conquista. Professor: Luis Paulo da Silva Carvalho.

---

## 1. Proposta

O **FavaTonka** é como um **catálogo de perfumes** cuja intenção é **entender as notas dos perfumes**.
O foco é a **descoberta olfativa**, e não propriamente uma venda: não há preços, carrinho nem compra.
Em cada perfume, o usuário vê o que se sente na saída (topo), no meio (coração) e no que permanece na
pele (fundo). Tocando em uma nota, descobre em quais outros perfumes da vitrine ela aparece.

### Perfumes da vitrine

| # | Perfume | Marca | Ano | Classificação |
|:-:|---|---|:-:|---|
| 1 | Scandal | Jean Paul Gaultier | 2017 | Gourmand · Floral |
| 2 | Good Girl | Carolina Herrera | 2016 | Oriental · Floral |
| 3 | Nº 5 | Chanel | 1921 | Floral · Aldeídico |
| 4 | J'adore | Dior | 1999 | Floral · Frutal |
| 5 | Sabah Al Ward | Al Wataniah | — | Floral · Âmbar · Gourmand |
| 6 | Lily Absolu | O Boticário | 2020 | Floral · Doce |
| 7 | Atheri | — | — | Floral |
| 8 | Eclaire | Lattafa | 2024 | Gourmand · Floral · Frutal |
| 9 | India Misteriosa | Mahogany | — | Floral · Oriental · Amadeirado |
| 10 | Her Confession | Lattafa | 2024 | Âmbar · Gourmand · Floral |

A classificação segue as famílias olfativas do Fragrantica, agrupadas nas oito categorias do FavaTonka:
**Aldeídico, Amadeirado, Doce, Floral, Frutal, Gourmand, Oriental e Âmbar**. O traço (—) indica dado
não informado.

## 2. Funcionalidades

| Recurso | Sem login | Com login |
|---|:---:|:---:|
| Ver a lista de perfumes | ✅ | ✅ |
| Buscar por perfume, marca ou nota, em tempo real | ✅ | ✅ |
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

O app tem quatro telas e uma janela inferior (a da nota).

### 3.1 Catálogo (`lib/telas/catalogo.dart`)

Tela inicial, com a lista dos perfumes.

- **Barra superior:** logotipo FavaTonka e três botões: tema claro/escuro (sol/lua), favoritos (coração)
  e entrar/sair.
- **Cabeçalho:** "Vitrine olfativa" e "Descubra perfumes pelas suas notas".
- **Busca** ("Buscar perfume, marca ou nota"): a lista é filtrada a cada letra digitada, desde a primeira.
  O botão X limpa o campo.
- **Filtros:** "Todos" e as famílias olfativas (Aldeídico, Amadeirado, Doce, Floral, Frutal, Gourmand,
  Oriental e Âmbar). Abaixo, o contador "N perfumes".
- **Grade de cartões:** foto, nome, marca e até quatro círculos com as notas do coração, mais "+N" com
  as restantes. Um coração vermelho marca os favoritos. A grade tem de 2 a 6 colunas, conforme a largura da tela.
- **Outros estados:** puxar para atualizar, "Nenhum perfume encontrado." e, se os dados não carregarem,
  "Não foi possível carregar os perfumes." com o botão "Tentar novamente".

<table>
  <tr>
    <td align="center"><img src="docs/prints/catalogo-claro.png" width="220" alt="Catálogo no tema claro"><br><sub>Tema claro</sub></td>
    <td align="center"><img src="docs/prints/catalogo-escuro.png" width="220" alt="Catálogo no tema escuro"><br><sub>Tema escuro</sub></td>
    <td align="center"><img src="docs/prints/catalogo-busca.png" width="220" alt="Catálogo com busca"><br><sub>Busca em tempo real</sub></td>
    <td align="center"><img src="docs/prints/catalogo-filtro.png" width="220" alt="Catálogo com filtro"><br><sub>Filtro por família</sub></td>
  </tr>
</table>

<p align="center">
  <img src="docs/prints/catalogo-desktop.png" width="640" alt="Catálogo no desktop"><br>
  <sub>Catálogo no desktop (várias colunas)</sub>
</p>

### 3.2 Detalhes (`lib/telas/detalhes.dart`)

Abre ao tocar em um perfume.

- **Barra superior:** voltar, logotipo, favoritar e compartilhar. Sem login, o coração avisa
  "Entre para favoritar perfumes" com a ação ENTRAR.
- **Perfume:** foto grande, nome, "marca · ano · gênero", chips com a classificação e a descrição.
- **Pirâmide olfativa:** topo (primeiros minutos), coração (algumas horas) e fundo (o que fica na pele),
  com cada nota num círculo com emoji e nome.
- **Janela da nota:** ao tocar numa nota, abre uma janela com o círculo grande, o nome e a lista
  "Também está em:" (tocar num perfume da lista abre os detalhes dele). Se nenhum outro perfume
  tem a nota, mostra "Nenhum outro perfume da vitrine tem esta nota.".
- **Comentários:** com login, há um campo "Escreva seu comentário..."; sem login, o botão "Entre para comentar".
  Cada comentário mostra avatar, nome, data e texto. Os do usuário logado ficam destacados e têm lixeira,
  com a confirmação "Deseja apagar o comentário?". Sem comentários: "Ainda não há comentários.".
- **Desktop (a partir de 900 px):** foto à esquerda e conteúdo à direita.

<table>
  <tr>
    <td align="center"><img src="docs/prints/detalhes-claro.png" width="220" alt="Detalhes no tema claro"><br><sub>Tema claro</sub></td>
    <td align="center"><img src="docs/prints/detalhes-piramide.png" width="220" alt="Pirâmide olfativa"><br><sub>Pirâmide olfativa</sub></td>
    <td align="center"><img src="docs/prints/detalhes-escuro.png" width="220" alt="Detalhes no tema escuro"><br><sub>Tema escuro</sub></td>
  </tr>
  <tr>
    <td align="center"><img src="docs/prints/detalhes-nota.png" width="220" alt="Janela de uma nota"><br><sub>Janela da nota</sub></td>
    <td align="center"><img src="docs/prints/detalhes-comentarios.png" width="220" alt="Comentários"><br><sub>Comentários</sub></td>
    <td></td>
  </tr>
</table>

<p align="center">
  <img src="docs/prints/detalhes-desktop.png" width="640" alt="Detalhes no desktop"><br>
  <sub>Detalhes no desktop (duas colunas)</sub>
</p>

### 3.3 Login (`lib/telas/login.dart`)

- Logotipo e "Entre para favoritar e comentar".
- Campos **E-mail** e **Senha** (com botão para mostrar/ocultar), validados ("Informe um e-mail válido",
  "Informe a senha"), e o botão **Entrar**, que mostra um indicador de progresso.
- Credenciais erradas: "E-mail ou senha inválidos". Sucesso: "Bem-vinda(o), NOME!" e volta à tela anterior.
- **Continuar sem entrar** fecha a tela e mantém o modo sem login.
- Para sair, use o botão de sair da barra do catálogo ("Você foi desconectado com sucesso").

<table>
  <tr>
    <td align="center"><img src="docs/prints/login.png" width="220" alt="Tela de login"><br><sub>Login</sub></td>
    <td align="center"><img src="docs/prints/login-erro.png" width="220" alt="Login com erro"><br><sub>Credenciais inválidas</sub></td>
  </tr>
</table>

### 3.4 Favoritos (`lib/telas/favoritos.dart`)

Exige login. Se você não estiver logado, o botão de favoritos avisa e leva à tela de login.

- Título "Meus favoritos" e lista com foto circular, nome e marca de cada perfume favoritado.
- O coração vermelho remove o perfume ("NOME removido dos favoritos"). Tocar no item abre os detalhes.
- Lista vazia: "Você ainda não favoritou nenhum perfume. Toque no coração na tela de detalhes.".
- Os favoritos são zerados ao sair da conta.

<table>
  <tr>
    <td align="center"><img src="docs/prints/favoritos.png" width="220" alt="Lista de favoritos"><br><sub>Favoritos</sub></td>
    <td align="center"><img src="docs/prints/favoritos-vazio.png" width="220" alt="Favoritos vazio"><br><sub>Lista vazia</sub></td>
  </tr>
</table>

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

- **Flutter** 3.47 ou superior (Dart 3.13.2 ou superior, conforme o `pubspec.yaml`), com Material 3.
- **provider**: gerenciamento de estado (dados, login, favoritos, comentários, tema e busca).
- **share_plus**: compartilhamento de um perfume.
- **intl**: formatação das datas dos comentários.
- **cupertino_icons**: pacote de ícones que já vem no projeto Flutter.
- Fontes **Lora** (títulos e logotipo) e **Poppins** (texto), incluídas em `recursos/fontes/`.

## 6. Estrutura do projeto

```
docs/
  logo-favatonka.png           banner do topo deste README
  prints/                      prints das telas usados neste README
lib/
  main.dart                    ponto de entrada e configuração dos temas
  tema.dart                    paleta clara/escura, fontes e utilitários
  gerenciador_estado.dart      estado: dados, login, favoritos, comentários, tema, busca
  autenticador.dart            login/logoff simulados
  usuario.dart
  modelos/                     Perfume, Nota, Comentario
  telas/                       catalogo, detalhes, login, favoritos
  componentes/                 logo, cartão de perfume, pirâmide, avatar de nota, foto, comentário
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

Se, por algum motivo, as pastas de plataforma (`android`, `ios`, `web`...) não vierem no repositório,
recrie-as com `flutter create --project-name favatonka .` antes do `flutter pub get`.

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
| `Plugin with id 'com.android.library' not found` (projetos `jni` ou `share_plus`) | Aviso do editor, que importa cada pasta `android` de plugin isoladamente. Não afeta o app: se `flutter run` funciona, ignore. No VS Code, para parar o aviso, crie o arquivo `.vscode/settings.json` com `{ "java.import.gradle.enabled": false }`. Essa pasta fica fora do Git (está no `.gitignore`). |
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
`lily-absolute` (usado pelo Lily Absolu), `atheeri` (usado pelo Atheri), `eclaire`,
`india-misteriosa` e `her-confession`. Para usar outra extensão, mude a linha `caminhoFoto`
em `lib/modelos/perfume.dart`.

**Perfumes:** `recursos/jsons/perfumes.json`. Cada perfume tem `nome`, `marca`, `ano`,
`genero`, `familias`, `descricao` e `notas` com `topo`, `coracao` e `fundo`.

**Notas:** cada nota usada nas listas precisa existir em `recursos/jsons/notas.json`
com `nome`, `emoji`, `cor1` e `cor2`. Notas sem cadastro aparecem com ✨ e o nome da chave.

**Comentários iniciais:** `recursos/jsons/comentarios.json`. O campo `email` deve ser o mesmo
do usuário em `lib/autenticador.dart` para que ele possa apagar o próprio comentário.

**Busca:** ignora acentos e maiúsculas e começa a filtrar na primeira letra. Um perfume aparece se
qualquer palavra do nome, da marca ou das notas **começar** com o que foi digitado (por exemplo, `s`
mostra o Sabah e os perfumes com sândalo). Aceita o nome da nota em português ou em inglês
(baunilha ou vanilla), e o J'adore pode ser buscado com ou sem apóstrofo (`j'adore`, `jadore`, `j adore`).
O Nº 5 é achado por `no 5`, `no5` ou `5`. As palavras "de", "da" e "do" são ignoradas.

## 10. Limitações conhecidas

- O login é **simulado**: os usuários estão fixos no código, sem servidor.
- Favoritos, comentários novos e a escolha do tema ficam **só na memória** e se perdem
  ao fechar o app (os favoritos também são zerados ao sair da conta). Os dados vêm de JSON
  estáticos, como pede a avaliação.
- Marca e ano não foram informados para alguns perfumes (Atheri, Sabah Al Ward e India Misteriosa).
- O botão de compartilhar depende do sistema (no desktop e na web, o comportamento varia).
- No Linux, o emoji só aparece colorido se houver uma fonte de emoji instalada.

## 11. Créditos e avisos

- Notas e classificações olfativas conforme informações públicas (como Fragrantica e Parfumo) e de lojas.
  Podem diferir entre versões e concentrações do perfume. As descrições foram escritas para este projeto.
- As fotos dos frascos pertencem às respectivas marcas e são usadas apenas para fins
  educacionais neste trabalho acadêmico.
- Fontes **Lora** e **Poppins** sob a licença SIL Open Font License.
- Logotipo, banner e ícone do app criados para o projeto.
- Projeto acadêmico, sem fins comerciais e sem vínculo com as marcas citadas.
