class TaskException < RuntimeError
  def initialize(message: nil)
    message ||= 'Ocorreu um erro durante a manipulação da task.'
    super(message)
  end
end