module.exports =
  app:
    name: 'jazz-fcr-toolkit'
  environment: 'production'
  brand: 'sleep'
  language: 'en'
  hasRegions: true
  isDelphire: true
  initials:
    active: true
    type: 'brand' # 'team' or 'brand' #~ TEAM = REGIONS / BRAND = GROUPS
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
    production: "f1b61dd4-615f-49d1-a382-2f4ce571e868"
  naValue: 5
  noDataMessage: "No data to show."
  noReviewsNeededMessage: "No forms to review at this time."
  dataLoadingMessage: "Data loading..."
  evaluatorTerm: "Evaluator"
  evaluateeTerm: "Employee"

  activeGroups:
    '-MUPEuIxnVe_TghroQ-3':
      'id': '-MUPEuIxnVe_TghroQ-3'
      'name': 'SSCs OXYBATE'
      'initials': 'Xy'
      'dataSet': true
      'dataSetLabel': 'XYWAV'
      'level': 1
      'brand': 'xywav'

    '-MUPEw7VWw4IH-HRt50z':
      'id': '-MUPEw7VWw4IH-HRt50z'
      'name': 'SSCs SUNOSI'
      'initials': 'Su'
      'dataSet': true
      'dataSetLabel': 'SUNOSI'
      'level': 1
      'brand': 'sunosi'

    '-MUQYHt6n3cOdRvIlTyP':
      'id': '-MUQYHt6n3cOdRvIlTyP'
      'name': 'SSCs OXYBATE and SUNOSI'
      'initials': 'Su'
      'dataSet': false
      'level': 1
      'brand': 'sunosi'

    '-LzhVQI35fCFGR2uSDfo':
      'id': '-LzhVQI35fCFGR2uSDfo'
      'name': 'Regional Sales Managers'
      'level': 2

    '-MGnUVpxL5PpMNI1wfyl':
      'id': '-MGnUVpxL5PpMNI1wfyl'
      'name': 'Sleep New Hire RSMs'
      'level': 2

    '-LzhVdGiGrnnPzEx6Uto':
      'id': '-LzhVdGiGrnnPzEx6Uto'
      'name': 'Area Business Director'
      'level': 3

    '-MUyJk2j47pq6dACNlaP':
      'id': '-MUyJk2j47pq6dACNlaP'
      'name': 'New Hire ABDs'
      'level': 3

    '-LzhW9U390xXwcNb5NZX':
      'id': '-LzhW9U390xXwcNb5NZX'
      'name': 'National Sales Director'
      'level': 4

    '-MVMYf7t9IOJAOU30oX6':
      'id': '-MVMYf7t9IOJAOU30oX6'
      'name': 'Jazz FCR/Training Super Users'
      'level': 4
      'super': true

    '-Lydv3QoOrsCWuVJ5EUG':
      'id': '-Lydv3QoOrsCWuVJ5EUG'
      'name': 'Boco Super'
      'level': 4
      'super': true

  activeDistricts:

    '-MR7-znppnQvjE8gGKdk':
      'id': '-MR7-znppnQvjE8gGKdk'
      'name': 'New England'
      'region': '-MUAUBaKQpMTuFkxWgKa'

    '-MR700QXI4TFyaETay9a':
      'id': '-MR700QXI4TFyaETay9a'
      'name': 'NY Metro'
      'region': '-MUAUBaKQpMTuFkxWgKa'

    '-MUAYoAc3XqpiP9SZXGV':
      'id': '-MUAYoAc3XqpiP9SZXGV'
      'name': 'Penn-NY'
      'region': '-MUAUBaKQpMTuFkxWgKa'

    '-MR707sxIAddRyvOPVzZ':
      'id': '-MR707sxIAddRyvOPVzZ'
      'name': 'Mid-Atlantic'
      'region': '-MUAUBaKQpMTuFkxWgKa'

    '-MR70Ed-2b-IcuEygEHx':
      'id': '-MR70Ed-2b-IcuEygEHx'
      'name': 'Capital'
      'region': '-MUAUBaKQpMTuFkxWgKa'

    '-MUAZ474GBkmiz0wMoRg':
      'id': '-MUAZ474GBkmiz0wMoRg'
      'name': 'Blue Ridge Mountains'
      'region': '-MUAUBaKQpMTuFkxWgKa'

    '-MUAZDoUSdRz6zwyHzHf':
      'id': '-MUAZDoUSdRz6zwyHzHf'
      'name': 'Sleep North Florida'
      'region': '-LzhUhvHdnwUZBQ9eL-b'

    '-MR70GGI25g8bSsomUaH':
      'id': '-MR70GGI25g8bSsomUaH'
      'name': 'Carolinas'
      'region': '-LzhUhvHdnwUZBQ9eL-b'

    '-MR70HMfwhvxu2P-hYao':
      'id': '-MR70HMfwhvxu2P-hYao'
      'name': 'South Florida'
      'region': '-LzhUhvHdnwUZBQ9eL-b'

    '-MUAZga_4bfZ6gpvE7ar':
      'id': '-MUAZga_4bfZ6gpvE7ar'
      'name': 'Alabama-Georgia'
      'region': '-LzhUhvHdnwUZBQ9eL-b'

    '-MR70OK1oB78Ba7pdH1y':
      'id': '-MR70OK1oB78Ba7pdH1y'
      'name': 'Tennessee Valley'
      'region': '-LzhUhvHdnwUZBQ9eL-b'

    '-MR70QimjJCx8okTT4OL':
      'id': '-MR70QimjJCx8okTT4OL'
      'name': 'Gulf Coast'
      'region': '-LzhUhvHdnwUZBQ9eL-b'

    '-MR705q1g8VOJX8bT2bS':
      'id': '-MR705q1g8VOJX8bT2bS'
      'name': 'Ohio Valley'
      'region': '-MUAUiIiJs-oZMxZQN8l'

    '-MR70Bu-l_BHgitJdsX8':
      'id': '-MR70Bu-l_BHgitJdsX8'
      'name': 'North Central'
      'region': '-MUAUiIiJs-oZMxZQN8l'

    '-MUA_jYln8JhZXwiKWXg':
      'id': '-MUA_jYln8JhZXwiKWXg'
      'name': 'Mid-West'
      'region': '-MUAUiIiJs-oZMxZQN8l'

    '-MR709seshnHz3foRBdN':
      'id': '-MR709seshnHz3foRBdN'
      'name': 'Great Lakes'
      'region': '-MUAUiIiJs-oZMxZQN8l'

    '-MUA_zT5fy4bKgtQ4REz':
      'id': '-MUA_zT5fy4bKgtQ4REz'
      'name': 'Northern Plains'
      'region': '-MUAUiIiJs-oZMxZQN8l'

    '-MR70UXxP2IDenRNWCcJ':
      'id': '-MR70UXxP2IDenRNWCcJ'
      'name': 'Heartland'
      'region': '-MUAUiIiJs-oZMxZQN8l'

    '-MR70WcQn_Sf2VBbQoVU':
      'id': '-MR70WcQn_Sf2VBbQoVU'
      'name': 'Sleep South Central'
      'region': '-LzhTmo1WsBymrteELGk'

    '-MR70d5-_yKrp4GlEaob':
      'id': '-MR70d5-_yKrp4GlEaob'
      'name': 'Pacific Northwest'
      'region': '-LzhTmo1WsBymrteELGk'

    '-MUAcyTsgfiqaqq8csiV':
      'id': '-MUAcyTsgfiqaqq8csiV'
      'name': 'Texas'
      'region': '-LzhTmo1WsBymrteELGk'

    '-MR70aa5ZczenZa_omWp':
      'id': '-MR70aa5ZczenZa_omWp'
      'name': 'SoCal'
      'region': '-LzhTmo1WsBymrteELGk'

    '-MUAdHkqRTHORWTNYpmd':
      'id': '-MUAdHkqRTHORWTNYpmd'
      'name': 'Rocky Mountains'
      'region': '-LzhTmo1WsBymrteELGk'

  activeRegions:
    '-MUAUBaKQpMTuFkxWgKa':
      'id': '-MUAUBaKQpMTuFkxWgKa'
      'name': 'Northeast Area'
      'districts': [
        '-MR7-znppnQvjE8gGKdk'
        '-MR700QXI4TFyaETay9a'
        '-MUAYoAc3XqpiP9SZXGV'
        '-MR707sxIAddRyvOPVzZ'
        '-MR70Ed-2b-IcuEygEHx'
        '-MUAZ474GBkmiz0wMoRg'
      ]

    '-LzhUhvHdnwUZBQ9eL-b':
      'id': '-LzhUhvHdnwUZBQ9eL-b'
      'name': 'Southeast Area'
      'districts': [
        '-MUAZDoUSdRz6zwyHzHf'
        '-MR70GGI25g8bSsomUaH'
        '-MR70HMfwhvxu2P-hYao'
        '-MUAZga_4bfZ6gpvE7ar'
        '-MR70OK1oB78Ba7pdH1y'
        '-MR70QimjJCx8okTT4OL'
      ]

    '-MUAUiIiJs-oZMxZQN8l':
      'id': '-MUAUiIiJs-oZMxZQN8l'
      'name': 'Central Area'
      'districts': [
        '-MR705q1g8VOJX8bT2bS'
        '-MR70Bu-l_BHgitJdsX8'
        '-MUA_jYln8JhZXwiKWXg'
        '-MR709seshnHz3foRBdN'
        '-MUA_zT5fy4bKgtQ4REz'
        '-MR70UXxP2IDenRNWCcJ'
      ]

    '-LzhTmo1WsBymrteELGk':
      'id': '-LzhTmo1WsBymrteELGk'
      'name': 'West Area'
      'districts': [
        '-MR70WcQn_Sf2VBbQoVU'
        '-MR70d5-_yKrp4GlEaob'
        '-MUAcyTsgfiqaqq8csiV'
        '-MR70aa5ZczenZa_omWp'
        '-MUAdHkqRTHORWTNYpmd'
      ]

  activeTeam:
    id: '-MR6fgloK4ZfAyw73TcR'
    name: 'Sleep National'
    manager:
      email: 'jorge.gomez@jazzpharma.com'
      id: '-MZ--l_8Cr1D_YehMkRx'
      # name: 'National Sales Director'
      name: 'Jorge Gomez'


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
    'Employee compliance'
    'Meeting expectations'
  ]

  includedQuestions: [
    false
    false
  ]