defmodule IotController.MQTTClient do
  use GenServer
  require Logger

  def start_link() do
    GenServer.start_link(__MODULE__, :ok, [])
  end

  def init(:ok) do
    {:ok, client} = :emqttc.start_link([
      host: to_charlist(Application.get_env(:iot_controller, :endpoint)),
      port: 8883,
      client_id: Application.get_env(:iot_controller, :client_id),
      ssl: [
        certfile: to_charlist(Application.get_env(:iot_controller, :cert_file)),
        keyfile: to_charlist(Application.get_env(:iot_controller, :key_file)),
        cacertfile: to_charlist(Application.get_env(:iot_controller, :root_crt_file)),
      ],
      clean_sess: true,
      keepalive: 60,
      connack_timeout: 30,
      reconnect: {3, 60},
      logger: :debug,
    ])
    {:ok, %{
        client: client,
        devices: [],
        subscriptions: [],
     }}
  end

  defp get_topic(device, action) do
    "$aws/things/#{device}/shadow/#{action}"
  end

  def handle_cast({:subscribe, device, action}, state) do
    :emqttc.subscribe(state[:client], get_topic(device, action))
    {:noreply, Map.put(state, :subscriptions, [{device, action} | state[:subscriptions]])}
  end

  def handle_cast({:unsubscribe, device, action}, state) do
    :emqttc.unsubscribe(state[:client], get_topic(device, action))
    {:noreply, Map.put(state, :subscriptions, List.delete(state[:subscriptions], {device, action}))}
  end

  def handle_cast({:publish, device, action, payload}, state) do
    :emqttc.publish(state[:client], get_topic(device, action), payload)
    {:noreply, state}
  end

  def handle_cast({:add_device, device}, state) do
    {:noreply, Map.put(state, :devices, [device | state[:devices]])}
  end

  def handle_cast({:delete_device, device}, state) do
    {:noreply, Map.put(state, :devices, List.delete(state[:devices], device))}
  end

  def handle_info({:publish, topic, payload}, state) do
    Logger.info "Message received from #{topic}: #{inspect payload}"
    {:noreply, state}
  end

  def handle_info({:mqttc, _pid, :connected}, state) do
    Logger.info "Connected"
    {:noreply, state}
  end

  def handle_info({:mqttc, _pid, :disconnected}, state) do
    Logger.info "Disconnected"
    {:noreply, state}
  end
end
