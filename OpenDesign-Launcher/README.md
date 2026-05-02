# Open Design — Taskleisten-Launcher

Schnellzugriff auf Start / Stop / Restart des Open-Design-Servers, damit er täglich ohne Terminal-Tipperei nutzbar ist.

## Speicherort

- **Launcher:** `<repo>\OpenDesign-Launcher\` (liegt im Repo)
- **Repo:** auf diesem Rechner `C:\Users\Dictator\Documents\open-design`

> Auf einem anderen PC zeigen die `.cmd`-Skripte und die `.lnk`-Verknüpfungen noch auf diesen Pfad. Nach dem Klonen einmalig den Repo-Pfad anpassen — siehe **Auf neuem Rechner einrichten** unten.

## Dateien

| Datei | Zweck |
|---|---|
| `OpenDesign.cmd` | Interaktives Menü mit allen Aktionen (für Taskleiste empfohlen) |
| `OpenDesign-Start.cmd` | 1-Klick: Server starten (daemon + web im Hintergrund) |
| `OpenDesign-Stop.cmd` | 1-Klick: Server stoppen |
| `OpenDesign-Restart.cmd` | 1-Klick: Server neu starten |
| `OpenDesign-Status.cmd` | 1-Klick: Status + Web-URL anzeigen |
| `_pnpm.cmd` | Helper: ruft intern `pnpm tools-dev …` auf, mit Fallback auf `%APPDATA%\npm\pnpm.cmd` |
| `*.lnk` | Verknüpfungen mit Icons — diese an die Taskleiste pinnen |

## Bedienung

1. Doppelklick auf `OpenDesign.cmd` (oder die Verknüpfung an der Taskleiste).
2. Im Menü `[1] Starten` wählen.
3. Im Browser die Web-URL öffnen, z.B. `http://127.0.0.1:50445`. Die Port-Nummer ändert sich pro Lauf — `[4] Status` zeigt sie an.
4. Am Ende des Tages `[2] Stoppen`.

## Menüpunkte

| Nr. | Aktion | Befehl im Hintergrund |
|---|---|---|
| 1 | Starten | `pnpm tools-dev start web` |
| 2 | Stoppen | `pnpm tools-dev stop` |
| 3 | Neustart | `pnpm tools-dev restart web` |
| 4 | Status | `pnpm tools-dev status` |
| 5 | Logs anzeigen | `pnpm tools-dev logs` |
| 6 | Im Vordergrund | `pnpm tools-dev run web` (Strg+C zum Beenden) |
| 7 | Check | `pnpm tools-dev check` |
| 8 | Mit Desktop-Shell | `pnpm tools-dev` (Electron, kann timeout werfen — siehe Hinweis unten) |
| 9 | Web-URL anzeigen | parsed `status --json` |
| 0 | Beenden | — |

## An die Taskleiste anheften

1. Explorer öffnen: `C:\Users\Dictator\OpenDesign-Launcher\`
2. Rechtsklick auf `Open Design.lnk` → **Weitere Optionen anzeigen** → **An Taskleiste anheften**
   - Falls die Option fehlt: per Drag & Drop auf die Taskleiste ziehen.
3. Empfehlung: nur `Open Design.lnk` anpinnen — das Menü deckt alles ab. Optional die Einzel-Buttons.

## Was beim Setup auf diesem Rechner repariert wurde

Drei Hürden mussten einmalig gelöst werden, damit der Server überhaupt startet:

### 1. `pnpm` fehlte im PATH

```powershell
npm install -g pnpm@10.33.2
```

Landet in `%APPDATA%\npm\` (im User-PATH, kein Admin nötig). `corepack enable` brauchte Admin-Rechte und wurde umgangen.

### 2. `better-sqlite3` ließ sich nicht bauen

`better-sqlite3@^11.10.0` (im Repo gepinnt) liefert keine Prebuilds für Node 24 (ABI 137). Der Fallback auf `node-gyp rebuild` scheiterte an fehlenden **Visual Studio C++ Build Tools**.

**Lösung:** In `apps/daemon/package.json` auf eine neuere Version gebumpt:

```diff
- "better-sqlite3": "^11.10.0",
+ "better-sqlite3": "^12.9.0",
```

`v12.9.0` enthält `better-sqlite3-v12.9.0-node-v137-win32-x64.tar.gz` als Prebuild — kein Compiler nötig. Danach `pnpm install` lief in ~6 Sekunden sauber durch.

> Diese Repo-Änderung wurde im Repo **commited**, profitiert also auch jedem anderen Klon auf Node 24.

### 3. Electron-Desktop schmiss Timeout-Fehler

`pnpm tools-dev` (ohne Sub-Befehl) startet zusätzlich die Electron-Shell, die hier nicht ordentlich konfiguriert ist und mit `desktop did not expose status in time` abbricht. Daemon + Web laufen trotzdem.

**Lösung:** Launcher verwendet konsequent `start web` / `restart web`. Electron bleibt weg, alles läuft sauber. Wer es trotzdem ausprobieren möchte: Menüpunkt `[8]`.

## Voraussetzungen (zur Erinnerung)

- Node.js `~24`
- pnpm `10.33.2` — global via npm (`npm install -g pnpm@10.33.2`)
- Repo irgendwo lokal geklont
- `pnpm install` einmal im Repo-Root ausgeführt (`node_modules/` muss existieren)

## Auf neuem Rechner einrichten

1. Repo klonen, `pnpm install` im Repo-Root.
2. In allen `OpenDesign*.cmd` (in diesem Ordner) den Pfad `C:\Users\Dictator\Documents\open-design` durch den eigenen Repo-Pfad ersetzen — Suchen & Ersetzen über alle 5 Dateien reicht.
3. Die `.lnk`-Verknüpfungen sind absolute Windows-Shortcuts und überleben den Klon nicht. Entweder neu erstellen (Rechtsklick auf z.B. `OpenDesign.cmd` → *Senden an* → *Desktop (Verknüpfung erstellen)*) oder die `.cmd` direkt an die Taskleiste pinnen.
4. Repo-relevante Änderung, die schon im Repo steckt: `better-sqlite3` ist auf `^12.9.0` gebumpt (Prebuilds für Node 24). Kein zusätzlicher Schritt nötig.

## Erweitern

- Repo verschoben? In allen `*.cmd` den Pfad `C:\Users\Dictator\Documents\open-design` anpassen.
- Eigene Aktion? Ein neues `OpenDesign-XYZ.cmd` nach Vorbild erstellen, z.B.:
  ```cmd
  @echo off
  title Open Design - XYZ
  cd /d "C:\Users\Dictator\Downloads\Open-Design"
  call "%~dp0_pnpm.cmd" <dein-tools-dev-subcommand>
  pause
  ```
- Andere Ports? `_pnpm.cmd` aufrufen mit z.B. `start web --daemon-port 17456 --web-port 17573`.
