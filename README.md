# yassinalaya.github.io — personal site

Plain HTML and one stylesheet. No build step, no dependencies.

## How the site is put together

It is a Jekyll site. GitHub builds it automatically on every push — there is
nothing to install and no build command to run.

- `_layouts/default.html` — the shared skeleton: head, header, menu, footer.
  Everything that appears on every page lives here, and only here.
- `_data/nav.yml` — the menu. Add, remove or reorder entries here and all
  pages follow. This is the one place the menu is defined.
- `_config.yml` — site-wide settings: name, affiliation, description.
- `index.html`, `research.html`, `teaching.html` — one page each. They contain
  only that page's content, under a short front-matter block.
- `style.css` — all styling; colours are variables in the `:root` block.
- `papers/` — paper PDFs.

### Front matter

Every page starts with a block fenced by `---`:

    ---
    layout: default
    title: Research
    mathjax: true
    ---

`layout: default` wraps the page in the shared skeleton. `title` sets the
browser tab (omit it on the home page). `mathjax: true` loads MathJax, so you
can write maths in the text as \( ... \); leave it out on pages that do not
need it.

### Adding a page

Copy `teaching.html`, change the front matter and content, and add an entry to
`_data/nav.yml`. Removing a page means deleting the file and its line in
`nav.yml`. Either way you touch two files, never every page.

### Previewing

Opening the `.html` files directly in a browser no longer shows a finished
page — the menu and header are added by GitHub at build time. Either push and
look at the live site, or install Ruby and run Jekyll locally:

    gem install jekyll bundler
    jekyll serve

which serves a live-reloading preview at http://localhost:4000.

If a push does not appear on the live site, the build failed: check the
Actions tab in the repository. GitHub also emails you when a build breaks.

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

It copies the compiled `main.pdf` (path set by `$Source` at the top of the
script, or pass `-Source <path>`) to `papers/main.pdf`, stamps the "Last revised"
date on `research.html`, commits, and pushes. If the PDF's text has not changed
since the published version, it does nothing and says so.

**Or do it by hand:** copy `main.pdf` over `papers/main.pdf`, edit the date
between the `<!--DAC_DATE-->` markers in `research.html`, then:

    git add . && git commit -m "Update paper" && git push

### Turning automatic publishing back on

Open `.vscode/settings.json` in the LaTeX project folder and swap the two entries in
`latex-workshop.latex.recipes` so that `latexmk -> publish` comes first.
LaTeX Workshop uses the first recipe as the default, so every build — including
build-on-save — will publish again. The file has a comment saying the same.

Without swapping anything you can also publish a one-off build from
Ctrl+Shift+P -> "LaTeX Workshop: Build with recipe" -> "latexmk -> publish".

Note that VS Code only reads `.vscode/settings.json` from the workspace root,
so if you open a folder other than `Latex` as your workspace, move that file to
that folder's `.vscode/`. The publish recipe there must call this script by its
full path, `C:\Users\yrala\OneDrive\Documents\website\publish-paper.ps1`,
since the website no longer sits next to the LaTeX folder.
