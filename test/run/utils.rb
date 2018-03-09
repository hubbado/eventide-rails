module Utils

  def self.included(mod)
    mod.extend ClassMethods
  end

  module ClassMethods
    def delegate(*keys, to:)
      keys.each do |key|
        define_method(key) do |*args, &block|
          obj = to.to_s.start_with?('@') ? instance_variable_get(to) : send(to)
          obj.public_send(key, *args, &block)
        end
      end
    end
  end
end