unit Gurux.DLMS.ControlState;

interface

type

// The internal states of the disconnect control object.
TControlState =
(
  // The output_state is set to false and the consumer is disconnected.
  csDisconnected,
  // The output_state is set to true and the consumer is connected.
  csConnected,
  // The output_state is set to false and the consumer is disconnected.
  csReadyForReconnection
);

implementation

end.
