<#
  publish-paper.ps1

  Copies the freshly compiled paper into the website and pushes it to GitHub,
  replacing the previous version. Safe to run on every compile: it does nothing
  when the paper's text has not actually changed, and it never fails the build
  (it always exits 0, so LaTeX Workshop does not report a broken recipe).

  Run by hand:   powershell -ExecutionPolicy Bypass -File publish-paper.ps1
  Or let the VS Code build recipe run it automatically. See README.md.
#>

$ErrorActionPreference = 'Continue'

$site    = $PSScriptRoot
$project = Split-Path $site -Parent
$source  = Join-Path $project 'Latex/main.pdf'
$target  = Join-Path $site 'papers/dac.pdf'
$page    = Join-Path $site 'research.html'

function Say($msg) { Write-Host "publish-paper: $msg" }

if (-not (Test-Path $source)) {
    Say "no compiled PDF at $source - nothing to publish."
    exit 0
}

if (-not (Test-Path (Join-Path $site '.git'))) {
    Say "$site is not a git repository yet - see README.md. Skipping."
    exit 0
}

# --- Has the visible content changed? -------------------------------------
# Every LaTeX run stamps a new creation date into the PDF, so the bytes always
# differ. Compare the extracted text instead, and only publish a real change.
$changed = $true
if ((Test-Path $target) -and (Get-Command pdftotext -ErrorAction SilentlyContinue)) {
    $a = Join-Path $env:TEMP 'publish-paper-new.txt'
    $b = Join-Path $env:TEMP 'publish-paper-old.txt'
    pdftotext -q $source $a
    pdftotext -q $target $b
    if ((Test-Path $a) -and (Test-Path $b)) {
        $ha = (Get-FileHash $a -Algorithm SHA256).Hash
        $hb = (Get-FileHash $b -Algorithm SHA256).Hash
        $changed = ($ha -ne $hb)
    }
    Remove-Item $a, $b -ErrorAction SilentlyContinue
}

if (-not $changed) {
    Say "paper text unchanged - nothing to publish."
    exit 0
}

# --- Copy the PDF and stamp the date on the page ---------------------------
Copy-Item $source $target -Force
Say "copied main.pdf -> papers/dac.pdf"

if (Test-Path $page) {
    $stamp = (Get-Date).ToString('d MMMM yyyy', [Globalization.CultureInfo]::InvariantCulture)
    $html  = Get-Content $page -Raw -Encoding UTF8
    $new   = [regex]::Replace(
        $html,
        '(?s)(<!--DAC_DATE-->).*?(<!--/DAC_DATE-->)',
        "`${1}$stamp`${2}")
    if ($new -ne $html) {
        Set-Content $page -Value $new -Encoding UTF8 -NoNewline
        Say "stamped research.html with $stamp"
    }
}

# --- Commit and push -------------------------------------------------------
Push-Location $site
try {
    git add --all
    git diff --cached --quiet
    if ($LASTEXITCODE -eq 0) {
        Say "nothing staged - working tree already matches."
        exit 0
    }

    git commit -q -m "Update job market paper ($(Get-Date -Format 'yyyy-MM-dd HH:mm'))"
    if ($LASTEXITCODE -ne 0) {
        Say "commit failed (is git user.name / user.email set?). Nothing pushed."
        exit 0
    }

    $remotes = git remote
    if (-not $remotes) {
        Say "committed locally. No git remote configured yet, so nothing was pushed."
        exit 0
    }

    git push -q
    if ($LASTEXITCODE -eq 0) { Say "pushed. The site will update in about a minute." }
    else                     { Say "commit made, but the push failed - run 'git push' here to see why." }
}
finally {
    Pop-Location
}

exit 0
