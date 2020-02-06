module.exports = (angular, defaults) ->

  angular.module defaults.app.name
    .factory 'Email', [
      '$rootScope'
      '$q'
      '$http'
      '$filter'
      (
        $rootScope
        $q
        $http
        $filter
      ) ->

        Email =
          # set up a promise
          deferred: $q.defer()
          # url: 'http://boco-proxy-email.us-east-1.elasticbeanstalk.com:3000/api/email/send/'
          # url: 'https://mail.boco-delphire.com/api/email/send/'
          url: 'https://mail.boco-delphire.com/api/ses/sendRawEmail'
          subject: ''
          to: ''

          styles:
            h2: 'font-size: 16px; font-weight: bold; margin: 0 0 8px 0;'
            h3: 'font-size: 14px; font-weight: bold; margin: 0 0 8px 0;'
            div: 'font-size: 14px; font-weight: normal; margin: 0 0 8px 0;'

          # ---------------------------------------------------------------------------

          send: (data) ->
            console.log '[ Email.send data ]', data

            # store subject and to
            @setup data

            # use the data object to generate the html email
            html = @create data

            # send the actual email and return a promise
            return @_send data, html

          # ---------------------------------------------------------------------------

          # store some stuff internally
          setup: (data) ->
            Email.to = data.to
            #Email.to = 'bruce.hubbard@bocodigital.com'
            # Email.to = 'stephen.mcdonald@bocodigital.com'
            Email.subject = data.subject

          # ---------------------------------------------------------------------------

          create: (data) ->

            console.log '[ Email.create data ]', data

            if data.data.name?
              nameFored = data.data.name
            else
              nameFored = data.data.email
            console.log '[ User Name Sent ]', nameFored

            return """
              <div style="#{Email.styles.div}">
                <p>Dear #{nameFored},</p>
                <p>Attached is your FCR Report for the dates #{data.data.date1} through #{data.data.date2}.</p>
              </div>
            """
          _send: (data, str) ->

            console.log '[ Email._send attempting ]', data

            message = Message.create(
              text: ''
              from: 'Boco Digital <support@bocodigital.com>'
              to: Email.to
              subject: Email.subject
              attachment: [ {data:str, alternative:true},
              {
                data: data.data.file
                type: 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet'
                name: data.data.filename
              } ])

            stream = message.stream()
            content = ''

            stream.on('data',  (buf) => content += buf.toString())

            stream.on 'end', () =>
              params =
                from: 'support@bocodigital.com'
                rawMessage: content
              console.log 'Sending email', message
              $http.post(@url, params).then (resp) =>
                console.log '\t%c Emails sent.', 'color: #008000'
                console.log resp
                @deferred.resolve()
            @deferred.promise

    ]