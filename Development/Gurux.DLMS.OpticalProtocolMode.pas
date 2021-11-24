unit Gurux.DLMS.OpticalProtocolMode;

interface

type

// Defines the protocol used by the meter on the port.
TOpticalProtocolMode =
(
    /// <summary>
    /// Protocol according to IEC 62056-21 (modes A…E),
    /// </summary>
    Default,
    /// <summary>
    /// Protocol according to IEC 62056-46.
    /// Using this enumeration value all other attributes of this IC are not applicable.
    /// </summary>
    Net,
    /// <summary>
    /// Protocol not specified. Using this enumeration value,
    /// ProposedBaudrate is used for setting the communication speed on the port.
    /// All other attributes are not applicable.
    /// </summary>
    Unknown
);

implementation

end.
