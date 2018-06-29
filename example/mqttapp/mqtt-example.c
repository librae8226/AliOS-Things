/*
 * Copyright (C) 2015-2017 Alibaba Group Holding Limited
 */

#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "iot_import.h"
#include "iot_export.h"
#include "aos/log.h"
#include "aos/yloop.h"
#include "aos/network.h"
#include "aos/uData.h"
#include <netmgr.h>
#include <aos/kernel.h>
#include <netmgr.h>
#include <aos/cli.h>
#include <aos/cloud.h>
#include "iot_export_mqtt.h"
#include "mqtt_instance.h"

#ifdef AOS_ATCMD
#include <atparser.h>
#endif

typedef struct {
    char productKey[16];
    char deviceName[32];
    char deviceSecret[48];

    int max_msg_size;
    int max_msgq_size;
    int connected;
    int (*event_handler)(int event_type, void *ctx);
    int (*delete_subdev)(char *productKey, char *deviceName, void *ctx);
    void *ctx;
} MqttContext;

// These are pre-defined topics
#define TOPIC_UPDATE            "/"PRODUCT_KEY"/"DEVICE_NAME"/update"
#define TOPIC_ERROR             "/"PRODUCT_KEY"/"DEVICE_NAME"/update/error"
#define TOPIC_GET               "/"PRODUCT_KEY"/"DEVICE_NAME"/get"
#define TOPIC_DATA		        "/"PRODUCT_KEY"/"DEVICE_NAME"/data"

#define MSG_LEN_MAX             (2048)

char msg_pub[128];
static char temperature[5] = {0}, humidity[5] = {0};

int mqtt_client_example(void);

void uData_report_demo(input_event_t *event, void *priv_data)
{
    udata_pkg_t buf;
    if ((event == NULL) || (event->type != EV_UDATA)) {
        return;
    }

    if (event->code == CODE_UDATA_REPORT_PUBLISH) {
        int ret = 0;
        ret = uData_report_publish(event, &buf);
        if (ret != 0) {
            return;
        }
        switch (buf.type) {
            case UDATA_SERVICE_TEMP: {
                temperature_data_t *temp = (temperature_data_t *)buf.payload;
                //printf("temp: %.2f\n", temp->t/10.0f);
                snprintf(temperature, sizeof(temperature), "%.2f", temp->t/10.0f);
                printf("%s\n", temperature);
                break;
            }

            case UDATA_SERVICE_HUMI: {
                humidity_data_t *humi = (humidity_data_t *)buf.payload;
                //printf("humi: %.2f\n", humi->h/10.0f);
                snprintf(humidity, sizeof(humidity), "%.2f", humi->h/10.0f);
                printf("%s\n", humidity);
                break;
            }
            default:
                break;
        }
    }
}

static int udata_sample(void)
{
    int ret = 0;

    aos_register_event_filter(EV_UDATA, uData_report_demo, NULL);

    ret = uData_subscribe(UDATA_SERVICE_HUMI);
    if (ret != 0) {
        LOG("%s %s %s %d\n", uDATA_STR, __func__, ERROR_LINE, __LINE__);
        return -1;
    }

    ret = uData_subscribe(UDATA_SERVICE_TEMP);
    if (ret != 0) {
        LOG("%s %s %s %d\n", uDATA_STR, __func__, ERROR_LINE, __LINE__);
        return -1;
    }

    return 0;
}

static void wifi_service_event(input_event_t *event, void *priv_data)
{
    if (event->type != EV_WIFI) {
        return;
    }

    if (event->code != CODE_WIFI_ON_GOT_IP) {
        return;
    }
    LOG("wifi_service_event!");
    mqtt_client_example();
    udata_sample();
}

static void mqtt_sub_callback(char *topic, int topic_len, void *payload, int payload_len, void *ctx)
{
    LOG("----");
    LOG("Topic: '%.*s' (Length: %d)",
        topic_len,
        topic,
        topic_len);
    LOG("Payload: '%.*s' (Length: %d)",
        payload_len,
        (char *)payload,
        payload_len);
    LOG("----");
}

/*
 * Subscribe the topic: IOT_MQTT_Subscribe(pclient, TOPIC_DATA, IOTX_MQTT_QOS1, _demo_message_arrive, NULL);
 * Publish the topic: IOT_MQTT_Publish(pclient, TOPIC_DATA, &topic_msg);
 */
static void mqtt_work(void *parms)
{

    int rc = -1;

    int msg_len = snprintf(msg_pub, sizeof(msg_pub), "{\"temperature\":\"%s\", \"humidity\":\"%s\"}", temperature, humidity);
    if (msg_len < 0) {
	    LOG("Error occur! Exit program");
    }
    rc = mqtt_publish(TOPIC_DATA, IOTX_MQTT_QOS0, msg_pub, msg_len);
    if (rc < 0) {
	    LOG("error occur when publish");
    }

    LOG("packet-id=%u, publish topic msg=%s", (uint32_t)rc, msg_pub);
    aos_post_delayed_action(3000, mqtt_work, NULL);
}

static void mqtt_service_event(input_event_t *event, void *priv_data)
{

    if (event->type != EV_SYS) {
        return;
    }

    if (event->code != CODE_SYS_ON_MQTT_READ) {
        return;
    }
    LOG("mqtt_service_event!");
    mqtt_work(NULL);
}

static MqttContext mqtt;

int mqtt_client_example(void)
{
    memset(&mqtt, 0, sizeof(MqttContext));

    strncpy(mqtt.productKey,   PRODUCT_KEY,   sizeof(mqtt.productKey)   - 1);
    strncpy(mqtt.deviceName,   DEVICE_NAME,   sizeof(mqtt.deviceName)   - 1);
    strncpy(mqtt.deviceSecret, DEVICE_SECRET, sizeof(mqtt.deviceSecret) - 1);

    mqtt.max_msg_size = MSG_LEN_MAX;
    mqtt.max_msgq_size = 8;

    mqtt.event_handler = NULL;
    mqtt.delete_subdev = NULL;
    if (mqtt_init_instance(mqtt.productKey, mqtt.deviceName, mqtt.deviceSecret, mqtt.max_msg_size) < 0) {
        LOG("mqtt_init_instance failed\n");
        return -1;
    }
    aos_register_event_filter(EV_SYS,  mqtt_service_event, NULL);

    return 0;

}

#ifdef AOS_ATCMD
static void at_uart_configure(uart_dev_t *u)
{
    u->port                = AT_UART_PORT;
    u->config.baud_rate    = AT_UART_BAUDRATE;
    u->config.data_width   = AT_UART_DATA_WIDTH;
    u->config.parity       = AT_UART_PARITY;
    u->config.stop_bits    = AT_UART_STOP_BITS;
    u->config.flow_control = AT_UART_FLOW_CONTROL;
}
#endif

int application_start(int argc, char *argv[])
{
#if AOS_ATCMD
    at.set_mode(ASYN);
    at.init(AT_RECV_PREFIX, AT_RECV_SUCCESS_POSTFIX,
            AT_RECV_FAIL_POSTFIX, AT_SEND_DELIMITER, 1000);
#endif

#ifdef WITH_SAL
    sal_init();
#elif defined (CSP_LINUXHOST)
    aos_post_event(EV_WIFI, CODE_WIFI_ON_GOT_IP, 0u);
#endif

    aos_set_log_level(AOS_LL_DEBUG);

    aos_register_event_filter(EV_WIFI, wifi_service_event, NULL);

    netmgr_init();
    netmgr_start(false);

    aos_loop_run();
    return 0;
}