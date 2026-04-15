v2.0.3

- Cleaned up workflow: removed non-functional Discord notification stubs
- Workflow now focuses solely on packaging and release via BigWigs packager

v2.0.2

- Fixed GitHub Actions workflow `if` conditionals to use canonical expression syntax
- Removed redundant `${{ }}` wrappers from conditional steps

v2.0.1

- Fixed README and CurseForge description formatting to match the fuller RGX addon presentation
- Corrected the branded `Up!` title styling in MW2 docs

v2.0.0

- Renamed addon files and package metadata from `MW2LU` to `ModernWarfare2LevelUp`
- Reworked the addon to follow the same `SRLU` and `FFLU` structure with `data/core.lua` and `data/locales.lua`
- Added MW2LU slash commands, saved variables, login message toggle, and updated branding
- Renamed the bundled sound file set to `modern_warfare_2_high.ogg`, `modern_warfare_2_med.ogg`, and `modern_warfare_2_low.ogg`
