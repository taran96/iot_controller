defmodule IotController.Shadow do

  defmodule State do
    defstruct desired: nil, reported: nil, delta: nil
  end

  defmodule Metadata do
    defstruct desired: nil, reported: nil
  end

  defstruct state: State, metadata: Metadata
end
