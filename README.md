# yassinalaya.github.io — personal site

Plain HTML and one stylesheet. No build step, no dependencies.

## Editing

Open the `.html` files in any editor. Every spot that needs your input is
marked with a `TODO` comment. Search for `TODO` to find them all.

- `index.html` — about, research interests, contact
- `research.html` — papers; copy an `<article class="paper">` block to add one
- `teaching.html` — courses
- `style.css` — all styling; colours live in the `:root` block at the top
- `papers/` — paper PDFs
- `cv.pdf` — drop your CV here (the nav links to it)

To preview locally, double-click `index.html`, or run:

    python -m http.server 8000

and open http://localhost:8000.

## Publishing to GitHub Pages

1. Create a GitHub repo named exactly `<your-username>.github.io` — public,
   with no README, no .gitignore, no licence.
2. From this folder:

       git init -b main
       git add .
       git commit -m "Initial site"
       git remote add origin https://github.com/<your-username>/<your-username>.github.io.git
       git push -u origin main

3. The site is live at `https://<your-username>.github.io` within a minute.

Every later update is just `git add . && git commit -m "..." && git push`.

## Custom domain (optional)

Buy a domain (~$12/yr at Cloudflare or Namecheap), then:

1. Add a file named `CNAME` in this folder containing only your domain,
   e.g. `yassinalaya.com`.
2. At your registrar, add four `A` records for the apex pointing at
   `185.199.108.153`, `185.199.109.153`, `185.199.110.153`, `185.199.111.153`,
   and a `CNAME` for `www` pointing at `<your-username>.github.io`.
3. In the repo: Settings → Pages → set the custom domain and tick
   "Enforce HTTPS".

## Updating the paper

Automatic publishing on every compile is **off**. Update the paper when a
version is polished enough, in either of these two ways.

**Run the script** (does everything in one go):

    powershell -ExecutionPolicy Bypass -File publish-paper.ps1

It copies `../Latex/main.pdf` to `papers/dac.pdf`, stamps the "Last revised"
date on `research.html`, commits, and pushes. If the PDF's text has not changed
since the published version, it does nothing and says so.

**Or do it by hand:** copy `main.pdf` over `papers/dac.pdf`, edit the date
between the `<!--DAC_DATE-->` markers in `research.html`, then:

    git add . && git commit -m "Update paper" && git push

### Turning automatic publishing back on

Open `../Latex/.vscode/settings.json` and swap the two entries in
`latex-workshop.latex.recipes` so that `latexmk -> publish` comes first.
LaTeX Workshop uses the first recipe as the default, so every build — including
build-on-save — will publish again. The file has a comment saying the same.

Without swapping anything you can also publish a one-off build from
Ctrl+Shift+P -> "LaTeX Workshop: Build with recipe" -> "latexmk -> publish".

Note that VS Code only reads `.vscode/settings.json` from the workspace root,
so if you open a folder other than `Latex` as your workspace, move that file to
that folder's `.vscode/`.
