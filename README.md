
# Time-Favorito ⚽

Aplicativo Flutter para **escolher, salvar e exibir** o seu time do coração.  
O app usa **Rotas Nomeadas**, **SharedPreferences** para persistência local e leitura de **JSON** em `assets` para carregar a lista de times. Inclui **Splash** com animação **Lottie** e uma **tela de introdução (Intro)** com múltiplas páginas.

---

## ✨ Funcionalidades

- **Escolha de time favorito** a partir de uma lista carregada de `assets/data/teams.json`.
- **Persistência local** do time escolhido usando `SharedPreferences` (chave `favorite_team`). 
- **Tela inicial (Home)** exibe o time salvo (nome e logo) ou uma imagem genérica com mensagem de orientação. 
- **Trocar/Remover time** diretamente pela Home (ícone de exclusão sobre o card). 
- **Tela de seleção (Select)** com **busca** para filtrar times e retorno imediato à Home após a escolha.
- **Splash Screen** com **Lottie** e decisão de rota (Intro ↔ Home) com base no `SharedPreferences` (chave `show_intro`). 
- **Tela de Introdução (Intro)** paginada com Lottie, botão **“Não mostrar novamente”** e navegação “Voltar/Avançar/Concluir”.

---

## 🧭 Rotas Nomeadas

- `/` → **Splash** (rota inicial)  
- `/intro` → **Intro**  
- `/home` → **Home**  
- `/select` → **Select**  
As rotas são centralizadas em `routes.dart` com um `onGenerateRoute` que instancia as telas correspondentes.

---

## 🗂 Estrutura sugerida do projeto

```text
lib/
├─ main.dart
├─ routes.dart
├─ data/
│  ├─ teams_repository.dart        # Lê JSON de assets e mapeia para List<Team>
│  └─ user_settings_repository.dart# SharedPreferences (favorite_team, show_intro)
├─ model/
│  └─ team.dart                    # id, name, logo + fromJson/toJson
├─ screens/
│  ├─ splash/splash_screen.dart
│  ├─ intro/intro_screen.dart
│  ├─ home/home_screen.dart
│  └─ select/select_screen.dart
assets/
├─ data/teams.json
├─ images/...(logos e generico.png)
└─ lottie/...(splash.json, intro1.json, intro2.json, intro3.json)
```

> O `TeamsRepository` usa `rootBundle.loadString` para ler o `JSON` de `assets/data/teams.json`.  
> O `UserSettingsRepository` provê `getTeam/setTeam/clearTeam` e `getShowIntro/setShowIntro`. 

---

## 🧩 Modelos e Repositórios

### `Team` (modelo)
- Campos: `id`, `name`, `logo`.  
- Métodos: `fromJson(Map)`, `toJson()`.

### `TeamsRepository`
- `load()` → lê `assets/data/teams.json`, decodifica e retorna `List<Team>`. 

### `UserSettingsRepository`
- `getTeam()` / `setTeam(team)` / `clearTeam()` usando chave `favorite_team`.  
- `getShowIntro()` / `setShowIntro(bool)` usando chave `show_intro`.

---

## 🏁 Fluxo de navegação

1. **Splash (`/`)**  
   - Mostra animação Lottie (~2s).  
   - Lê `show_intro` no `SharedPreferences`: se `true` → `/intro`; senão → `/home`. 

2. **Intro (`/intro`)**  
   - `PageView` com 3 páginas (Lottie + título + subtítulo).  
   - Checkbox “**Não mostrar novamente**” (salva `!dontShowAgain` em `show_intro`).  
   - Botões “Voltar/Avançar/Concluir”. Ao concluir → `/home`.

3. **Home (`/home`)**  
   - `FutureBuilder<Team?>` busca o time salvo.  
   - Se **existe**: mostra **nome e logo** + botão **trocar** (AppBar) e **excluir** (ícone no card).  
   - Se **não existe**: mostra imagem `assets/images/generico.png` e mensagem; toque abre `/select`. 

4. **Select (`/select`)**  
   - Carrega lista de times do JSON via `TeamsRepository`.  
   - Campo **buscar** filtra a lista em memória.  
   - Ao tocar em um time: salva (`setTeam`) e `pop()` para Home.

---

## 🗃️ Estrutura do JSON

Exemplo de item em `assets/data/teams.json`:
```json
[
  { "id": 1, "name": "Flamengo", "logo": "assets/images/flamengo.png" }
]
```
> Certifique-se de registrar os **assets** no `pubspec.yaml` (ver seção a seguir). 

---

## 📦 Dependências e Assets

No `pubspec.yaml`:

```yaml
dependencies:
  flutter:
    sdk: flutter
  cupertino_icons: ^1.0.8
  shared_preferences: ^2.5.3
  lottie: 3.3.1

flutter:
  assets:
    - assets/images/
    - assets/data/
    - assets/lottie/
```

- `shared_preferences` → persistência local (time e flag de introdução).  
- `lottie` → animações da Splash e Intro.  
- Registre as pastas `assets/images`, `assets/data` e `assets/lottie`.

---

## 📱 Design Responsivo

- O app utiliza **layout flexível** com `Column` + `Expanded`/`ListView`, **`Padding`** e **`SafeArea`**, além de componentes como `Card`, `InkWell`, `Stack` e `Image.asset` com `BoxFit.contain`. Isso oferece **responsividade básica** (adaptação fluida ao espaço disponível). 
- **Não há** uso de bibliotecas de responsividade (ex.: `responsive_framework`, `flutter_screenutil`) nem **breakpoints específicos**. Para telas grandes (web/desktop/tablet), recomenda-se evoluir para grades ou layouts com `LayoutBuilder`/`MediaQuery` e, se necessário, um framework de responsividade. *(Ver melhorias abaixo.)* 

---

## ▶️ Como executar

```bash
# Clonar
git clone https://github.com/NicolasMachado777/Time-Favorito.git
cd Time-Favorito

# Instalar dependências
flutter pub get

# Rodar em um dispositivo/emulador
flutter run
```

> Se quiser testar **Web**, habilite e rode no Chrome:
```bash
flutter config --enable-web
flutter run -d chrome
```
---

## 🛠️ Pontos técnicos em destaque

- **Rotas Nomeadas** → `/`, `/intro`, `/home`, `/select`.  
- **Gerência de estado** → `setState` + `FutureBuilder`.  
- **Persistência** → `SharedPreferences` para `favorite_team` (objeto serializado JSON) e `show_intro` (bool).  
- **Lista e Busca** → `ListView.separated` + filtro em memória com `toLowerCase().contains(...)`.  
- **UI** → `Card` + `InkWell` + `Stack` na Home (com ícone de **excluir** posicionado).  
- **Splash/Intro** → **Lottie** para animações, `PageView` na Intro e decisão de rota na Splash. 
