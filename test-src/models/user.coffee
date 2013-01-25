Api = zooniverse.Api
User = zooniverse.models.User

describe 'User', ->
  describe 'on a failed API', ->
    before ->
      @api = new Api
        project: 'test'
        host: "#{location.protocol}//#{location.host}"
        path: '/bad-path-for-user-tests'
        loadTimeout: 100

    beforeEach ->
      User.current?.destroy?()
      User.current = false

    describe 'checking the current user', ->
      it 'triggers "change" with no current user', (done) ->
        User.one 'change', -> done() unless User.current?
        User.fetch()

      it 'triggers "sign-in-error"', (done) ->
        User.one 'sign-in-error', -> done()
        User.fetch()

  describe 'on an available API', ->
    before ->
      @api = new Api
        project: 'test'
        host: "#{location.protocol}//#{location.host}"
        path: '/test/helpers/proxy#for-user-tests'

    beforeEach ->
      User.current?.destroy?()
      User.current = false

    describe 'checking the current user when not signed in', ->
      it 'triggers "change" with no user', (done) ->
        User.one 'change', (e, user) -> done() if user is null
        User.fetch()

      it 'triggers "sign-in-error"', (done) ->
        User.one 'sign-in-error', -> done()
        User.fetch()

    describe 'checking the current user when signed in', ->
      it 'triggers "change" with the current user', (done) ->
        User.one 'change', (e, user) -> done() if user? and user is User.current
        User.fetch testSignedIn: true

    describe 'login', ->
      describe 'with a good username and password', ->
        it 'triggers "change" with the current user', (done) ->
          User.one 'change', (e, user) -> done() if user? and User.current? and user is User.current
          User.login {username: 'clyde', password: 'clyde'}, console.info, console.warn

      describe 'with a bad username or password', ->
        it 'triggers "change" with no user', (done) ->
          User.one 'change', (e, user) -> done() if user is null
          User.login username: 'BAD', password: 'BAD'

        it 'triggers "sign-in-error"', (done) ->
          User.one 'sign-in-error', -> done()
          User.login username: 'BAD', password: 'BAD'

    describe 'logout', ->
      it 'triggers "change" with no current user', (done) ->
        User.one 'change', (e, user) -> done() if user is null
        User.logout()

    describe 'signup', ->
      describe 'when given insufficient data', ->
        it 'triggers "change" with no user', (done) ->
          User.one 'change', (e, user) -> done() if user is null
          User.signup username: 'OKAY', password: 'OKAY'

        it 'triggers "sign-in-error"', (done) ->
          User.one 'sign-in-error', -> done()
          User.signup username: 'OKAY', password: 'OKAY'

      describe 'when given all required data', ->
        it 'triggers "change" with the current user', (done) ->
          User.one 'change', (e, user) -> done() if user? and User.current is user
          User.signup username: 'OKAY', password: 'OKAY', email: 'OKAY'