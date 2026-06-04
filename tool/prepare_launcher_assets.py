"""Derive launcher-icon and splash source images from assets/images/logo.png.

logo.png is the master brand mark with real alpha transparency, tightly cropped.
This script never alters the artwork itself — it only trims to the alpha bounding
box and re-pads it (centered, square) at the coverage each target needs:

  * app_icon.png            opaque, white background   -> iOS AppIcon + Android legacy mipmaps
  * app_icon_foreground.png transparent, extra padding  -> Android adaptive foreground (66dp safe zone)
  * splash_logo.png         transparent, centered       -> flutter_native_splash (legacy + Android 12)

The white icon background and #121212 dark splash are applied by the generators /
configs, not baked here. Run:  python tool/prepare_launcher_assets.py
"""

from __future__ import annotations

import sys
from pathlib import Path

from PIL import Image

ROOT = Path(__file__).resolve().parent.parent
SRC = ROOT / "assets" / "images" / "logo.png"
OUT_DIR = ROOT / "assets" / "launcher"

WHITE = (255, 255, 255, 255)


# Trim against this alpha threshold, not 0: the master PNG carries a faint scatter
# of alpha 1-8 "noise" pixels reaching the corners. Sizing against the raw bbox
# would track that invisible noise and shrink the real mark to a fraction of the
# tile. >16 isolates the visible logo; its hard edge means nothing visible is lost.
VISIBLE_ALPHA = 16


def trimmed_artwork() -> Image.Image:
    im = Image.open(SRC).convert("RGBA")
    mask = im.split()[3].point(lambda v: 255 if v > VISIBLE_ALPHA else 0)
    bbox = mask.getbbox()
    if bbox is None:
        raise SystemExit("ERROR: logo.png has no visible pixels")
    art = im.crop(bbox)
    print(f"  source={im.size} visible-bbox={bbox} trimmed={art.size}")
    return art


def compose(art: Image.Image, canvas: int, coverage: float,
            background: tuple[int, int, int, int] | None) -> Image.Image:
    """Center `art` on a square `canvas` so its longest side spans `coverage`
    of the canvas. `background` None => fully transparent."""
    aw, ah = art.size
    scale = (canvas * coverage) / max(aw, ah)
    nw, nh = max(1, round(aw * scale)), max(1, round(ah * scale))
    resized = art.resize((nw, nh), Image.LANCZOS)
    base = Image.new("RGBA", (canvas, canvas), background or (0, 0, 0, 0))
    base.alpha_composite(resized, ((canvas - nw) // 2, (canvas - nh) // 2))
    return base


def main() -> int:
    if not SRC.exists():
        raise SystemExit(f"ERROR: missing source logo at {SRC}")
    OUT_DIR.mkdir(parents=True, exist_ok=True)
    print(f"Loading {SRC.relative_to(ROOT)} ...")
    art = trimmed_artwork()

    # Opaque launcher icon on white (iOS forbids alpha; legacy Android needs a bg).
    compose(art, 1024, 0.80, WHITE).save(OUT_DIR / "app_icon.png")
    # Adaptive foreground: near full-bleed; flutter_launcher_icons adds a 16% inset
    # in ic_launcher.xml, so 0.90 here lands the mark at ~0.61 of the tile — a solid
    # size that still clears the 66dp circular-mask safe zone (no cropping).
    compose(art, 1024, 0.90, None).save(OUT_DIR / "app_icon_foreground.png")
    # Native splash mark: transparent, centered, modest so it clears the Android-12
    # icon circle and reads as ~1/3 screen width on the legacy splash.
    compose(art, 1152, 0.42, None).save(OUT_DIR / "splash_logo.png")

    print("Wrote:")
    for p in sorted(OUT_DIR.glob("*.png")):
        with Image.open(p) as g:
            print(f"  {p.relative_to(ROOT)}  {g.size}")
    return 0


if __name__ == "__main__":
    sys.exit(main())
