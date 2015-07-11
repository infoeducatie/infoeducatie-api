module V1
  class EditionsController < ApplicationController

    def index
      @editions = Edition.all
    end

  end
end
