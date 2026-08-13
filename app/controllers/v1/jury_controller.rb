module V1
  class JuryController < ApiController
    def index
      @jury_categories = JuryCategory
        .active
        .joins(:jury_members)
        .merge(JuryMember.active)
        .distinct
        .ordered
        .preload(:active_jury_members)
    end
  end
end
