import '../../models/scenario.dart';
import '../../models/chat_choice.dart';

const List<Scenario> defaultScenarios = [
  // --------------------------------------------
  // 1. IT support OTP scam 
  // --------------------------------------------
  Scenario(
    id: 'it_otp_scam',
    title: 'Message with IT',
    sender: 'IT',
    category: 'social_engineering',
    steps: [
      ChatStep(
        id: 'intro',
        botMessages: [
          'Hello !! I\'m from the IT Security team.',
          'We detected suspicious login activity on your student account from an unrecognised IP address in another country.',
          'To protect your account, please send me the OTP code we just sent to your phone so I can verify your identity and block the attacker.',
        ],
        choices: [
          ChatChoice(
            text: 'Sure, here is the code: 482917',
            riskPoints: 4,
            feedback:
                'Never share OTP codes. Real IT teams NEVER ask for them — the code is the key to your account.',
            nextStepId: 'after_shared',
          ),
          ChatChoice(
            text: 'Who are you exactly?',
            safePoints: 2,
            feedback:
                'Good instinct. Asking for identity slows social engineers down — but stay alert, they often have a fake answer ready.',
            nextStepId: 'fake_identity',
          ),
          ChatChoice(
            text: 'I never share OTP codes.',
            safePoints: 3,
            feedback:
                'Excellent. OTP codes are only for YOU to type into the official app or website, never to send to a person.',
            nextStepId: 'pressure',
          ),
        ],
      ),
      ChatStep(
        id: 'after_shared',
        botMessages: [
          'Thank you. Verifying now...',
          '(Your account was just accessed from an unknown device.)',
        ],
      ),
      ChatStep(
        id: 'fake_identity',
        botMessages: [
          'I am Kevin from Campus IT, employee ID 3382. This is urgent — the attacker is active RIGHT NOW. Send the code quickly!',
        ],
        choices: [
          ChatChoice(
            text: 'Okay okay, the code is 482917.',
            riskPoints: 4,
            feedback:
                'Urgency is the #1 pressure trick. Anyone rushing you to share a code is almost certainly a scammer.',
            nextStepId: 'after_shared',
          ),
          ChatChoice(
            text: 'I will contact official IT support myself.',
            safePoints: 4,
            feedback:
                'Perfect. Contacting the official channel yourself defeats impersonation completely.',
            nextStepId: 'ending_safe',
          ),
        ],
      ),
      ChatStep(
        id: 'pressure',
        botMessages: [
          'This is official procedure! If you refuse, your account will be suspended within 10 minutes.',
        ],
        choices: [
          ChatChoice(
            text: 'Fine, here is the code.',
            riskPoints: 4,
            feedback:
                'Threats of suspension are a classic bluff to make you panic. Real IT never threatens you into sharing codes.',
            nextStepId: 'after_shared',
          ),
          ChatChoice(
            text: 'Report and block this contact.',
            safePoints: 4,
            feedback:
                'The best possible move: refuse, report, block. You protected yourself AND others.',
            nextStepId: 'ending_safe',
          ),
        ],
      ),
      ChatStep(
        id: 'ending_safe',
        botMessages: ['(The contact stopped replying. Your account is safe.)'],
      ),
    ],
  ),
  // --------------------------------------------
  // 2. Delivery link scam (SMS phishing)
  // --------------------------------------------
  Scenario(
    id: 'delivery_scam',
    title: 'Package Delivery',
    sender: '+855 77 123 456',
    category: 'phishing',
    steps: [
      ChatStep(
        id: 'intro',
        botMessages: [
          'J&T Express: Your parcel could not be delivered due to an incomplete address.',
          'Update your address within 24h or the parcel will be returned: http://jt-express-kh.top/update',
        ],
        choices: [
          ChatChoice(
            text: 'Open the link and fill in my address.',
            riskPoints: 4,
            feedback:
                'The link is not the real company domain — ".top" links in SMS are a huge red flag. This page would steal your info.',
            nextStepId: 'fake_form',
          ),
          ChatChoice(
            text: 'Check the official app / call the company instead.',
            safePoints: 4,
            feedback:
                'Exactly right. Always verify deliveries through the official app or hotline, never SMS links.',
            nextStepId: 'ending_safe',
          ),
          ChatChoice(
            text: 'Ignore — I am not expecting any package.',
            safePoints: 3,
            feedback:
                'Good. If you are not expecting a parcel, delivery texts are almost always scams. Deleting is safe.',
            nextStepId: 'ending_safe',
          ),
        ],
      ),
      ChatStep(
        id: 'fake_form',
        botMessages: [
          'The page asks for your full name, address, and a \$1.50 "redelivery fee" by card.',
        ],
        choices: [
          ChatChoice(
            text: 'Pay the small fee, it\'s only \$1.50.',
            riskPoints: 4,
            feedback:
                'The fee is bait — the real prize is your card details. Scammers charge much more later or sell the card.',
          ),
          ChatChoice(
            text: 'Stop — this looks wrong. Close the page.',
            safePoints: 2,
            feedback:
                'Better late than never. Closing before entering card details saved you.',
            nextStepId: 'ending_safe',
          ),
        ],
      ),
      ChatStep(
        id: 'ending_safe',
        botMessages: ['(You avoided the delivery scam.)'],
      ),
    ],
  ),

  // --------------------------------------------
  // 3. Telegram job scam
  // --------------------------------------------
  Scenario(
    id: 'telegram_job_scam',
    title: 'Telegram Job Offer',
    sender: 'HR Sokha (Telegram)',
    category: 'social_engineering',
    steps: [
      ChatStep(
        id: 'intro',
        botMessages: [
          'Hello! I found your profile. Our company offers part-time online work — \$50–150/day just for liking videos and simple tasks. No experience needed!',
        ],
        choices: [
          ChatChoice(
            text: 'Wow, tell me more!',
            riskPoints: 2,
            feedback:
                '"Too good to be true" pay for trivial work is the opening of almost every task scam. Engaging marks you as a target.',
            nextStepId: 'deposit',
          ),
          ChatChoice(
            text: 'How did you get my contact?',
            safePoints: 2,
            feedback:
                'Smart question. Legit recruiters can explain exactly where they found you; scammers dodge it.',
            nextStepId: 'deposit',
          ),
          ChatChoice(
            text: 'Block and report.',
            safePoints: 4,
            feedback:
                'Correct. Unsolicited "easy money" offers on Telegram are a top scam category in Cambodia. Block and move on.',
            nextStepId: 'ending_safe',
          ),
        ],
      ),
      ChatStep(
        id: 'deposit',
        botMessages: [
          'First you complete 3 trial tasks and earn \$15 instantly!',
          'To activate your worker account, a refundable deposit of \$30 is required. You get it back with your first payout.',
        ],
        choices: [
          ChatChoice(
            text: 'Pay the \$30 deposit — it\'s refundable anyway.',
            riskPoints: 4,
            feedback:
                'The "refundable deposit" never comes back. They will invent more fees until you stop paying. Real jobs never charge you to work.',
          ),
          ChatChoice(
            text: 'A job that asks ME to pay? No thanks. Report.',
            safePoints: 4,
            feedback:
                'Golden rule spotted: employers pay you, never the reverse. Reporting protects other students too.',
            nextStepId: 'ending_safe',
          ),
        ],
      ),
      ChatStep(
        id: 'ending_safe',
        botMessages: ['(You escaped the job scam.)'],
      ),
    ],
  ),
];
