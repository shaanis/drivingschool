// driving_questions.dart
enum Level { beginner, intermediate, advanced }

class Question {
  final String question;
  final List<String> options;
  final int correctIndex;
  final Level level;
  final String explanation;

  Question({
    required this.question,
    required this.options,
    required this.correctIndex,
    required this.level,
    required this.explanation,
  });
}

final List<Question> allQuestions = [
  // Beginner Questions (15 questions)
  Question(
    question: 'What does a red traffic light mean?',
    options: ['Go', 'Stop', 'Slow down', 'Turn right'],
    correctIndex: 1,
    level: Level.beginner,
    explanation:
        'A red traffic light means you must come to a complete stop before the stop line or crosswalk.',
  ),
  Question(
    question: 'When must you wear a seatbelt?',
    options: [
      'Only on highways',
      'Only at night',
      'At all times while driving',
      'Only in the front seat',
    ],
    correctIndex: 2,
    level: Level.beginner,
    explanation:
        'Seatbelts must be worn by all occupants at all times when the vehicle is in motion.',
  ),
  Question(
    question: 'What does a solid white line at the edge of the road mean?',
    options: [
      'Road edge / shoulder',
      'No parking',
      'No overtaking',
      'Bus lane only',
    ],
    correctIndex: 0,
    level: Level.beginner,
    explanation: 'Solid white lines mark the edge of the road or shoulder.',
  ),
  Question(
    question: 'What should you do at a STOP sign?',
    options: [
      'Slow down and proceed',
      'Stop completely and proceed when safe',
      'Honk and proceed',
      'Speed up to clear quickly',
    ],
    correctIndex: 1,
    level: Level.beginner,
    explanation: 'A STOP sign requires a complete stop before proceeding.',
  ),
  Question(
    question: 'What does a yellow traffic light mean?',
    options: [
      'Speed up to cross',
      'Stop if safe to do so',
      'Turn left only',
      'Park your vehicle',
    ],
    correctIndex: 1,
    level: Level.beginner,
    explanation:
        'Yellow means prepare to stop if safe, otherwise proceed cautiously.',
  ),
  Question(
    question: 'When turning left, you should:',
    options: [
      'Stay in the right lane',
      'Give way to oncoming traffic',
      'Honk continuously',
      'Speed up to beat traffic',
    ],
    correctIndex: 1,
    level: Level.beginner,
    explanation: 'Always give way to oncoming traffic when turning left.',
  ),
  Question(
    question: 'What is the speed limit in residential areas?',
    options: ['60 km/h', '80 km/h', '40 km/h', '100 km/h'],
    correctIndex: 2,
    level: Level.beginner,
    explanation: 'The typical speed limit in residential areas is 40 km/h.',
  ),
  Question(
    question: 'When should you use your indicators?',
    options: [
      'Only on highways',
      'Before changing direction or lane',
      'Only at night',
      'When you feel like it',
    ],
    correctIndex: 1,
    level: Level.beginner,
    explanation: 'Indicators must be used before changing direction or lane.',
  ),
  Question(
    question: 'What does this sign mean? (Picture of pedestrian crossing)',
    options: [
      'School ahead',
      'Pedestrian crossing',
      'No pedestrians',
      'Bicycle lane',
    ],
    correctIndex: 1,
    level: Level.beginner,
    explanation: 'This sign indicates a pedestrian crossing ahead.',
  ),
  Question(
    question: 'When parking uphill with a curb, you should:',
    options: [
      'Turn wheels toward the curb',
      'Turn wheels away from the curb',
      'Keep wheels straight',
      'Use parking brake only',
    ],
    correctIndex: 1,
    level: Level.beginner,
    explanation:
        'Turn wheels away from curb so vehicle rolls into curb if brake fails.',
  ),
  Question(
    question: 'What should you check before starting your vehicle?',
    options: [
      'Fuel level only',
      'Mirrors and seat position',
      'All lights and indicators',
      'All of the above',
    ],
    correctIndex: 3,
    level: Level.beginner,
    explanation: 'Always perform a pre-drive check of all systems.',
  ),
  Question(
    question: 'When driving in fog, you should use:',
    options: [
      'High beam headlights',
      'Fog lights or low beams',
      'Parking lights only',
      'No lights',
    ],
    correctIndex: 1,
    level: Level.beginner,
    explanation: 'Fog lights or low beams are best for foggy conditions.',
  ),
  Question(
    question: 'What is the minimum safe following distance?',
    options: ['1 second', '2 seconds', '4 seconds', '6 seconds'],
    correctIndex: 1,
    level: Level.beginner,
    explanation:
        'Maintain at least 2 seconds following distance in good conditions.',
  ),
  Question(
    question: 'When approaching a roundabout, you should:',
    options: [
      'Speed up',
      'Give way to vehicles already in it',
      'Honk to warn others',
      'Enter without looking',
    ],
    correctIndex: 1,
    level: Level.beginner,
    explanation: 'Always give way to vehicles already in the roundabout.',
  ),
  Question(
    question: 'What does a broken white line mean?',
    options: [
      'No crossing allowed',
      'Lane changing permitted',
      'Bus stop ahead',
      'Road ends',
    ],
    correctIndex: 1,
    level: Level.beginner,
    explanation: 'Broken white lines indicate lane changing is permitted.',
  ),

  // Intermediate Questions (15 questions)
  Question(
    question: 'When are you allowed to overtake from the left side?',
    options: [
      'Never',
      'On one-way roads when the vehicle in front turns right',
      'At intersections only',
      'In school zones only',
    ],
    correctIndex: 1,
    level: Level.intermediate,
    explanation:
        'Overtaking from left is allowed on one-way roads when safe and the vehicle ahead is turning right.',
  ),
  Question(
    question: 'A flashing amber (yellow) light at an intersection means:',
    options: [
      'Stop and wait',
      'Proceed with caution',
      'U-turn allowed only',
      'Pedestrians have no right of way',
    ],
    correctIndex: 1,
    level: Level.intermediate,
    explanation: 'Flashing amber means proceed with caution after yielding.',
  ),
  Question(
    question: 'What should you do before changing lanes?',
    options: [
      'Signal, check mirrors, and check blind spot',
      'Only use the horn',
      'Speed up without signalling',
      'Rely only on side mirrors',
    ],
    correctIndex: 0,
    level: Level.intermediate,
    explanation:
        'Always signal, check mirrors, and check blind spot before changing lanes.',
  ),
  Question(
    question: 'When merging onto a highway, you should:',
    options: [
      'Stop and wait for gap',
      'Match speed with traffic and merge',
      'Slow down significantly',
      'Force your way in',
    ],
    correctIndex: 1,
    level: Level.intermediate,
    explanation: 'Match highway speed and merge when safe.',
  ),
  Question(
    question: 'What does a blue traffic sign indicate?',
    options: [
      'Warning',
      'Mandatory instruction',
      'Information/guide',
      'Prohibition',
    ],
    correctIndex: 2,
    level: Level.intermediate,
    explanation: 'Blue signs provide information or guidance.',
  ),
  Question(
    question: 'When driving at night, you should:',
    options: [
      'Use high beams always',
      'Dim lights for oncoming traffic',
      'Follow closer to see better',
      'Drive faster to reach sooner',
    ],
    correctIndex: 1,
    level: Level.intermediate,
    explanation: 'Always dim high beams for oncoming traffic.',
  ),
  Question(
    question: 'What is "hydroplaning"?',
    options: [
      'Car floating on water',
      'Driving through puddles',
      'Tires losing contact with wet road',
      'Using windshield wipers',
    ],
    correctIndex: 2,
    level: Level.intermediate,
    explanation:
        'Hydroplaning occurs when tires lose contact with wet road surface.',
  ),
  Question(
    question: 'When being overtaken, you should:',
    options: [
      'Speed up',
      'Maintain speed or slow slightly',
      'Move to the left',
      'Honk to warn',
    ],
    correctIndex: 1,
    level: Level.intermediate,
    explanation: 'Maintain or reduce speed to allow safe overtaking.',
  ),
  Question(
    question: 'What does a triangular traffic sign indicate?',
    options: ['Stop', 'Warning', 'Speed limit', 'Parking area'],
    correctIndex: 1,
    level: Level.intermediate,
    explanation: 'Triangular signs are warning signs.',
  ),
  Question(
    question: 'When driving in strong crosswinds:',
    options: [
      'Speed up to stabilize',
      'Grip steering wheel firmly',
      'Use hazard lights',
      'Pull over immediately',
    ],
    correctIndex: 1,
    level: Level.intermediate,
    explanation:
        'Firm grip on steering wheel helps maintain control in crosswinds.',
  ),
  Question(
    question: 'What should you do if your brakes fail?',
    options: [
      'Turn off engine',
      'Pump brakes, use handbrake, downshift',
      'Jump out of vehicle',
      'Crash into something soft',
    ],
    correctIndex: 1,
    level: Level.intermediate,
    explanation:
        'Pump brakes, use handbrake gradually, and downshift to slow down.',
  ),
  Question(
    question: 'A flashing red light means:',
    options: [
      'Slow down',
      'Stop and proceed when safe',
      'Speed up',
      'Caution only',
    ],
    correctIndex: 1,
    level: Level.intermediate,
    explanation: 'Flashing red means stop and proceed only when safe.',
  ),
  Question(
    question: 'When driving near cyclists, you should:',
    options: [
      'Honk to warn them',
      'Give at least 1 meter space',
      'Follow closely',
      'Ignore them',
    ],
    correctIndex: 1,
    level: Level.intermediate,
    explanation: 'Give cyclists at least 1 meter of space when passing.',
  ),
  Question(
    question: 'What does ABS prevent during emergency braking?',
    options: ['Skidding', 'Wheel lock-up', 'Brake fade', 'All of the above'],
    correctIndex: 3,
    level: Level.intermediate,
    explanation:
        'ABS prevents wheel lock-up, helping maintain steering control.',
  ),
  Question(
    question: 'When approaching an emergency vehicle with lights flashing:',
    options: [
      'Speed up to clear',
      'Pull over and stop',
      'Continue normally',
      'Flash your lights',
    ],
    correctIndex: 1,
    level: Level.intermediate,
    explanation: 'Always pull over and stop for emergency vehicles.',
  ),

  // Advanced Questions (15 questions)
  Question(
    question: 'While driving in rain, what is the safest practice?',
    options: [
      'Use high beam lights',
      'Maintain a greater following distance',
      'Turn off headlights',
      'Drive in neutral gear',
    ],
    correctIndex: 1,
    level: Level.advanced,
    explanation:
        'Increased following distance helps prevent accidents in wet conditions.',
  ),
  Question(
    question: 'ABS (Anti-lock Braking System) helps you to:',
    options: [
      'Increase fuel efficiency',
      'Prevent wheel lock-up while braking',
      'Drive faster on curves',
      'Reduce tyre wear only',
    ],
    correctIndex: 1,
    level: Level.advanced,
    explanation: 'ABS prevents wheel lock-up during emergency braking.',
  ),
  Question(
    question:
        'On a multi-lane road, the right-most lane is generally used for:',
    options: [
      'Parking',
      'Slow vehicles',
      'Overtaking and faster vehicles',
      'Two-wheelers only',
    ],
    correctIndex: 2,
    level: Level.advanced,
    explanation: 'Right lane is typically for overtaking and faster traffic.',
  ),
  Question(
    question: 'What is "defensive driving"?',
    options: [
      'Driving slowly always',
      'Anticipating and avoiding hazards',
      'Using horn frequently',
      'Following all vehicles closely',
    ],
    correctIndex: 1,
    level: Level.advanced,
    explanation:
        'Defensive driving means anticipating hazards and acting to avoid them.',
  ),
  Question(
    question: 'When recovering from a skid, you should:',
    options: [
      'Brake hard',
      'Steer in direction of skid',
      'Accelerate quickly',
      'Close your eyes',
    ],
    correctIndex: 1,
    level: Level.advanced,
    explanation: 'Steer in the direction you want the front of the car to go.',
  ),
  Question(
    question: 'What is the correct hand position on steering wheel?',
    options: [
      '10 and 2 o\'clock',
      '9 and 3 o\'clock',
      '8 and 4 o\'clock',
      '6 and 12 o\'clock',
    ],
    correctIndex: 1,
    level: Level.advanced,
    explanation: '9 and 3 position allows maximum control and airbag safety.',
  ),
  Question(
    question: 'When driving in black ice conditions:',
    options: [
      'Brake gently',
      'Steer sharply',
      'Accelerate to warm tires',
      'Use hazard lights continuously',
    ],
    correctIndex: 0,
    level: Level.advanced,
    explanation: 'Gentle braking and steering inputs are crucial on black ice.',
  ),
  Question(
    question: 'What does ESP (Electronic Stability Program) do?',
    options: [
      'Improves fuel economy',
      'Prevents skids and loss of control',
      'Adjusts suspension height',
      'Controls radio volume',
    ],
    correctIndex: 1,
    level: Level.advanced,
    explanation: 'ESP helps maintain vehicle control during extreme maneuvers.',
  ),
  Question(
    question: 'When towing a trailer, you should:',
    options: [
      'Increase following distance',
      'Brake later than normal',
      'Use lower gear downhill',
      'Both A and C',
    ],
    correctIndex: 3,
    level: Level.advanced,
    explanation: 'Increase following distance and use lower gear when towing.',
  ),
  Question(
    question: 'What is "trail braking"?',
    options: [
      'Braking while turning',
      'Using parking brake only',
      'Brake failure technique',
      'Engine braking method',
    ],
    correctIndex: 0,
    level: Level.advanced,
    explanation: 'Trail braking involves gradual brake release while turning.',
  ),
  Question(
    question: 'For maximum braking efficiency:',
    options: [
      'Pump brakes rapidly',
      'Apply firm, steady pressure',
      'Use handbrake first',
      'Turn steering while braking',
    ],
    correctIndex: 1,
    level: Level.advanced,
    explanation: 'Firm, steady pressure provides maximum braking with ABS.',
  ),
  Question(
    question: 'When driving through deep water:',
    options: [
      'Speed up to create bow wave',
      'Drive slowly in low gear',
      'Use high RPM',
      'Turn off AC',
    ],
    correctIndex: 1,
    level: Level.advanced,
    explanation: 'Drive slowly in low gear to prevent water entering exhaust.',
  ),
  Question(
    question: 'What is the "two-second rule" in driving?',
    options: [
      'Wait 2 seconds after light turns green',
      'Maintain 2-second gap from vehicle ahead',
      'Signal 2 seconds before turning',
      'Check mirrors every 2 seconds',
    ],
    correctIndex: 1,
    level: Level.advanced,
    explanation: 'Minimum 2-second gap from vehicle ahead in good conditions.',
  ),
  Question(
    question: 'When driving in a convoy:',
    options: [
      'Maintain visual contact only',
      'Keep same following distance as normal',
      'Use same lane always',
      'Establish communication method',
    ],
    correctIndex: 3,
    level: Level.advanced,
    explanation: 'Establish communication and emergency signals in convoy.',
  ),
  Question(
    question: 'For emergency evasive maneuvers:',
    options: [
      'Brake and swerve simultaneously',
      'Brake first, then steer',
      'Steer first, then brake',
      'Accelerate through obstacle',
    ],
    correctIndex: 1,
    level: Level.advanced,
    explanation: 'Brake first to reduce speed, then steer around obstacle.',
  ),
];
