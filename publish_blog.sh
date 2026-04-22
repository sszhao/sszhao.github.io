#!/usr/bin/env bash
set -euo pipefail

# ── Blog Publishing Script ──
# Converts raw Obsidian posts → polished Jekyll blog posts via Claude CLI
#
# Usage:
#   ./publish_blog.sh "Post Title"
#   ./publish_blog.sh                  # lists available raw posts to choose

VAULT="/Users/zhaoshengdong/Documents/GitHub/ShenMacPro_Obsidian"
RAW_DIR="$VAULT/Social Media/Blog Posts/raw"
PROD_DIR="$VAULT/Social Media/Blog Posts/production"
WEBSITE="/Users/zhaoshengdong/Documents/Shen_Website"
POSTS_DIR="$WEBSITE/_posts"
IMG_DIR="$WEBSITE/assets/blog"

# Colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
NC='\033[0m'

# ── Select post ──
if [ -z "${1:-}" ]; then
  echo -e "${CYAN}Available raw posts:${NC}"
  ls -1 "$RAW_DIR"/*.md 2>/dev/null | while read f; do
    echo "  - $(basename "$f" .md)"
  done
  echo ""
  read -rp "Enter post title (or part of filename): " TITLE
else
  TITLE="$1"
fi

# Find the raw file (match by partial name)
RAW_FILE=$(ls -1 "$RAW_DIR"/*.md 2>/dev/null | grep -i "$TITLE" | head -1 || true)

if [ -z "$RAW_FILE" ]; then
  echo "ERROR: No raw post found matching '$TITLE'"
  echo "Available posts:"
  ls -1 "$RAW_DIR"/*.md 2>/dev/null | while read f; do echo "  $(basename "$f" .md)"; done
  exit 1
fi

POST_TITLE="$(basename "$RAW_FILE" .md)"
echo -e "${GREEN}Found:${NC} $POST_TITLE"

# ── Prompt for metadata ──
read -rp "Date (YYYY-MM-DD, default: today): " POST_DATE
POST_DATE="${POST_DATE:-$(date +%Y-%m-%d)}"

read -rp "Category (default: Lab Life): " CATEGORY
CATEGORY="${CATEGORY:-Lab Life}"

read -rp "Excerpt (one sentence, or press Enter to auto-generate): " EXCERPT

# ── Generate slug ──
SLUG=$(echo "$POST_TITLE" | tr '[:upper:]' '[:lower:]' | sed 's/[^a-z0-9]/-/g' | sed 's/--*/-/g' | sed 's/^-//;s/-$//')
POST_FILENAME="${POST_DATE}-${SLUG}.md"
POST_PATH="$POSTS_DIR/$POST_FILENAME"

# Build the post URL (used in permalink and blog card)
YEAR=$(echo "$POST_DATE" | cut -d- -f1)
MONTH=$(echo "$POST_DATE" | cut -d- -f2)
DAY=$(echo "$POST_DATE" | cut -d- -f3)
POST_URL="/${YEAR}/${MONTH}/${DAY}/${SLUG}.html"

if [ -f "$POST_PATH" ]; then
  echo "ERROR: Post already exists at $POST_PATH"
  exit 1
fi

# ── Extract referenced images ──
IMAGES=$(grep -oE '!\[\[([^]]+)\]\]' "$RAW_FILE" | sed 's/!\[\[//;s/\]\]//' || true)

if [ -n "$IMAGES" ]; then
  echo -e "${CYAN}Found images:${NC}"
  echo "$IMAGES" | while read img; do echo "  - $img"; done

  # Copy images to website
  mkdir -p "$IMG_DIR"
  echo "$IMAGES" | while read img; do
    if [ -f "$VAULT/$img" ]; then
      cp "$VAULT/$img" "$IMG_DIR/"
      echo -e "  ${GREEN}Copied:${NC} $img → assets/blog/"
    else
      echo -e "  ${YELLOW}WARNING:${NC} Image not found in vault: $img"
    fi
  done
fi

# ── Generate excerpt if not provided ──
if [ -z "$EXCERPT" ]; then
  EXCERPT=$(echo "$POST_TITLE" | sed 's/^./\U&/')
fi

# ── Generate hero image path ──
HERO_IMAGE=""
if [ -n "$IMAGES" ]; then
  FIRST_IMG=$(echo "$IMAGES" | head -1)
  HERO_IMAGE="/assets/blog/$FIRST_IMG"
fi

# ── Call Claude to polish the post ──
echo ""
echo -e "${CYAN}Generating polished blog post with Claude...${NC}"

mkdir -p "$PROD_DIR"
PROD_FILE="$PROD_DIR/$POST_TITLE.md"

# Read raw content
RAW_CONTENT=$(cat "$RAW_FILE")

# Build Claude prompt
CLAUDE_PROMPT="You are a blog editor for Synteraction Lab, an HCI research lab at City University of Hong Kong, led by Prof. Shengdong Zhao.

Take the following raw blog post material and convert it into a polished, professional blog post. The post should be warm yet professional, suitable for an academic research lab blog.

Rules:
- Keep all factual information (names, dates, institutions, research areas)
- Remove the 'Raw material below' section and everything after it
- Remove any notes about photos (those are internal notes)
- Rewrite Obsidian wiki image links like ![[photo.jpeg]] as standard markdown: ![Photo](/assets/blog/photo.jpeg)
- IMPORTANT: The FIRST image is used as the hero image in the layout. Do NOT include the first image in the body — only include the 2nd, 3rd, etc. images in the body text. If there is only one image, include NO images in the body.
- Use proper markdown formatting
- Keep the post concise (3-5 paragraphs)
- Do NOT add a title heading (# Title) — the title comes from front matter
- Write in first person plural (we) or third person as appropriate for a lab blog
- End with an engaging closing line

Here is the raw material:

---
$RAW_CONTENT
---

Output ONLY the polished blog post body in markdown. No front matter, no title heading, no explanation."

# Call Claude CLI
POLISHED=$(claude -p "$CLAUDE_PROMPT" --model sonnet 2>&1)

if [[ "$POLISHED" == ERROR* ]] || [[ "$POLISHED" == *"API Error"* ]] || [[ -z "$POLISHED" ]]; then
  echo "ERROR: Failed to generate post with Claude"
  echo "$POLISHED"
  exit 1
fi

# Save production version
echo "$POLISHED" > "$PROD_FILE"
echo -e "${GREEN}Saved production post:${NC} $PROD_FILE"

# ── Create Jekyll post ──
cat > "$POST_PATH" << EOF
---
layout: blog-post
title: "$POST_TITLE"
image: $HERO_IMAGE
description: "$EXCERPT"
keywords:
date: $POST_DATE 12:00:00 +0800
published: true
category: $CATEGORY
permalink: $POST_URL
---

$POLISHED
EOF

echo -e "${GREEN}Created Jekyll post:${NC} $POST_PATH"

# ── Summary ──
echo ""
echo -e "${GREEN}━━━ Publish Summary ━━━${NC}"
echo "  Title:    $POST_TITLE"
echo "  Date:     $POST_DATE"
echo "  Category: $CATEGORY"
echo "  Slug:     $SLUG"
echo "  Post:     _posts/$POST_FILENAME"
echo "  Images:   $HERO_IMAGE"
echo "  URL:      $POST_URL"
echo ""
echo "Next steps:"
echo "  1. Preview: bundle exec jekyll serve"
echo "  2. Publish: git add _posts/$POST_FILENAME && git commit -m 'Add blog: $POST_TITLE' && git push origin master"
