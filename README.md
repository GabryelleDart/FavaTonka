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
| 10. Instruções para rodar  | Seção 7 deste README (Android Studio, Chrome, pelo terminal ou pelo botão de play). |
| 8 e 9. Vídeo de até 3 minutos | Entregue à parte, com link testado. |

## 5. Tecnologias

- **Flutter 3.47.2** (stable, Dart 3.13.2), com Material 3. É a versão usada no desenvolvimento e travada no `pubspec.yaml`, que aceita só a série 3.47.x.
- **JDK 17 ou superior** para o build Android (o JDK que acompanha o Android Studio serve).
- **Gradle 9.3.1**, **Android Gradle Plugin 9.1.0** e **Kotlin 2.4.0**: já fixados em `android/` (o Gradle é baixado sozinho pelo `gradlew`).
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

O FavaTonka foi testado de duas formas: no **emulador do Android Studio** (Medium Phone) e no **Chrome**.
Em cada uma você pode rodar pelo **terminal** (`flutter run`) ou pelo **botão de play** do VS Code.
Siga os passos 7.1 a 7.3 uma vez e depois escolha a forma que preferir (7.4 ou 7.5).

### 7.1 O que instalar

| Item | Para que serve |
|---|---|
| **Git** | Baixar o projeto do GitHub (opcional se você baixar o zip). |
| **VS Code** com as extensões **Flutter** e **Dart** | Editor onde o projeto é aberto e executado. |
| **Flutter 3.47.2** (stable, Dart 3.13.2) | https://docs.flutter.dev/get-started/install. Versões fora da série 3.47.x são recusadas pelo `flutter pub get`. |
| **JDK 17 ou superior** | Necessário para o build Android. O JDK que acompanha o Android Studio serve. |
| **Android Studio** (SDK e emulador) | Necessário só para a forma 7.4. |
| **Google Chrome** | Necessário só para a forma 7.5. |
| **Internet** | Usada na primeira execução. |

### 7.2 Baixar o projeto

Escolha **uma** das opções:

**Opção A: clonar com o Git**

```bash
git clone <URL-DO-REPOSITORIO>
cd FavaTonka
```

**Opção B: baixar o zip**

1. No GitHub, clique em **Code → Download ZIP**.
2. Extraia o zip. A pasta extraída pode se chamar `FavaTonka-main`.
3. Abra um terminal dentro dessa pasta (a que contém o arquivo `pubspec.yaml`).

Depois, no VS Code: **File → Open Folder** e escolha essa pasta. Abra sempre a pasta **raiz** do projeto,
nunca só a pasta `android`.

### 7.3 Conferir o ambiente e baixar as bibliotecas

No terminal do VS Code (**Terminal → New Terminal**), dentro da pasta do projeto:

```bash
flutter --version
java -version
flutter doctor -v
flutter pub get
```

| Comando | Para que serve |
|---|---|
| `flutter --version` | Mostra a versão do Flutter. Deve ser a **3.47.2**. |
| `java -version` | Mostra o JDK. Deve ser a versão **17 ou superior**. |
| `flutter doctor -v` | Diagnóstico da instalação. Resolva o que aparecer com `[!]` ou `[✗]` na plataforma que você vai usar. |
| `flutter pub get` | Baixa as bibliotecas (`provider`, `share_plus`, `intl`...) nas versões exatas do `pubspec.lock`. |

> Se o VS Code mostrar o aviso "Get packages", clique nele: faz o mesmo que `flutter pub get`.
> Logo depois de abrir o projeto, é normal ver muitos erros em `lib/` até as bibliotecas serem baixadas.

> **A primeira execução demora** (de 3 a 10 minutos no Android). O Gradle baixa suas ferramentas e
> compila tudo do zero. Da segunda vez em diante leva segundos. Não cancele.

### 7.4 Forma 1: emulador do Android Studio (Medium Phone)

#### Preparação (uma vez só)

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
3. Crie o emulador: *More Actions → Virtual Device Manager → Create Device*, escolha **Medium Phone**,
   uma imagem do sistema e clique em *Finish*.
4. Aceite as licenças do Android SDK (digite `y` em cada pergunta):
```bash
   flutter doctor --android-licenses
```

#### Rodar pelo terminal

```bash
flutter emulators
flutter emulators --launch <ID-DO-EMULADOR>
flutter devices
flutter run
```

| Comando | Para que serve |
|---|---|
| `flutter emulators` | Lista os emuladores criados e o id de cada um (o do Medium Phone aparece aqui). |
| `flutter emulators --launch <ID-DO-EMULADOR>` | Abre o emulador. Troque pelo id mostrado no comando anterior. |
| `flutter devices` | Confirma que o emulador aparece como dispositivo (algo como `emulator-5554`). |
| `flutter run` | Compila o app, instala no emulador e abre. Com mais de um dispositivo, use `flutter run -d emulator-5554`. |

#### Rodar pelo botão de play do VS Code

1. Abra o emulador (pelo comando acima ou pelo *Device Manager* do Android Studio).
2. **Espere a tela inicial do Android aparecer** (relógio e ícones). Se rodar antes disso, aparece
   `device is still booting`.
3. Na barra azul inferior do VS Code, clique no nome do dispositivo (canto direito) e escolha
   o emulador **Medium Phone**.
4. Abra o arquivo `lib/main.dart` e clique em **▷ Run** (acima de `void main()`),
   no botão de play no canto superior direito, ou aperte **F5**.

Se o Flutter não achar o SDK, informe o caminho: `flutter config --android-sdk "<CAMINHO-DO-SDK>"`.
No Windows, ele costuma ficar em `C:\Users\<usuário>\AppData\Local\Android\Sdk`.

### 7.5 Forma 2: Chrome

Não precisa de emulador, Java nem Gradle. Instale o **Google Chrome**.

#### Rodar pelo terminal

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

#### Rodar pelo botão de play do VS Code

1. Na barra azul inferior do VS Code, clique no nome do dispositivo e escolha **Chrome (web)**.
2. Abra o arquivo `lib/main.dart` e clique em **▷ Run** (acima de `void main()`),
   no botão de play no canto superior direito, ou aperte **F5**.


Se o Chrome não for encontrado, informe o caminho dele:

```bash
# Windows (PowerShell)
$env:CHROME_EXECUTABLE="C:\Program Files\Google\Chrome\Application\chrome.exe"

# Linux
export CHROME_EXECUTABLE=/usr/bin/google-chrome
```

### 7.6 Se o Android der erro de Gradle

O repositório já traz as versões fixadas (Gradle 9.3.1, Android Gradle Plugin 9.1.0, Kotlin 2.4.0 e
Flutter 3.47.2). Antes de mexer na pasta `android`, siga esta ordem:

1. **Confira o ambiente.** O Flutter deve ser o 3.47.2 e o Java, 17 ou superior:
```bash
   flutter --version
   java -version
```
2. **Limpe e rode de novo:**
```bash
   flutter clean
   flutter pub get
   flutter run
```
3. **Veja o erro de verdade.** O texto importante vem depois de `What went wrong:`. Para ver tudo:
```bash
   flutter run -v
```
4. **Último recurso: recriar a pasta `android`.** Só faça se os passos acima não resolverem:
```bash
   # Windows (PowerShell)
   Remove-Item -Recurse -Force android

   # Linux e macOS
   rm -rf android

   flutter create --project-name favatonka --platforms=android .
```

| Comando | Para que serve |
|---|---|
| `flutter clean` | Apaga os arquivos de build antigos. |
| `flutter pub get` | Baixa as bibliotecas nas versões do `pubspec.lock`. |
| `flutter run -v` | Roda mostrando todos os detalhes, para achar a primeira mensagem de erro. |

> **Aviso "Gradle: Build Error" na barra inferior do VS Code:** quase sempre é só a extensão de Java, e não
> o app. Se o `flutter run` ou o play funcionam, ignore. Para limpar o aviso, use `Ctrl+Shift+P` e
> "Developer: Reload Window". Veja a seção 8.

> Ao recriar a pasta `android`, o Flutter usa o modelo da versão instalada, que pode trazer outras versões de
> Gradle e Kotlin, e o **ícone** e o **nome** do app voltam ao padrão. Para recuperá-los, copie as pastas
> `android/app/src/main/res/mipmap-*` do GitHub e troque `android:label="favatonka"` por
> `android:label="FavaTonka"` em `android/app/src/main/AndroidManifest.xml`. Por isso este é o último recurso.

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
| `Plugin with id 'com.android.library' not found` (projetos `jni`, `jni_flutter` ou `share_plus`) | Aviso do editor, que abre a pasta `android` de cada plugin isoladamente. Não afeta o app: se o `flutter run` funciona, ignore. O arquivo `.vscode/settings.json` do repositório já desliga essa análise; se o aviso continuar, use `Ctrl+Shift+P` e "Developer: Reload Window". |
| `Building with plugins requires symlink support` (Windows) | Ative o Modo de Desenvolvedor: execute `start ms-settings:developers`, ative a opção e reinicie o terminal. |
| `Because favatonka requires SDK version ...` ou `... requires Flutter SDK version ...` | A versão do Flutter é diferente da usada no projeto. Instale o **Flutter 3.47.2** e rode `flutter pub get` de novo. Confira com `flutter --version`. |
| Chrome não aparece em `flutter devices` | Rode `flutter config --enable-web` e depois `flutter doctor`. Se o Chrome estiver instalado e mesmo assim não aparecer, informe o caminho (seção 7.5). |
| Fotos ou fontes não mudam depois de editar | Arquivos de recursos só são lidos ao iniciar o app. Pare e rode `flutter run` de novo (hot reload não basta). Se persistir: `flutter clean` e `flutter pub get`. |
| Aparece um frasco desenhado no lugar da foto | O arquivo da foto não foi achado. Veja a seção 9. |
| Erro de Gradle depois de atualizar o Flutter | Volte para o Flutter 3.47.2. Depois: `flutter clean`, apague `android/.gradle` e rode `flutter run` de novo. |
| Qualquer erro estranho de build | `flutter clean`, `flutter pub get`, `flutter run`. Se continuar, rode `flutter run -v` e veja o primeiro erro. |
| **Gradle: Build Error** na barra inferior do VS Code | Quase sempre é aviso da extensão de Java, e não do app. Confirme rodando `flutter build apk --debug`: se terminar com `Built build\app\outputs\flutter-apk\app-debug.apk`, o projeto está certo. Para limpar o aviso: `Ctrl+Shift+P` e "Developer: Reload Window". |
| `WARNING: A restricted method in java.lang.System has been called` | Aviso do JDK 21 sobre o Gradle 9.3.1. Não impede o build, pode ignorar. |
| `Error: device is still booting` / `ADB exited with exit code 1` | O emulador ainda estava ligando. Espere a tela inicial do Android aparecer e rode de novo. Se persistir: `adb devices` (deve mostrar `device`) e, no Device Manager, *Cold Boot Now*. |
| A primeira execução demora vários minutos | É normal: o Gradle baixa as ferramentas e compila tudo. Depois fica rápido. |
| `flutter.sdk not set in local.properties` | O arquivo `android/local.properties` não existe. Ele é gerado pelo Flutter: rode `flutter pub get` na raiz do projeto. Não abra só a pasta `android` no editor. |

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
- Os emojis das notas usam a fonte de emoji do sistema, sem fonte embutida no projeto. No Android e no Windows aparecem coloridos; em computadores Linux podem aparecer sem cor se não houver uma fonte de emoji instalada (por exemplo, `sudo apt install fonts-noto-color-emoji`).

## 11. Créditos e avisos

- Notas e classificações olfativas conforme informações públicas (como Fragrantica e Parfumo) e de lojas.
  Podem diferir entre versões e concentrações do perfume. As descrições foram escritas para este projeto.
- As fotos dos frascos pertencem às respectivas marcas e são usadas apenas para fins
  educacionais neste trabalho acadêmico.
- Fontes **Lora** e **Poppins** sob a licença SIL Open Font License.
- Logotipo, banner e ícone do app criados para o projeto.
- Projeto acadêmico, sem fins comerciais e sem vínculo com as marcas citadas.
