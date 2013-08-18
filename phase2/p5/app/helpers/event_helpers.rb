helpers do
  def error_class?(attr_name, errors)
    "style='border: 1px solid red'" if errors.keys.include? attr_name
  end
end
