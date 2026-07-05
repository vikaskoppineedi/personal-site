# personal-site

Public personal hub for **[vikas.koppineedi.com](https://vikas.koppineedi.com)** — a
linktree-style landing page with a tech blog, portfolio, resume, and an
auto-updating music section.

Built with **[Astro](https://astro.build)**, hosted on **GitHub Pages** (free,
GitHub-hosted runners).

## Structure

```
src/
  layouts/BaseLayout.astro     # <head>, theme, global styles
  components/LinkCard.astro     # reusable linktree card
  styles/global.css             # design system (dark/light, accent)
  content.config.ts             # blog content collection schema
  content/blog/*.md             # blog posts
  pages/
    index.astro                 # linktree landing
    blog/index.astro            # blog list
    blog/[...slug].astro        # blog post pages
    portfolio.astro
    resume.astro
    music.astro                 # placeholder → auto-generated in a later milestone
public/                         # static assets (favicon, resume.pdf, …)
scripts/setup-pages.sh          # one-time Pages + custom-domain provisioning (as code)
.github/workflows/deploy.yml    # build Astro + deploy to Pages on push to main
```

## Local development

```bash
npm install
npm run dev       # http://localhost:4321
npm run build     # outputs to dist/
npm run preview   # serve the built site
```

## How hosting works

| Concern | Managed by |
|---|---|
| Repo | created via `gh` (public) |
| Build + deploy | `.github/workflows/deploy.yml` — `withastro/action` builds, `deploy-pages` publishes |
| Pages enablement + custom domain + HTTPS | `scripts/setup-pages.sh` (gh API — run once, idempotent) |
| DNS (`vikas` CNAME → `vikaskoppineedi.github.io`) | Terraform in `homelab-infra` (Cloudflare, `proxied=false`) |

Push to `main` → Astro builds → the `dist/` artifact deploys to Pages.

> **Note:** with the Actions deploy model the custom domain is a Pages *API
> setting* (see `scripts/setup-pages.sh`), not a `CNAME` file — that only applies
> to legacy branch-based Pages.

## Content

- **Blog:** add a markdown file to `src/content/blog/` with frontmatter
  (`title`, `date`, optional `description`, `draft`). It appears automatically.
- **Resume:** drop `public/resume.pdf` and uncomment the download link in
  `src/pages/resume.astro`.

## Roadmap

- `/music/` auto-generated from the private `spotify-library-manager` repo
  (emits `music.json` consumed at build time).
- Fill in portfolio + resume.
