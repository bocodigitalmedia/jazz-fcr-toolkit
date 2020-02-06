module.exports = (angular, defaults) ->

  angular.module defaults.app.name
    .factory 'Email', [
      '$rootScope'
      '$q'
      '$http'
      (
        $rootScope
        $q
        $http
      ) ->

        Email =

          url: 'https://mail.boco-delphire.com/api/email/send/'
          subject: ''
          to: ''

          styles:
            h2: 'font-size: 16px; font-weight: bold; margin: 0 0 8px 0;'
            h3: 'font-size: 14px; font-weight: bold; margin: 0 0 8px 0;'
            div: 'font-size: 14px; font-weight: normal; margin: 0 0 8px 0;'

          # ---------------------------------------------------------------------------

          send: (response) ->
            console.log '[ EMAIL ][ send: response ]', response

            # store subject and to
            @setup response

            # use the response object to generate the html email
            html = @create response

            console.log '[ EMAIL ][ send: HTML RESPONSE ]', html

            # send the actual email and return a promise
            return @_send response, html

          # ---------------------------------------------------------------------------

          # store some stuff internally
          setup: (response) ->
            Email.to = response.to
            Email.subject = response.subject

          # ---------------------------------------------------------------------------

          createHTML: (data, response) ->

            console.log '[ EMAIL ][ createSubmission: response ]', response
            console.log '[ EMAIL ][ createSubmission: data ]', data
            console.log '[ EMAIL ][ createSubmission: action ]', response.action

            evaluateeEmail = data.payload.evaluatee.email

            switch response.type
              when 'manager'  then emailBody = evaluateeEmail + ' has rejected your Field Coaching Report in SHARP. Please contact your employee within 48 hours to regroup and resolve.'
              when 'employee' then emailBody = 'You have rejected the FCR submitted by your manager. You and your manager should regroup to resolve within 48 hours.'

            str = ""
            str += '<body style="background-color: #f8f8fa">'
            str += '  <table border="0" cellpadding="0" cellspacing="0" width="100%" style="border-collapse: collapse; padding: 0; margin: 0px; vertical-align: top;text-align: left; border-spacing: 0;">'
            str += '    <tr valign="top" style="padding: 0;vertical-align: top;text-align: left;">'
            str += '      <td align="center" style="font-size: 14px; line-height: 19px; color: #222222; font-family: Helvetica, Arial, sans-serif; font-weight: normal;padding: 0; margin: 0 auto; text-align: left;">'
            str += '        <table style="border-spacing: 0; border-collapse: collapse; height: 100%; width: 100%; font-size: 14px;line-height:19px;">'
            str += '          <tr style="padding: 0; vertical-align: top; text-align: left;">'
            str += '            <td align="center" valign="top" style="text-align: center !important;">'
            str += '              <center style="width: 100%; min-width: 580px; display: block;">'
            str += '                <table style="border-spacing: 0; border-collapse: collapse; width: 580px; margin: 0 auto; text-align: inherit; background-color: #fff;">'
            str += '                  <tr>'
            str += '                    <td align="center" style="text-align: center;">'
            str += '                      <center style="width: 100%; min-width: 580px; display: block;">'
            str += '                        <table style="width: 580px; margin: 0 auto; text-align: inherit; background-color: #fff; border-spacing: 0; border-collapse: collapse;">'
            str += '                          <tr>'
            str += '                            <td style="position: relative; padding: 0;">'
            str += '                              <table style="border-spacing: 0; border-collapse: collapse; width: 580px; margin: 0 auto; background-color: #fff;">'
            str += '                                <!-- LOGOS -->'
            str += '                                <tr style="padding: 0; vertical-align: top; text-align: left;">'
            str += '                                  <td style="padding: 0;">'
            str += '                                    <ul style="padding: 0; margin: 0; text-align: center; width: 100%; font-size: 1.15em; color: #fa771f;">'
            str += '                                      <li style="display: inline-block; list-style: none; color: #fa771f; font-weight: lighter;">'
            str += '                                        <img src="http://bocoweb.bocodigital.com/GNE/email/SPT/gsk-eu-header.png" alt="SHARP - Syneos Health Assessment Review Program" style="width: 830px; height:auto; max-width: 100%; float: left; clear: both; display: block; outline: none; text-decoration: none;">'
            str += '                                      </li>'
            str += '                                    </ul>'
            str += '                                  </td>'
            str += '                                  <td style="visibility: hidden; width: 0px; padding: 0 !important;"></td>'
            str += '                                </tr>'
            str += '                              </table>'
            str += '                            </td>'
            str += '                          </tr>'
            str += '                        </table>'
            str += '                      </center>'
            str += '                    </td>'
            str += '                  </tr>'
            str += '                </table>'
            str += '                <table style="border-collapse: collapse; padding: 0; vertical-align: top; text-align: left; border-spacing: 0; width: 580px; margin: 0 auto; text-align: inherit; background-color: #fff;">'
            str += '                  <tr>'
            str += '                    <td>'
            str += '                      <table style="display: block; padding: 0px; position: relative; border-collapse: collapse; padding: 0; vertical-align: top; border-spacing: 0; width: 580px; margin: 0 auto; text-align: inherit; background-color: #fff;">'
            str += '                        <tr>'
            str += '                          <td style="padding: 0px; position: relative;">'
            str += '                            <table style="width: 580px; margin: 0 auto;">'
            str += '                              <tr>'
            str += '                                <td>'
            str += '                                  <h1 style="font-family: Helvetica, Arial, sans-serif; font-weight: bold; font-size: 20px; line-height:30px; padding-left: 40px; padding-right: 40px;">' + emailBody + '</h1>'
            str += '                                  <div style="width: 520px; margin: 0 auto; text-align: center;"><hr></div>'
            str += '                                </td>'
            str += '                              </tr>'
            str += '                            </table>'
            str += '                          </td>'
            str += '                        </tr>'
            str += '                      </table>'
            str += '                    </td>'
            str += '                  </tr>'
            str += '                </table>'
            str += '                <table style="border-collapse: collapse; padding: 0; vertical-align: top; text-align: left; border-spacing: 0; width: 580px; display: block; position: relative; background-color: #fff;">'
            str += '                  <tr>'
            str += '                    <td align="center" style="text-align: center; padding: 0px; position: relative;">'
            str += '                      <table style="display: block; padding: 0px; width: 450px; border-collapse: collapse; vertical-align: top; border-spacing: 0; margin: 0 auto; background-color: #fff;">'
            str += '                        <tr>'
            str += '                          <td style="text-align: center;">'
            str += '                            <p style="width: 580px; font-family: Helvetica, Arial, sans-serif; font-weight: normal; font-size: 11px; color: #4f4f4f; text-align: center; margin-top: -10px;">&copy;2018 All rights reserved  |  Confidential  |  For Syneos Health&tm; use only</p>'
            str += '                          </td>'
            str += '                        </tr>'
            str += '                      </table>'
            str += '                    </td>'
            str += '                  </tr>'
            str += '                </table>'
            str += '              </center>'
            str += '            </td>'
            str += '          </tr>'
            str += '        </table>'
            str += '      </td>'
            str += '    </tr>'
            str += '  </table>'
            str += '</body>'

            return str

          # ---------------------------------------------

          # generate HTML
          create: (response) ->

            console.log '[ EMAIL ][ create: response ]', response

            data = response.data

            str = @createHTML data, response

            # switch response.action
            #   when 'completed'
            #     str = @createCompleted data, response
            #   when 'rejected'
            #     str = @createRejected data, response

            return str

          # ---------------------------------------------------------------------------

          _send: (response, str) ->

            console.log '[ ++++++++++++++++++++++++++++ ]'
            console.log '[ EMAIL ][ _send: response ]', response
            console.log '[ EMAIL ][ _send: str ]', str
            console.log '[ ++++++++++++++++++++++++++++ ]'

            # set up a promise
            deferred = $q.defer()

            # build the email api data object
            data =
              to: Email.to
              from: 'SHARP <no-reply@gettingsharp.com>'
              replyTo: 'SHARP <no-reply@gettingsharp.com>'
              cc: null
              bcc: ['jangello@bocodigital.com', 'eric@latenightfactory.com']
              # bcc: ['eric.emmons@bocodigital.com', 'stephen.mcdonald@bocodigital.com']
              subject: Email.subject
              message: str

            # DEBUG
            console.log "[ EMAIL ][ _send: sending email ]", data

            # if working locally we can use our localhost usually
            # if $rootScope.localhost
            #   @url = 'http://localhost:3000/api/email/send/'

            #! THIS IS STOPPING THE SEND
            # console.log "[ EMAIL ] STOP"
            # return $q.when()

            # send
            $http.post(@url, data).then (resp) ->

              # DEBUG
              console.log "\t%c Emails sent.", "color: #008000"
              console.log resp

              # finish promise
              deferred.resolve()

            # send back the promise
            deferred.promise

          # ---------------------------------------------------------------------------
    ]