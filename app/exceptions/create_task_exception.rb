class CreateTaskException < RuntimeError
  def initialize(message: nil)
    message ||= 'Data da subtarefa não pode ser diferente da tarefa original.'
    super(message)
  end
end