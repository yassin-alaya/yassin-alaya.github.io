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

## Auto-publishing the paper on every compile

`publish-paper.ps1` copies `../Latex/main.pdf` to `papers/dac.pdf`, stamps the
"Last revised" date on `research.html`, commits, and pushes. It is wired into
VS Code by `../Latex/.vscode/settings.json`, which adds a build recipe
`latexmk -> publish` and makes it the default — so an ordinary build (including
LaTeX Workshop's build-on-save) publishes.

The script is deliberately quiet and safe to run constantly:

- it compares the PDF's extracted *text*, not its bytes, so recompiling without
  substantive changes publishes nothing;
- it always exits 0, so a publishing problem never shows up as a failed build;
- if the site has no git remote yet, it commits locally and says so.

To compile without publishing, either pick the plain `latexmk` recipe from
LaTeX Workshop's build menu, or swap the order of the two recipes in
`.vscode/settings.json` (the first one is the default).

To run it by hand instead:

    powershell -ExecutionPolicy Bypass -File publish-paper.ps1

Two caveats. VS Code only reads `.vscode/settings.json` from the workspace
root, so if you open a folder other than `Latex` as your workspace, move that
file to that folder's `.vscode/`. And every published revision stays in git
history forever — at ~550 KB per PDF that is fine for years, but it is not free.
