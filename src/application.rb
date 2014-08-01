require_relative 'stdlib/class'
require_relative 'solver/solver'
require_relative 'solver/backtracking_solver'
require_relative 'provider/provider'
require_relative 'provider/file_provider'

##
# {Application} is the engine of the sudoku solver.
# It uses a {Provider} to retrieve a {BoardState} and a {Solver} to configure the {BoardState} as close to a solution
# as possible. If the solution is found from the {Application.run!} method, a triple of
# ({Provider}, {BoardState}, Boolean)
# It declares a {Application::DEFAULT_PROVIDER} and {Application::DEFAULT_SOLVER}, both of which can be configured
# separately when the {Application.run!} function is invoked.
#
# @see Application.run!
class Application

  # Constants

  # The default {Provider} is {FileProvider}
  DEFAULT_PROVIDER=FileProvider

  # The default {Solver} is {BacktrackingSolver}.
  DEFAULT_SOLVER=BacktrackingSolver

  # Runs the {Application} by getting the {BoardState} from the {Provider} and then having {Solver#solve} interact with it
  #
  # @param provider_type [Class] The {Provider} sub-type used to get the {BoardState}.
  # @param solver_type [Class] The {Solver} sub-type used to search for a sudoku configuration in the {BoardState}.
  #
  # @return [(Provider, BoardState, Boolean)] Returns a triple of ({Provider}, {BoardState}, Boolean) containing the {Provider} used to get the {BoardState} and a Boolean to indicate if the run was successful (true) or not (false).
  def self.run!(provider_type, solver_type)
    solver_type.new.solve provider_type
  end

  # Returns a {Provider} sub-type based on name, if available.
  #
  # @param provider_name [String] The name of the requested {Provider} sub-type.
  #
  # @return [Class] Returns a {Provider} sub-type based on name, if available.
  def self.get_provider_type(provider_name)
    Provider.descendants.find do |clazz|
      clazz::PROVIDER_NAME == provider_name
    end
  end

  # Returns a {Solver} sub-type based on name, if available.
  #
  # @param solver_name [String] The name of the requested {Solver} sub-type.
  #
  # @return [Class] Returns a {Solver} sub-type based on name, if available.
  def self.get_solver_type(solver_name)
    Solver.descendants.find do |clazz|
      clazz::SOLVER_NAME == solver_name
    end
  end

end