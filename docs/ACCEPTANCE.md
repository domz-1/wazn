# Required acceptance checks

This is a review branch. Do not merge or distribute on the strength of Dart tests alone.

Automated checks: fresh history, duplicate reading claims, daily rollover, missed-day streaks, once-daily allowances, persisted notes and rewards, complete Quran verse counts, basic widget build.

Manual Android checks, still required:
- Build the APK against the actual Android SDK and test on Android 10, 13 and 14+ plus an OEM with aggressive battery management.
- Grant/revoke Usage Access and overlay permission. Confirm the status updates and the overlay never traps the user.
- Use two selected apps and confirm one shared budget decreases only during selected foreground usage, not screen-off time.
- Exhaust credit, verify an actual overlay, return Home, open Wazn and earn credit. Confirm unblock within two seconds and that Settings/dialer are never blocked.
- Use emergency/snooze once, restart process, cross midnight, and check one-per-day enforcement.
- Stop using the persistent notification. Confirm it stays stopped until explicitly restarted in Wazn.
- Kill process, reopen, reboot and reopen. Check usage reconciliation and clearly communicate that reboot requires reopening Wazn.
- Test multi-window, picture-in-picture, rapid switching, timezone/date changes and OEM battery killing. These cases are not certified.
- Check Quran text against an independent authoritative Mushaf, including basmala, diacritics and verse numbering. Package licensing is not religious-text certification.
- Test recitation, failures, network-off operation and app interruption. Playback is not a substitute for religious-content review.
- Check all screens at small/large text sizes and full surahs, not only splash.

Remaining product scope: full tafsir, reviewed complete adhkar/hadith, voice notes, remote partner sharing, reminders, rest-day rules and iOS blocking. No production readiness claim is made.
