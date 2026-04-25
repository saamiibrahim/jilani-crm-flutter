---
name: Jillani Executive CRM
colors:
  surface: '#121414'
  surface-dim: '#121414'
  surface-bright: '#37393a'
  surface-container-lowest: '#0c0f0f'
  surface-container-low: '#1a1c1c'
  surface-container: '#1e2020'
  surface-container-high: '#282a2b'
  surface-container-highest: '#333535'
  on-surface: '#e2e2e2'
  on-surface-variant: '#d2c5b3'
  inverse-surface: '#e2e2e2'
  inverse-on-surface: '#2f3131'
  outline: '#9b8f7f'
  outline-variant: '#4e4538'
  surface-tint: '#eebf6f'
  primary: '#ffd796'
  on-primary: '#422c00'
  primary-container: '#e8ba6a'
  on-primary-container: '#694900'
  inverse-primary: '#7b5810'
  secondary: '#c8c6c5'
  on-secondary: '#303030'
  secondary-container: '#474746'
  on-secondary-container: '#b7b5b4'
  tertiary: '#dfdcdb'
  on-tertiary: '#313030'
  tertiary-container: '#c3c0c0'
  on-tertiary-container: '#4f4e4e'
  error: '#ffb4ab'
  on-error: '#690005'
  error-container: '#93000a'
  on-error-container: '#ffdad6'
  primary-fixed: '#ffdeaa'
  primary-fixed-dim: '#eebf6f'
  on-primary-fixed: '#271900'
  on-primary-fixed-variant: '#5f4100'
  secondary-fixed: '#e4e2e1'
  secondary-fixed-dim: '#c8c6c5'
  on-secondary-fixed: '#1b1c1c'
  on-secondary-fixed-variant: '#474746'
  tertiary-fixed: '#e5e2e1'
  tertiary-fixed-dim: '#c8c6c5'
  on-tertiary-fixed: '#1c1b1b'
  on-tertiary-fixed-variant: '#474746'
  background: '#121414'
  on-background: '#e2e2e2'
  surface-variant: '#333535'
typography:
  headline-xl:
    fontFamily: manrope
    fontSize: 32px
    fontWeight: '700'
    lineHeight: 40px
    letterSpacing: -0.02em
  headline-lg:
    fontFamily: manrope
    fontSize: 24px
    fontWeight: '600'
    lineHeight: 32px
    letterSpacing: -0.01em
  headline-md:
    fontFamily: manrope
    fontSize: 20px
    fontWeight: '600'
    lineHeight: 28px
  body-lg:
    fontFamily: inter
    fontSize: 18px
    fontWeight: '400'
    lineHeight: 28px
  body-md:
    fontFamily: inter
    fontSize: 16px
    fontWeight: '400'
    lineHeight: 24px
  body-sm:
    fontFamily: inter
    fontSize: 14px
    fontWeight: '400'
    lineHeight: 20px
  label-lg:
    fontFamily: inter
    fontSize: 14px
    fontWeight: '600'
    lineHeight: 16px
    letterSpacing: 0.05em
  label-md:
    fontFamily: inter
    fontSize: 12px
    fontWeight: '500'
    lineHeight: 16px
    letterSpacing: 0.02em
  label-sm:
    fontFamily: inter
    fontSize: 10px
    fontWeight: '700'
    lineHeight: 12px
rounded:
  sm: 0.125rem
  DEFAULT: 0.25rem
  md: 0.375rem
  lg: 0.5rem
  xl: 0.75rem
  full: 9999px
spacing:
  base: 4px
  xs: 8px
  sm: 12px
  md: 16px
  lg: 24px
  xl: 32px
  margin-mobile: 20px
  gutter: 16px
---

## Brand & Style

The brand personality is anchored in **prestige, efficiency, and unwavering professionalism**. Targeted at high-performing real estate agents, the interface must facilitate rapid lead management while maintaining an aesthetic of exclusivity and trust.

The chosen design style is **Corporate Minimalism with a Luxury Edge**. This approach utilizes a high-contrast dark theme to allow the brand’s signature gold accents to command attention. The UI avoids unnecessary decorative elements, focusing instead on structural clarity and refined details that mirror the experience of a high-end concierge service. The emotional response is one of "command and control"—giving agents the confidence that their data is secure and their workflow is optimized.

## Colors

The palette is derived directly from the brand’s digital presence, optimized for a high-end mobile experience. We utilize a **Dark-First approach** to evoke a sense of luxury and to reduce eye strain during long periods of lead management.

- **Primary (#E8BA6A):** A sophisticated gold used exclusively for primary actions, active states, and critical highlights. It represents the "premium" nature of the properties managed.
- **Secondary (#262626):** Used for surface-level containers, cards, and input backgrounds to create subtle separation from the base background.
- **Tertiary (#1A1A1A):** The foundation color for the application background, providing a deep, immersive canvas.
- **Neutral (#FFFFFF):** Reserved for high-readability typography and iconography, ensuring maximum contrast against the dark surfaces.

## Typography

The typography strategy balances editorial elegance with functional utility. 

**Manrope** is used for all headlines. Its refined, geometric construction mirrors the modern architectural lines found in Jillani Properties' listings. It provides a contemporary, high-end feel that differentiates the app from standard utility tools.

**Inter** is utilized for all body copy and labels. Its neutral, systematic nature ensures that complex CRM data (names, phone numbers, property details) remains exceptionally legible at various sizes and light conditions. Letter spacing is slightly increased on labels and small text to maintain clarity against dark backgrounds.

## Elevation & Depth

To maintain the sophisticated aesthetic, the design system avoids heavy, traditional shadows. Depth is communicated through **Tonal Layering** and **Low-Contrast Outlines**.

- **Level 0 (Base):** Background color #1A1A1A.
- **Level 1 (Cards/Inputs):** Surface color #262626.
- **Level 2 (Modals/Overlays):** Surface color #333333 with a subtle 1px border in #E8BA6A at 15% opacity.

Instead of shadows, a "glow" effect may be used for primary call-to-action buttons, using a highly diffused #E8BA6A shadow (0px 4px 20px) at very low opacity (10-15%) to make the element feel as if it is emitting light rather than casting a shadow.
