# Animated research UI patch

Based on the previous visual-accessibility interactive-home ZIP.

- Homepage study infographic emojis now gently float, tilt and pulse continuously.
- Home infographic cards use richer theme-aware gradients and selected-state shadows.
- Experience of Place six choices use animated emoji icons, colourful gradients,
  selection borders and theme-aware labels.
- Spend More Time choices use animated emoji icons and matching theme-aware gradients.
- Questionnaire heading, supporting text and progress accent adapt to dark themes.
- Animation respects system reduced-motion (`MediaQuery.disableAnimations`).
- No changes to question keys, choice values, saving logic, Firebase rules,
  Google Maps, route planner, or researcher dashboard.

IMPORTANT: Local Flutter SDK not available; build not verified. Deploy to a
feature branch and test on Vercel Preview before merging into main.
Check desktop and mobile, dark/light themes, 6 multi-select choices, YES/MAYBE/NO,
navigation, and reduced-motion setting.
