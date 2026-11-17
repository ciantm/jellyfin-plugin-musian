#!/usr/bin/env bash
# Run this ONCE in a fresh repository, after the first push to main.
#
# It creates an orphan gh-pages branch holding manifest.json and
# update_manifest.py. The release workflow checks that branch out, updates the
# manifest and commits it back — but the *published* site comes from the Pages
# workflow artifact, not from the branch. See the note at the end.

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

# Copy the manifest update script
git show main:update_manifest.py > update_manifest.py

git add manifest.json update_manifest.py
git commit -m "chore: initialise gh-pages with empty manifest"
git push origin gh-pages

git checkout main

echo "Done! gh-pages branch created."
echo
echo "NOW DO THIS — it is required, and getting it wrong breaks the deploy:"
echo "  GitHub repo -> Settings -> Pages -> Source: GitHub Actions"
echo
echo "Do NOT choose 'Deploy from a branch'. deploy-pages runs from the main"
echo "branch, and a branch-based Pages source rejects it with:"
echo "  'Branch main is not allowed to deploy to github-pages due to"
echo "   environment protection rules.'"
echo
echo "The gh-pages branch is still required — the workflow checks it out and"
echo "commits the manifest there — it just is not the deploy source."
echo
echo "Manifest will be at: https://ciantm.github.io/jellyfin-plugin-musian/manifest.json"
