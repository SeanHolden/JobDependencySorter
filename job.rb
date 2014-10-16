class Job
  def sort(input='')
    return error_message( validate(input) ) unless validate(input) == 'valid'
  end


  private

  def validate(input)
    if !input.kind_of? String
      "non_string"
    elsif input.empty?
      "no_argument"
    else
      "valid"
    end
  end

  # Method to simply return error messsages
  def error_message(error_type)
    case error_type
    when 'non_string'
      "Error: Input must be a comma separated string."
    when 'no_argument'
      "Note: An argument must be entered."
    end
  end
end
