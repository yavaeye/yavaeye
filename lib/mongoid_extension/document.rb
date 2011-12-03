module Mongoid
  module Document
    module ClassMethods
      def find_by_id id
        where(_id: id).first
      end
    end
  end
end
