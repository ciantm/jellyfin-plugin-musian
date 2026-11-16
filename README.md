# 🎵 Musian

A community Jellyfin plugin that turns your music library into a mood wheel: tap a feeling, get tracks.

This is a third-party plugin. Add the repository URL below; it is not in the official Jellyfin catalogue.

---

## Install via Plugin Repository (recommended)

1. Open Jellyfin → **Dashboard → Plugins → Repositories**
2. Click **+** and add this URL:
   ```
   https://ciantm.github.io/jellyfin-plugin-musian/manifest.json
   ```
3. Go to **Catalogue**, search for **Musian**, and install
4. Restart Jellyfin
5. **Musian** will appear in the sidebar for all users

---

## 📱 Also on Android

The Musian Android app plays the same wheel from your phone, with background playback,
lock-screen controls and Android Auto. The plugin stays free and fully featured; the app
is an optional paid upgrade.

[Get Musian on Google Play](https://play.google.com/store/apps/details?id=com.musian.app)

---

## How it works

Click anywhere on the circular mood wheel — your position maps to two emotional axes:

| Axis | Direction |
|------|-----------|
| **Valence** (positive/negative) | ← negative · positive → |
| **Arousal** (energy level) | ↓ passive · active ↑ |

**Quadrant moods:**

| Quadrant | Mood | Default genres |
|----------|------|----------------|
| 🔴 Top-left  | Angry / Tense     | Metal, Punk, Hard Rock, Industrial |
| 🟡 Top-right | Happy / Excited   | Pop, Dance, Electronic, Funk, House |
| 🔵 Bottom-left  | Sad / Melancholic | Blues, Soul, Folk, Indie |
| 🟢 Bottom-right | Calm / Relaxed    | Jazz, Ambient, Classical, Acoustic |

Clicking near edges blends genres from adjacent moods automatically.

---

## Requirements

- Jellyfin **10.9** or later (tested on 12.4)
- Audio tracks with **Genre** tags set in your library
- .NET **8.0** SDK (only needed if building from source)

---

## Publishing a new release

Bump `version:` in `build.yaml`, then commit and push to `main`:

```bash
# edit build.yaml -> version: "3.1.93.0"
git commit -am "release 3.1.93.0"
git push origin main
```

The GitHub Actions workflow builds the DLL, creates the Release, and publishes
the updated `manifest.json` to GitHub Pages automatically.

> Keep the version in `build.yaml` and `Jellyfin.Plugin.Musian.csproj` in sync.

---

## Submitting to the official Jellyfin Plugin Catalogue

To get Musian listed without needing a manual repo URL:

1. Ensure the repo is public with at least one release
2. Open a PR at [jellyfin/jellyfin-plugin-repository](https://github.com/jellyfin/jellyfin-plugin-repository)
3. Follow the review checklist in that repo

---

## Build from source

```bash
git clone https://github.com/ciantm/jellyfin-plugin-musian.git
cd jellyfin-plugin-musian
dotnet build Jellyfin.Plugin.Musian -c Release
```

Copy the DLL to your Jellyfin plugins folder:

- **Linux:** `~/.local/share/jellyfin/plugins/Musian_1.0.0.0/`
- **Windows:** `%APPDATA%\Jellyfin\plugins\Musian_1.0.0.0\`
- **Docker:** `/config/plugins/Musian_1.0.0.0/`

---

## Licence

MIT — see [LICENSE](LICENSE).
