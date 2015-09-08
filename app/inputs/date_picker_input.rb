class DatePickerInput < SimpleForm::Inputs::StringInput
  def input
    input_html_classes.push 'form-control'
    super
  end
  
  def input_html_options
    options[:date] ||= Date.today
    super.merge('data-date' => options[:date])
  end
end