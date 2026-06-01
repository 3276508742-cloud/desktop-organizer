---
name: desktop-organizer
description: Use this skill when the user wants to classify or organize Windows desktop icons, shortcuts, installers, documents, development tools, games, screenshots, or mixed desktop files. Always preview first and never delete files.
---

# Desktop Organizer

Use this skill for Windows desktop classification and cleanup. Treat the desktop as user-owned state: preview before action, avoid destructive operations, and put uncertain items into `待确认`.

## Core Rules

- Default to dry-run preview only. Do not move, delete, rename, or modify files unless the user explicitly confirms.
- Generate a classification report with: name, path, type, shortcut target path, suggested category, match reason, confidence, and whether movement is suggested.
- For `.lnk` shortcuts, classify by target path when readable. Do not classify by `.lnk` extension.
- If a shortcut target cannot be read or does not exist, classify it as `待确认`.
- Put all low-confidence or conflicting items into `待确认`.
- Do not process protected system icons or shell entries such as Recycle Bin, This PC, Network, Control Panel, user folders, or OneDrive entries.
- Never provide a delete operation in the workflow.

## Workflow

Step 1: Scan the desktop.

- Use `scripts/scan_desktop.ps1`.
- Default desktop roots are `$env:USERPROFILE\Desktop` and `$env:USERPROFILE\OneDrive\Desktop` when present.
- For tests or non-real runs, pass `-DesktopPath <path>`.

Step 2: Generate preview reports.

- The script writes:
  - `outputs/desktop_classification_preview.csv`
  - `outputs/desktop_classification_preview.md`
- Read and summarize the report for the user.

Step 3: Ask the user to confirm classification results.

- Surface `待确认`, low-confidence, mixed folders, broken shortcuts, and green executable cases.
- Accept user overrides before moving anything.

Step 4: Optionally execute movement.

- Only run with `-Apply` after explicit user confirmation.
- Before applying, the script prints the movement list again.
- Move items into category folders under the chosen desktop root.
- Do not overwrite existing files; generate a unique destination name.

Step 5: Generate an organize log.

- When `-Apply` is used, the script also writes `outputs/desktop_organize_log.csv`.
- Verify shortcut integrity after moving if shortcuts or target files were moved.

## Categories

Use this priority order for rule evaluation, while keeping genuinely conflicting multi-category items in `待确认`:

`安装包 > 文档 > 开发工具 > 游戏 > 系统工具 > 通讯远程 > 多媒体设计 > 办公学习 > 图片截图 > 待确认`

Detailed rules live in `references/classification_rules.md`. Load that file when reviewing or changing classification behavior.

## Script Usage

Preview a mock or real desktop:

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File "C:\Users\Lenovo\.codex\skills\desktop-organizer\scripts\scan_desktop.ps1"
powershell -NoProfile -ExecutionPolicy Bypass -File "C:\Users\Lenovo\.codex\skills\desktop-organizer\scripts\scan_desktop.ps1" -DesktopPath "C:\path\to\mock_desktop"
```

Apply movement only after confirmation:

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File "C:\Users\Lenovo\.codex\skills\desktop-organizer\scripts\scan_desktop.ps1" -DesktopPath "C:\path\to\desktop" -Apply
```
