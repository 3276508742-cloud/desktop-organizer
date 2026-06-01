param(
    [string[]]$DesktopPath,
    [switch]$Apply,
    [string]$OutputDir = (Join-Path (Get-Location) "outputs")
)

$ErrorActionPreference = "Stop"

$Categories = @(
    "安装包",
    "文档",
    "开发工具",
    "游戏",
    "系统工具",
    "通讯远程",
    "多媒体设计",
    "办公学习",
    "图片截图",
    "待确认"
)

$CategoryFolders = @{
    "安装包" = "安装包"
    "文档" = "文档"
    "开发工具" = "开发工具"
    "游戏" = "游戏"
    "系统工具" = "系统工具"
    "通讯远程" = "通讯远程"
    "多媒体设计" = "多媒体设计"
    "办公学习" = "办公学习"
    "图片截图" = "图片截图"
    "待确认" = "待确认"
}

$ExtensionCategories = @{
    ".exe" = "安装包"; ".msi" = "安装包"; ".zip" = "安装包"; ".rar" = "安装包"
    ".7z" = "安装包"; ".iso" = "安装包"; ".apk" = "安装包"; ".tar" = "安装包"; ".gz" = "安装包"
    ".pdf" = "文档"; ".docx" = "文档"; ".doc" = "文档"; ".xlsx" = "文档"; ".xls" = "文档"
    ".pptx" = "文档"; ".ppt" = "文档"; ".txt" = "文档"; ".md" = "文档"; ".csv" = "文档"
    ".jpg" = "图片截图"; ".jpeg" = "图片截图"; ".png" = "图片截图"; ".webp" = "图片截图"
    ".gif" = "图片截图"; ".bmp" = "图片截图"; ".svg" = "图片截图"
}

$NamePatterns = [ordered]@{
    "安装包" = "setup|install|installer|portable|x64|x86|driver|update|patch"
    "文档" = "作业|论文|报告|课表|简历|合同|资料|教程|笔记|总结|表格|名单|方案|PPT"
    "开发工具" = "VS Code|Cursor|GitHub|\bGit\b|Node|\bnpm\b|Python|PyCharm|IDEA|WebStorm|Android Studio|\bJDK\b|Java|Maven|Gradle|Docker|\bWSL\b|Terminal|PowerShell|Anaconda|Postman|MySQL|Redis|MongoDB|\bcode\b|\bdev\b|\bsrc\b|\brepo\b|project|workspace|frontend|backend|react|vue"
    "游戏" = "Steam|steamapps|Epic|Ubisoft|\bEA\b|Origin|Battle\.net|Blizzard|Riot|Valorant|\bLOL\b|Minecraft|Roblox|原神|Genshin|崩坏|Honkai|鸣潮|HoYoverse|WeGame|PUBG|Apex|\bGTA\b|FiveM"
    "系统工具" = "NVIDIA|AMD|Intel|Realtek|Lenovo|Legion|Driver|控制面板|设置|DiskGenius|Everything|7-Zip|WinRAR|Rufus|Ventoy|HWiNFO|CPU-Z|GPU-Z|MSI Afterburner"
    "通讯远程" = "微信|WeChat|\bQQ\b|\bTIM\b|Telegram|Discord|飞书|钉钉|向日葵|ToDesk|TeamViewer|AnyDesk|Zoom|腾讯会议"
    "多媒体设计" = "\bPS\b|Photoshop|\bPR\b|Premiere|\bAE\b|Illustrator|Lightroom|Blender|剪映|CapCut|OBS|PotPlayer|VLC|Audacity|DaVinci|Figma|\bCAD\b|AutoCAD"
    "办公学习" = "Word|Excel|PowerPoint|Office|WPS|OneNote|Notion|Obsidian|Typora|Zotero|Edge|Chrome|Firefox|网盘"
    "图片截图" = "截图|screenshot|屏幕截图|微信图片|QQ图片"
    "待确认" = "^新建文件夹$|\btest\b|\btemp\b|backup|未命名|杂项"
}

$PathPatterns = [ordered]@{
    "开发工具" = "Git|nodejs|Python|JetBrains|Android|Docker|VS Code|Cursor|GitHub|npm|PyCharm|IDEA|WebStorm|JDK|Java|Maven|Gradle|WSL|Terminal|PowerShell|Anaconda|Postman|MySQL|Redis|MongoDB"
    "游戏" = "Steam|steamapps|Epic|Ubisoft|\bEA\b|Origin|Battle\.net|Blizzard|Riot|Valorant|\bLOL\b|Minecraft|Roblox|原神|Genshin|崩坏|Honkai|鸣潮|HoYoverse|WeGame|PUBG|Apex|\bGTA\b|FiveM"
    "系统工具" = "NVIDIA|AMD|Intel|Realtek|Legion|Driver|控制面板|设置|DiskGenius|Everything|7-Zip|WinRAR|Rufus|Ventoy|HWiNFO|CPU-Z|GPU-Z|MSI Afterburner"
    "通讯远程" = "微信|WeChat|\bQQ\b|\bTIM\b|Telegram|Discord|飞书|钉钉|向日葵|ToDesk|TeamViewer|AnyDesk|Zoom|腾讯会议"
    "多媒体设计" = "\bPS\b|Photoshop|\bPR\b|Premiere|\bAE\b|Illustrator|Lightroom|Blender|剪映|CapCut|OBS|PotPlayer|VLC|Audacity|DaVinci|Figma|\bCAD\b|AutoCAD"
    "办公学习" = "Word|Excel|PowerPoint|Office|WPS|OneNote|Notion|Obsidian|Typora|Zotero|Edge|Chrome|Firefox|网盘"
}

$ProtectedNames = @(
    "回收站", "Recycle Bin", "此电脑", "This PC", "网络", "Network",
    "控制面板", "Control Panel", "用户文件夹", "OneDrive", "desktop.ini"
)

function Get-DesktopRoots {
    if ($DesktopPath -and $DesktopPath.Count -gt 0) {
        return $DesktopPath | Where-Object { Test-Path -LiteralPath $_ } | Select-Object -Unique
    }

    $roots = @()
    if ($env:USERPROFILE) {
        $roots += Join-Path $env:USERPROFILE "Desktop"
        $roots += Join-Path $env:USERPROFILE "OneDrive\Desktop"
    }
    return $roots | Where-Object { Test-Path -LiteralPath $_ } | Select-Object -Unique
}

function Choose-Category {
    param([string[]]$Matches)
    foreach ($category in $Categories) {
        if ($Matches -contains $category) {
            return $category
        }
    }
    return "待确认"
}

function Match-Text {
    param(
        [string]$Text,
        [hashtable]$Patterns
    )

    if ([string]::IsNullOrWhiteSpace($Text)) {
        return $null
    }

    $matchedCategories = @()
    foreach ($category in $Patterns.Keys) {
        if ($Text -match $Patterns[$category]) {
            $matchedCategories += $category
        }
    }

    if ($matchedCategories.Count -eq 0) {
        return $null
    }
    if ($matchedCategories.Count -gt 1) {
        return "待确认"
    }
    return $matchedCategories[0]
}

function Get-ShortcutInfo {
    param([string]$Path)
    try {
        $shell = New-Object -ComObject WScript.Shell
        $shortcut = $shell.CreateShortcut($Path)
        return [pscustomobject]@{
            TargetPath = [string]$shortcut.TargetPath
            Arguments = [string]$shortcut.Arguments
            WorkingDirectory = [string]$shortcut.WorkingDirectory
        }
    }
    catch {
        return $null
    }
}

function New-Result {
    param(
        [System.IO.FileSystemInfo]$Item,
        [string]$Type,
        [string]$ShortcutTarget,
        [string]$Category,
        [string]$Reason,
        [string]$Confidence
    )

    [pscustomobject]@{
        Name = $Item.Name
        Path = $Item.FullName
        Type = $Type
        ShortcutTargetPath = $ShortcutTarget
        SuggestedCategory = $Category
        MatchReason = $Reason
        Confidence = $Confidence
        ShouldMove = if ($Category -eq "待确认" -or $Confidence -eq "低") { "No" } else { "Yes" }
    }
}

function Classify-Item {
    param(
        [System.IO.FileSystemInfo]$Item,
        [switch]$FolderChild
    )

    if ($ProtectedNames -contains $Item.Name) {
        return New-Result $Item "Protected" "" "待确认" "Protected system or shell item" "低"
    }

    if ($Item.PSIsContainer -and $FolderChild) {
        $nameCategory = Match-Text $Item.Name $NamePatterns
        if ($nameCategory -and $nameCategory -ne "待确认") {
            return New-Result $Item "Folder" "" $nameCategory "Nested folder name matched $nameCategory; contents not scanned" "中"
        }
        if ($nameCategory -eq "待确认") {
            return New-Result $Item "Folder" "" "待确认" "Nested folder name matched uncertain pattern; contents not scanned" "低"
        }
        return New-Result $Item "Folder" "" "待确认" "Nested folder contents not scanned" "低"
    }

    if ($Item.PSIsContainer) {
        return Classify-Folder $Item
    }

    $extension = $Item.Extension.ToLowerInvariant()
    $type = if ($extension -eq ".lnk") { "Shortcut" } else { "File" }

    if ($extension -eq ".lnk") {
        $shortcut = Get-ShortcutInfo $Item.FullName
        if (-not $shortcut -or [string]::IsNullOrWhiteSpace($shortcut.TargetPath)) {
            return New-Result $Item $type "" "待确认" "Shortcut target unreadable" "低"
        }
        if (-not (Test-Path -LiteralPath $shortcut.TargetPath -ErrorAction SilentlyContinue)) {
            return New-Result $Item $type $shortcut.TargetPath "待确认" "Shortcut target missing" "低"
        }

        $category = Match-Text "$($shortcut.TargetPath) $($shortcut.Arguments) $($shortcut.WorkingDirectory)" $PathPatterns
        if ($category -and $category -ne "待确认") {
            return New-Result $Item $type $shortcut.TargetPath $category "Shortcut target path matched $category" "高"
        }

        $category = Match-Text $Item.Name $NamePatterns
        if ($category -and $category -ne "待确认") {
            return New-Result $Item $type $shortcut.TargetPath $category "Shortcut name matched $category" "中"
        }

        return New-Result $Item $type $shortcut.TargetPath "待确认" "Shortcut target did not match rules" "低"
    }

    if ($extension -eq ".exe") {
        $installerNameCategory = Match-Text $Item.Name ([ordered]@{ "安装包" = $NamePatterns["安装包"] })
        if ($installerNameCategory -eq "安装包") {
            return New-Result $Item $type "" "安装包" "Executable name matched installer keyword" "高"
        }
        return New-Result $Item $type "" "待确认" "Executable without installer keyword; possible green app main program" "低"
    }

    if ($ExtensionCategories.ContainsKey($extension)) {
        $category = $ExtensionCategories[$extension]
        return New-Result $Item $type "" $category "Extension $extension matched $category" "高"
    }

    $category = Match-Text $Item.Name $NamePatterns
    if ($category -and $category -ne "待确认") {
        return New-Result $Item $type "" $category "Name matched $category" "中"
    }

    return New-Result $Item $type "" "待确认" "No rule matched" "低"
}

function Classify-Folder {
    param([System.IO.DirectoryInfo]$Folder)

    $nameCategory = Match-Text $Folder.Name $NamePatterns
    if ($nameCategory -and $nameCategory -ne "待确认") {
        return New-Result $Folder "Folder" "" $nameCategory "Folder name matched $nameCategory" "中"
    }
    if ($nameCategory -eq "待确认") {
        return New-Result $Folder "Folder" "" "待确认" "Folder name matched uncertain pattern" "低"
    }

    $children = Get-ChildItem -LiteralPath $Folder.FullName -Force -ErrorAction SilentlyContinue |
        Where-Object { $ProtectedNames -notcontains $_.Name }

    if (-not $children -or $children.Count -eq 0) {
        return New-Result $Folder "Folder" "" "待确认" "Empty folder or first level unreadable" "低"
    }

    $counts = @{}
    foreach ($child in $children) {
        $childResult = Classify-Item $child -FolderChild
        if ($childResult.SuggestedCategory -ne "待确认" -and $childResult.Confidence -ne "低") {
            if (-not $counts.ContainsKey($childResult.SuggestedCategory)) {
                $counts[$childResult.SuggestedCategory] = 0
            }
            $counts[$childResult.SuggestedCategory]++
        }
    }

    if ($counts.Count -eq 0) {
        return New-Result $Folder "Folder" "" "待确认" "No clear first-level folder majority" "低"
    }

    $top = $counts.GetEnumerator() | Sort-Object Value -Descending | Select-Object -First 1
    $ratio = [double]$top.Value / [double]$children.Count
    if ($ratio -ge 0.6) {
        return New-Result $Folder "Folder" "" $top.Key ("First-level contents: {0}/{1} are {2} ({3:P0})" -f $top.Value, $children.Count, $top.Key, $ratio) "中"
    }

    return New-Result $Folder "Folder" "" "待确认" ("Mixed folder; highest category ratio {0:P0}, below 60%" -f $ratio) "低"
}

function Get-UniqueDestination {
    param(
        [string]$Directory,
        [string]$Name
    )

    $candidate = Join-Path $Directory $Name
    if (-not (Test-Path -LiteralPath $candidate)) {
        return $candidate
    }

    $base = [IO.Path]::GetFileNameWithoutExtension($Name)
    $ext = [IO.Path]::GetExtension($Name)
    for ($i = 1; $i -lt 1000; $i++) {
        $candidate = Join-Path $Directory ("{0} ({1}){2}" -f $base, $i, $ext)
        if (-not (Test-Path -LiteralPath $candidate)) {
            return $candidate
        }
    }
    throw "Could not create a unique destination for $Name"
}

function Get-SourceRootForPath {
    param(
        [string]$Path,
        [string[]]$Roots
    )

    $fullPath = [IO.Path]::GetFullPath($Path)
    foreach ($root in ($Roots | Sort-Object Length -Descending)) {
        $fullRoot = [IO.Path]::GetFullPath($root).TrimEnd("\")
        $rootPrefix = "$fullRoot\"
        if ($fullPath.Equals($fullRoot, [System.StringComparison]::OrdinalIgnoreCase) -or
            $fullPath.StartsWith($rootPrefix, [System.StringComparison]::OrdinalIgnoreCase)) {
            return $root
        }
    }

    return $Roots | Select-Object -First 1
}

function Write-Reports {
    param([object[]]$Rows)

    if (-not (Test-Path -LiteralPath $OutputDir)) {
        New-Item -ItemType Directory -Path $OutputDir | Out-Null
    }

    $csv = Join-Path $OutputDir "desktop_classification_preview.csv"
    $md = Join-Path $OutputDir "desktop_classification_preview.md"

    $Rows | Export-Csv -LiteralPath $csv -NoTypeInformation -Encoding UTF8

    $lines = @()
    $lines += "# Desktop Classification Preview"
    $lines += ""
    $lines += "| 名称 | 路径 | 类型 | 目标路径 | 建议分类 | 命中原因 | 置信度 | 是否建议移动 |"
    $lines += "|---|---|---|---|---|---|---|---|"
    foreach ($row in $Rows) {
        $lines += "| $($row.Name) | $($row.Path) | $($row.Type) | $($row.ShortcutTargetPath) | $($row.SuggestedCategory) | $($row.MatchReason) | $($row.Confidence) | $($row.ShouldMove) |"
    }
    Set-Content -LiteralPath $md -Value $lines -Encoding UTF8

    Write-Output "Preview CSV: $csv"
    Write-Output "Preview MD: $md"
}

$roots = Get-DesktopRoots
if (-not $roots -or $roots.Count -eq 0) {
    throw "No desktop path found. Pass -DesktopPath explicitly."
}

$rows = New-Object System.Collections.Generic.List[object]
foreach ($root in $roots) {
    Get-ChildItem -LiteralPath $root -Force -ErrorAction SilentlyContinue |
        Where-Object { $ProtectedNames -notcontains $_.Name } |
        ForEach-Object {
            [void]$rows.Add((Classify-Item $_))
        }
}

Write-Reports ($rows.ToArray())

if (-not $Apply) {
    Write-Output "Dry-run only. No files were moved."
    return
}

$moveRows = $rows.ToArray() | Where-Object { $_.ShouldMove -eq "Yes" }
Write-Output "Apply requested. Items that will be moved:"
$moveRows | Select-Object Name, Path, SuggestedCategory | Format-Table -AutoSize

$organizeLog = @()
foreach ($row in $moveRows) {
    $sourceRoot = Get-SourceRootForPath $row.Path $roots
    $categoryFolder = Join-Path $sourceRoot $CategoryFolders[$row.SuggestedCategory]
    if (-not (Test-Path -LiteralPath $categoryFolder)) {
        New-Item -ItemType Directory -Path $categoryFolder | Out-Null
    }
    $dest = Get-UniqueDestination $categoryFolder $row.Name
    Move-Item -LiteralPath $row.Path -Destination $dest
    $organizeLog += [pscustomobject]@{
        Name = $row.Name
        Category = $row.SuggestedCategory
        Source = $row.Path
        Destination = $dest
        Reason = $row.MatchReason
    }
}

$logPath = Join-Path $OutputDir "desktop_organize_log.csv"
$organizeLog | Export-Csv -LiteralPath $logPath -NoTypeInformation -Encoding UTF8
Write-Output "Moved $($organizeLog.Count) items."
Write-Output "Organize log: $logPath"
