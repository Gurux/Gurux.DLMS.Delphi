unit Gurux.DLMS.ControlMode;

interface

type

/// <summary>
/// Configures the behaviour of the disconnect control object for all
/// triggers, i.e. the possible state transitions.
/// </summary>
TControlMode =
(
  /// <summary>
 /// The disconnect control object is always in 'connected' state,
 /// </summary>
 None,
 /// <summary>
 /// Disconnection: Remote (b, c), manual (f), local (g)
 /// Reconnection: Remote (d), manual (e).
 /// </summary>
 Mode1,
 /// <summary>
 /// Disconnection: Remote (b, c), manual (f), local (g)
 /// Reconnection: Remote (a), manual (e).
 /// </summary>
 Mode2,
 /// <summary>
 /// Disconnection: Remote (b, c), manual (-), local (g)
 /// Reconnection: Remote (d), manual (e).
 /// </summary>
 Mode3,
 /// <summary>
 /// Disconnection: Remote (b, c), manual (-), local (g)
 /// Reconnection: Remote (a), manual (e)
 /// </summary>
 Mode4,
 /// <summary>
 /// Disconnection: Remote (b, c), manual (f), local (g)
 /// Reconnection: Remote (d), manual (e), local (h),
 /// </summary>
 Mode5,
 /// <summary>
 ///Disconnection: Remote (b, c), manual (-), local (g)
 ///Reconnection: Remote (d), manual (e), local (h)
 /// </summary>
 Mode6,
 /// <summary>
 ///Disconnection: Remote (b, c), manual (-), local (g)
 ///Reconnection: Remote (a, i), manual (e), local (h)
 /// </summary>
 Mode7
);

implementation

end.
