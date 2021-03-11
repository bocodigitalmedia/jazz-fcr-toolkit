module.exports =
  app:
    name: 'jazz-fcr-toolkit'
  environment: 'production'
  brand: 'hemonc'
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
    dataShard: "https://delphire-jazz-io-heme-onc.firebaseio.com/"
  initials:
    active: true
    type: 'team' # or 'team' 'brand' #~ TEAM = REGIONS / BRAND = GROUPS
    included:
      evaluatees:
        levels: [3,4]
      competencies:
        levels: [3,4]
      incompletes:
        levels: [3,4]
      actions:
        levels: [3,4]
      glance:
        levels: []
  formId:
    production: "12bdfe6a-c475-41e3-876e-0fd007eb4015"
  naValue: 5
  integrityQuestion: 30
  noDataMessage: "No data to show."
  noReviewsNeededMessage: "No forms to review at this time."
  dataLoadingMessage: "Data loading..."
  evaluatorTerm: "Evaluator"
  evaluateeTerm: "Employee"
  activeGroups:
    '-MUVAGg1LWrWR6Wynv5j':
      'id': '-MUVAGg1LWrWR6Wynv5j'
      'name': 'Hemonc New Hire OAMs - Adult'
      'level': 1

    '-MUVAJ5v_nf9gsR8AXSq':
      'id': '-MUVAJ5v_nf9gsR8AXSq'
      'name': 'Hemonc New Hire OAMs - L&T'
      'level': 1

    '-MUOsyIqV7SS1nXQNctX':
      'id': '-MUOsyIqV7SS1nXQNctX'
      'name': 'Hemonc OAMs - Adult'
      'level': 1

    '-MUOtOqUaPY-uIDeaB4J':
      'id': '-MUOtOqUaPY-uIDeaB4J'
      'name': 'Hemonc OAMs - L&T'
      'level': 1

    '-M5wIMJ4wBOP5_LUcffa':
      'id': '-M5wIMJ4wBOP5_LUcffa'
      'name': 'HemOnc RSMs - Adult'
      'level': 2
    '-MQn2PDDJSAYBtJQQImH':
      'id': '-MQn2PDDJSAYBtJQQImH'
      'name': 'HemOnc RSMs - L&T'
      'level': 2

    '-M5wIK3iPnSIq8dmC1kV':
      'id': '-M5wIK3iPnSIq8dmC1kV'
      'name': 'HemOnc ADBs'
      'level': 3
    '-MQnLQ84JiSNPuKzIVvM':
      'id': '-MQnLQ84JiSNPuKzIVvM'
      'name': 'ABD - L&T'
      'level': 3

    '-Lzhjc1dGSoz2316nOSk':
      'id': '-Lzhjc1dGSoz2316nOSk'
      'name': 'HemOnc National'
      'level': 4
      'super': true

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
    '-MR71Wzd594z2IVmUouY':
      'id': '-MR71Wzd594z2IVmUouY'
      'name': 'HemOnc Northeast'
      'region': '-MR715rTi75n9uaD0F6S'
    '-MR71YOXgZIjjHVeyoRL':
      'id': '-MR71YOXgZIjjHVeyoRL'
      'name': 'HemOnc Tri-State'
      'region': '-MR715rTi75n9uaD0F6S'
    '-MR71_JVd_W2W7BP1-Ot':
      'id': '-MR71_JVd_W2W7BP1-Ot'
      'name': 'HemOnc Mid-Atlantic'
      'region': '-MR715rTi75n9uaD0F6S'
    '-MR71ai6sKFxydeAhfdJ':
      'id': '-MR71ai6sKFxydeAhfdJ'
      'name': 'HemOnc Southeast'
      'region': '-MR715rTi75n9uaD0F6S'
    '-MR71cQQ8loRcGsm-xQS':
      'id': '-MR71cQQ8loRcGsm-xQS'
      'name': 'HemOnc Michiana'
      'region': '-MR715rTi75n9uaD0F6S'

    '-MR71fiJp6wRK1K-e1en':
      'id': '-MR71fiJp6wRK1K-e1en'
      'name': 'HemOnc Midwest'
      'region': '-MR71IAOu3xawM_Ayt4_'
    '-MR71hGie1YA5MGSlAn8':
      'id': '-MR71hGie1YA5MGSlAn8'
      'name': 'HemOnc Gulf Coast'
      'region': '-MR71IAOu3xawM_Ayt4_'
    '-MR71iw4VRBRZROHUwAz':
      'id': '-MR71iw4VRBRZROHUwAz'
      'name': 'HemOnc Southwest'
      'region': '-MR71IAOu3xawM_Ayt4_'
    '-MR71l9dhj-TyTZaT-_C':
      'id': '-MR71l9dhj-TyTZaT-_C'
      'name': 'HemOnc West'
      'region': '-MR71IAOu3xawM_Ayt4_'
    '-MR71nw66ttr0t3NvqHI':
      'id': '-MR71nw66ttr0t3NvqHI'
      'name': 'HemOnc Great Plains'
      'region': '-MR71IAOu3xawM_Ayt4_'

    '-MUAG6rubNyj7nL8MfxI':
      'id': '-MUAG6rubNyj7nL8MfxI'
      'name': 'HemOnc L&T West'
      'region': '-M5wJ0--M3ZKGhGhJi4C'
    '-MUAGHVx-GZPSQIf6Fv3':
      'id': '-MUAGHVx-GZPSQIf6Fv3'
      'name': 'HemOnc L&T Northeast'
      'region': '-M5wJ0--M3ZKGhGhJi4C'
    '-MUAGNJx3qK4tRUEwd-o':
      'id': '-MUAGNJx3qK4tRUEwd-o'
      'name': 'HemOnc L&T Southeast'
      'region': '-M5wJ0--M3ZKGhGhJi4C'

  activeRegions:
    '-MR715rTi75n9uaD0F6S':
      'id': '-MR715rTi75n9uaD0F6S'
      'name': 'East Area'
      'initials': 'A'
      'districts': [
        '-MR71Wzd594z2IVmUouY'
        '-MR71YOXgZIjjHVeyoRL'
        '-MR71_JVd_W2W7BP1-Ot'
        '-MR71ai6sKFxydeAhfdJ'
        '-MR71cQQ8loRcGsm-xQS'
      ]
    '-MR71IAOu3xawM_Ayt4_':
      'id': '-MR71IAOu3xawM_Ayt4_'
      'name': 'West Area'
      'initials': 'A'
      'districts': [
        '-MR71fiJp6wRK1K-e1en'
        '-MR71hGie1YA5MGSlAn8'
        '-MR71iw4VRBRZROHUwAz'
        '-MR71l9dhj-TyTZaT-_C'
        '-MR71nw66ttr0t3NvqHI'
      ]
    '-M5wJ0--M3ZKGhGhJi4C':
      'id': '-M5wJ0--M3ZKGhGhJi4C'
      'name': 'L&T Area'
      'initials': 'LT'
      'districts': [
        '-MUAG6rubNyj7nL8MfxI'
        '-MUAGHVx-GZPSQIf6Fv3'
        '-MUAGNJx3qK4tRUEwd-o'
      ]

  activeTeam:
    id: '-M5wIrtDrAovUDNMipbC'
    name: 'National'
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
    'Employee compliance'
    'Meeting expectations'
  ]

  includedQuestions: [
    false
    false
  ]