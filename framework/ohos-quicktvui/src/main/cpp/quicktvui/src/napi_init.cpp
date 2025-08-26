// entry/src/main/cpp/napi_init.cpp
#include <napi/native_api.h>
#include <stdio.h>
#include <hilog/log.h>
// entry/src/main/cpp/napi_init.cpp
#include "../include/layout.h"
using namespace quicktvui::layout;

EXTERN_C_START
// 模块初始化
static napi_value InitModels(napi_env env, napi_value exports) {
    quicktvui::layout::LayoutNapi::Init(env, exports);
    return exports;
}
EXTERN_C_END

// 准备模块加载相关信息，将上述Init函数与本模块名等信息记录下来。
static napi_module demoModule = {
    .nm_version = 1,
    .nm_flags = 0,
    .nm_filename = nullptr,
    .nm_register_func = InitModels,
    .nm_modname = "quicktvui",
    .nm_priv = ((void*)0),
    .reserved = {0},
};

// 加载so时，该函数会自动被调用，将上述demoModule模块注册到系统中。
extern "C" __attribute__((constructor)) void RegisterDemoModule() {
    OH_LOG_INFO(LOG_APP, "NAPI module registered: libquicktvui_native.so");
    napi_module_register(&demoModule);
}


