require 'time'
require 'date'

class FlatironAirlines
  # here will be your CLI!
  # it is not an AR class so you need to add attr

  def run
    interface = Interface.new()
    interface.welcome
    # Plane.plane_animation
    #interface.main_menu
  end

  private

  
end


