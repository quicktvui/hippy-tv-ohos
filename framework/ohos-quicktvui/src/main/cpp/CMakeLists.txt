
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

include_directories(
${PROJECT_ROOT_DIR}/dom/include
    # 添加 Hippy 核心头文件路径
    ${PROJECT_ROOT_DIR}/dom/include
    ${CMAKE_CURRENT_SOURCE_DIR}/../include/
    # 添加 taitank 头文件路径
    ${CMAKE_CURRENT_BINARY_DIR}/_deps/taitank-src/src
    ${CMAKE_CURRENT_BINARY_DIR}/_deps/taitank-src/include
  )


add_library(quicktvui SHARED
  quicktvui/src/napi_init.cpp
  quicktvui/src/dom_layout.cpp
)

target_link_libraries(quicktvui PUBLIC
  hippy_impl
  )

#  # 设置目标属性
#  set_target_properties(quicktvui PROPERTIES
#      OUTPUT_NAME "quicktvui"
#      PREFIX "lib"
#      SUFFIX ".so"
#  )


# 添加依赖关系，确保 hippy 先编译
#add_dependencies(quicktvui ./hippy_impl)
set(SOURCE_SET
  )
set(PUBLIC_SOURCE_SET
  )

target_sources(${PROJECT_NAME} PRIVATE ${SOURCE_SET} PUBLIC ${PUBLIC_SOURCE_SET})

