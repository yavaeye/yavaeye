module Mongoid
  module Document
    module ClassMethods
      def [] id
        where(_id: id).first
      end
    end
  end
end
