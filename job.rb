class Job
  def sort(input='')
    return error_message unless input.kind_of? String
  end

  def error_message
    "Error: Input must be a comma separated string."
  end
end
