unit Gurux.DLMS.SingleActionScheduleType;

interface

type

TSingleActionScheduleType =
(
  // Size of execution_time = 1. Wildcard in date allowed.
  SingleActionScheduleType1,
  // Size of execution_time = n.
  // All time values are the same, wildcards in date not allowed.
  SingleActionScheduleType2,
  // Size of execution_time = n.
  // All time values are the same, wildcards in date are allowed,
  SingleActionScheduleType3,
  // Size of execution_time = n.
  // Time values may be different, wildcards in date not allowed,
  SingleActionScheduleType4,
  // Size of execution_time = n.
  // Time values may be different, wildcards in date are allowed
  SingleActionScheduleType5
);

implementation

end.
