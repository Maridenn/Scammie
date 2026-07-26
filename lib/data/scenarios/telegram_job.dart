import '../../models/scenario.dart';
import '../../models/chat_choice.dart';
import 'scenario_sources.dart';

const telegramJob = Scenario(
  id: "job",
  title: "Telegram Scam",
  sender: "Remote Jobs HR",
  category: "Job / task scam",
  sources: [ftcTopTextScams, cisaSocialEngineering],
  steps: [
    ChatStep(
      id: "start",
      botMessages: [
        "Hi! I'm Amy from Remote Jobs HR. We saw your profile and think you'd "
        "be perfect for flexible online work.",
        "\$200–\$400 a day, work from home, no experience needed.",
        "Interested?",
      ],
      choices: [
        ChatChoice(
          text: "Sounds great!! tell me more!",
          riskPoints: 1,
          feedback:
              "Pay far above the work is the lure. Curiosity costs nothing, "
              "but it is how every one of these starts.",
          nextStepId: "tasks",
        ),
        ChatChoice(
          text: "How did you get my number?",
          safePoints: 2,
          feedback:
              "Good, a recruiter who can't say where they found you isn't a "
              "recruiter.",
          nextStepId: "tasks",
        ),
        ChatChoice(
          text: "That's far too much money for unskilled work.",
          safePoints: 2,
          feedback:
              "Right instinct. Compare the offer to reality: nobody pays "
              "\$300 a day for liking videos.",
          nextStepId: "tasks",
        ),
      ],
    ),
    ChatStep(
      id: "tasks",
      botMessages: [
        "It's simple. you complete small tasks. Liking videos, leaving app "
        "reviews, that sort of thing.",
        "Here's your dashboard. See? You've already earned \$38 today.",
        "Payouts are daily once the account is active.",
      ],
      choices: [
        ChatChoice(
          text: "Nice!!! how do I start?",
          riskPoints: 1,
          feedback:
              "That dashboard is just a web page they control. Fake earnings "
              "exist to make the next request feel reasonable.",
          nextStepId: "deposit",
        ),
        ChatChoice(
          text: "Who is the actual employer? Is there a contract?",
          safePoints: 2,
          feedback:
              "Real jobs have a named employer, a written contract and "
              "payslips. Task scams have none of the three.",
          nextStepId: "deposit",
        ),
        ChatChoice(
          text: "Real work doesn't pay people to like videos.",
          safePoints: 3,
          feedback:
              "Exactly. If the 'work' produces nothing of value, the money "
              "isn't coming from work it's coming from someone like you.",
          nextStepId: "deposit",
        ),
      ],
    ),
    ChatStep(
      id: "deposit",
      botMessages: [
        "You're nearly set, withdrawals unlock once the account is activated.",
        "Activation is a refundable \$30. It comes straight back with your "
        "first payout.",
      ],
      choices: [
        ChatChoice(
          text: "Okay, sending the \$30.",
          riskPoints: 3,
          feedback:
              "Never pay to get a job. Refundable is how they get the "
              "money moving in the wrong direction.",
          nextStepId: "paid",
        ),
        ChatChoice(
          text: "No legitimate job asks me to pay upfront.",
          safePoints: 3,
          feedback:
              "Right, and treat it as an absolute rule: employers pay you, "
              "never the other way round.",
          nextStepId: "pressure",
        ),
        ChatChoice(
          text: "Why do I have to pay in order to get paid?",
          safePoints: 1,
          feedback:
              "Good question and there is never a straight answer to it, "
              "only more pressure.",
          nextStepId: "pressure",
        ),
      ],
    ),
    ChatStep(
      id: "pressure",
      botMessages: [
        "Everyone starts this way and gets it back on the first withdrawal.",

        "We only have 3 spots left today. I'd hate for you to miss out.",
      ],
      choices: [
        ChatChoice(
          text: "Fine, I'll pay to secure my spot.",
          riskPoints: 3,
          feedback:
              "False scarcity on top of a pay-to-work fee. The refund never "
              "arrives, because there was never a job.",
          nextStepId: "paid",
        ),
        ChatChoice(
          text: "Pressure tactics don't work on me. Blocking you.",
          safePoints: 3,
          feedback:
              "You didn't fall for the invented deadline. Walking away from "
              "an offer costs you nothing.",
          nextStepId: "last_ask",
        ),
        ChatChoice(
          text: "Send me the company's registration number.",
          safePoints: 2,
          feedback:
              "Asking for something checkable is powerful. A scammer can't "
              "produce a record you can look up.",
          nextStepId: "last_ask",
        ),
      ],
    ),
    ChatStep(
      id: "paid",
      botMessages: [
        "Payment received. welcome to the team!!! (/0 u 0/)",
        "(That \$30 is gone.)",
        "Your balance shows \$412. Withdrawals over \$400 need the VIP tier — "
            "that's just \$150 more.",
      ],
      choices: [
        ChatChoice(
          text: "Okay, I'll pay the \$150 to get my money out.",
          riskPoints: 3,
          feedback:
              "This is the entire business model: each 'unlock' is bigger "
              "than the last, and the balance can never be withdrawn.",
          nextStepId: "last_ask",
        ),
        ChatChoice(
          text: "No. I'm stopping here and reporting the account.",
          safePoints: 3,
          feedback:
              "The right call after a slip, stop paying immediately. From "
              "this point the losses only grow.",
          nextStepId: "last_ask",
        ),
        ChatChoice(
          text: "So the money I 'earned' isn't actually mine?",
          safePoints: 2,
          feedback:
              "Exactly the question that breaks the illusion. That balance "
              "is just numbers on a page they own.",
          nextStepId: "last_ask",
        ),
      ],
    ),
    ChatStep(
      id: "last_ask",
      botMessages: [
        "Let's just get you registered properly then.",
        "Send a photo of your ID and your bank details for payroll.",
      ],
      choices: [
        ChatChoice(
          text: "Sure, here's my ID.",
          riskPoints: 3,
          feedback:
              "An ID photo plus bank details is enough for identity fraud in "
              "your name. Never send them to an employer you can't verify.",
          nextStepId: "hacked",
        ),
        ChatChoice(
          text: "I don't send ID or bank details to someone I can't verify.",
          safePoints: 3,
          feedback:
              "Right. Payroll details come after a signed contract with a "
              "company you have independently checked out.",
          nextStepId: "safe_end",
        ),
        ChatChoice(
          text: "I'm done here.",
          safePoints: 2,
          feedback:
              "Leaving is an option at any point in the conversation, and it "
              "never gets harder by waiting.",
          nextStepId: "safe_end",
        ),
      ],
    ),
    ChatStep(
      id: "hacked",
      botMessages: [
        "Great!! processing your account now.",
        "(There was no job. The money is gone, and your documents are in a "
            "fraudster's hands.)",
      ],
    ),
    ChatStep(
      id: "safe_end",
      botMessages: [
        "(You stopped replying. 'Amy' moved on to the next number.)",
        "Nothing paid, nothing shared. Check your report to see how each reply scored.",
      ],
    ),
  ],
);
