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

unit Gurux.DLMS.AccountCreditStatus;

interface

type
  //Credit status.
  TAccountCreditStatus = (
    // In credit.
    InCredit = $1,
    // Low credit.
    LowCredit = $2,
    // Next credit enabled.
    NextCreditEnabled = $4,
    // Next credit selectable.
    NextCreditSelectable = $8,
    // Credit reference list.
    CreditReferenceList = $10,
    // Selectable credit in use.
    SelectableCreditInUse = $20,
    // Out of credit.
    OutOfCredit = $40,
    // Reserved.
    Reserved = $80
  );

implementation

end.
