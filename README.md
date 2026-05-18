# NoahMiner

A shared Minecraft world you can host at home. This folder contains the **world save** and server settings. Each person downloads the official Minecraft server program separately (Mojang does not allow bundling it in GitHub).

**Important:** Everyone must use the same Minecraft version: **26.2 Snapshot 7** (Java Edition). In the launcher, enable snapshots under *Installations* → *Snapshots*, then install **26.2 Snapshot 7**. (It's prolly enabled anyway so if the snapshot's in your dropdown just click it)

# EXTRA IMPORTANT: IF YOU ARE HOSTING YOU MUST git pull BEFORE STARTING THE SERVER AND PUSH THE NEW SAVE AFTER STOPPING. SAVE CONFLICTS CANNOT BE RESOLVED

---

## What you need once per computer

| Item | Where to get it |
|------|-----------------|
| **Git** | [git-scm.com](https://git-scm.com/) (Windows) or your Linux package manager |
| **Java 21 or newer** | [adoptium.net](https://adoptium.net/) — pick Temurin 21 LTS |
| **This repo** | Clone from GitHub (see below) |
| **server.jar** | Use the download script in this repo (one click / one command) |

You do **not** need to buy Minecraft again to host, but you need a Java Edition account to play, and players connect with the same snapshot version.

---

## First-time setup

### 1. Get the project folder

**Windows (Git Bash or PowerShell):**

You dont need to be in any specific folder to git clone, I just had mine in ~/fun/minecraft so gpt defaulted to there

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
Your gonna have to set up an SSH key prolly cause git wants them, you can probably set one up in like 15 min if you ask the hive mind

### 2. Install Java

- **Windows:** Install [Eclipse Temurin 21](https://adoptium.net/). During setup, check “Add to PATH” if offered.
- **Linux (Ubuntu/Debian):** `sudo apt install openjdk-21-jre`

Check it works:

```bash
java -version
```

You should see version **21** or higher.

### 3. Download the Minecraft server

**Windows:** Double-click `scripts\download-server.bat`  
(wait until it says it saved `server.jar`)

**Linux:** In a terminal:

```bash
chmod +x scripts/download-server.sh start-server.sh
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

### On your home network (LAN)

1. Find your computer’s local IP:
   - **Windows:** Open Command Prompt, run `ipconfig`, look for **IPv4 Address** (e.g. `192.168.1.42`).
   - **Linux:** Run `hostname -I` and use the first address.
2. Friends open Minecraft → **Multiplayer** → **Add Server**.
3. Address: `192.168.1.42` (use your real IP). Port is **25565** unless you changed it in `server.properties`.

### Over the internet

Your router must forward **port 25565 (TCP)** to the computer running the server. Steps differ per router; search for “port forwarding” in your router’s admin page. Give friends your **public IP** (search “what is my ip” in a browser) and port `25565`.

**Security note:** `online-mode=true` in `server.properties` means only real Minecraft accounts can join (recommended). Do not share your router password.

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
| `java` is not recognized | Install Java 21+ and restart the terminal / PC |
| `server.jar not found` | Run the download script again |
| Server asks about EULA | Set `eula=true` in `eula.txt` |
| Friends can’t connect | Same Wi‑Fi? Firewall blocking port 25565? Correct IP? |
| “Outdated server” / version mismatch | Everyone must use **26.2 Snapshot 7** (see `minecraft-version.txt`) |
| World looks wrong after update | Make sure you ran `git pull` before starting and `stop` before pushing |

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
| `scripts/` | Download helpers for `server.jar` |
| `start-server.sh` / `start-server.bat` | Start the server |

Files **not** in Git (you create them locally): `server.jar`, `logs/`, `ops.json`, etc.

