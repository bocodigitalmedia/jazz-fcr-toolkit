module.exports =
  app:
    name: 'jazz-fcr-toolkit'
  environment: 'production'
  # brand: 'hemonc' #! HEMONC
  brand: 'sleep' #? SLEEP
  language: 'en'
  hasRegions: true
  isDelphire: false
  #? SLEEP
  initials:
    active: true
    type: 'brand' # or 'team' 'brand' #~ TEAM = REGIONS / BRAND = GROUPS
    included:
      evaluatees:
        levels: [3,4]
      competencies:
        levels: [2..4]
      incompletes:
        levels: [2..4]
      actions:
        levels: [2..4]
      glance:
        levels: [2]
  #! HEMONC
  # initials:
  #   active: true
  #   type: 'team' # or 'team' 'brand' #~ TEAM = REGIONS / BRAND = GROUPS
  #   included:
  #     evaluatees:
  #       levels: [3,4]
  #     competencies:
  #       levels: [3,4]
  #     incompletes:
  #       levels: [3,4]
  #     actions:
  #       levels: [3,4]
  #     glance:
  #       levels: []
  firebase:
    apiKey: "AIzaSyCMBzkklmkwLAvUfrJbiNe0ukseKUJIF_U"
    authDomain: "delphire-jazz-io.firebaseapp.com"
    databaseURL: "https://delphire-jazz-io.firebaseio.com"
    projectId: "delphire-jazz-io"
    storageBucket: "delphire-jazz-io.appspot.com"
    messagingSenderId: "898601993167"
    appId: "1:898601993167:web:714d1ac170576f43c888ba"
    measurementId: "G-VEHMJ8Z0P9"
    stateShard: "https://delphire-jazz-io-state.firebaseio.com/"
    # dataShard: "https://delphire-jazz-io-heme-onc.firebaseio.com/" #! HEMONC
    dataShard: "https://delphire-jazz-io-sleep.firebaseio.com/" #? SLEEP
  formId:
    # production: "test-hemeonc-fcr" #! HEMONC
    production: "test-sleep-fcr" #? SLEEP
    # production: "f1b61dd4-615f-49d1-a382-2f4ce571e868" #? SLEEP
  naValue: 5
  integrityQuestion: 30
  noDataMessage: "No data to show."
  noReviewsNeededMessage: "No forms to review at this time."
  dataLoadingMessage: "Data loading..."
  evaluatorTerm: "Evaluator"
  evaluateeTerm: "Employee"
  activeGroups: #TODO ADD USERS TO CORRECT GROUPS IN THE CMS
    # '-M03B4-G4OgGYz4dnjVt': #! HEMONC - all 6 boco reps from district 1 and distric 2
    #   'id': '-M03B4-G4OgGYz4dnjVt'
    #   'name': 'Boco Reps'
    #   'level': 1
    '-MUiS1vC2-ARhE99QGvk': #? SLEEP (SUNOSI)
      'id': '-MUiS1vC2-ARhE99QGvk'
      'name': 'Boco Reps SUNOSI'
      'initials': 'Su'
      'dataSet': true
      'dataSetLabel': 'SUNOSI'
      'level': 1
      'brand': 'sunosi'
    '-MUo0YnEn0KppnGI2MKE': #? SLEEP (SUNOSI/XYWAV)
      'id': '-MUo0YnEn0KppnGI2MKE'
      'name': 'Boco Reps SUNOSI/XYWAV'
      'initials': 'Su'
      'dataSet': false
      'level': 1
      'brand': 'sunosi'
    '-MUiSC_ADzZKAOV5APWO': #? SLEEP (XYWAV)
      'id': '-MUiSC_ADzZKAOV5APWO'
      'name': 'Boco Reps XYWAV'
      'initials': 'Xy'
      'dataSet': true
      'dataSetLabel': 'XYWAV'
      'level': 1
      'brand': 'xywav'
    '-M03BCiWABXAUuo2xEoU':
      'id': '-M03BCiWABXAUuo2xEoU'
      'name': 'Boco DMs'
      'level': 2
    '-M03BGAcmENfAf5jdq93':
      'id': '-M03BGAcmENfAf5jdq93'
      'name': 'Boco RMs'
      'level': 3
    '-M03BLyXd0n-QzSKbYEu':
      'id': '-M03BLyXd0n-QzSKbYEu'
      'name': 'Boco NSM'
      'level': 4
    '-Lydv3QoOrsCWuVJ5EUG':
      'id': '-Lydv3QoOrsCWuVJ5EUG'
      'name': 'Boco Super'
      'level': 4
      'super': true

  activeDistricts:
    '-M03BTgcsR1xpi8H6w-7':
      'id': '-M03BTgcsR1xpi8H6w-7'
      'name': 'Boco Philadelphia'
      'region': '-M03BXyv8l_rQZJqjW9F'
    '-M03BVeWmqPCtySIrzgP':
      'id': '-M03BVeWmqPCtySIrzgP'
      'name': 'Boco San Diego'
      'region': '-M03B_4wAvDCNicrj2RW'

  activeRegions:
    '-M03BXyv8l_rQZJqjW9F':
      'id': '-M03BXyv8l_rQZJqjW9F'
      'name': 'Boco East'
      'initials': 'BE'
      'districts': [
        '-M03BTgcsR1xpi8H6w-7'
      ]
    '-M03B_4wAvDCNicrj2RW':
      'id': '-M03B_4wAvDCNicrj2RW'
      'name': 'Boco West'
      'initials': 'BW'
      'districts': [
        '-M03BVeWmqPCtySIrzgP'
      ]

  activeTeam:
    id: '-M03Bq3CZoyZsNUo0i-D'
    name: 'Boco NSM'
    manager:
      email: 'boco.national.director@gmail.com'
      id: '-M-QREGos1cWmgTsDoeM'
      name: 'National Sales Manager'

  colors: [
    '#EB3A6E'
    '#4c92fa'
    '#60f178'
    '#fcf172'
    '#e554f2'
    '#8747f3'
    '#0059bd'
    '#f05a15'
    '#252525'
    '#a16526'
    '#85d6ff'
    '#fea6cf'
    '#898989'
    '#f0b16b'
    '#ab86d1'
    '#f8426d'
    '#6ab512'
  ]

  questions: [
    'Quality of Resource Usage'
    'Quality of Boostrix Delivery'
    'Quality of Disease State Delivery'
    'Quality Call to Action'
    'Diagnose'
    'Build Your Plan | Resource Utilization'
    'Execute & Evaluate | Targeting/Routing'
    'Disease State'
    'Product'
    'Promotion/Selling'
    'Prepare to Sell'
    'Open the Sales Call'
    'Uncover Opportunities'
    'Align Brand and Handle Objections'
    'Close with Commitment'
    'Total Office Call'
    'Analyze Call and Plan Next Steps'
    'Payer Pull Through'
    'Initiative | Seize Opportunity'
    'Drive Performance'
    'Coachability'
    'Personal Development'
    'Effective Collaboration'
    'Builds Trust'
    'Effective Communication'
    'Expense Management'
    'Sample/Resource Management'
    'Fleet Management'
    'Report Timeliness'
    'Recording of Activity in CRM'
    'Compliance'
  ]

  includedQuestions: [
    false
    false
    false
    false
    true
    true
    true
    true
    true
    true
    true
    true
    true
    true
    true
    true
    true
    true
    true
    true
    true
    true
    true
    true
    true
    true
    true
    true
    true
    true
    true
    false
  ]
