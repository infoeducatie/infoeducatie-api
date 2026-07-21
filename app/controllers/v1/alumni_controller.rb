module V1
  class AlumniController < ApiController

    def index
      @alumni = Alumnus.all
    end

  end
end
