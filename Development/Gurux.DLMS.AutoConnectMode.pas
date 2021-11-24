unit Gurux.DLMS.AutoConnectMode;

interface

type

/// Defines the mode controlling the auto dial functionality concerning the timing.

TAutoConnectMode =
(
  /// <summary>
  /// No auto dialling,
  /// </summary>
  NoAutoDialling,
  /// <summary>
  /// Auto dialling allowed anytime,
  /// </summary>
  AutoDiallingAllowedAnytime,
  /// <summary>
  /// Auto dialling allowed within the validity time of the calling window.
  /// </summary>
  AutoDiallingAllowedCallingWindow,
  /// <summary>
  /// “regular” auto dialling allowed within the validity time
  /// of the calling window; “alarm” initiated auto dialling allowed anytime,
  /// </summary>
  RegularAutoDiallingAllowedCallingWindow,
  /// <summary>
  /// SMS sending via Public Land Mobile Network (PLMN),
  /// </summary>
  SmsSendingPlmn,
  /// <summary>
  /// SMS sending via PSTN.
  /// </summary>
  SmsSendingPstn,
  /// <summary>
  /// Email sending.
  /// </summary>
  EmailSending
  //(200..255) manufacturer specific modes
);

implementation

end.
