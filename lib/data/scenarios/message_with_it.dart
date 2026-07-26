import '../../models/scenario.dart';
import '../../models/chat_choice.dart';
import 'scenario_sources.dart';

const messageWithIt = Scenario(
  id: "it_otp",
  title: "Message with IT",
  sender: "IT Security team",
  category: "Phishing / OTP theft",
  sources: [ftcTopTextScams, cisaSocialEngineering],
  steps: [
    ChatStep(
      id: "start",
      botMessages: [
        "Hello, this is the IT security team at your university.",
        "We've flagged unusual sign in attempts on your student account overnight.",
      ],
      choices: [
        ChatChoice(
          text: "What kind of unusual sign ins?",
          safePoints: 1,
          feedback:
              "Asking for detail is reasonable, but it also keeps you talking. "
              "Work out who is really contacting you before you engage with "
              "their story.",
          nextStepId: "detail",
        ),
        ChatChoice(
          text: "How do I know you're really from IT?",
          safePoints: 2,
          feedback:
              "Strong instinct challenge identity first. Watch what they "
              "offer as proof: it is usually information anyone could find.",
          nextStepId: "detail",
        ),
        ChatChoice(
          text: "Oh no, what do I need to do?",
          riskPoints: 1,
          feedback:
              "Panic is the goal. An unexpected security warning is a reason "
              "to slow down, not to speed up.",
          nextStepId: "detail",
        ),
      ],
    ),
    ChatStep(
      id: "detail",
      botMessages: [
        "Your student ID and course are right here on file, so you can see this "
            "is genuine.",
        "A login from another country was blocked at 03:12. They will almost "
            "certainly try again within the hour.",
        "I can lock it down from my side, but I need to confirm it's really you.",
      ],
      choices: [
        ChatChoice(
          text: "I'll sign in to the university portal myself and check.",
          safePoints: 3,
          feedback:
              "Perfect!! go to the service directly, through an address you "
              "typed yourself. Notice they keep pushing anyway: a scammer "
              "rarely stops at the first refusal.",
          nextStepId: "ask_code",
        ),
        ChatChoice(
          text: "Okay, how do we confirm it?",
          riskPoints: 1,
          feedback:
              "Letting them lead hands over control of the conversation. "
              "Real IT tells you what they are doing; they don't walk you "
              "through steps.",
          nextStepId: "ask_code",
        ),
        ChatChoice(
          text: "Anyone could look up my student ID. Prove it another way.",
          safePoints: 2,
          feedback:
              "Right! they knew my details: proves nothing. Student IDs, "
              "addresses and course names leak in breaches all the time.",
          nextStepId: "ask_code",
        ),
      ],
    ),
    ChatStep(
      id: "ask_code",
      botMessages: [
        "Our system has just sent a 6 digit verification code to your phone.",
        "Read it back to me and I'll close the ticket right now.",
      ],
      choices: [
        ChatChoice(
          text: "Sure, it's 482917.",
          riskPoints: 3,
          feedback:
              "Never read out a one-time code. That code IS the key saying "
              "it out loud signs the attacker straight into your account.",
          nextStepId: "breach",
        ),
        ChatChoice(
          text: "I never share one time codes with anyone.",
          safePoints: 3,
          feedback:
              "Exactly right. A code is for you to type into an app you "
              "opened yourself, never to be told to a person.",
          nextStepId: "pressure",
        ),
        ChatChoice(
          text: "Why would IT need a code that was sent to me?",
          safePoints: 2,
          feedback:
              "Good challenge. No genuine agent ever needs your one time "

              "code being asked for one is proof on its own.",
          nextStepId: "pressure",
        ),
      ],
    ),
    ChatStep(
      id: "pressure",
      botMessages: [
        "There's no time to argue the account locks in 5 minutes and you'll "
            "lose your coursework.",
        "I'm trying to help you here. Just read me the code.",
      ],
      choices: [
        ChatChoice(
          text: "Okay okay, its 482917!",
          riskPoints: 3,
          feedback:
              "Urgency plus a frightening loss is the oldest lever there is, "
              "and it worked. Any real deadline survives you hanging up and "
              "calling back.",
          nextStepId: "breach",
        ),
        ChatChoice(
          text: "Deadlines like that are a scam tactic. No.",
          safePoints: 3,
          feedback:
              "You held firm. Manufactured time pressure exists for one "
              "reason: to stop you checking.",
          nextStepId: "last_ask",
        ),
        ChatChoice(
          text: "I'll call the IT desk on the number from the website.",
          safePoints: 3,
          feedback:
              "The best move available!!! verify through a channel you chose, "
              "never the one that contacted you.",
          nextStepId: "last_ask",
        ),
      ],
    ),
    ChatStep(
      id: "breach",
      botMessages: [
        "Got it! securing the account now ...",
        "(That code just let someone else sign in as you.)",
        "While I have you: billing flagged the card on your account. Confirm "
            "the long number and I'll clear that too.",
      ],
      choices: [
        ChatChoice(
          text: "Sure, it's 4539 8821 ....",
          riskPoints: 3,
          feedback:
              "Once you comply once, the asks escalate immediately. The "
              "second request is always bigger than the first.",
          nextStepId: "last_ask",
        ),
        ChatChoice(
          text: "No. I'm changing my password and calling IT myself.",
          safePoints: 3,
          feedback:
              "The right recovery after a slip: change the password, sign "
              "out other sessions, and report it to the real IT desk fast.",
          nextStepId: "last_ask",
        ),
        ChatChoice(
          text: "Wait! why does IT need my card number?",
          safePoints: 2,
          feedback:
              "Good catch. IT never handles card numbers. One question in "
              "the wrong place and the whole pretext falls apart.",
          nextStepId: "last_ask",
        ),
      ],
    ),
    ChatStep(
      id: "last_ask",
      botMessages: [
        "Fine, no code needed then.",
        "Just open our secure reset portal and sign in there instead:",
        "uni.secure.reset.link/verify",
      ],
      choices: [
        ChatChoice(
          text: "Opening it now.",
          riskPoints: 3,
          feedback:
              "The fallback ask. A portal link in a message you didn't "
              "request is a fake sign in page built to capture your password.",
          nextStepId: "hacked",
        ),
        ChatChoice(
          text: "I don't open links sent to me. I'll type the address myself.",
          safePoints: 3,
          feedback:
              "Right. Link text can say anything while pointing somewhere "
              "else. Type it yourself or use your own bookmark.",
          nextStepId: "safe_end",
        ),
        ChatChoice(
          text: "I'm reporting this number and blocking you.",
          safePoints: 3,
          feedback:
              "Reporting matters. it protects the next person who gets this "
              "message, not just you.",
          nextStepId: "safe_end",
        ),
      ],
    ),
    ChatStep(
      id: "hacked",
      botMessages: [
        "All sorted, have a good day!",
        "(Nothing was sorted. Your account is in someone else's hands.)",
      ],
    ),
    ChatStep(
      id: "safe_end",
      botMessages: [
        "...no reply. The IT agent has gone quiet.",

        "They got no further with you. Check your report to see how each reply scored.",
      ],
    ),
  ],
);
