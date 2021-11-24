//
// --------------------------------------------------------------------------
//  Gurux Ltd
// 
//
//
// Filename:        $HeadURL$
//
// Version:         $Revision$,
//                  $Date$
//                  $Author$
//
// Copyright (c) Gurux Ltd
//
//---------------------------------------------------------------------------
//
//  DESCRIPTION
//
// This file is a part of Gurux Device Framework.
//
// Gurux Device Framework is Open Source software; you can redistribute it
// and/or modify it under the terms of the GNU General Public License 
// as published by the Free Software Foundation; version 2 of the License.
// Gurux Device Framework is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of 
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. 
// See the GNU General Public License for more details.
//
// This code is licensed under the GNU General Public License v2. 
// Full text may be retrieved at http://www.gnu.org/licenses/gpl-2.0.txt
//---------------------------------------------------------------------------

unit Gurux.DLMS.ErrorCode;

interface
type

//  Enumerated DLMS error codes.
TErrorCode =
(
// Disconnect Mode.
ecDisconnectMode = -4,
// Receive Not Ready.
ecReceiveNotReady = -3,
// Connection is rejected.
ecRejected = -2,
// Unacceptable frame.
ecUnacceptableFrame = -1,
// No error has occurred.
ecOk = 0,
// Access Error : Device reports a hardware fault.
ecHardwareFault = 1,
// Access Error : Device reports a temporary failure.
ecTemporaryFailure = 2,
// Access Error : Device reports Read-Write denied.
ecReadWriteDenied = 3,
// Access Error : Device reports a undefined object.
ecUndefinedObject = 4,
// Access Error : Device reports a inconsistent Class or object.
ecInconsistentClass = 9,
// Access Error : Device reports a unavailable object.
ecUnavailableObject = 11,
// Access Error : Device reports a unmatched type.
ecUnmatchedType = 12,
// Access Error : Device reports scope of access violated.
ecAccessViolated = 13,
// Access Error : Data Block Unavailable.
ecDataBlockUnavailable = 14,
// Access Error : Long Get Or Read Aborted.
ecLongGetOrReadAborted = 15,
// Access Error : No Long Get Or Read In Progress.
ecNoLongGetOrReadInProgress = 16,
// Access Error : Long Set Or Write Aborted.
ecLongSetOrWriteAborted = 17,
// Access Error : No Long Set Or Write In Progress.
ecNoLongSetOrWriteInProgress = 18,
// Access Error : Data Block Number Invalid.
ecDataBlockNumberInvalid = 19,
// Access Error : Other Reason.
ecOtherReason = 250);
implementation

end.
