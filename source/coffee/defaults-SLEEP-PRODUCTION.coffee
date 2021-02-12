module.exports =
  app:
    name: 'jazz-fcr-toolkit'
  environment: 'production'
  brand: 'sleep'
  language: 'en'
  hasRegions: true
  isDelphire: true
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
    dataShard: "https://delphire-jazz-io-sleep.firebaseio.com/"

  formId:
    # production: "836f7797-ab87-4755-82ae-ca74f90eeb8b"
    production: "f1b61dd4-615f-49d1-a382-2f4ce571e868"
  naValue: 5
  noDataMessage: "No data to show."
  noReviewsNeededMessage: "No forms to review at this time."
  dataLoadingMessage: "Data loading..."
  evaluatorTerm: "Evaluator"
  evaluateeTerm: "Employee"

  activeGroups:
    '-MTDKsyMXHgl10_OQQ_R':
      'id': '-MTDKsyMXHgl10_OQQ_R'
      'name': 'Sleep February FCR Group - Rep'
      'level': 1
    # '-LzhVD3Qsk4LOqCdSL4c':
    #   'id': '-LzhVD3Qsk4LOqCdSL4c'
    #   'name': 'Sleep Sales Consultant'
    #   'level': 1
    '-MTCixV2n5xGEkJPr9Cn':
      'id': '-MTCixV2n5xGEkJPr9Cn'
      'name': 'Sleep February FCR Group - RSM'
      'level': 2
    # '-LzhVQI35fCFGR2uSDfo':
    #   'id': '-LzhVQI35fCFGR2uSDfo'
    #   'name': 'Regional Sales Manager'
    #   'level': 2
    '-LzhVdGiGrnnPzEx6Uto':
      'id': '-LzhVdGiGrnnPzEx6Uto'
      'name': 'Area Business Director'
      'level': 3
    '-LzhW9U390xXwcNb5NZX':
      'id': '-LzhW9U390xXwcNb5NZX'
      'name': 'National Sales Director'
      'level': 4
    # '-Lz81nYlZEh8PxWY4wYz':
    #   'id': '-Lz81nYlZEh8PxWY4wYz'
    #   'name': 'Jazz Training Team'
    #   'level': 4
    #   'super': true
    '-Lydv3QoOrsCWuVJ5EUG':
      'id': '-Lydv3QoOrsCWuVJ5EUG'
      'name': 'Boco Super'
      'level': 4
      'super': true
    # "-Lzhjc1dGSoz2316nOSk":
    #   'id': "-Lzhjc1dGSoz2316nOSk"
    #   'name': "Hem-Onc Sales Lead"
    #   'level': 4
    #   'super': true

  activeDistricts:
    # '-LzhUhvHdnwUZBQ9eL-b':
    #   'id': '-LzhUhvHdnwUZBQ9eL-b'
    #   'name': 'Southeast'
    #   'region': '-LzhTkAMq4eBlRoeuYzo'
    '-MR70WcQn_Sf2VBbQoVU':
      'id': '-MR70WcQn_Sf2VBbQoVU'
      'name': 'Sleep South Central'
      'region': '--LzhTmo1WsBymrteELGk'

  activeRegions:
    # '-LzhTkAMq4eBlRoeuYzo':
    #   'id': '-LzhTkAMq4eBlRoeuYzo'
    #   'name': 'South Area'
    #   'districts': [
    #     '-LzhUhvHdnwUZBQ9eL-b'
    #   ]
    '--LzhTmo1WsBymrteELGk':
      'id': '--LzhTmo1WsBymrteELGk'
      'name': 'West Area'
      'districts': [
        '-MR70WcQn_Sf2VBbQoVU'
      ]

  activeTeam:
    id: '-MR6fgloK4ZfAyw73TcR'
    name: 'Sleep Sales'
    manager:
      email: 'dave.hirsch@jazzpharma.com'
      id: '-LzhWho4tx2_lyRIEv21'
      name: 'National Sales Director'
    # id: '-LzhU2DAlCznHw7NiB1F'
    # name: 'Sleep Sales'
    # manager:
    #   email: 'dave.hirsch@jazzpharma.com'
    #   id: '-LzhWho4tx2_lyRIEv21'
    #   name: 'National Sales Director'

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
    'Average Compliance'
    'Average Compliance'
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