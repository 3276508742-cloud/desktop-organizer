# desktop-organizer

Windows desktop classification and organization helper for Codex.

This skill scans Windows desktop files, folders, and shortcuts, then generates a classification preview report. It is designed for cautious desktop cleanup: preview first, confirm manually, and only then optionally move files into category folders.

## Safety Notice

This is an early personal project. Use it carefully.

- The default mode is dry-run preview only.
- The script does not delete files.
- The script does not rename files.
- `.lnk` shortcuts are classified by their target path when possible, not by the `.lnk` extension itself.
- Low-confidence items, unreadable shortcuts, broken shortcuts, mixed folders, and uncertain executable files are placed into `待确认`.
- Moving files requires the explicit `-Apply` parameter.
- Before using `-Apply`, read the generated preview report and confirm the result yourself.
- Back up important desktop files before applying changes.

The author is not responsible for accidental file movement, incorrect classification, broken shortcuts caused by unusual software layouts, or data loss caused by manual follow-up actions.

## What It Does

- Scans the current user's desktop.
- Also checks the OneDrive desktop when present.
- Reads Windows shortcut targets with `WScript.Shell`.
- Scans only the desktop and the first level of folders.
- Generates preview reports in CSV and Markdown, including Chinese categories with English labels.
- Can optionally move high-confidence items after explicit confirmation.

## What It Does Not Do

- It does not delete files.
- It does not recursively reorganize deep folder trees.
- It does not guarantee perfect classification.
- It does not handle protected Windows shell icons such as Recycle Bin, This PC, Network, Control Panel, user folders, or OneDrive shell entries.

## Categories

Classification priority:

1. 安装包 (Installers)
2. 文档 (Documents)
3. 开发工具 (Development Tools)
4. 游戏 (Games)
5. 系统工具 (System Tools)
6. 通讯远程 (Messaging & Remote Access)
7. 多媒体设计 (Media & Design)
8. 办公学习 (Office & Study)
9. 图片截图 (Images & Screenshots)
10. 待确认 (Needs Review)

Detailed rules are stored in:

```text
references/classification_rules.md
```

## Installation

Place this folder under your Codex skills directory:

```text
C:\Users\<YourName>\.codex\skills\desktop-organizer
```

Then restart Codex so the skill list refreshes.

## Preview Scan

Run a preview scan:

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File "C:\Users\<YourName>\.codex\skills\desktop-organizer\scripts\scan_desktop.ps1"
```

The preview report is written to:

```text
outputs\desktop_classification_preview.csv
outputs\desktop_classification_preview.md
```

No files are moved in preview mode.

## Mock Test

Test with a mock desktop directory before touching your real desktop:

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File "C:\Users\<YourName>\.codex\skills\desktop-organizer\scripts\scan_desktop.ps1" -DesktopPath "C:\path\to\mock_desktop"
```

Review the generated CSV or Markdown report.

## Apply Movement

Only run this after checking the preview report:

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File "C:\Users\<YourName>\.codex\skills\desktop-organizer\scripts\scan_desktop.ps1" -Apply
```

When `-Apply` is used, the script moves only items marked as `ShouldMove = Yes`. It also writes:

```text
outputs\desktop_organize_log.csv
```

## Recommended Workflow

1. Run a mock test.
2. Run a real desktop preview.
3. Open the Markdown or CSV preview report.
4. Review every `待确认` and low-confidence item.
5. Add manual overrides if needed.
6. Run `-Apply` only after you are comfortable with the preview.
7. Check the organize log and desktop shortcuts afterward.

## License

Licensed under the Apache License, Version 2.0. See `LICENSE`.
