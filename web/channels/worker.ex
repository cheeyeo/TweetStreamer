defmodule TwitterPlayground.Worker do
  def greet do
    receive do
      {pid, msg, ref} ->
        for n <- 1..100 do
          send pid, {:work_complete, "Hello: #{msg} #{n} !!!", ref}
        end
        greet()
    end
  end
end
