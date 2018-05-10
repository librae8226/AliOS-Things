NAME := msp432
HOST_OPENOCD := msp432
$(NAME)_TYPE := kernel

$(NAME)_COMPONENTS += platform/arch/arm/armv7m
$(NAME)_COMPONENTS += libc rhino hal vfs digest_algorithm

GLOBAL_DEFINES += CONFIG_AOS_KV_MULTIPTN_MODE
GLOBAL_DEFINES += CONFIG_AOS_KV_PTN=6
GLOBAL_DEFINES += CONFIG_AOS_KV_SECOND_PTN=7
GLOBAL_DEFINES += CONFIG_AOS_KV_PTN_SIZE=4096
GLOBAL_DEFINES += CONFIG_AOS_KV_BUFFER_SIZE=8192
GLOBAL_DEFINES += __BSD_VISIBLE
GLOBAL_DEFINES += __MSP432P401R__
GLOBAL_DEFINES += TARGET_IS_MSP432P4XX
GLOBAL_DEFINES += MX_DEBUG

GLOBAL_INCLUDES += \
		   IOT-MSP432/examples/MSP432P4xx/mxchip/iot_sdk \
		   IOT-MSP432/examples/MSP432P4xx/mxchip/iot_sdk/Board \
		   IOT-MSP432/examples/MSP432P4xx/mxchip/iot_sdk/Board/drv_button \
		   IOT-MSP432/examples/MSP432P4xx/mxchip/iot_sdk/Board/drv_color_led \
		   IOT-MSP432/examples/MSP432P4xx/mxchip/iot_sdk/Board/drv_sht20 \
		   IOT-MSP432/examples/MSP432P4xx/mxchip/iot_sdk/Board/drv_VGM128064 \
		   IOT-MSP432/examples/MSP432P4xx/mxchip/iot_sdk/Board/helper \
		   IOT-MSP432/examples/MSP432P4xx/mxchip/iot_sdk/Board/helper/hal \
		   IOT-MSP432/examples/MSP432P4xx/mxchip/iot_sdk/Board/AliCloud_SDS \
		   IOT-MSP432/examples/MSP432P4xx/mxchip/iot_sdk/Board/helper/emhost \
		   IOT-MSP432/examples/MSP432P4xx/mxchip/iot_sdk/Board/helper/jsmn \
		   IOT-MSP432 \
		   IOT-MSP432/inc \
		   IOT-MSP432/inc/CMSIS \
		   IOT-MSP432/driverlib/MSP432P4xx

$(NAME)_SOURCES := \
		IOT-MSP432/examples/MSP432P4xx/mxchip/iot_sdk/app_console.c \
		IOT-MSP432/examples/MSP432P4xx/mxchip/iot_sdk/app_rgbled.c \
		IOT-MSP432/examples/MSP432P4xx/mxchip/iot_sdk/app_sht20.c \
		IOT-MSP432/examples/MSP432P4xx/mxchip/iot_sdk/app_switch.c \
		IOT-MSP432/examples/MSP432P4xx/mxchip/iot_sdk/startup_msp432p401r_gcc.c \
		IOT-MSP432/examples/MSP432P4xx/mxchip/iot_sdk/system_msp432p401r.c \
		IOT-MSP432/examples/MSP432P4xx/mxchip/iot_sdk/Board/AliCloud_SDS/alicloud_sds.c \
		IOT-MSP432/examples/MSP432P4xx/mxchip/iot_sdk/Board/drv_VGM128064/oled.c \
		IOT-MSP432/examples/MSP432P4xx/mxchip/iot_sdk/Board/drv_board.c \
		IOT-MSP432/examples/MSP432P4xx/mxchip/iot_sdk/Board/drv_board_test.c \
		IOT-MSP432/examples/MSP432P4xx/mxchip/iot_sdk/Board/drv_button/io_button.c \
		IOT-MSP432/examples/MSP432P4xx/mxchip/iot_sdk/Board/drv_color_led/color_led.c \
		IOT-MSP432/examples/MSP432P4xx/mxchip/iot_sdk/Board/drv_color_led/hsb2rgb.c \
		IOT-MSP432/examples/MSP432P4xx/mxchip/iot_sdk/Board/drv_sht20/sht2x.c \
		IOT-MSP432/examples/MSP432P4xx/mxchip/iot_sdk/Board/helper/emhost/ATCmdParser/ATCmdParser.c \
		IOT-MSP432/examples/MSP432P4xx/mxchip/iot_sdk/Board/helper/emhost/ATCmdParser/ATCmdParserTest.c \
		IOT-MSP432/examples/MSP432P4xx/mxchip/iot_sdk/Board/helper/emhost/emh_alisds.c \
		IOT-MSP432/examples/MSP432P4xx/mxchip/iot_sdk/Board/helper/emhost/emh_arg.c \
		IOT-MSP432/examples/MSP432P4xx/mxchip/iot_sdk/Board/helper/emhost/emh_module.c \
		IOT-MSP432/examples/MSP432P4xx/mxchip/iot_sdk/Board/helper/emhost/emh_wlan.c \
		IOT-MSP432/examples/MSP432P4xx/mxchip/iot_sdk/Board/helper/hal/mx_hal_atomic.c \
		IOT-MSP432/examples/MSP432P4xx/mxchip/iot_sdk/Board/helper/hal/mx_i2c.c \
		IOT-MSP432/examples/MSP432P4xx/mxchip/iot_sdk/Board/helper/hal/mx_serial.c \
		IOT-MSP432/examples/MSP432P4xx/mxchip/iot_sdk/Board/helper/hal/mx_stdio.c \
		IOT-MSP432/examples/MSP432P4xx/mxchip/iot_sdk/Board/helper/hal/mx_tick.c \
		IOT-MSP432/examples/MSP432P4xx/mxchip/iot_sdk/Board/helper/jsmn/jsmn.c \
		IOT-MSP432/examples/MSP432P4xx/mxchip/iot_sdk/Board/helper/jsmn/json_escape_str.c \
		IOT-MSP432/examples/MSP432P4xx/mxchip/iot_sdk/Board/helper/jsmn/json_generator.c \
		IOT-MSP432/examples/MSP432P4xx/mxchip/iot_sdk/Board/helper/jsmn/json_utils.c \
		IOT-MSP432/examples/MSP432P4xx/mxchip/iot_sdk/Board/helper/jsmn/json_wrappers.c \
		IOT-MSP432/examples/MSP432P4xx/mxchip/iot_sdk/Board/helper/mx_utils/mx_ringbuffer.c

$(NAME)_SOURCES += \
                   aos/aos.c \
		   aos/soc_impl.c \
		   aos/trace_impl.c \
		   hal/hw.c

#$(NAME)_PREBUILT_LIBRARY += \
		IOT-MSP432/examples/MSP432P4xx/mxchip/iot_sdk/msp432p4xx_driverlib.a

ifeq ($(COMPILER),armcc)
GLOBAL_CFLAGS   += --c99 --cpu=Cortex-M4 --apcs=/hardfp --fpu=vfpv4_sp_d16 -D__MICROLIB -g --split_sections
else ifeq ($(COMPILER),iar)
GLOBAL_CFLAGS += --cpu=Cortex-M4 \
                 --cpu_mode=thumb \
                 --endian=little
else
GLOBAL_CFLAGS += -mcpu=cortex-m4 \
                 -march=armv7-m  \
                 -mlittle-endian \
                 -mthumb -mthumb-interwork \
                 -mfloat-abi=hard \
                 -mfpu=fpv4-sp-d16 \
                 -w
GLOBAL_CFLAGS  += -D__VFP_FP__
endif

ifeq ($(COMPILER),armcc)
GLOBAL_ASMFLAGS += --cpu=Cortex-M4 -g --apcs=/hardfp --fpu=vfpv4_sp_d16 --library_type=microlib --pd "__MICROLIB SETA 1"
else ifeq ($(COMPILER),iar)
GLOBAL_ASMFLAGS += --cpu Cortex-M4 \
                   --cpu_mode thumb \
                   --endian little
else
GLOBAL_ASMFLAGS += -mcpu=cortex-m4 \
                   -mlittle-endian \
                   -mthumb \
                   -mfloat-abi=hard \
                   -mfpu=fpv4-sp-d16 \
                   -w
endif

ifeq ($(COMPILER),armcc)
GLOBAL_LDFLAGS += -L --cpu=Cortex-M4   \
                  -L --fpu=vfpv4_sp_d16 \
                  -L --apcs=/hardfp \
                  -L --strict \
                  -L --xref -L --callgraph -L --symbols \
                  -L --info=sizes -L --info=totals -L --info=unused -L --info=veneers -L --info=summarysizes
else ifeq ($(COMPILER),iar)
GLOBAL_LDFLAGS += --silent --cpu=Cortex-M4.vfp

else
GLOBAL_LDFLAGS += -mcpu=cortex-m4  \
                  -mlittle-endian  \
                  -mthumb -mthumb-interwork \
                  --specs=nosys.specs \
                  -mfloat-abi=hard \
                  -mfpu=fpv4-sp-d16 \
                  $(CLIB_LDFLAGS_NANO_FLOAT)
endif
