defmodule Joel.Application do
  @moduledoc false

  use Application

  def start(_type, _args) do
    children = [
      {Nosedrum.Interactor.Dispatcher, name: Nosedrum.Interactor.Dispatcher},
      Joel.Consumer
    ]

    opts = [strategy: :one_for_one, name: Joel.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
