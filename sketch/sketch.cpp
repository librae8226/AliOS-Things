/*
 * Copyright (C) 2015-2017 Alibaba Group Holding Limited
 */

#if defined (__cplusplus)
extern "C" {
#endif
#include <aos/aos.h>
#include <assert.h>
#if defined (__cplusplus)
}
#endif
#include <cstdio>
#include "cpp_class.h"

static void app_delayed_action(void *arg)
{
    LOG("%s:%d %s\r\n", __func__, __LINE__, aos_task_name());
    aos_post_delayed_action(5000, app_delayed_action, NULL);
}

extern "C" int application_start(int argc, char *argv[])
{
    cpp_class cpp_obj;

    aos_post_delayed_action(1000, app_delayed_action, NULL);

    printf("hello\n");
    cpp_obj.say_hello(42);
    setup();

    aos_loop_run();

    return 0;
}
