module.exports = (angular, defaults) ->

  angular.module defaults.app.name
    .factory 'FirebaseStorage', [
      '$firebaseArray'
      '$firebaseObject'
      (
        $firebaseArray
        $firebaseObject
      ) ->

        FirebaseStorage =

          # ------------------------------------------------------------------------

          # upload file to firebase storage using environment and return reference (for state watching)
          upload: (file, metadata, children...) ->
            console.log '[ FirebaseStorage ]: upload', metadata, "environments/" + defaults.environment + "/" + children.join('/')

            ref = firebase.storage().ref().child "environments/" + defaults.environment + "/" + children.join('/')
            return ref.put file, metadata

          # ------------------------------------------------------------------------

          getUrl: (children...) ->
            path = "environments/" + defaults.environment + "/" + children.join('/')
            console.log '[ FirebaseStorage ]: getUrl', path
            return firebase.storage().ref().child(path).getDownloadURL()
    ]