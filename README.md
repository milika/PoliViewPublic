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

One window, one set of keys for pictures, video and sound. Pictures are decoded into linear-light floating-point RGB and everything on screen goes through OpenGL shaders, so scaling, HDR and the display calibration work on the light values, not on gamma-encoded pixels.

### Pictures
- **Formats:** JPEG (.jpg .jpeg .jpe .jfif), PNG, BMP, GIF (animated too), TIFF (.tif .tiff), ICO, WebP, AVIF, HEIC, JPEG 2000 (.jp2 .jpf), JPEG XL (.jxl), SVG (drawn sharp at any zoom, transparency kept), Netpbm (.pbm .pgm .ppm .pnm .pam, 8 and 16 bit), HDR .pfm and Poli View's own .hji. Camera RAW is not supported.
- **Fast browsing:** decoding runs in the background, the neighbours in the folder are prefetched, Explorer's natural order (`img2` before `img10`), EXIF orientation applied. The first picture is on screen in about 0.3 seconds. A picture comes back with its zoom and the part that was in the window.
- **Zoom and move:** mouse wheel, `+` / `-`, fit (`*`), 100% / 50% (`1` / `2`), right-drag to pan, bicubic or pixel-art filtering (`F`), rotate (`R`), a pixel grid at high zoom.
- **Select, copy, crop:** drag a part of the picture to zoom into it, copy it (Ctrl+C) or crop it (Enter / `C`); draw, move, size and turn the rectangle with the mouse.
- **Colour picker:** a loupe with the pixels around the pointer, their `#RRGGBB`, R G B (and the linear light values); keys copy the colour. The title bar shows the cursor's coordinates and values.
- **Highlighter:** mark a picture like with a yellow marker (`M`); undo with Ctrl+Z.
- **Save:** Save As Image as PNG (16 bit), AVIF (lossless, high quality 10-bit, low quality 8-bit) or JPG; Crop And Save; Resize And Save (filtered in linear light, with a live preview and six filters). Saves run in the background and say what they did.
- **Print** with a preview: printer, paper, orientation, scale, colour / grayscale / black and white, resolution, margins, copies.
- **Whole-screen grab:** Ctrl+Shift+S saves the monitor under the window as an AVIF in Pictures\Poli View; an HDR monitor gives an HDR file.

### Video
- Whatever FFmpeg 8.1 plays (.mkv .mp4 .avi .mov .m4v .webm .wmv .flv .mpg .mpeg .ts .m2ts .mts .3gp .ogv and more), with chapters, audio-track and video-track choice, resume where you left off, the next video of the folder at the end (or stop / close, your choice), and Play / Pause / Stop in the taskbar thumbnail.
- **Seeking:** frame step, timed skips (2 / 5 / 10 s, adding up while you hold the key), key-frame jumps, chapters; seek-bar previews (a small picture of the video where you hover).
- **Speed and sound:** playback speed 0.25x-4x with the pitch kept, volume, audio delay trim for Bluetooth and soundbars, audio normalization, 2.0 / 5.1 output, loop between two marks (A-B), mirror and flip.
- **Cut:** mark a start and an end and save that piece in the video's own format, nothing re-encoded.
- **Snapshots:** a frame as AVIF (10-bit), HJI (keeps HDR), PNG or JPG; a contact sheet of 12 frames with their times; Save As Image, Resize And Save, Crop and Print also work on the frame on screen.
- The screen saver and sleep are held back only while something plays.

### Sound
- MP3, M4A, M4B (audiobooks with chapters), AAC, FLAC, OGG, Opus, WAV, WMA, AIFF, MKA, AC3, APE, WV and more play in the same window with the same seek bar, speed and audio tracks. The window shows the cover picture when the file has one, otherwise the title, artist and album. Sounds keep their place in a list of their own.

### Subtitles
- External .srt .sub .txt .ass .ssa (drop one onto a playing video); embedded ASS / SSA drawn by libass as the author styled them (fonts, colours, positions, fades, fonts attached to an MKV); other embedded text in Poli View's own style; Blu-ray (PGS), DVD and DVB picture subtitles.
- Size, position and timing: smaller / larger, lower / higher, offset by half seconds; font, colours, outline, charset and preferred languages in Settings.
- **Subtitles from the internet:** the Subtitle menu lists what two free services (BSPlayer, OpenSubtitles; no account, no key) have for the playing video; picking one loads it and saves it next to the video for next time. Switch it off in Settings > Find Missing Subtitles Online; what it sends is listed in the program's privacy notes.

### Colour and HDR
- A linear-light float pipeline; HDR pictures and video (PQ / HLG, BT.2020) are shown in HDR on an HDR screen and fitted to the screen otherwise.
- The monitor's colour profile is used (a wide-gamut screen is not oversaturated); pictures with their own profile (Display P3, Adobe RGB ...) are converted from it.
- Easy Display Calibration by eye; Image Display Adjustment (monitor luminance in nits, brightness, saturation, contrast, colour-blind compensation).
- A one-time check of how the graphics card shows colours.

### Windows and files
- **Portable:** nothing is installed; all settings are in `PoliConfig.ini` beside the program, nothing in the registry unless you ask for the optional file associations.
- One window for everything: a file opened while Poli View runs goes to the open window (`/new` for another); several files dropped together make a playlist; the window opens where you left it; fullscreen with the transport bar at the bottom edge; always on top.
- **File associations** (optional, Settings): for images, videos and sounds, or only for the types nobody else opens; Explorer thumbnails and a preview pane for the types Windows cannot show (JPEG 2000, AVIF, HEIC, WebP, SVG, Netpbm ...); a viewer plugin for Total Commander (F3 and Quick View).
- Media Info for any file, including the versions of the decoders in use; Open File Location; Copy File Path.
- Updates: a check once a day (switch it off in the menu), nothing installed by itself.

## Licence

Free to use, for personal and commercial use. All rights reserved. Do not redistribute modified copies; download Poli View only from its official releases page. Third-party parts are under their own licences (see [LICENCES.md](LICENCES.md)).
