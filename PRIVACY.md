# Privacy implementation notes

This is a draft for product-owner review, not a published legal policy.

Settings, selected packages, per-day aggregate usage, reading seconds, completed adhkar and reflection notes are stored locally using Android preferences and Flutter SharedPreferences. These stores are not an encrypted vault. OS/device backups may include them. Uninstalling or clearing app data removes local records subject to OS backup/restore behavior.

The Android service reads UsageEvents to infer selected-app foreground time. The code sends no usage history or notes to a backend. It displays a persistent notification while active and includes a Stop action. Revoking permissions or force-stopping disables monitoring.

Audio playback contacts the Islamic Network CDN, which receives ordinary network metadata such as IP address and the requested verse. Offline Quran text and local history do not need network access. A streak summary is copied only after the user taps Copy, and the user chooses where to send it.

No account backend, automatic partner sharing or analytics is added. Review dependency and platform behavior before distributing; the owner must supply a support contact and final privacy disclosures.
