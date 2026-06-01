# Desktop Classification Rules

分类优先级：

`安装包 > 文档 > 开发工具 > 游戏 > 系统工具 > 通讯远程 > 多媒体设计 > 办公学习 > 图片截图 > 待确认`

## 安装包

真实文件后缀 `.exe/.msi/.zip/.rar/.7z/.iso/.apk/.tar/.gz`。

或名称含 `setup/install/installer/portable/x64/x86/driver/update/patch`。

例外：`.lnk` 指向 `exe` 不算安装包；绿色软件主程序不确定则待确认。

## 文档

后缀 `.pdf/.docx/.doc/.xlsx/.xls/.pptx/.ppt/.txt/.md/.csv`。

或名称含 `作业/论文/报告/课表/简历/合同/资料/教程/笔记/总结/表格/名单/方案/PPT`。

## 开发工具

名称/路径含 `VS Code/Cursor/Git/GitHub/Node/npm/Python/PyCharm/IDEA/WebStorm/Android Studio/JDK/Java/Maven/Gradle/Docker/WSL/Terminal/PowerShell/Anaconda/Postman/MySQL/Redis/MongoDB`。

路径含 `Git/nodejs/Python/JetBrains/Android/Docker`。

文件夹含 `code/dev/src/repo/project/workspace/frontend/backend/react/vue`。

## 游戏

名称/路径含 `Steam/steamapps/Epic/Ubisoft/EA/Origin/Battle.net/Blizzard/Riot/Valorant/LOL/Minecraft/Roblox/原神/Genshin/崩坏/Honkai/鸣潮/HoYoverse/WeGame/PUBG/Apex/GTA/FiveM`。

## 系统工具

名称/路径含 `NVIDIA/AMD/Intel/Realtek/Lenovo/Legion/Driver/控制面板/设置/DiskGenius/Everything/7-Zip/WinRAR/Rufus/Ventoy/HWiNFO/CPU-Z/GPU-Z/MSI Afterburner`。

## 通讯远程

名称/路径含 `微信/WeChat/QQ/TIM/Telegram/Discord/飞书/钉钉/向日葵/ToDesk/TeamViewer/AnyDesk/Zoom/腾讯会议`。

## 多媒体设计

名称/路径含 `PS/Photoshop/PR/Premiere/AE/Illustrator/Lightroom/Blender/剪映/CapCut/OBS/PotPlayer/VLC/Audacity/DaVinci/Figma/CAD/AutoCAD`。

## 办公学习

名称/路径含 `Word/Excel/PowerPoint/Office/WPS/OneNote/Notion/Obsidian/Typora/Zotero/Edge/Chrome/Firefox/网盘`。

## 图片截图

后缀 `.jpg/.jpeg/.png/.webp/.gif/.bmp/.svg`。

或名称含 `截图/screenshot/屏幕截图/微信图片/QQ图片`。

## 待确认

无规则、名称过短、多类冲突、混合文件夹、绿色 `exe`、失效快捷方式、新建文件夹、`test/temp/backup/未命名/杂项`。

## 文件夹规则

先看文件夹名；如果不明确，扫描第一层文件。若 60% 以上文件属于同一类，则归该类；否则待确认。
