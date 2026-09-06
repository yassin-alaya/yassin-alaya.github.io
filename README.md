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
