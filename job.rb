class Job

  def initialize(input='')
    error_message unless check(input) == 'valid'
    self.unsorted_string = input
  end

  def sort
    unsorted_string
  end

  private

  def unsorted_string=(input)
    @unsorted_string ||= input
  end

  def unsorted_string
    @unsorted_string
  end

  def check(input)
    if !input.kind_of? String
      @input_invalid = "Error: Input must be a comma separated string."
    elsif input.empty?
      @input_invalid = "Error: An argument must be entered."
    else
      "valid"
    end
  end

  def error_message  
    raise ArgumentError.new, @input_invalid
  end

end

