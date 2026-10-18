# Unified colour themes

The Settings menu now offers 12 complete themes: Beige (default), Sage, Ocean, Sunset, Lavender, Forest and dark versions of each. There are no separate Light/Dark/System controls. Choosing a theme updates the MaterialApp theme brightness and accent together.

The selected theme is persisted as `selected_theme` using SharedPreferences. Older `color_palette` and `theme_mode` preferences are migrated on first load; a new user starts with Beige.

Route planner, assessment handling, Firebase security rules and infographic logic have not been changed by this patch.

Some page-specific artwork and hardcoded colours may remain; test contrast and consistency across every screen. Flutter SDK was not available in the editing environment, so run Flutter web build on GitHub Actions/Vercel before merging.
