# Design System — "Ink on Warm Paper"

An editorial, typography-forward system for a personal
website. Designed to read as *considered and crafted*, deliberately avoiding
generic template/AI-slop patterns (no default blue, no gradients, no
glassmorphism, no scroll animations).

All tokens live as CSS custom properties in `src/styles/global.css`. Change a
value there once and it updates everywhere.

## Typography

| Role | Font | Why |
|------|------|-----|
| Display (headings, brand) | **Fraunces Variable** (serif) | Warm, crafted character — signals substance and taste |
| Text / UI | **Inter Variable** (sans) | Highly legible, neutral; lets the serif carry personality |

Fonts are **self-hosted** via Fontsource (`@fontsource-variable/*`), so the live
site makes no external font requests — faster and privacy-friendly.

## Color

A warm paper-and-ink palette with a single terracotta accent. Full light and
dark variants (auto-switches with the visitor's system setting).

| Token | Light | Role |
|-------|-------|------|
| `--paper` | `#faf7f2` | Page background (warm off-white) |
| `--paper-raised` | `#ffffff` | Cards |
| `--ink` | `#22201c` | Primary text / headings |
| `--ink-soft` | `#5f584e` | Body / secondary |
| `--ink-faint` | `#8a8176` | Meta, captions |
| `--accent` | `#b4531f` | Terracotta — links, active nav, rules |
| `--line` | `#e7e0d5` | Hairline borders |

## Spacing

An 8px rhythm: `--s1` (0.5rem) → `--s6` (4.5rem). Used for all vertical spacing
so the page has consistent, deliberate breathing room.

## Layout

- Single readable column, `--maxw: 44rem` (optimal line length for reading).
- Generous whitespace; content-first, chrome-light.

## Polish details

- Active nav item marked with a terracotta underline.
- Cards lift slightly (`translateY`) and border turns terracotta on hover.
- Experience entries use a left hairline rule that warms to terracotta on hover.
- Blockquotes render in italic Fraunces for an editorial pull-quote feel.

## Changing the look

- **Different accent color:** edit `--accent` (and its dark-mode value).
- **Different fonts:** swap the `@fontsource-variable/*` packages and the
  `--font-display` / `--font-text` variables.
- **Wider/narrower page:** adjust `--maxw`.
