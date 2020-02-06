module.exports =
  app:
    name: 'jazz-fcr-toolkit'
  environment: 'production'
  brand: 'hemonc'
  language: 'en'
  hasRegions: true
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
    dataShard: "https://delphire-jazz-io-heme-onc.firebaseio.com/"

  formId:
    production: "7533a241-20b6-4e4d-8a9f-a55afdf9defd"
  naValue: 5
  integrityQuestion: 30
  noDataMessage: "No data to show."
  noReviewsNeededMessage: "No forms to review at this time."
  dataLoadingMessage: "Data loading..."
  evaluatorTerm: "Evaluator"
  evaluateeTerm: "Employee"

  activeGroups:
    '-Lzhj0M8qEjtiHBs9TDk':
      'id': '-Lzhj0M8qEjtiHBs9TDk'
      'name': 'Oncology Account Manager'
      'level': 1
    '-LzhjCGdSnN4nSqfkLby':
      'id': '-LzhjCGdSnN4nSqfkLby'
      'name': 'Regional Sales Manager'
      'level': 2
    '-Lzhjc1dGSoz2316nOSk':
      'id': '-Lzhjc1dGSoz2316nOSk'
      'name': 'National Sales Manager'
      'level': 3
    '-Lz81nYlZEh8PxWY4wYz':
      'id': '-Lz81nYlZEh8PxWY4wYz'
      'name': 'Jazz Training Team'
      'level': 3
      'super': true
    '-Lydv3QoOrsCWuVJ5EUG':
      'id': '-Lydv3QoOrsCWuVJ5EUG'
      'name': 'Boco Super'
      'level': 3
      'super': true

  activeDistricts:
    '-Lzhk3eLULX2FJmqQScU':
      'id': '-Lzhk3eLULX2FJmqQScU'
      'name': 'Southwest'
      'region': '-LzhkOXj4Q1ANu18NM4a'

  activeRegions:
    '-LzhkOXj4Q1ANu18NM4a':
      'id': '-LzhkOXj4Q1ANu18NM4a'
      'name': 'Region HemOnc'
      'districts': [
        '-Lzhk3eLULX2FJmqQScU'
      ]

  activeTeam:
    id: '-LzhkOXj4Q1ANu18NM4a'
    name: 'Nation HemOnc'
    manager:
      email: 'roddy.mcilwain@jazzpharma.com'
      id: '-Lzhl7ys-TgHOkT6XJY8'
      name: 'National Sales Director'

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
