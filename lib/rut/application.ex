defmodule Rut.Application do
  use Application

  def start(_type, _args) do
    children = []
    opts = [strategy: :one_for_one, name: Rut.Supervisor]
    {:ok, pid} = Supervisor.start_link(children, opts)

    initialize()

    {:ok, pid}
  end

  def initialize() do
    # Currently empty
  end
end