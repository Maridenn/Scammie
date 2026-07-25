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
];
