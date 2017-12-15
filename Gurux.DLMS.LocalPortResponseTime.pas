unit Gurux.DLMS.LocalPortResponseTime;

interface

type

/// <summary>
/// Defines the minimum time between the reception of a request
/// (end of request telegram) and the transmission of the response (begin of response telegram).
/// </summary>
TLocalPortResponseTime =
(
    /// <summary>
    /// Minimium time is 20 ms.
    /// </summary>
    ms20,
    /// <summary>
    /// Minimium time is 200 ms.
    /// </summary>
    ms200
);

implementation

end.
