# Scammie

**A social-engineering simulator that lets you get scammed safely, so you don't get scammed for real.**

Scammie drops you into a realistic chat with a scammer : fake IT support, a fake delivery
company, a fake Telegram recruiter and lets you reply. Every reply is scored. At the end
you get a **Risk Report** with a score, a risk level, and an explanation of what
each of your answers actually did. You can export that report as a PDF and send it to anyone.

Nothing in the app is real. No messages are sent anywhere, and no personal data is collected.

---

## Download

**[Download the APK](https://drive.google.com/file/d/1waUWqnDvxnqJHrYmV8q4xmVJAjw6pKd6/view?usp=sharing)** (Android)

### Installing it

1. Open the link on your Android phone and tap **Download**.
2. Open the downloaded `scammie.apk` from your notifications or the Files app.
3. Android will warn you that this app is from an unknown source that is expected for any
   app not installed from the Play Store. Tap **Settings** then **Allow from this source**, then go
   back and tap **Install**.
4. Play Protect may show a second "unsafe app" warning. Tap **Install anyway**.

The app needs an internet connection so you can create an account. After that
the scam conversations themselves work offline only saving your results needs the network,
and those get queued and uploaded when you reconnect.

> iPhone is not supported. Building an iOS version requires a Mac with Xcode and a paid Apple
> developer account to install on real devices.

---

## Features

### Accounts
Sign up with a username, email and password. Your results follow your account, so you can sign
in on another phone and your history is still there.

### 3 scam scenarios
| Scenario | Who's texting you | The scam |
|---|---|---|
| **Message with IT** | "IT Security team" | Phishing for your one time password |
| **Failed Delivery** | "ParcelCo" | Fake redelivery fee to steal your card |
| **Telegram Scam** | "Remote Jobs HR" | Fake job that asks you to deposit money first |

Each one is a real branching conversation 8 steps deep, with different endings depending on
what you reply. Giving away the OTP takes you to a "you got hacked" ending; refusing sends the
scammer into a pressure tactic instead.

Every scenario is based on documented scam patterns from the FTC, CISA and the FCC. The
sources are listed in app behind the ⓘ button.

### Two difficulties
- **Easy** : a small shield icon marks the safe replies, and risky answers are scored normally.
- **Hard** : no icons, and risky answers count 1.5× against you.

### Risk Report
After every run you get:
- a **score out of 100** with a colour coded ring,
- a **risk level**  LOW (80+), MEDIUM (50–79) or HIGH (below 50),
- **"What to remember"** : every reply you gave, marked safe or risky, with the reason,
- counts of your safe vs risky actions.

### Export the report as a PDF
The **Export Report** button builds a real PDF on your phone and opens the Android share sheet,
so you can send it through Telegram, Gmail, Drive like anywhere you want . The PDF contains your
score, your risk level, the lessons from your mistakes, and its feedback. Long runs flow onto extra pages instead of getting cut off.

### History
Your runs are grouped by scenario, so you can see whether you're actually improving. Each card
shows your latest score, how many attempts you've made, and your best. Tap a scenario to see
every attempt, and tap an attempt to reopen its full report. Pull down to refresh.

### Profile
Shows your username, email, best score, which scenario you got that best score on, and how
many scenarios you've completed. You can change your username and log out from here.

---

## How to use it

1. **Open the app.** You'll get a 3 page intro carousel the first time.
2. **Create an account**: username, email, password. (If you already have one, tap
   **Sign In** instead.)
3. **Pick a scenario** from the home tab.
4. **Pick a difficulty** and tap **Start Game**. Start with easy the shield icons teach you
   what a safe answer looks like.
5. **Play the conversation.** The scammer's messages appear on the left. Your options are the
   **QUICK REPLIES** at the bottom, tap one to send it. Tap the ⓘ in the top right at any
   point to see the real scams this one is based on.
6. **Finish.** When the conversation reaches an ending, tap **Continue** to see your report.
7. **Read the report**: the "What to remember" section is the actual point of the app, not
   the score.
8. **Tap Export Report** to save it as a PDF and share it.
9. **Play again** and check the **History** tab to see if you improved.

### The bottom bar
| Icon | Tab |
|---|---|
| Clock (left) | History |
| Home (middle) | Scenarios / home |
| Person (right) | Profile |

---

## How the score works

```
score = 100 × safe points ÷ (safe points + risky points)
```

On Hard, risky points are multiplied by 1.5 before that division, so the same mistakes hurt
more. A run where you never picked anything risky scores 100.

| Score | Risk level |
|---|---|
| 80–100 | LOW |
| 50–79 | MEDIUM |
| 0–49 | HIGH |

---

## For developers

### Running it

```bash
flutter pub get
flutter run
```

Requires the Flutter SDK and an Android device or emulator. Firebase is already configured via
`lib/firebase_options.dart` and `android/app/google-services.json`.

To build a shareable APK:

```bash
flutter build apk --release
# output: build/app/outputs/flutter-apk/app-release.apk
```

### Project structure

```
lib/
├── main.dart            # Firebase init + auth gate
├── models/              # UserProfile, Scenario, ChatStep, ChatChoice,
│                        # GameResult, ActionLog, GameHistory, RiskLevel
├── data/
│   ├── scenarios/                # one file per scam conversation
│   ├── repositories/             # auth, results, 
|   |                             # scenarios: the only Firebase callers
│   └── report_exporter.dart      # PDF generation + share sheet
├── logic/
│   └── game_controller.dart      # scoring, branching, action log
└── ui/
    ├── screens/                  # welcome, login, sign up, dashboard,
    │                             # chat, risk report, history, 
    |                             # difficulty, profile, edit profile
    ├── widgets/                  # app shell, chat bubble, 
    |                             # quick reply, form fields
    └── theme/
```

Screens never touch `FirebaseAuth` or `FirebaseFirestore` directly! they go through the
repositories in `data/repositories/`.

### Data

**Local:** all scam content lives in `lib/data/scenarios/`. Adding a new scam means adding one
file and registering it, no changes to any game logic.

**Cloud (Firestore):**
```
users/{uid}                     username, email, bestScore, bestGame,
                                gamesPlayed, scenariosPlayed
users/{uid}/results/{autoId}    one document per finished run, including 
                                the full action log so History can reopen 
                                the exact report
```

`bestScore` and `gamesPlayed` are updated in a Firestore transaction after each run, so two
devices finishing a game at the same time can't clobber each other.


---

## Known limitations

- **Android only** : no iOS build.
- **Email sign in only.** The "Sign in with Google" button on the login screen is a
  placeholder and does nothing.
- **Username changes only** in edit profile. Changing email or password requires Firebase
  re-authentication and is not implemented, those fields are visibly disabled.
- **No delete** in History. `ResultRepository.deleteResult` exists but no screen calls it yet.
- Scripted scenarios can't cover every scam. Scammie teaches the common patterns, the
  urgency, the fake authority, the small first payment, not an exhaustive list.

---

*Built with Flutter and Firebase for Y2-T3 Mobile Development.*
