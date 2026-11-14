# Resume

**[View the resume](https://adam-mcdaniel.github.io/resume/)** · [Download PDF](https://adam-mcdaniel.github.io/resume/Resume.pdf)

[![Resume page 1](https://adam-mcdaniel.github.io/resume/Resume-1.png)](https://adam-mcdaniel.github.io/resume/Resume.pdf)

## Updating

Edit `src/resume.tex` and push to `master`. GitHub Actions compiles the PDF,
checks that nothing private slipped in, and publishes it to GitHub Pages.
No PDFs or images are committed.

## Building locally

Requires a LaTeX distribution with `latexmk` (MacTeX on macOS) and, for
`make site`, `pdftoppm` (`brew install poppler`).

```bash
make            # public PDF   -> build/Resume.pdf
make private    # full PDF     -> build/Resume-private.pdf
make site       # web page     -> build/site/index.html
make check      # verify the public PDF has no private details
```

## Public and private versions

`src/resume.tex` is public. Anything that should stay off the web (phone
number, unpublished results, papers under anonymous review) goes in
`private.tex`, which is git-ignored. In the source, `\Private{key}{public text}`
prints the public text unless `private.tex` defines `key`. See
`private.example.tex`.
