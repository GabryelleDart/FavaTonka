<p align="center">
  <img width="100%"  alt="FavaTonka - Descubra perfumes pelas suas notas" src="https://github.com/user-attachments/assets/c66745c2-959f-432b-9313-3506b1dc2975" />
  
<p>
Aplicativo <b>Flutter/Dart</b> de descoberta olfativa: dez perfumes, cada um com descrição e <b>pirâmide olfativa</b>
  (notas de topo, coração e fundo) em círculos ilustrados, busca em tempo real, filtro por família olfativa,
  tema claro e escuro, login simulado, favoritos e comentários.
</p>

Trabalho da **Avaliação I (Front-end)** da disciplina **Programação Móvel** do
IFBA, Campus de Vitória da Conquista. 
**Professor:** Luis Paulo da Silva Carvalho.

---

## 1. Proposta

O **FavaTonka** nasce como um guia  para a exploração olfativa, um espaço dedicado à pura apreciação e ao entendimento das fragrâncias, livre de foco comercial, preços ou carrinhos.Em cada perfume, o usuário vê o que se sente na saída (topo), no meio (coração) e no que permanece na pele (fundo). Tocando em uma nota, descobre em quais outros perfumes da vitrine ela aparece.

### Perfumes da vitrine

| # | Perfume | Marca | Ano | Classificação |
|:-:|---|---|:-:|---|
| 1 | Scandal | Jean Paul Gaultier | 2017 | Gourmand · Floral |
| 2 | Good Girl | Carolina Herrera | 2016 | Oriental · Floral |
| 3 | Nº 5 | Chanel | 1921 | Floral · Aldeídico |
| 4 | J'adore | Dior | 1999 | Floral · Frutal |
| 5 | Sabah Al Ward | Al Wataniah | 2023 | Floral · Âmbar · Gourmand |
| 6 | Lily Absolu | O Boticário | 2020 | Floral · Doce |
| 7 | Atheri | Lattafa  | 2025 | Floral |
| 8 | Eclaire | Lattafa | 2024 | Gourmand · Floral · Frutal |
| 9 | India Misteriosa | Mahogany | 2010 | Floral · Oriental · Amadeirado |
| 10 | Her Confession | Lattafa | 2024 | Âmbar · Gourmand · Floral |

A classificação segue as famílias olfativas do Fragrantica, agrupadas nas oito categorias do FavaTonka:
**Aldeídico, Amadeirado, Doce, Floral, Frutal, Gourmand, Oriental e Âmbar**.

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


<img width="1917" height="910" alt="Captura de tela 2026-10-14 185721" src="https://github.com/user-attachments/assets/7d574bde-2c4e-4563-9fb2-8a6db9a7a477" />

<img width="1917" height="906" alt="Captura de tela 2026-10-14 185738" src="https://github.com/user-attachments/assets/e9baea17-91c1-4472-be43-fc815305cc9d" />

<img width="1917" height="907" alt="Captura de tela 2026-10-14 185755" src="https://github.com/user-attachments/assets/82013f7c-724f-41e5-a30b-e2dfbfc0fcd6" />

<img width="1917" height="910" alt="Captura de tela 2026-10-14 185810" src="https://github.com/user-attachments/assets/d6c381fa-c795-4a27-a872-de2b8b07b653" />

### 3.2 Detalhes (`lib/telas/detalhes.dart`)

Abre ao tocar em um perfume.

- **Barra superior:** voltar, logotipo, favoritar e compartilhar. Sem login, o coração avisa
  "Entre para favoritar perfumes" com a ação ENTRAR.
- **Perfume:** foto grande, nome, "marca · ano · gênero", tags com a classificação e a descrição.
- **Pirâmide olfativa:** topo (primeiros minutos), coração (algumas horas) e fundo (o que fica na pele),
  com cada nota num círculo com emoji e nome.
- **Janela da nota:** ao tocar numa nota, abre uma janela com o círculo grande, o nome e a lista
  "Também está em:" (tocar num perfume da lista abre os detalhes dele). Se nenhum outro perfume
  tem a nota, mostra "Nenhum outro perfume da vitrine tem esta nota.".
- **Comentários:** com login, há um campo "Escreva seu comentário..."; sem login, o botão "Entre para comentar".
  Cada comentário mostra avatar, nome, data e texto. Os do usuário logado ficam destacados e têm lixeira,
  com a confirmação "Deseja apagar o comentário?". Sem comentários: "Ainda não há comentários.".
- **Desktop (a partir de 900 px):** foto à esquerda e conteúdo à direita.

<img width="1917" height="903" alt="Captura de tela 2026-10-14 190122" src="https://github.com/user-attachments/assets/3eb188d6-b514-471d-a845-290528833b37" />

<img width="1917" height="898" alt="Captura de tela 2026-10-14 190144" src="https://github.com/user-attachments/assets/189c9d50-eaaf-4fa5-a604-ecbc2d54c132" />

<img width="1917" height="906" alt="Captura de tela 2026-10-14 190635" src="https://github.com/user-attachments/assets/8ab38558-0914-483e-80aa-06484eb0c91b" />


### 3.3 Login (`lib/telas/login.dart`)

- Logotipo e "Entre para favoritar e comentar".
- Campos **E-mail** e **Senha** (com botão para mostrar/ocultar), validados ("Informe um e-mail válido",
  "Informe a senha"), e o botão **Entrar**, que mostra um indicador de progresso.
- Credenciais erradas: "E-mail ou senha inválidos". Sucesso: "Bem-vinda(o), NOME!" e volta à tela anterior.
- **Continuar sem entrar** fecha a tela e mantém o modo sem login.
- Para sair, use o botão de sair da barra do catálogo ("Você foi desconectado com sucesso").

<img width="1917" height="906" alt="Captura de tela 2026-10-14 190254" src="https://github.com/user-attachments/assets/3daf38b2-8aa5-4190-a3c2-c1c54281b682" />

<img width="1917" height="913" alt="Captura de tela 2026-10-14 190358" src="https://github.com/user-attachments/assets/5e89741f-2e07-4594-a9c6-28212a084315" />


### 3.4 Favoritos (`lib/telas/favoritos.dart`)

Exige login. Se você não estiver logado, o botão de favoritos avisa e leva à tela de login.

- Título "Meus favoritos" e lista com foto circular, nome e marca de cada perfume favoritado.
- O coração vermelho remove o perfume ("NOME removido dos favoritos"). Tocar no item abre os detalhes.
- Lista vazia: "Você ainda não favoritou nenhum perfume. Toque no coração na tela de detalhes.".
- Os favoritos são zerados ao sair da conta.
  
<img width="1917" height="902" alt="Captura de tela 2026-10-14 190451" src="https://github.com/user-attachments/assets/ae23f950-7fe8-4219-a865-c7315c57c288" />


## 4. Atendimento ao descritivo da avaliação

| Item do descritivo | Como o app atende |
|---|---|
| 7. Dart e Flutter | Todo o código em Dart, com Flutter. |
| 11. Duas ou mais telas, uma com lista | 4 telas; o catálogo e os favoritos são listas. |
| 12. Login e logoff, com modo sem login | Botão de entrar/sair no topo do catálogo. Sem login, o app é navegável; Favoritar e comentar exigem login. |
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

O FavaTonka pode ser executado de **três formas**: no emulador do Android Studio (7.3), no celular por
cabo USB, Android ou iPhone (7.4), ou no Chrome (7.5). Antes, siga os passos de 7.1 e 7.2.

### 7.1 Antes de começar

Instale o **Flutter** (https://docs.flutter.dev/get-started/install) e o **Git**. Depois, no terminal:

```bash
flutter --version
flutter doctor -v
```

| Comando | Para que serve |
|---|---|
| `flutter --version` | Mostra a versão instalada. O projeto precisa do Flutter 3.47 ou superior. Se for mais antigo, rode `flutter upgrade`. |
| `flutter doctor -v` | Faz um diagnóstico da instalação e lista o que falta (Android SDK, Chrome, Xcode...). Resolva o que aparecer com `[!]` ou `[✗]` na plataforma que você vai usar. |

### 7.2 Baixar o projeto

Há dois repositórios. Use o **completo** se puder. Use o **enxuto** se for o que está no GitHub.

**Repositório completo** (inclui as pastas de plataforma, como `android/`, `ios/` e `web/`):

```bash
git clone <URL-DO-REPOSITORIO-COMPLETO>
cd FavaTonka
flutter pub get
```

| Comando | Para que serve |
|---|---|
| `git clone <URL>` | Copia o repositório para o seu computador. |
| `cd FavaTonka` | Entra na pasta do projeto. Todos os comandos seguintes são rodados dentro dela. |
| `flutter pub get` | Baixa as bibliotecas que o app usa (`provider`, `share_plus`, `intl`...), listadas no `pubspec.yaml`. |

**Repositório enxuto** (só o código, os recursos e o `pubspec.yaml`, sem as pastas de plataforma):

```bash
git clone <URL-DO-REPOSITORIO-ENXUTO>
cd FavaTonka
flutter create --project-name favatonka .
flutter pub get
```

| Comando | Para que serve |
|---|---|
| `flutter create --project-name favatonka .` | **Gera as pastas de plataforma que faltam** (`android`, `ios`, `web`, `windows`, `linux`, `macos`). O ponto no final significa "nesta pasta". Não apaga nem altera `lib/`, `recursos/` nem o `pubspec.yaml`. O `--project-name favatonka` garante o nome do pacote que o código usa nos imports. |
| `flutter pub get` | Baixa as bibliotecas, como no repositório completo. |

> No repositório enxuto o app funciona igual, mas abre com o **ícone padrão do Flutter** e o nome
> "favatonka" no Android, porque o ícone e o nome personalizados ficam dentro das pastas de plataforma
> do repositório completo. Para gerar só uma plataforma, use `--platforms`, por exemplo
> `flutter create --project-name favatonka --platforms=android,web .`

### 7.3 Alternativa 1: emulador do Android Studio

Funciona em Windows, Linux e macOS.

**Preparação (uma vez só):**

1. Instale o **Android Studio**. Em *More Actions → SDK Manager → SDK Tools*, marque
   **Android SDK Command-line Tools**, **Android SDK Platform-Tools** e **Android Emulator**.
2. Ative a **virtualização** do computador:
   - **Windows:** ative VT-x ou AMD-V (SVM) na BIOS e, em "Ativar ou desativar recursos do Windows",
     a **Plataforma do Hipervisor do Windows**. Reinicie.
   - **Linux:** instale e libere o KVM, depois saia e entre na sessão de novo:
```bash
     sudo apt install qemu-kvm
     sudo adduser $USER kvm
```
3. Crie o emulador: *More Actions → Virtual Device Manager → Create Device*, escolha **Pixel 7**,
   uma imagem do sistema (por exemplo, API 34, x86_64) e clique em *Finish*.

**Rodar:**

```bash
flutter doctor --android-licenses
flutter emulators
flutter emulators --launch Pixel_7
flutter devices
flutter run
```

| Comando | Para que serve |
|---|---|
| `flutter doctor --android-licenses` | Aceite as licenças do Android SDK (digite `y` em cada pergunta). Sem isso, o build do Android falha. |
| `flutter emulators` | Lista os emuladores criados e o id de cada um. |
| `flutter emulators --launch Pixel_7` | Abre o emulador. Troque `Pixel_7` pelo id mostrado no comando anterior. Espere ele carregar a tela inicial. |
| `flutter devices` | Confirma que o emulador aparece como dispositivo (algo como `emulator-5554`). |
| `flutter run` | Compila o app, instala no emulador e abre. Se houver mais de um dispositivo, use `flutter run -d emulator-5554`. |

Se o Flutter não achar o SDK, informe o caminho: `flutter config --android-sdk "<CAMINHO-DO-SDK>"`.
No Windows, ele costuma ficar em `C:\Users\<usuário>\AppData\Local\Android\Sdk`.

### 7.4 Alternativa 2: celular por cabo USB

#### Android (Windows, Linux ou macOS)

1. No celular: *Configurações → Sobre o telefone* e toque 7 vezes em **Número da versão**. Depois, em
   *Opções do desenvolvedor*, ative a **Depuração USB**.
2. Conecte o cabo (precisa ser de dados, e não só de carga) e, no celular, escolha o modo
   **Transferência de arquivos**. Aceite a janela "Permitir depuração USB?".
3. **Driver, se o celular não aparecer:**
   - **Windows:** instale o driver do fabricante (Samsung, Motorola, Xiaomi...) ou, no Android Studio,
     *SDK Manager → SDK Tools → Google USB Driver*.
   - **Linux:** libere o acesso ao USB e depois saia e entre na sessão de novo:
```bash
     sudo apt install android-sdk-platform-tools-common
     sudo usermod -aG plugdev $USER
```
   - **macOS:** não precisa de driver.

```bash
adb devices
flutter devices
flutter run
```

| Comando | Para que serve |
|---|---|
| `adb devices` | Lista os aparelhos vistos pelo Android. O seu deve aparecer com `device`. Se aparecer `unauthorized`, aceite a janela no celular. Se aparecer `no permissions` (Linux), refaça a parte do `plugdev`. |
| `flutter devices` | Confirma que o Flutter enxerga o celular. |
| `flutter run` | Compila, instala e abre o app no celular. Com mais de um dispositivo, use `flutter run -d <id>`. |

Se o `adb` não for reconhecido, adicione ao PATH a pasta `platform-tools` do Android SDK. Se o celular
não aparecer, reinicie o serviço com `adb kill-server` e depois `adb start-server`.

#### iPhone

> **Só funciona em um Mac com Xcode.** Windows e Linux não conseguem compilar para iPhone; nesses
> sistemas, use o celular Android (acima), o emulador (7.3) ou o Chrome (7.5).

1. Instale o **Xcode** pela App Store e prepare-o:
```bash
   sudo xcode-select --switch /Applications/Xcode.app/Contents/Developer
   sudo xcodebuild -runFirstLaunch
   sudo gem install cocoapods
```
2. No iPhone, ative o **Modo Desenvolvedor** (*Ajustes → Privacidade e Segurança → Modo Desenvolvedor*)
   e reinicie o aparelho. Conecte o cabo e toque em **Confiar neste computador**.
3. Abra o projeto no Xcode, escolha seu Apple ID e troque o identificador do app por um único:
```bash
   open ios/Runner.xcworkspace
```
   Em *Runner → Signing & Capabilities*, escolha o **Team** (um Apple ID gratuito serve) e mude o
   **Bundle Identifier** (por exemplo, `br.edu.ifba.favatonka.seunome`).
4. Rode:
```bash
   flutter devices
   flutter run
```
5. Na primeira vez, o iPhone pode bloquear o app. Vá em *Ajustes → Geral → VPN e Gerenciamento de
   Dispositivo*, toque no seu Apple ID e escolha **Confiar**.

| Comando | Para que serve |
|---|---|
| `sudo xcode-select --switch ...` | Diz ao sistema qual Xcode usar. |
| `sudo xcodebuild -runFirstLaunch` | Conclui a instalação dos componentes do Xcode. |
| `sudo gem install cocoapods` | Instala o CocoaPods, que baixa as bibliotecas nativas do iPhone. |
| `open ios/Runner.xcworkspace` | Abre a parte iOS do projeto no Xcode, para configurar a assinatura. |
| `flutter devices` | Confirma que o iPhone aparece. |
| `flutter run` | Compila e instala no iPhone. Se der erro de CocoaPods, rode `cd ios && pod install && cd ..` e tente de novo. |

Com Apple ID gratuito, o app instalado deixa de abrir após cerca de 7 dias; basta rodar `flutter run` de novo.

### 7.5 Alternativa 3: Chrome

Funciona em Windows, Linux e macOS, sem emulador nem cabo. Instale o **Google Chrome** e rode:

```bash
flutter config --enable-web
flutter devices
flutter run -d chrome
```

| Comando | Para que serve |
|---|---|
| `flutter config --enable-web` | Liga o suporte a web do Flutter (em geral já vem ligado). |
| `flutter devices` | Deve listar **Chrome (web)**. |
| `flutter run -d chrome` | Compila o app para a web e abre numa janela do Chrome. |

Com o app rodando no terminal: `r` recarrega o código, `R` reinicia o app e `q` encerra. Dá para
redimensionar a janela do Chrome para ver o layout mudar de celular para desktop.

Se o Chrome não for encontrado, informe o caminho dele:

```bash
# Windows (PowerShell)
$env:CHROME_EXECUTABLE="C:\Program Files\Google\Chrome\Application\chrome.exe"

# Linux
export CHROME_EXECUTABLE=/usr/bin/google-chrome
```

### 7.6 Se o Android der erro: apagar e recriar a pasta `android`

Erros de Gradle, plugin não encontrado ou diferença de versões (comuns depois de atualizar o Flutter)
costumam se resolver recriando a pasta `android`:

1. Pare o app e apague a pasta `android`:
```bash
   # Windows (PowerShell)
   Remove-Item -Recurse -Force android

   # Linux e macOS
   rm -rf android
```
2. Recrie só o Android com os arquivos da versão atual do Flutter:
```bash
   flutter create --platforms=android .
```
   Se o Flutter reclamar do nome do projeto, use `flutter create --project-name favatonka --platforms=android .`
3. Limpe e rode de novo:
```bash
   flutter clean
   flutter pub get
   flutter run
```

| Comando | Para que serve |
|---|---|
| `Remove-Item -Recurse -Force android` / `rm -rf android` | Apaga a pasta `android` com a configuração que deu erro. |
| `flutter create --platforms=android .` | Recria **apenas** a pasta `android`. Não mexe em `lib/`, `recursos/` nem no `pubspec.yaml`. |
| `flutter clean` | Apaga os arquivos de build antigos. |
| `flutter pub get` | Baixa as bibliotecas de novo. |
| `flutter run` | Compila e abre o app. |

> Ao recriar, o **ícone** e o **nome** personalizados do Android voltam ao padrão. Para recuperá-los,
> copie as pastas `android/app/src/main/res/mipmap-*` do repositório completo e troque
> `android:label="favatonka"` por `android:label="FavaTonka"` em `android/app/src/main/AndroidManifest.xml`.

### 7.7 Credenciais de teste

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
