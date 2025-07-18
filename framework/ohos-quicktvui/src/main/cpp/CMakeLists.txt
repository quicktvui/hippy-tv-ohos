
# 对于需要源码依赖 Hippy c++ 代码的特别需求，需要做2点：
# 1 集成 Hippy c++ 源码，生成使用方自己的 so，类似下面配置。
# 2 Hippy 内部不再编译 hippy so，注释掉 Hippy/framework/ohos/src/main/cpp/CMakeLists.txt 里内容。


cmake_minimum_required(VERSION 3.5.0)

project(quicktvui)

set(QUICK_TV_UI_ROOT_DIR "${CMAKE_CURRENT_SOURCE_DIR}/../../")
set(PROJECT_ROOT_DIR "${QUICK_TV_UI_ROOT_DIR}/../../../")
set(HIPPY_ROOT_DIR "${PROJECT_ROOT_DIR}/framework/ohos/")
set(HIPPY_IMPL_CPP_DIR "${HIPPY_ROOT_DIR}/src/main/cpp/impl")

add_subdirectory("${HIPPY_IMPL_CPP_DIR}" ./hippy_impl)

add_library(quicktvui SHARED)

target_link_libraries(quicktvui PUBLIC hippy_impl)

set(SOURCE_SET
  quicktvui/src/event_view.cc
  )
set(PUBLIC_SOURCE_SET
  quicktvui/src/view_provider.cc
  )

target_sources(${PROJECT_NAME} PRIVATE ${SOURCE_SET} PUBLIC ${PUBLIC_SOURCE_SET})

