# Poli View - one-line installer for Windows (64-bit).
#   irm https://raw.githubusercontent.com/milika/PoliViewPublic/main/install.ps1 | iex
# Downloads the newest release from github.com/milika/PoliViewPublic, checks its SHA-256 against the release's poliview-release.json,
# unpacks it into %LOCALAPPDATA%\Programs\PoliView (an update keeps PoliConfig.ini and logs\), adds a Start Menu shortcut and starts the program.
# Settings (also as environment variables, for the piped form): -Dir / POLIVIEW_DIR, -NoStart / POLIVIEW_NO_START=1, -NoShortcut / POLIVIEW_NO_SHORTCUT=1.
param(
  [string]$Dir = $(if ($env:POLIVIEW_DIR) { $env:POLIVIEW_DIR } else { Join-Path $env:LOCALAPPDATA 'Programs\PoliView' }),
  [switch]$NoStart = ($env:POLIVIEW_NO_START -eq '1'),
  [switch]$NoShortcut = ($env:POLIVIEW_NO_SHORTCUT -eq '1')
)
$ErrorActionPreference = 'Stop'
$ProgressPreference = 'SilentlyContinue' # the progress bar makes Invoke-WebRequest many times slower in Windows PowerShell
try { [Net.ServicePointManager]::SecurityProtocol = [Net.ServicePointManager]::SecurityProtocol -bor [Net.SecurityProtocolType]::Tls12 } catch { }

$repo = 'milika/PoliViewPublic'
$tmp = Join-Path ([IO.Path]::GetTempPath()) ('poliview-install-' + [Guid]::NewGuid().ToString('N'))
try {
  if (-not [Environment]::Is64BitOperatingSystem) { throw 'Poli View needs 64-bit Windows.' }
  New-Item -ItemType Directory -Path $tmp | Out-Null

  Write-Host 'Poli View: looking for the newest version...'
  $headers = @{ 'User-Agent' = 'PoliViewInstall' }
  $release = Invoke-RestMethod -Headers $headers -Uri "https://api.github.com/repos/$repo/releases/latest"
  $meta = $release.assets | Where-Object { $_.name -eq 'poliview-release.json' } | Select-Object -First 1
  if (-not $meta) { throw "The release $($release.tag_name) has no poliview-release.json." }
  $info = Invoke-RestMethod -Headers $headers -Uri $meta.browser_download_url
  $pkg = $info.package
  if (-not $pkg.url -or -not $pkg.sha256 -or -not $info.root) { throw 'poliview-release.json is incomplete.' }

  $zip = Join-Path $tmp $pkg.name
  Write-Host ("Poli View {0}: downloading {1:N0} MB..." -f $info.version, ($pkg.size / 1MB))
  Invoke-WebRequest -Headers $headers -Uri $pkg.url -OutFile $zip -UseBasicParsing
  $hash = (Get-FileHash -Algorithm SHA256 -Path $zip).Hash
  if ($hash -ne $pkg.sha256.ToUpperInvariant()) { throw "The download does not match its SHA-256 ($hash, expected $($pkg.sha256)). Nothing was installed." }

  Write-Host 'Unpacking...'
  $unpacked = Join-Path $tmp 'unpacked'
  Expand-Archive -Path $zip -DestinationPath $unpacked
  $source = Join-Path $unpacked ($info.root.TrimEnd('/', '\'))
  if (-not (Test-Path (Join-Path $source 'PoliView.exe'))) { throw 'The package holds no PoliView.exe.' }

  $exe = Join-Path $Dir 'PoliView.exe'
  Get-Process -Name PoliView -ErrorAction SilentlyContinue | Where-Object { $_.Path -eq $exe } | ForEach-Object {
    Write-Host 'Closing the running Poli View...'
    [void]$_.CloseMainWindow()
    if (-not $_.WaitForExit(8000)) { $_.Kill(); $_.WaitForExit(5000) | Out-Null }
  }

  New-Item -ItemType Directory -Force -Path $Dir | Out-Null
  Get-ChildItem -LiteralPath $Dir -Force | Where-Object { $_.Name -notin 'PoliConfig.ini', 'logs' } | Remove-Item -Recurse -Force
  Copy-Item -Path (Join-Path $source '*') -Destination $Dir -Recurse -Force

  if (-not $NoShortcut) {
    $lnk = Join-Path ([Environment]::GetFolderPath('Programs')) 'Poli View.lnk'
    $sh = New-Object -ComObject WScript.Shell
    $s = $sh.CreateShortcut($lnk)
    $s.TargetPath = $exe
    $s.WorkingDirectory = $Dir
    $s.Save()
  }

  Write-Host "Poli View $($info.version) is installed in $Dir"
  Write-Host 'Remove it later: delete that folder and the "Poli View" Start Menu shortcut (nothing is in the registry).'
  if (-not $NoStart) { Start-Process -FilePath $exe -WorkingDirectory $Dir }
} finally {
  Remove-Item -Recurse -Force -LiteralPath $tmp -ErrorAction SilentlyContinue
}
