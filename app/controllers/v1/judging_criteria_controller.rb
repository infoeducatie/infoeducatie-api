module V1
  class JudgingCriteriaController < ApiController
    def index
      @judging_criteria = JudgingCriterion.active.ordered
    end
  end
end
