unit Gurux.DMLS.AddressState;

interface

type

// Defines whether or not the device has been assigned an address
// since last power up of the device.
TAddressState =
(
// Not assigned an address yet.
None,

// Assigned an address either by manual setting, or by automated method.
Assigned
);

implementation

end.
