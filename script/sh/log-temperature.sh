#!/bin/bash

## usage: sudo ./log-temperature.sh | tee n0145_0929_temperature.log.rst

## simple script to query for temperature from nvidia-smi, ipmitool
## and display them for login
## use a while loop 

## cuz grafana plugin with nvidia-smi dont currently work


#loopCount=400 # ~20 hours of logging
loopCount=960 # ~8 days of logging @ 5min interval
i=0

ExitCode=0

while [[ $i -lt $loopCount ]]; do
	echo "## *--------------------* ##"
	date
	nvidia-smi --query-gpu=timestamp,gpu_bus_id,temperature.gpu,temperature.memory,power.draw,utilization.gpu,pstate,clocks_throttle_reasons.hw_slowdown,clocks_throttle_reasons.active --format=csv
	ExitCode=$?
	ipmitool sensor | egrep 'Temp|PSU|degree|RPM'
	#sleep 180  ## ie run about every 3 min, ~ 20x/hour
	sleep 300  ## ie run about every 5 min, ~ 12x/hour
	i=$(expr $i + 1)
done


exit $ExitCode

## ref: https://nvidia.custhelp.com/app/answers/detail/a_id/3751/~/useful-nvidia-smi-queries

##
expected output:

Tue Sep 29 13:06:39 PDT 2020

2020/09/29 12:50:08.289, 00000000:1A:00.0, 38, N/A, 0 %, P0, Not Active, 0x0000000000000000
2020/09/29 12:50:08.308, 00000000:1B:00.0, 37, N/A, 0 %, P0, Not Active, 0x0000000000000000
2020/09/29 12:50:08.326, 00000000:60:00.0, 37, N/A, 0 %, P0, Not Active, 0x0000000000000000
2020/09/29 12:50:08.345, 00000000:61:00.0, 39, N/A, 0 %, P0, Not Active, 0x0000000000000000
2020/09/29 12:50:08.361, 00000000:B1:00.0, 39, N/A, 0 %, P0, Not Active, 0x0000000000000000
2020/09/29 12:50:08.378, 00000000:B2:00.0, 40, N/A, 0 %, P0, Not Active, 0x0000000000000000
2020/09/29 12:50:08.395, 00000000:DA:00.0, 37, N/A, 0 %, P0, Not Active, 0x0000000000000000


CPU0_Temp        | 29.000     | degrees C  | ok    | na        | na        | na        | na        | 96.000    | na
P1_MC1_DIMM_CH_F | 27.000     | degrees C  | ok    | na        | na        | na        | na        | 85.000    | na
SYS_Air_Inlet    | 27.000     | degrees C  | ok    | na        | na        | na        | na        | 40.000    | na
SYS_Air_Outlet   | 31.000     | degrees C  | ok    | na        | na        | na        | na        | 70.000    | na


##

nvidia-smi --help info:


   -d,   --display=            Display only selected information: MEMORY,
                                    UTILIZATION, ECC, TEMPERATURE, POWER, CLOCK,
                                    COMPUTE, PIDS, PERFORMANCE, SUPPORTED_CLOCKS,
                                    PAGE_RETIREMENT, ACCOUNTING, ENCODER_STATS, FBC_STATS
                                Flags can be combined with comma e.g. ECC,POWER.
                                Sampling data with max/min/avg is also returned
                                for POWER, UTILIZATION and CLOCK display types.
                                Doesnt work with -u or -x flags.

    --query-gpu=                Information about GPU.
                                Call --help-query-gpu for more info.


	--query-gpu=serial

	fan.speed
	"clocks_throttle_reasons.supported"
	Bitmask of supported clock throttle reasons. See nvml.h for more details.

	"clocks_throttle_reasons.active"
	Bitmask of active clock throttle reasons. See nvml.h for more details.

	"clocks_throttle_reasons.gpu_idle"
	Nothing is running on the GPU and the clocks are dropping to Idle state. This limiter may be removed in a later release.

	"clocks_throttle_reasons.applications_clocks_setting"
	GPU clocks are limited by applications clocks setting. E.g. can be changed by nvidia-smi --applications-clocks=

	"clocks_throttle_reasons.sw_power_cap"
	SW Power Scaling algorithm is reducing the clocks below requested clocks because the GPU is consuming too much power. E.g. SW power cap limit can be changed with nvidia-smi --power-limit=

	"clocks_throttle_reasons.hw_slowdown"
	HW Slowdown (reducing the core clocks by a factor of 2 or more) is engaged. This is an indicator of:
	 HW Thermal Slowdown: temperature being too high
	 HW Power Brake Slowdown: External Power Brake Assertion is triggered (e.g. by the system power supply)
	 * Power draw is too high and Fast Trigger protection is reducing the clocks

	"temperature.gpu"
	 Core GPU temperature. in degrees C.

	"temperature.memory"
	 HBM memory temperature. in degrees C.





dmon

 STATISTICS: (EXPERIMENTAL)
    stats                       Displays device statistics. "nvidia-smi stats -h" for more information.

 Device Monitoring:
    dmon                        Displays device stats in scrolling format.
                                "nvidia-smi dmon -h" for more information.


    -r    --gpu-reset           Trigger reset of the GPU.
                                Can be used to reset the GPU HW state in situations
                                that would otherwise require a machine reboot.
                                Typically useful if a double bit ECC error has
                                occurred.
