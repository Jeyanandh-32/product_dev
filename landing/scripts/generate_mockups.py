#!/usr/bin/env python3
"""
Generate responsive Apple device mockups for Finch POS landing page:
1. Customer Mobile Store: iPhone 16 Pro Max frame (customer-iphone.png & .webp)
2. Merchant Admin Dashboard: 16" MacBook Pro frame (merchant-macbook.png & .webp)
3. Counter Billing Terminal: 16" MacBook Pro frame (terminal-macbook.png & .webp)
"""

import os
from PIL import Image
import numpy as np

SCRIPT_DIR = os.path.dirname(os.path.abspath(__file__))
LANDING_DIR = os.path.dirname(SCRIPT_DIR)
IMAGES_DIR = os.path.join(LANDING_DIR, 'images')

def build_customer_mockup():
    print("Generating Customer iPhone mockup...")
    frame_path = os.path.join(IMAGES_DIR, 'iphone-max-frame.png')
    mask_path = os.path.join(IMAGES_DIR, 'iphone-max-mask.png')
    cust_path = os.path.join(IMAGES_DIR, 'customer.png')

    frame = Image.open(frame_path).convert('RGBA')
    mask = Image.open(mask_path).convert('L')
    cust_img = Image.open(cust_path).convert('RGBA')

    # Add iOS safe-area top padding (150px) so Dynamic Island floats in whitespace
    pad_top = 150
    padded = Image.new('RGBA', (cust_img.width, cust_img.height + pad_top), (255, 255, 255, 255))
    padded.paste(cust_img, (0, pad_top))

    # Screen dimensions inside iPhone 16 Pro Max frame
    # Bounding box: x: 99..1388 (width 1290), y: 100..2895 (height 2796)
    cust_resized = padded.resize((1290, 2796), Image.Resampling.LANCZOS)

    canvas = Image.new('RGBA', frame.size, (0, 0, 0, 0))
    canvas.paste(cust_resized, (99, 100))

    # Mask with rounded screen corners
    screen_masked = Image.composite(canvas, Image.new('RGBA', frame.size, (0, 0, 0, 0)), mask)

    # Composite phone frame on top
    final = Image.alpha_composite(screen_masked, frame)

    # Save PNG fallback
    png_out = os.path.join(IMAGES_DIR, 'customer-iphone.png')
    final.save(png_out, format='PNG', optimize=True)
    print(f"Saved {png_out} ({os.path.getsize(png_out):,} bytes, size={final.size})")

    # Save WebP optimized (796x1600)
    webp_out = os.path.join(IMAGES_DIR, 'customer-iphone.webp')
    final_webp = final.resize((796, 1600), Image.Resampling.LANCZOS)
    final_webp.save(webp_out, format='WEBP', quality=85, method=6)
    print(f"Saved {webp_out} ({os.path.getsize(webp_out):,} bytes, size={final_webp.size})")

def build_macbook_mockups():
    print("Generating MacBook Pro mockups...")
    base_frame_path = os.path.join(IMAGES_DIR, 'macbook-pro-frame.png')
    base_frame = Image.open(base_frame_path).convert('RGBA')
    base_arr = np.array(base_frame)

    # Screen rectangle: (x: 400..3856, y: 300..2534) -> 3456 x 2234 (Liquid Retina XDR)
    screen_mask = np.ones((2234, 3456), dtype=bool)
    notch_region = base_arr[300:370, 1900:2350, :3]
    is_notch = (notch_region.mean(axis=-1) < 40)
    screen_mask[0:70, 1500:1950] = ~is_notch
    screen_mask[0:30, 0:30] = ~(base_arr[300:330, 400:430, :3].mean(axis=-1) < 40)
    screen_mask[0:30, 3426:3456] = ~(base_arr[300:330, 3826:3856, :3].mean(axis=-1) < 40)

    def compose_macbook(source_filename):
        src_path = os.path.join(IMAGES_DIR, source_filename)
        src_img = Image.open(src_path).convert('RGBA')
        src_resized = np.array(src_img.resize((3456, 2234), Image.Resampling.LANCZOS))

        comp = base_arr.copy()
        comp_screen = comp[300:2534, 400:3856]
        for c in range(3):
            comp_screen[:, :, c] = np.where(screen_mask, src_resized[:, :, c], comp_screen[:, :, c])
        comp[300:2534, 400:3856] = comp_screen
        return Image.fromarray(comp)

    # 1. Merchant Admin Dashboard
    print("Compositing Merchant MacBook...")
    merchant_mock = compose_macbook('merchant.png')
    merchant_png_out = os.path.join(IMAGES_DIR, 'merchant-macbook.png')
    merchant_mock.save(merchant_png_out, format='PNG', optimize=True)
    print(f"Saved {merchant_png_out} ({os.path.getsize(merchant_png_out):,} bytes, size={merchant_mock.size})")

    merchant_webp_out = os.path.join(IMAGES_DIR, 'merchant-macbook.webp')
    merchant_webp = merchant_mock.resize((1600, 1065), Image.Resampling.LANCZOS)
    merchant_webp.save(merchant_webp_out, format='WEBP', quality=85, method=6)
    print(f"Saved {merchant_webp_out} ({os.path.getsize(merchant_webp_out):,} bytes, size={merchant_webp.size})")

    # 2. Terminal Counter POS
    print("Compositing Terminal MacBook...")
    terminal_mock = compose_macbook('terminal.png')
    terminal_png_out = os.path.join(IMAGES_DIR, 'terminal-macbook.png')
    terminal_png = terminal_mock.resize((2128, 1417), Image.Resampling.LANCZOS)
    terminal_png.save(terminal_png_out, format='PNG', optimize=True)
    print(f"Saved {terminal_png_out} ({os.path.getsize(terminal_png_out):,} bytes, size={terminal_png.size})")

    terminal_webp_out = os.path.join(IMAGES_DIR, 'terminal-macbook.webp')
    terminal_webp = terminal_mock.resize((1600, 1065), Image.Resampling.LANCZOS)
    terminal_webp.save(terminal_webp_out, format='WEBP', quality=85, method=6)
    print(f"Saved {terminal_webp_out} ({os.path.getsize(terminal_webp_out):,} bytes, size={terminal_webp.size})")

def main():
    build_customer_mockup()
    build_macbook_mockups()
    print("All mockups successfully generated and optimized!")

if __name__ == '__main__':
    main()

