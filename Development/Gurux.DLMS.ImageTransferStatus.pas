unit Gurux.DLMS.ImageTransferStatus;

interface
type
TImageTransferStatus =
(
    NotInitiated = 0,
    TransferInitiated,
    VerificationInitiated,
    VerificationSuccessful,
    VerificationFailed,
    ActivationInitiated,
    ActivationSuccessful,
    ActivationFailed
);

implementation

end.
