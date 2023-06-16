module CustomerHelper
  def fieldset_disabled
    if action_name == 'show'
      'disabled-form'
    end
  end
end
