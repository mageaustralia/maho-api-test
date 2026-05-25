# Maho API Test Harness

A static, build-free test harness and playground for the **Maho API Platform**
(REST + GraphQL). Built with [Alpine.js](https://alpinejs.dev/) and Tailwind (both via
CDN) — no bundler, no install step. Drop it into a Maho install's `public/api-test/` and
open it in a browser.

## What's here

| Path | Purpose |
|------|---------|
| `store/` | Full single-page storefront SPA — the main harness |
| `index.html` | Landing page linking the standalone endpoint testers |
| `products.html`, `categories.html`, `cart.html`, `checkout.html`, `customers.html`, `reviews.html`, `wishlist.html`, `giftcards.html`, `cms.html`, `blog.html` | Focused per-area endpoint testers |

### The store SPA (`store/`)

A working storefront that exercises most of the API surface:

- Catalog browse, category pages, layered-nav filters, **search**
- Product detail: media gallery, configurable + custom options, **downloadable links**
- Cart, coupons, gift cards, checkout (addresses, shipping, payment)
- Customer auth (JWT), account, addresses, orders
- Wishlist, product reviews
- CMS pages, blog

It runs against either protocol and flips between them at runtime:

- **REST** — `/api/rest/v2/...`
- **GraphQL** — `/api/graphql`

Use the REST/GraphQL toggle in the header (persisted in `localStorage` as `apiMode`).

## Install

Copy the contents of this repo into a Maho install's web root under `public/api-test/`,
then visit:

- `https://<your-store>/api-test/` — standalone testers
- `https://<your-store>/api-test/store/` — the SPA

The harness uses **relative URLs only**, so it works on any host with no configuration.

> API Platform protocols are opt-in. Enable the ones you want to test under
> **System Config → API Platform → Protocols** (`apiplatform/protocols/rest`,
> `apiplatform/protocols/graphql`). A disabled protocol returns
> `{"error":"protocol_disabled"}`.

## Deploy

`deploy.sh` rsyncs this repo into an install's `public/api-test/`:

```bash
./deploy.sh user@host:/var/www/<store>/public/api-test/ [ssh-port]
```

Or list one target per line in a gitignored `.deploy-targets` file (optional port as a
second field) and run `./deploy.sh` with no arguments.

## Cache busting

`index.html` loads `store.js?v=N`; `store.js` reads that `N` from its own URL and appends
it to every lazy-loaded module — so **bumping the single `?v=` in `index.html` busts the
whole SPA**. Bump it whenever you change any file under `store/`.
