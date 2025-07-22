module AssigningError
  class AlreadyUsedOnOtherUser < StandardError; end
  class AlreadyUsedByUser < StandardError; end
end