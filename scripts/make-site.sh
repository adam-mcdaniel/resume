#!/usr/bin/env bash
# Builds the GitHub Pages site from a compiled resume PDF.
#   usage: scripts/make-site.sh build/Resume.pdf build/site
set -euo pipefail

pdf=$1
out=$2

rm -rf "$out"
mkdir -p "$out/resume"

cp "$pdf" "$out/Resume.pdf"
# Older links point at /resume/resume/Resume.pdf; keep that path working.
cp "$pdf" "$out/resume/Resume.pdf"

# One PNG per page for the preview (Resume-1.png, Resume-2.png, ...).
# The page margins are cropped down to PAD_IN so the text is as large as
# possible on a phone. MARGIN_IN must match the geometry margin in src/resume.tex.
DPI=200
MARGIN_IN=0.75
PAD_IN=0.2
crop() { awk -v d="$DPI" -v m="$MARGIN_IN" -v p="$PAD_IN" -v s="$1" 'BEGIN { printf "%d", (s == 0 ? m - p : s - 2 * (m - p)) * d }'; }
pdftoppm -png -r "$DPI" -x "$(crop 0)" -y "$(crop 0)" -W "$(crop 8.5)" -H "$(crop 11)" "$pdf" "$out/Resume"
for f in "$out"/Resume-0*.png; do
    [ -e "$f" ] || continue
    n=${f##*-}; n=${n%.png}; mv "$f" "$out/Resume-$((10#$n)).png"
done

pages=""
for f in $(ls "$out"/Resume-*.png | sort -V); do
    name=$(basename "$f")
    pages+="      <a href=\"Resume.pdf\"><img src=\"$name\" alt=\"Resume page ${name//[!0-9]/}\"></a>"$'\n'
done

cat > "$out/index.html" <<HTML
<!doctype html>
<html lang="en">
<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>Adam McDaniel | Resume</title>
  <meta name="description" content="Resume of Adam McDaniel, PhD student at the University of Tennessee, Knoxville.">
  <style>
    body { margin: 0; background: #f2f4f6; color: #272341; font-family: system-ui, -apple-system, "Segoe UI", sans-serif; }
    header { display: flex; flex-wrap: wrap; gap: 12px 24px; align-items: center; justify-content: space-between;
             max-width: 880px; margin: 0 auto; padding: 24px 16px 16px; }
    h1 { margin: 0; font-size: 24px; }
    nav { display: flex; gap: 12px; }
    nav a { display: inline-block; padding: 10px 16px; border-radius: 4px; font-weight: 600; text-decoration: none; }
    .primary { background: #017a90; color: #fff; }
    .secondary { border: 2px solid #017a90; color: #017a90; padding: 8px 14px; }
    nav { flex-wrap: wrap; }
    .intro { max-width: 880px; margin: 0 auto; padding: 0 16px 16px; font-size: 17px; line-height: 1.5; }
    main { max-width: 880px; margin: 0 auto; padding: 0 8px 48px; display: flex; flex-direction: column; gap: 12px; }
    main img { display: block; width: 100%; height: auto; background: #fff; box-shadow: 0 2px 10px rgba(0,0,0,.12); }
  </style>
</head>
<body>
  <header>
    <h1>Adam McDaniel</h1>
    <nav>
      <a class="primary" href="Resume.pdf" download>Download PDF</a>
      <a class="secondary" href="mailto:amcdan23@vols.utk.edu">Email</a>
      <a class="secondary" href="https://github.com/adam-mcdaniel/">GitHub</a>
      <a class="secondary" href="https://adam-mcdaniel.net">Website</a>
    </nav>
  </header>
  <p class="intro">Ph.D. student at the University of Tennessee, Knoxville, researching energy-aware compilers
  and runtime systems for GPU-accelerated HPC and AI workloads. Research intern at Oak Ridge National Laboratory.</p>
  <main>
$pages  </main>
</body>
</html>
HTML

echo "Site written to $out"
