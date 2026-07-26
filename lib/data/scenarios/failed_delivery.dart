import '../../models/scenario.dart';
import '../../models/chat_choice.dart';
import 'scenario_sources.dart';

const failedDelivery = Scenario(
  id: "delivery",
  title: "Failed Delivery",
  sender: "ParcelCo",
  category: "Smishing / delivery scam",
  sources: [ftcTopTextScams, fccSmishing],
  steps: [
    ChatStep(
      id: "start",
      botMessages: [
        "ParcelCo: we tried to deliver your parcel (#PC839210) today, but "
        "nobody was home.",
        "It's being held at our depot.",
      ],
      choices: [
        ChatChoice(
          text: "I'm not expecting any parcel.",
          safePoints: 2,
          feedback:
              "Good. The hook works because almost everyone is expecting "
              "*something* knowing you aren't is your advantage.",
          nextStepId: "held",
        ),
        ChatChoice(
          text: "Oh, how do I get it?",
          riskPoints: 1,
          feedback:
              "Eagerness is the bait. Nothing in this message has been "
              "verified yet, including that there is a parcel.",
          nextStepId: "held",
        ),
        ChatChoice(
          text: "Which parcel, and from which sender?",
          safePoints: 1,
          feedback:
              "Fair question but never trust their answer. Check the tracking "
              "number with the courier yourself.",
          nextStepId: "held",
        ),
      ],
    ),
    ChatStep(
      id: "held",
      botMessages: [
        "It's a gift parcel the sender asked to stay anonymous.",
        "Our driver left a card. To book redelivery there's a €1.99 handling "
        "fee.",
        "Once that's paid it goes out tomorrow morning.",
      ],
      choices: [
        ChatChoice(
          text: "I'll check the courier's official app instead.",
          safePoints: 3,
          feedback:
              "Right move!! track it in the official app or on the site you "
              "typed yourself. Notice they keep messaging anyway.",
          nextStepId: "fee",
        ),
        ChatChoice(
          text: "€1.99 is nothing, I'll just pay it.",
          riskPoints: 2,
          feedback:
              "The tiny fee is the whole trick: small enough that you don't "
              "stop to think, and it was never about the €1.99 it's about "
              "your card details.",
          nextStepId: "fee",
        ),
        ChatChoice(
          text: "Why would a gift have a fee I owe?",
          safePoints: 1,
          feedback:
              "Good, the story doesn't hold together. Poke at the details "
              "and scam pretexts fall apart quickly.",
          nextStepId: "fee",
        ),
      ],
    ),
    ChatStep(
      id: "fee",
      botMessages: [
        "It's standard customs handling, it's on the parcel record.",
        "Pay and schedule redelivery here:",
        "parcelco-redeliver.link/PC839210",
      ],
      choices: [
        ChatChoice(
          text: "Opening the link to pay.",
          riskPoints: 3,
          feedback:
              "That page is a copy of a real payment form. Everything you "
              "type into it goes straight to the scammer.",
          nextStepId: "card_taken",
        ),
        ChatChoice(
          text: "I never pay through a link sent by text.",
          safePoints: 3,
          feedback:
              "Exactly. An unrequested link is a red flag by itself if you "
              "think it might be real, go to the site independently.",
          nextStepId: "pressure",
        ),
        ChatChoice(
          text: "That's not a ParcelCo web address.",
          safePoints: 2,
          feedback:
              "Sharp eye. Read the actual domain, not the brand name in "
              "front of it lookalike domains are the entire trick.",
          nextStepId: "pressure",
        ),
      ],
    ),
    ChatStep(
      id: "pressure",
      botMessages: [
        "FINAL NOTICE: unpaid parcels are returned and destroyed within 2 hours.",
        "This is your last chance to release it.",

      ],
      choices: [
        ChatChoice(
          text: "Fine, I'll pay just to be safe.",
          riskPoints: 3,
          feedback:
              "Manufactured deadlines exist to stop you checking. There was "
              "never a parcel to lose in the first place.",
          nextStepId: "card_taken",
        ),
        ChatChoice(
          text: "Fake urgency. I'm reporting this and deleting it.",
          safePoints: 3,
          feedback:
              "You saw the pressure play for what it was. Reporting the "
              "number helps get it shut down.",
          nextStepId: "last_ask",
        ),
        ChatChoice(
          text: "Nothing of mine is at your depot. Prove it.",
          safePoints: 2,
          feedback:
              "Making them prove the claim breaks the script, there is no "
              "parcel record to show you.",
          nextStepId: "last_ask",
        ),
      ],
    ),
    ChatStep(
      id: "card_taken",
      botMessages: [
        "Payment received : thank you!",
        "(There was no parcel. Your card number, expiry date and CVV are now "
            "theirs.)",
        "Ah, your bank has held the payment. Send us the 6 digit code they "
            "just texted you and we'll release it.",
      ],
      choices: [
        ChatChoice(
          text: "Here it is: 771204.",
          riskPoints: 3,
          feedback:
              "Your bank's code is the last barrier standing. Handing it "
              "over authorises exactly the payments it was blocking.",
          nextStepId: "last_ask",
        ),
        ChatChoice(
          text: "No. I'm calling my bank to freeze the card right now.",
          safePoints: 3,
          feedback:
              "Correct recovery: freeze the card and report the fraud "
              "immediately. Speed is what limits the damage.",
          nextStepId: "last_ask",
        ),
        ChatChoice(
          text: "Why would a courier need a code from my bank?",
          safePoints: 2,
          feedback:
              "Good question, no merchant or courier ever needs a code your "
              "bank sent to you.",
          nextStepId: "last_ask",
        ),
      ],
    ),
    ChatStep(
      id: "last_ask",
      botMessages: [
        "Alright. We'll arrange the return instead.",
        "Just confirm your full name, address and date of birth for the "
            "paperwork.",
      ],
      choices: [
        ChatChoice(
          text: "Sure, here you go.",
          riskPoints: 3,
          feedback:
              "That's the groundwork for identity theft. Name, address and "
              "date of birth together are enough to open accounts in your name.",
          nextStepId: "hacked",
        ),
        ChatChoice(
          text: "You claim to have my address already so you don't need it.",
          safePoints: 3,
          feedback:
              "Caught the contradiction. Their story only works as long as "
              "nobody examines it.",
          nextStepId: "safe_end",
        ),
        ChatChoice(
          text: "I'm blocking this number.",
          safePoints: 2,
          feedback:
              "Ending the conversation is always available, and it is always "
              "a safe move.",
          nextStepId: "safe_end",
        ),
      ],
    ),
    ChatStep(
      id: "hacked",
      botMessages: [
        "All done, thanks for your cooperation.",
        "(No parcel ever existed. What you gave away is worth far more than €1.99.)",
        "(;-;)",
      ],
    ),
    ChatStep(
      id: "safe_end",
      botMessages: [
        "(You checked the official app. There was no parcel, and the link was "
            "never opened.)",
        "They got nothing from you. Check your report to see how each reply "
            "scored.",
      ],
    ),
  ],
);
