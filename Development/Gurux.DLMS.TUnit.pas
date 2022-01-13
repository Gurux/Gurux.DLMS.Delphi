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

unit Gurux.DLMS.TUnit;

interface
type
// Unit describes available COSEM unit types.
TUnit =
(
    // No unit is used.
    utNone = 0,
    // Unit is yer.
    utYear = 1,
    // Unit is month.
    utMonth,
    // Unit is week.
    utWeek,
    // Unit is day.
    utDay,
    // Unit is hour.
    utHour,
    // Unit is minute.
    utMinute,
    // Unit is second.
    utSecond,
    // Unit is phase angle degree rad*180/p
    utPhaseAngleDegree,
    // Unit is temperature T degree centigrade
    utTemperature,
    // Local currency is used as unit.
    utLocalCurrency,
    // Length l meter m is used as an unit.
    utLength,
    // Unit is Speed v m/s.
    utSpeed,
    // Unit is Volume V m3.
    utVolumeCubicMeter,
    // Unit is Corrected volume m3.
    utCorrectedVolume,
    // Unit is Volume flux m3/60*60s.
    utVolumeFluxHour,
    // Unit is Corrected volume flux m3/60*60s.
    utCorrectedVolumeFluxHour,
    // Unit is Volume flux m3/24*60*60s.
    utVolumeFluxDay,
    // Unit is Corrected volume flux m3/24*60*60s.
    utCorrecteVolumeFluxDay,
    // Unit is Volume 10-3 m3.
    utVolumeLiter,
    // Unit is Mass m kilogram kg.
    utMassKg,
    // Unit is Force F newton N.
    utForce,
    // Unit is Energy newtonmeter J = Nm = Ws.
    utEnergy,
    // Unit is Pressure p pascal N/m2.
    utPressurePascal,
    // Unit is Pressure p bar 10-5 N/m2.
    utPressureBar,
    // Unit is Energy joule J = Nm = Ws.
    utEnergyJoule,
    // Unit is Thermal power J/60*60s.
    utThermalPower,
    // Unit is Active power P watt W = J/s.
    utActivePower,
    // Unit is Apparent power S.
    utApparentPower,
    // Unit is Reactive power Q.
    utReactivePower,
    // Unit is Active energy W*60*60s.
    utActiveEnergy,
    // Unit is Apparent energy VA*60*60s.
    utApparentEnergy,
    // Unit is Reactive energy var*60*60s.
    utReactiveEnergy,
    // Unit is Current I ampere A.
    utCurrent,
    // Unit is Electrical charge Q coulomb C = As.
    utElectricalCharge,
    // Unit is Voltage.
    utVoltage,
    // Unit is Electrical field strength E V/m.
    utElectricalFieldStrength,
    // Unit is Capacity C farad C/V = As/V.
    utCapacity,
    // Unit is Resistance R ohm = V/A.
    utResistance,
    // Unit is Resistivity.
    utResistivity,
    // Unit is Magnetic flux F weber Wb = Vs.
    utMagneticFlux,
    // Unit is Induction T tesla Wb/m2.
    utInduction,
    // Unit is Magnetic field strength H A/m.
    utMagnetic,
    // Unit is Inductivity L henry H = Wb/A.
    utInductivity,
    // Unit is Frequency f.
    utFrequency,
    // Unit is Active energy meter constant 1/Wh.
    utActive,
    // Unit is Reactive energy meter constant.
    utReactive,
    // Unit is Apparent energy meter constant.
    utApparent,
    // Unit is V260*60s.
    utV260,
    // Unit is A260*60s.
    utA260,
    // Unit is Mass flux kg/s.
    utMassKgPerSecond,
    // Unit is Conductance siemens 1/ohm.
    utConductance,
    // Temperature in Kelvin.
    utKelvin,
    // 1/(V2h) RU2h , volt-squared hour meter constant or pulse value.
    utRU2h,
    // 1/(A2h) RI2h , ampere-squared hour meter constant or pulse value.
    utRI2h,
    // 1/m3 RV , meter constant or pulse value (volume).
    utCubicMeterRV,
    // Percentage
    utPercentage,
    // Ah ampere-hours
    utAmpereHour,
    // Wh/m3 energy per volume 3,6*103 J/m3.
    utEnergyPerVolume = 60,
    // J/m3 calorific value, wobbe.
    utWobbe = 61,
    // Mol % molar fraction of gas composition mole percent (Basic gas composition unit)
    utMolePercent = 62,
    // g/m3 mass density, quantity of material.
    utMassDensity = 63,
    // Pa s dynamic viscosity pascal second (Characteristic of gas stream).
    utPascalSecond = 64,
    // J/kg Specific energy
    // NOTE The amount of energy per unit of mass of a
    // substance Joule / kilogram m2 . kg . s -2 / kg = m2 . s –2
    utJouleKilogram = 65,
    // Pressure, gram per square centimeter.
    utPressureGramPerSquareCentimeter = 66,
    //Pressure, atmosphere.
    utPressureAtmosphere = 67,
    // dBm Signal strength (e.g. of GSM radio systems)
    utSignalStrength = 70,
    // Signal strength, dB microvolt.
    utSignalStrengthMicroVolt = 71,
    // Logarithmic unit that expresses the ratio between two values of a physical quantity
    utdB = 72,
    // Length in inches.
    utInch = 128,
    // Foot (Length).
    utFoot = 129,
    // Pound (mass).
    utPound = 130,
    // Fahrenheit
    utFahrenheit = 131,
    // Rankine
    utRankine = 132,
    // Square inch.
    utSquareInch = 133,
    // Square foot.
    utSquareFoot = 134,
    // Acre
    utAcre = 135,
    // Cubic inch.
    utCubicInch = 136,
    // Cubic foot.
    utCubicFoot = 137,
    // Acre-foot.
    utAcreFoot = 138,
    // Gallon (imperial).
    utGallonImperial = 139,
    // Gallon (US).
    utGallonUS = 140,
    // Pound force.
    utPoundForce = 141,
    // Pound force per square inch
    utPoundForcePerSquareInch = 142,
    // Pound per cubic foot.
    utPoundPerCubicFoot = 143,
    // Pound per (foot second)
    utPoundPerFootSecond = 144,
    // Square foot per second.
    utSquareFootPerSecond = 145,
    // British thermal unit.
    utBritishThermalUnit = 146,
    // Therm EU.
    utThermEU = 147,
    // Therm US.
    utThermUS = 148,
    // British thermal unit per pound.
    utBritishThermalUnitPerPound = 149,
    // British thermal unit per cubic foot.
    utBritishThermalUnitPerCubicFoot = 150,
    // Cubic feet.
    utCubicFeet = 151,
    // Foot per second.
    utFootPerSecond = 152,
    // Cubic foot per second.
    utCubicFootPerSecond = 153,
    // Cubic foot per min.
    utCubicFootPerMin = 154,
    // Cubic foot per hour.
    utCubicFootPerhour = 155,
    // Cubic foot per day
    utCubicFootPerDay = 156,
    // Acre foot per second.
    utAcreFootPerSecond = 157,
    // Acre foot per min.
    utAcreFootPerMin = 158,
    // Acre foot per hour.
    utAcreFootPerHour = 159,
    // Acre foot per day.
    utAcreFootPerDay = 160,
    // Imperial gallon.
    utImperialGallon = 161,
    // Imperial gallon per second.
    utImperialGallonPerSecond = 162,
    // Imperial gallon per min.
    utImperialGallonPerMin = 163,
    // Imperial gallon per hour.
    utImperialGallonPerHour = 164,
    // Imperial gallon per day.
    utImperialGallonPerDay = 165,
    // US gallon.
    utUSGallon = 166,
    // US gallon per second.
    utUSGallonPerSecond = 167,
    // US gallon per min.
    utUSGallonPerMin = 168,
    // US gallon per hour.
    utUSGallonPerHour = 169,
    // US gallon per day.
    utUSGallonPerDay = 170,
    // British thermal unit per second.
    utBritishThermalUnitPerSecond = 171,
    // British thermal unit per minute.
    utBritishThermalUnitPerMinute = 172,
    // British thermal unit per hour.
    utBritishThermalUnitPerHour = 173,
    // British thermal unit per day.
    utBritishThermalUnitPerDay = 174,
    // Other Unit is used.
    utOtherUnit = 254,
    // No Unit is used.
    utNoUnit = 255
);

implementation

end.
