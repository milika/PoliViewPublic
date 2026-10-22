# Poli View

A portable viewer for pictures and videos in one window - built to be the fastest viewer on Windows that shows colours correctly. HDR pictures and videos are shown right. Nothing is installed: copy the folder anywhere (also a USB stick) and run `PoliView.exe` (64-bit Windows).

## Install in one line

Open PowerShell (Windows 10 / 11, 64-bit) and run:

```powershell
irm https://raw.githubusercontent.com/milika/PoliViewPublic/main/install.ps1 | iex
```

It downloads the newest release from this repository, checks its SHA-256 against the one in the release, unpacks it into `%LOCALAPPDATA%\Programs\PoliView`, adds a "PoliView" Start Menu shortcut (the one Poli View itself makes when it associates file types - that step replaces it, never duplicates it) and starts Poli View. Run the same line again to update: your `PoliConfig.ini` and `logs\` stay. It needs no administrator rights and writes nothing to the registry. To remove Poli View, delete that folder and the shortcut (after associating file types, also undo them in Poli View first).

Another folder or no start afterwards: `$env:POLIVIEW_DIR = 'D:\Apps\PoliView'` and / or `$env:POLIVIEW_NO_START = '1'` (also `POLIVIEW_NO_SHORTCUT = '1'`) before the line. The script is [install.ps1](install.ps1) - read it before you run it.

## Download

Newest version: https://github.com/milika/PoliViewPublic/releases

Download Poli View only from this releases page. Unzip the folder anywhere and run `PoliView.exe`. Poli View checks once a day whether a newer version is on this page (menu: Information > Check For Updates Automatically; switch it off there); it sends only a request for a small version file, with a fixed program name and no identifier, and installs nothing by itself.

## What it does

- **Pictures:** JPEG (.jpg .jpeg), PNG (.png), BMP (.bmp), GIF (.gif), TIFF (.tif .tiff), ICO (.ico), WebP (.webp), AVIF (.avif), HEIC (.heic), JPEG 2000 (.jp2 .jpf), JPEG XL (.jxl), SVG (.svg), Netpbm (.pbm .pgm .ppm .pnm .pam), HDR .pfm, and .hji. Select a part with the mouse to zoom, copy or crop. Print with a preview.
- **Video:** whatever FFmpeg plays (.mkv .mp4 .avi .mov .m4v .webm .wmv .flv .mpg .mpeg .ts .m2ts .mts .3gp .ogv), with subtitles (text, ASS, and Blu-ray / DVD picture subtitles), audio track choice and resume where you left off.
- **Colour:** all colour maths on the light values of the picture itself; HDR in HDR on an HDR screen, fitted to the screen otherwise; an easy display calibration.
- **Settings:** all in `PoliConfig.ini` beside the program - nothing in the registry.

## Licence

Free to use, for personal and commercial use. All rights reserved. Do not redistribute modified copies; download Poli View only from its official releases page. Third-party parts are under their own licences (see [LICENCES.md](LICENCES.md)).
