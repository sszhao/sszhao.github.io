#!/usr/bin/env python3
"""Add breadcrumb navigation to all book chapter files."""

import os
import re

# Chapter order and titles
CHAPTERS = [
    ("preface", "Preface"),
    ("dedication", "Dedication"),
    ("chapter-01", "Chapter 1: Introduction"),
    ("chapter-02", "Chapter 2: Research Contributions in HCI"),
    ("chapter-03", "Chapter 3: Empirical Research Methods"),
    ("chapter-04", "Chapter 4: The 5-Step Experiment Design"),
    ("chapter-05", "Chapter 5: Interaction Techniques"),
    ("chapter-06", "Chapter 6: Systems and Toolkits"),
    ("chapter-07", "Chapter 7: Your First HCI Project"),
    ("chapter-08", "Chapter 8: Literature Reviews"),
    ("chapter-09", "Chapter 9: Writing Your HCI Research Paper"),
    ("chapter-10", "Chapter 10: Reading & Responding to Reviews"),
    ("acknowledgements", "Acknowledgements"),
]

# CSS styles to add
BREADCRUMB_CSS = """
    /* Breadcrumb Navigation */
    .breadcrumb {
      display: flex;
      align-items: center;
      gap: 8px;
      padding: 12px 16px;
      background: var(--color-surface);
      border-radius: 8px;
      margin-bottom: 32px;
      font-size: 14px;
    }

    .breadcrumb a {
      color: var(--color-accent);
      text-decoration: none;
      font-weight: 500;
    }

    .breadcrumb a:hover {
      text-decoration: underline;
    }

    .breadcrumb-separator {
      color: var(--color-text-secondary);
      opacity: 0.5;
    }

    .breadcrumb-current {
      color: var(--color-text-secondary);
      font-weight: 500;
    }

    /* Chapter Navigation */
    .chapter-nav {
      display: flex;
      justify-content: space-between;
      align-items: center;
      padding: 16px;
      background: var(--color-surface);
      border-radius: 8px;
      margin-top: 64px;
      border: 1px solid var(--color-border);
    }

    .chapter-nav-prev,
    .chapter-nav-next {
      display: flex;
      flex-direction: column;
      gap: 4px;
    }

    .chapter-nav-next {
      text-align: right;
      align-items: flex-end;
    }

    .chapter-nav-label {
      font-size: 12px;
      color: var(--color-text-secondary);
      text-transform: uppercase;
      letter-spacing: 0.5px;
    }

    .chapter-nav-title {
      font-family: var(--font-heading);
      font-weight: 600;
      color: var(--color-accent);
      text-decoration: none;
      font-size: 14px;
    }

    .chapter-nav-title:hover {
      text-decoration: underline;
    }

    .chapter-nav-disabled {
      color: var(--color-text-secondary);
      opacity: 0.5;
      cursor: not-allowed;
    }
"""

def add_breadcrumbs_to_file(filepath, title, prev_file, prev_title, next_file, next_title):
    """Add breadcrumb and chapter navigation to a file."""
    with open(filepath, 'r', encoding='utf-8') as f:
        content = f.read()

    # Check if already has breadcrumbs
    if 'breadcrumb' in content:
        print(f"Skipping {filepath} - already has breadcrumbs")
        return

    # Add CSS before </style>
    if '</style>' in content:
        content = content.replace('</style>', BREADCRUMB_CSS + '\n</style>')

    # Create breadcrumb HTML
    breadcrumb = f'''
  <!-- Breadcrumb Navigation -->
  <nav class="breadcrumb">
    <a href="/book/">← Book</a>
    <span class="breadcrumb-separator">/</span>
    <span class="breadcrumb-current">{title}</span>
  </nav>
'''

    # Create chapter navigation HTML
    prev_html = f'<a href="{prev_file}" class="chapter-nav-title">{prev_title}</a>' if prev_file else '<span class="chapter-nav-title chapter-nav-disabled">None</span>'
    next_html = f'<a href="{next_file}" class="chapter-nav-title">{next_title}</a>' if next_file else '<span class="chapter-nav-title chapter-nav-disabled">None</span>'

    chapter_nav = f'''
  <!-- Chapter Navigation -->
  <nav class="chapter-nav">
    <div class="chapter-nav-prev">
      <span class="chapter-nav-label">← Previous</span>
      {prev_html}
    </div>

    <div class="chapter-nav-next">
      <span class="chapter-nav-label">Next →</span>
      {next_html}
    </div>
  </nav>
'''

    # Add breadcrumb after <body>
    body_match = re.search(r'(<body[^>]*>)', content)
    if body_match:
        insert_pos = body_match.end()
        content = content[:insert_pos] + '\n' + breadcrumb + content[insert_pos:]

    # Add chapter nav before </body>
    content = content.replace('</body>', chapter_nav + '\n</body>')

    with open(filepath, 'w', encoding='utf-8') as f:
        f.write(content)

    print(f"Updated {filepath}")

def main():
    book_dir = '/Users/zhaoshengdong/Documents/Shen_Website/_book'

    for i, (chapter, title) in enumerate(CHAPTERS):
        filepath = os.path.join(book_dir, f"{chapter}.html")
        if not os.path.exists(filepath):
            print(f"Warning: {filepath} not found")
            continue

        # Previous chapter
        if i > 0:
            prev_chapter = CHAPTERS[i-1][0]
            prev_title = CHAPTERS[i-1][1]
            prev_file = f"{prev_chapter}.html"
        else:
            prev_file = None
            prev_title = None

        # Next chapter
        if i < len(CHAPTERS) - 1:
            next_chapter = CHAPTERS[i+1][0]
            next_title = CHAPTERS[i+1][1]
            next_file = f"{next_chapter}.html"
        else:
            next_file = None
            next_title = None

        add_breadcrumbs_to_file(filepath, title, prev_file, prev_title, next_file, next_title)

if __name__ == '__main__':
    main()
