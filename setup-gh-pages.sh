#!/usr/bin/env bash
# One-time setup: creates the orphan gh-pages branch that holds manifest.json
# and update_manifest.py. The release workflow commits the manifest there, but
# the published site is deployed by the Pages workflow, not from the branch.

set -e

echo "Setting up gh-pages branch..."

git checkout --orphan gh-pages
git rm -rf . --quiet

cat > manifest.json << 'MANIFEST'
[
  {
    "category": "Music",
    "guid": "6c8a80b7-3e2f-4d5a-9b1c-f7e8d9a0b2c3",
    "name": "Musian",
    "description": "Your music, without the scrolling. Musian adds a mood music player to your Jellyfin server: tap the colour wheel and it plays tracks that match, chosen from the genre and mood tags in your files. Free. Android app with background playback and Android Auto: https://play.google.com/store/apps/details?id=com.musian.app",
    "overview": "Up is high energy, down is low. Right is positive, left is negative. The corners are Angry and Tense, Happy and Excited, Sad and Lonely, Calm and Serene. Tap near an edge and the genres blend.",
    "owner": "ciantm",
    "imageUrl": "https://raw.githubusercontent.com/ciantm/jellyfin-plugin-musian/main/assets/logo.png",
    "versions": []
  }
]
MANIFEST

git show main:update_manifest.py > update_manifest.py

git add manifest.json update_manifest.py
git commit -m "chore: initialise gh-pages with empty manifest"
git push origin gh-pages

git checkout main

echo "Done. gh-pages branch created."
echo
echo "Required: GitHub repo -> Settings -> Pages -> Source: GitHub Actions"
echo "Do not choose 'Deploy from a branch'. deploy-pages runs from main, and a"
echo "branch-based source rejects it with an environment protection error."
echo
echo "The gh-pages branch is still used by the release workflow, but it is not"
echo "the deploy source."
echo
echo "Manifest: https://ciantm.github.io/jellyfin-plugin-musian/manifest.json"
