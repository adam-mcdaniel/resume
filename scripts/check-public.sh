#!/usr/bin/env bash
# Fails if private details could reach the public site.
#   usage: scripts/check-public.sh build/Resume.pdf
set -euo pipefail

pdf=$1
status=0

# private.tex must never be committed.
if git ls-files --error-unmatch private.tex >/dev/null 2>&1; then
    echo "ERROR: private.tex is tracked by git. Run: git rm --cached private.tex" >&2
    status=1
fi

# The public PDF and the public source must not contain a phone number.
phone='(\+?1[ .-]?)?\(?[0-9]{3}\)?[ .-][0-9]{3}[ .-][0-9]{4}'
if pdftotext "$pdf" - | grep -Eq "$phone"; then
    echo "ERROR: the public PDF contains a phone number." >&2
    status=1
fi
if grep -Eq "$phone" src/*.tex; then
    echo "ERROR: src/ contains a phone number; move it to private.tex." >&2
    status=1
fi

# Every \Private{...} in the public build must have fallen back to its public text.
if [ -f build/public/Resume.log ] && grep -q "private.tex" build/public/Resume.log; then
    echo "ERROR: the public build read private.tex." >&2
    status=1
fi

[ $status -eq 0 ] && echo "Public PDF check passed."
exit $status
