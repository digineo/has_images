module HasImages
  module Scope

    def scope_method *args
      if defined?(Rails) && Rails.version >= "3"
        send :scope, *args
      else
        send :named_scope, *args
      end
    end

  end
end
