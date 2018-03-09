class RegisterHandler
  include Messaging::Handle
  include Messaging::StreamName

  dependency :write, Messaging::Postgres::Write

  def configure
    Messaging::Postgres::Write.configure(self)
  end

  category :registry

  handle Command::AddItem do |cmd|
    stream_name = stream_name(cmd.register_uuid)
    event = Event::ItemAdded.follow(cmd)
    write.(event, stream_name)
  end
end