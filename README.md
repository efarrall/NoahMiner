# NoahMiner

A shared Minecraft world you can host at home. This folder contains the **world save** and server settings. Each person downloads the official Minecraft server program separately (Mojang does not allow bundling it in GitHub).

**Important:** Everyone must use the same Minecraft version: **26.2 Snapshot 7** (Java Edition). In the launcher, enable snapshots under *Installations* → *Snapshots*, then install **26.2 Snapshot 7**.

---

## What you need once per computer

| Item | Where to get it |
|------|-----------------|
| **Git** | [git-scm.com](https://git-scm.com/) (Windows) or your Linux package manager |
| **Java 25 or newer** | Required for Minecraft 26.2 — see below |
| **This repo** | Clone from GitHub (see below) |
| **server.jar** | Use the download script in this repo (one click / one command) |
| **playit.gg** (online play, no router setup) | Free — see [Playing over the internet](#playing-over-the-internet-playitgg) |

You do **not** need to buy Minecraft again to host, but you need a Java Edition account to play, and players connect with the same snapshot version.

---

## First-time setup

### 1. Get the project folder

**Windows (Git Bash or PowerShell):**

```text
cd %USERPROFILE%\fun\minecraft
git clone git@github.com:efarrall/NoahMiner.git
cd NoahMiner
```

**Linux:**

```bash
mkdir -p ~/fun/minecraft
cd ~/fun/minecraft
git clone git@github.com:efarrall/NoahMiner.git
cd NoahMiner
```

(If you use HTTPS instead of SSH: `git clone https://github.com/efarrall/NoahMiner.git`)

### 2. Install Java 25

Minecraft **26.2** needs **Java 25**, not Java 21. If you see `class file version 69.0` or `only recognizes class file versions up to 65.0`, your Java is too old.

**Linux (Ubuntu/Debian):**

```bash
sudo apt update
sudo apt install openjdk-25-jre-headless
java -version
```

You should see `openjdk version "25"` (or higher).

**Windows:** Install [Eclipse Temurin **25**](https://adoptium.net/temurin/releases/?version=25) (not 21). During setup, check “Add to PATH” if offered. Open a **new** Command Prompt and run `java -version`.

### 3. Download the Minecraft server

**Windows:** Double-click `scripts\download-server.bat`  
(wait until it says it saved `server.jar`)

**Linux:**

```bash
chmod +x scripts/download-server.sh scripts/find-java.sh start-server.sh
./scripts/download-server.sh
```

This downloads the official `server.jar` (~50 MB). It is **not** stored on GitHub.

### 4. Accept the Minecraft EULA

1. Open `eula.txt` in Notepad (Windows) or any text editor (Linux).
2. Change the line `eula=false` to `eula=true`.
3. Save the file.

Read the EULA: https://aka.ms/MinecraftEULA

---

## Starting the server

**Windows:** Double-click `start-server.bat`

**Linux:**

```bash
./start-server.sh
```

The first start can take a few minutes while the world loads. When you see `Done!` in the log, the server is ready.

**Stop the server safely:** Click the server window, type `stop`, press Enter. Wait until the program exits. Do not close the window with the X button while people are playing—use `stop` so the world saves.

---

## Letting friends join

### On the same computer as the server

In Minecraft → **Multiplayer** → **Add Server**, use:

```text
localhost
```

### On the same home Wi‑Fi (another device in the house)

1. On the hosting PC, find its local IP:
   - **Windows:** Command Prompt → `ipconfig` → **IPv4 Address** (e.g. `192.168.1.42`)
   - **Linux:** `hostname -I` (first address)
2. On the other device, add server address: `192.168.1.42` (your real IP)

### Playing over the internet (playit.gg)

If your router **cannot** do port forwarding (or you don’t want to), use **[playit.gg](https://playit.gg/)** — the same kind of service that gives addresses like `z-es.gl.joinmc.link`. Friends type **that address** in Minecraft, not your home IP.

You need **two programs running** while people play:

1. **Minecraft server** — `./start-server.sh` (or `start-server.bat`) until you see `Done!`
2. **playit agent** — keeps the tunnel open (see setup below)

#### playit.gg setup on Linux (recommended for NoahMiner hosts)

**One-time install (Ubuntu/Debian):**

```bash
curl -SsL https://playit-cloud.github.io/ppa/key.gpg | gpg --dearmor | sudo tee /etc/apt/trusted.gpg.d/playit.gpg >/dev/null
echo "deb [signed-by=/etc/apt/trusted.gpg.d/playit.gpg] https://playit-cloud.github.io/ppa/data ./" | sudo tee /etc/apt/sources.list.d/playit-cloud.list
sudo apt update
sudo apt install playit
```

*(Other distros: download `playit-linux-amd64` from [playit.gg/download](https://playit.gg/download), `chmod +x`, run `./playit-linux-amd64`.)*

**One-time account link:**

```bash
playit setup
```

Follow the link in the terminal, sign in (or create a free account at [playit.gg](https://playit.gg/)), and **claim** this computer as an agent.

**Create the Minecraft tunnel (one-time, or via website):**

1. Open [playit.gg](https://playit.gg/) → log in → **Agents** → pick your computer.
2. **Add tunnel** (or **Create tunnel**).
3. Type: **Minecraft Java**
4. Local address: `127.0.0.1` and port **25565** (must match `server.properties` — default is 25565).
5. Save. playit shows a public address like `something.gl.joinmc.link`.

**Share that address** with friends. They paste it into **Server Address** in Minecraft. No port number needed for the default setup.

**Every time you host:**

```bash
# Terminal 1 — start Minecraft first, wait for Done!
cd ~/fun/minecraft/NoahMiner
./start-server.sh

# Terminal 2 — start playit (leave running)
playit start
# or, if you installed the raw binary: ./playit-linux-amd64
```

If you use `sudo systemctl start playit` for 24/7, you only need to start the Minecraft server yourself.

#### playit.gg on Windows

1. Download the Windows agent from [playit.gg/download](https://playit.gg/download).
2. Run it, claim the agent via the link it shows (same account as Linux is fine).
3. Create a **Minecraft Java** tunnel to `127.0.0.1:25565`.
4. Start `start-server.bat`, then keep the playit app running.
5. Give friends the `*.gl.joinmc.link` address.

#### playit troubleshooting

| Problem | Fix |
|---------|-----|
| **Unknown host** when joining `*.joinmc.link` | [Update DNS on Linux](https://playit.gg/support/linux-update-dns/) (Google `8.8.8.8` or Cloudflare `1.1.1.1`) |
| Friends can’t connect | Is `./start-server.sh` showing `Done!`? Is playit still running? |
| Tunnel disconnected | Restart playit; address usually stays the same |
| Wrong version | Everyone on **26.2 Snapshot 7** |

### Port forwarding (optional, not required with playit)

Only if you prefer not to use playit: forward **TCP 25565** on your router to the hosting PC, then give friends your **public IP** from [whatismyip.com](https://whatismyip.com). Most NoahMiner hosts should use playit instead.

**Security:** `online-mode=true` means only real Minecraft accounts can join (recommended).

---

## Updating the world from GitHub

Only **one person** should run the server at a time. The world file is shared through Git.

**Before you host** (get the latest builds from everyone):

```bash
git pull
```

**After you stop the server** (share your session with everyone):

```bash
git add world
git commit -m "World update after playing"
git push
```

If Git complains about conflicts, ask in your group chat—do not guess. Someone else may have pushed without pulling first.

**Never** run `git push` while the server is still running.

---

## Troubleshooting

| Problem | What to try |
|---------|-------------|
| `class file version 69.0` / `up to 65.0` | Install **Java 25** (see step 2), then run `./start-server.sh` again |
| `java` is not recognized | Install Java 25 and restart the terminal / PC |
| `server.jar not found` | Run the download script again |
| Server asks about EULA | Set `eula=true` in `eula.txt` |
| Friends can’t connect (playit) | Server at `Done!`? playit running? Correct `*.gl.joinmc.link` address? |
| Friends can’t connect (LAN) | Same Wi‑Fi? Firewall allowing Java / port 25565? |
| “Outdated server” / version mismatch | Everyone must use **26.2 Snapshot 7** (see `minecraft-version.txt`) |
| World looks wrong after update | `git pull` before starting, `stop` before pushing |

**More memory (lag with many players):**  
- Linux: `NOAHMINER_MEMORY=4G ./start-server.sh`  
- Windows: Edit `start-server.bat` and change `-Xms2G -Xmx2G` to `-Xms4G -Xmx4G` (only if you have enough RAM).

---

## What’s in this repo

| Path | Purpose |
|------|---------|
| `world/` | The shared map and player progress |
| `server.properties` | Game rules, max players, port, etc. |
| `minecraft-version.txt` | Exact Minecraft version for the download script |
| `eula.txt` | Mojang license acceptance (you must edit once) |
| `scripts/` | Download helpers and Java version check |
| `start-server.sh` / `start-server.bat` | Start the server |

Files **not** in Git (you create them locally): `server.jar`, `logs/`, `ops.json`, playit agent binary (if not installed via apt), etc.
