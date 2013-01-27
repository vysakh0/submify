$("#myModal").on "shown", ->
  $(ClientSideValidations.selectors.forms).validate()
