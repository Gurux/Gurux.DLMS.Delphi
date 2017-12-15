unit Gurux.DLMS.ControlMode;

interface

type

// Configures the behaviour of the disconnect control object for all
// triggers, i.e. the possible state transitions.
TControlMode =
(
  /// The disconnect control object is always in 'connected' state,
  None,
  /// Disconnection: Remote (b, c), manual (f), local (g)
  /// Reconnection: Remote (d), manual (e).
  Mode1,
  /// Disconnection: Remote (b, c), manual (f), local (g)
  /// Reconnection: Remote (a), manual (e).
  Mode2,
  /// Disconnection: Remote (b, c), manual (-), local (g)
  /// Reconnection: Remote (d), manual (e).
  Mode3,
  /// Disconnection: Remote (b, c), manual (-), local (g)
  /// Reconnection: Remote (a), manual (e)
  Mode4,
  /// Disconnection: Remote (b, c), manual (f), local (g)
  /// Reconnection: Remote (d), manual (e), local (h),
  Mode5,
  ///Disconnection: Remote (b, c), manual (-), local (g)
  ///Reconnection: Remote (d), manual (e), local (h)
  Mode6
);

implementation

end.
