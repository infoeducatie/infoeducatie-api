module V1
  class SponsorsController < ApiController
    def index
      @sponsor_tiers = SponsorTier
        .joins(:sponsors)
        .merge(Sponsor.active)
        .distinct
        .ordered
        .preload(:active_sponsors)
    end
  end
end
