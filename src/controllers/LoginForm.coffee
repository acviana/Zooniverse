$ = require '../jQuery'
User = require '../models/user'
Controller = require './controller'
templates = require '../views/LoginForm'

class BaseForm extends Controller
  events:
    sumbit: 'onSubmit'
    keydown: 'onInputChange'
    change: 'onInputChange'

  elements:
    '.errors': 'errors'
    'input[name="username"]': 'usernameField'
    'input[name="email"]': 'emailField'
    'input[name="password"]': 'passwordField'
    'input[name="password-confirm"]': 'passwordCOnfirmField'
    'input[name="policy"]': 'submitButton'
    'button[type="submit"]': 'submitButton'
    '.progress': 'progress'
    'input[required]': 'requiredInputs'

  constructor:
    super
    @html @template

    User.bind '
