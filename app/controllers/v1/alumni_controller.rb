module V1
  class AlumniController < ApplicationController

    def index
      @alumni = Alumnus.all
    end

  end
end
