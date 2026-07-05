# personal-site

Public personal hub for **[vikas.koppineedi.com](https://vikas.koppineedi.com)** — a
linktree-style landing page with sections for music, blog, and portfolio/resume.

Hosted on **GitHub Pages** (free, GitHub-hosted runners). Static HTML/CSS + light JS.

## Structure

```
site/                 # everything served at the site root
  index.html          # linktree landing page
  CNAME               # custom domain, as code -> vikas.koppineedi.com
.github/workflows/
  deploy.yml          # build-free deploy of site/ to GitHub Pages on push to main
```

## How hosting works

| Concern | Managed by |
|---|---|
| Repo | created via `gh` (public) |
| Pages enablement + deploy | `.github/workflows/deploy.yml` (Actions) |
| Custom domain + HTTPS | `scripts/setup-pages.sh` (gh API — run once, idempotent) |
| DNS (`vikas` CNAME → `vikaskoppineedi.github.io`) | Terraform in `homelab-infra` (Cloudflare, `proxied=false`) |

Push to `main` → the workflow uploads `site/` and deploys to Pages.

> **Note:** with the Actions deploy model the custom domain is a Pages *API
> setting*, not the `site/CNAME` file (that only applies to legacy branch-based
> Pages). `scripts/setup-pages.sh` sets it as code. Run it once after DNS resolves.

## Roadmap

- Adopt a static-site generator (Astro) once the pipeline is proven.
- `/music/` section auto-generated from the private `spotify-library-manager` repo
  (emits `music.json` consumed at build time).
- `/blog/`, `/portfolio/`, resume.
