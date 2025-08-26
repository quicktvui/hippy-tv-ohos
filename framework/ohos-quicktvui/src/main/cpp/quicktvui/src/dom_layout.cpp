#include "dom/taitank_layout_node.h"
#include "napi/native_api.h"
#include "dom/layout_node.h"
#include <unordered_map>
#include <string>

#include <arkui/native_node_napi.h>
#include <js_native_api.h>
#include <js_native_api_types.h>
#include "../include/layout.h"
// napi_init.cpp
// 实现代码...
namespace quicktvui {
inline namespace layout {
using namespace hippy;
using namespace dom;

  template<typename T>
  T GetArg(napi_env env, napi_value value);

  void LayoutNapi::Destructor(napi_env env, void* nativeObject, void* finalize_hint) {
    // 应该是 LayoutNodeWrapper* 而不是 LayoutNapi*
    LayoutNodeWrapper* wrapper = static_cast<LayoutNodeWrapper*>(nativeObject);
    delete wrapper;
}
  LayoutNapi::LayoutNapi()  {}
  LayoutNapi::~LayoutNapi() {}

napi_value LayoutNapi::Constructor(napi_env env, napi_callback_info info) {
    napi_value jsthis;
    napi_get_cb_info(env, info, nullptr, nullptr, &jsthis, nullptr);
    
    // 创建 LayoutNodeWrapper 而不是 LayoutNapi
    auto wrapper = new LayoutNapi::LayoutNodeWrapper();
    wrapper->node = CreateLayoutNode(LayoutEngineType::LayoutEngineTaitank);
    
    napi_wrap(env, jsthis, reinterpret_cast<void*>(wrapper),
              LayoutNapi::Destructor, nullptr, nullptr);
    
    return jsthis;
}


 // 添加基础模板实现（必须要有）
template<typename T>
T GetArg(napi_env env, napi_value value) {
    // 可以抛出异常或返回默认值
    napi_throw_error(env, nullptr, "Unsupported type for GetArg");
    return T();
}

// 现有的特化实现保持不变
template<>
float GetArg<float>(napi_env env, napi_value value) {
    double tmp;
    napi_get_value_double(env, value, &tmp);
    return static_cast<float>(tmp);
}

template<>
int32_t GetArg<int32_t>(napi_env env, napi_value value) {
    int32_t tmp;
    napi_get_value_int32(env, value, &tmp);
    return tmp;
}

template<>
bool GetArg<bool>(napi_env env, napi_value value) {
    bool tmp;
    napi_get_value_bool(env, value, &tmp);
    return tmp;
}

   //包装和拆包
    LayoutNapi::LayoutNodeWrapper* LayoutNapi::UnwrapNode(napi_env env, napi_value thisVar) {
        LayoutNapi::LayoutNodeWrapper* wrapper;
        napi_unwrap(env, thisVar, reinterpret_cast<void**>(&wrapper));
        return wrapper;
    }

  napi_value LayoutNapi::CreateLayoutNodeNapi(napi_env env, napi_callback_info info) {
      size_t argc = 1;
      napi_value args[1];
      napi_get_cb_info(env, info, &argc, args, nullptr, nullptr);

      int32_t typeInt = 0;
      napi_get_value_int32(env, args[0], &typeInt);

      auto wrapper = new LayoutNapi::LayoutNodeWrapper();
      wrapper->node = CreateLayoutNode(static_cast<LayoutEngineType>(typeInt));

      napi_value jsObj;
      napi_create_object(env, &jsObj);
      napi_wrap(env, jsObj, wrapper,
                [](napi_env env, void* data, void*) {
                    delete reinterpret_cast<LayoutNapi::LayoutNodeWrapper*>(data);
                },
                nullptr, nullptr);
      return jsObj;
  }

  // 简化声明宏，绑定无参返回float的方法
  #define DEFINE_LAYOUT_METHOD_FLOAT(name) \
  napi_value LayoutNapi::name##Napi(napi_env env, napi_callback_info info) { \
      napi_value thisVar; \
      napi_get_cb_info(env, info, nullptr, nullptr, &thisVar, nullptr); \
      auto node =  LayoutNapi::UnwrapNode(env, thisVar)->node; \
      float result = node->name(); \
      napi_value jsVal; \
      napi_create_double(env, result, &jsVal); \
      return jsVal; \
  }

  // 绑定无参返回bool
  #define DEFINE_LAYOUT_METHOD_BOOL(name) \
  napi_value LayoutNapi::name##Napi(napi_env env, napi_callback_info info) { \
      napi_value thisVar; \
      napi_get_cb_info(env, info, nullptr, nullptr, &thisVar, nullptr); \
      auto node =  LayoutNapi::UnwrapNode(env, thisVar)->node; \
      bool result = node->name(); \
      napi_value jsVal; \
      napi_get_boolean(env, result, &jsVal); \
      return jsVal; \
  }

  // 绑定带float参数setter
  #define DEFINE_LAYOUT_SETTER_FLOAT(name) \
  napi_value LayoutNapi::Set##name##Napi(napi_env env, napi_callback_info info) { \
      size_t argc = 1; \
      napi_value args[1], thisVar; \
      napi_get_cb_info(env, info, &argc, args, &thisVar, nullptr); \
      auto node =  LayoutNapi::UnwrapNode(env, thisVar)->node; \
      float v = GetArg<float>(env, args[0]); \
      node->Set##name(v); \
      return nullptr; \
  }

  // 绑定带bool参数setter
  #define DEFINE_LAYOUT_SETTER_BOOL(name) \
  napi_value LayoutNapi::Set##name##Napi(napi_env env, napi_callback_info info) { \
      size_t argc = 1; \
      napi_value args[1], thisVar; \
      napi_get_cb_info(env, info, &argc, args, &thisVar, nullptr); \
      bool v = GetArg<bool>(env, args[0]); \
      auto node =  LayoutNapi::UnwrapNode(env, thisVar)->node; \
      node->Set##name(v); \
      return nullptr; \
  }

  DEFINE_LAYOUT_METHOD_FLOAT(GetWidth)
  DEFINE_LAYOUT_METHOD_FLOAT(GetHeight)
  DEFINE_LAYOUT_METHOD_FLOAT(GetLeft)
  DEFINE_LAYOUT_METHOD_FLOAT(GetTop)
  DEFINE_LAYOUT_METHOD_FLOAT(GetRight)
  DEFINE_LAYOUT_METHOD_FLOAT(GetBottom)
  DEFINE_LAYOUT_METHOD_FLOAT(GetStyleWidth)
  DEFINE_LAYOUT_METHOD_FLOAT(GetStyleHeight)

  DEFINE_LAYOUT_SETTER_FLOAT(Width)
  DEFINE_LAYOUT_SETTER_FLOAT(Height)
  DEFINE_LAYOUT_SETTER_FLOAT(MaxWidth)
  DEFINE_LAYOUT_SETTER_FLOAT(MaxHeight)
  DEFINE_LAYOUT_SETTER_FLOAT(ScaleFactor)

  napi_value LayoutNapi::SetPositionNapi(napi_env env, napi_callback_info info) {
      size_t argc = 2;
      napi_value args[2], thisVar;
      napi_get_cb_info(env, info, &argc, args, &thisVar, nullptr);
      auto node =  LayoutNapi::UnwrapNode(env, thisVar)->node;

      int32_t edge;
      napi_get_value_int32(env, args[0], &edge);
      float pos = GetArg<float>(env, args[1]);
      node->SetPosition(static_cast<Edge>(edge), pos);
      return nullptr;
  }

  DEFINE_LAYOUT_METHOD_BOOL(HasNewLayout)
  //DEFINE_LAYOUT_SETTER_BOOL(Set)
  DEFINE_LAYOUT_METHOD_BOOL(IsDirty)

  napi_value LayoutNapi::MarkDirtyNapi(napi_env env, napi_callback_info info) {
      napi_value thisVar;
      napi_get_cb_info(env, info, nullptr, nullptr, &thisVar, nullptr);
      auto node =  LayoutNapi::UnwrapNode(env, thisVar)->node;
      node->MarkDirty();
      return nullptr;
  }

  napi_value LayoutNapi::CalculateLayoutNapi(napi_env env, napi_callback_info info) {
      size_t argc = 2;
      napi_value args[2], thisVar;
      napi_get_cb_info(env, info, &argc, args, &thisVar, nullptr);
      auto node =  LayoutNapi::UnwrapNode(env, thisVar)->node;

      float w = GetArg<float>(env, args[0]);
      float h = GetArg<float>(env, args[1]);

      node->CalculateLayout(w, h);
      return nullptr;
  }

  napi_value LayoutNapi::InsertChildNapi(napi_env env, napi_callback_info info) {
      size_t argc = 2;
      napi_value args[2], thisVar;
      napi_get_cb_info(env, info, &argc, args, &thisVar, nullptr);

      auto parent =  LayoutNapi::UnwrapNode(env, thisVar)->node;

      LayoutNapi::LayoutNodeWrapper* childWrapper = nullptr;
      napi_unwrap(env, args[0], reinterpret_cast<void**>(&childWrapper));

      int32_t index;
      napi_get_value_int32(env, args[1], &index);

      parent->InsertChild(childWrapper->node, static_cast<uint32_t>(index));
      return nullptr;
  }

  napi_value LayoutNapi::RemoveChildNapi(napi_env env, napi_callback_info info) {
      size_t argc = 1;
      napi_value args[1], thisVar;
      napi_get_cb_info(env, info, &argc, args, &thisVar, nullptr);

      auto parent =  LayoutNapi::UnwrapNode(env, thisVar)->node;

      LayoutNapi::LayoutNodeWrapper* childWrapper = nullptr;
      napi_unwrap(env, args[0], reinterpret_cast<void**>(&childWrapper));

      parent->RemoveChild(childWrapper->node);
      return nullptr;
  }

  // 这里暂时不绑定 SetLayoutStyles（复杂结构）
  // 可根据需要后续再写复杂转换

  napi_value LayoutNapi::ResetLayoutCacheNapi(napi_env env, napi_callback_info info) {
      napi_value thisVar;
      napi_get_cb_info(env, info, nullptr, nullptr, &thisVar, nullptr);
      auto node =  LayoutNapi::UnwrapNode(env, thisVar)->node;
      node->ResetLayoutCache();
      return nullptr;
  }

  napi_value LayoutNapi::CreateEnumObject(napi_env env, const std::unordered_map<std::string, int32_t>& map) {
      napi_value obj;
      napi_create_object(env, &obj);
      for (const auto& [key, val] : map) {
          napi_value v;
          napi_create_int32(env, val, &v);
          napi_set_named_property(env, obj, key.c_str(), v);
      }
      return obj;
  }

//  napi_value LayoutNapi::Init(napi_env env, napi_value exports) {
//      napi_property_descriptor desc[] = {
//          { "Layout_CreateLayoutNode", nullptr, CreateLayoutNodeNapi, nullptr, nullptr, nullptr, napi_default, nullptr },
//          { "Layout_GetWidth", nullptr, GetWidthNapi, nullptr, nullptr, nullptr, napi_default, nullptr },
//          { "Layout_GetHeight", nullptr, GetHeightNapi, nullptr, nullptr, nullptr, napi_default, nullptr },
//          { "Layout_GetLeft", nullptr, GetLeftNapi, nullptr, nullptr, nullptr, napi_default, nullptr },
//          { "Layout_GetTop", nullptr, GetTopNapi, nullptr, nullptr, nullptr, napi_default, nullptr },
//          { "Layout_GetRight", nullptr, GetRightNapi, nullptr, nullptr, nullptr, napi_default, nullptr },
//          { "Layout_GetBottom", nullptr, GetBottomNapi, nullptr, nullptr, nullptr, napi_default, nullptr },
//          { "Layout_GetStyleWidth", nullptr, GetStyleWidthNapi, nullptr, nullptr, nullptr, napi_default, nullptr },
//          { "Layout_GetStyleHeight", nullptr, GetStyleHeightNapi, nullptr, nullptr, nullptr, napi_default, nullptr },
//          { "Layout_SetWidth", nullptr, SetWidthNapi, nullptr, nullptr, nullptr, napi_default, nullptr },
//          { "Layout_SetHeight", nullptr, SetHeightNapi, nullptr, nullptr, nullptr, napi_default, nullptr },
//          { "Layout_SetMaxWidth", nullptr, SetMaxWidthNapi, nullptr, nullptr, nullptr, napi_default, nullptr },
//          { "Layout_SetMaxHeight", nullptr, SetMaxHeightNapi, nullptr, nullptr, nullptr, napi_default, nullptr },
//          { "Layout_SetScaleFactor", nullptr, SetScaleFactorNapi, nullptr, nullptr, nullptr, napi_default, nullptr },
//          { "Layout_SetPosition", nullptr, SetPositionNapi, nullptr, nullptr, nullptr, napi_default, nullptr },
//          { "Layout_HasNewLayout", nullptr, HasNewLayoutNapi, nullptr, nullptr, nullptr, napi_default, nullptr },
////          { "SetHasNewLayout", nullptr, SetSetHasNewLayoutNapi, nullptr, nullptr, nullptr, napi_default, nullptr },
//          { "Layout_MarkDirty", nullptr, MarkDirtyNapi, nullptr, nullptr, nullptr, napi_default, nullptr },
//          { "Layout_IsDirty", nullptr, IsDirtyNapi, nullptr, nullptr, nullptr, napi_default, nullptr },
//          { "Layout_CalculateLayout", nullptr, CalculateLayoutNapi, nullptr, nullptr, nullptr, napi_default, nullptr },
//          { "Layout_InsertChild", nullptr, InsertChildNapi, nullptr, nullptr, nullptr, napi_default, nullptr },
//          { "Layout_RemoveChild", nullptr, RemoveChildNapi, nullptr, nullptr, nullptr, napi_default, nullptr },
//          { "Layout_ResetLayoutCache", nullptr, ResetLayoutCacheNapi, nullptr, nullptr, nullptr, napi_default, nullptr },
//      };
//      napi_define_properties(env, exports, sizeof(desc) / sizeof(desc[0]), desc);
//
//      // 枚举导出
//      std::unordered_map<std::string, int32_t> edge_map = {
//          {"EdgeLeft", static_cast<int32_t>(Edge::EdgeLeft)},
//          {"EdgeTop", static_cast<int32_t>(Edge::EdgeTop)},
//          {"EdgeRight", static_cast<int32_t>(Edge::EdgeRight)},
//          {"EdgeBottom", static_cast<int32_t>(Edge::EdgeBottom)},
//          {"EdgeStart", static_cast<int32_t>(Edge::EdgeStart)},
//          {"EdgeEnd", static_cast<int32_t>(Edge::EdgeEnd)},
//      };
//      napi_value edgeObj = CreateEnumObject(env, edge_map);
//      napi_set_named_property(env, exports, "Edge", edgeObj);
//
//      std::unordered_map<std::string, int32_t> direction_map = {
//          {"Inherit", static_cast<int32_t>(Direction::Inherit)},
//          {"LTR", static_cast<int32_t>(Direction::LTR)},
//          {"RTL", static_cast<int32_t>(Direction::RTL)},
//      };
//      napi_value directionObj = CreateEnumObject(env, direction_map);
//      napi_set_named_property(env, exports, "Direction", directionObj);
//
//      std::unordered_map<std::string, int32_t> measure_mode_map = {
//          {"Undefined", static_cast<int32_t>(LayoutMeasureMode::Undefined)},
//          {"Exactly", static_cast<int32_t>(LayoutMeasureMode::Exactly)},
//          {"AtMost", static_cast<int32_t>(LayoutMeasureMode::AtMost)},
//      };
//      napi_value measureModeObj = CreateEnumObject(env, measure_mode_map);
//      napi_set_named_property(env, exports, "LayoutMeasureMode", measureModeObj);
//
//      std::unordered_map<std::string, int32_t> layout_engine_map = {
//          {"LayoutEngineDefault", static_cast<int32_t>(LayoutEngineType::LayoutEngineDefault)},
//          {"LayoutEngineTaitank", static_cast<int32_t>(LayoutEngineType::LayoutEngineTaitank)},
//          {"LayoutEngineYoga", static_cast<int32_t>(LayoutEngineType::LayoutEngineYoga)},
//      };
//      napi_value layoutEngineObj = CreateEnumObject(env, layout_engine_map);
//      napi_set_named_property(env, exports, "LayoutEngineType", layoutEngineObj);
//    
//     napi_value constructor;
//      napi_status status = napi_define_class(env, "QTNativeLayout", NAPI_AUTO_LENGTH, 
//                                            LayoutNapi::Constructor, nullptr,
//                                           sizeof(desc) / sizeof(desc[0]),
//                                           desc, &constructor);
//      if (status != napi_ok) {
//          napi_throw_error(env, nullptr, "Failed to define NativeLayout class");
//          return nullptr;
//      }
//      
//      status = napi_set_named_property(env, exports, "QTNativeLayout", constructor);
//      if (status != napi_ok) {
//          napi_throw_error(env, nullptr, "Failed to export NativeLayout class");
//          return nullptr;
//      }
//
//      return exports;
//  }
napi_value LayoutNapi::Init(napi_env env, napi_value exports) {
    napi_property_descriptor desc[] = {
        { "GetWidth", nullptr, GetWidthNapi, nullptr, nullptr, nullptr, napi_default, nullptr },
        { "GetHeight", nullptr, GetHeightNapi, nullptr, nullptr, nullptr, napi_default, nullptr },
        { "GetLeft", nullptr, GetLeftNapi, nullptr, nullptr, nullptr, napi_default, nullptr },
        { "GetTop", nullptr, GetTopNapi, nullptr, nullptr, nullptr, napi_default, nullptr },
        { "GetRight", nullptr, GetRightNapi, nullptr, nullptr, nullptr, napi_default, nullptr },
        { "GetBottom", nullptr, GetBottomNapi, nullptr, nullptr, nullptr, napi_default, nullptr },
        { "GetStyleWidth", nullptr, GetStyleWidthNapi, nullptr, nullptr, nullptr, napi_default, nullptr },
        { "GetStyleHeight", nullptr, GetStyleHeightNapi, nullptr, nullptr, nullptr, napi_default, nullptr },

        { "SetWidth", nullptr, SetWidthNapi, nullptr, nullptr, nullptr, napi_default, nullptr },
        { "SetHeight", nullptr, SetHeightNapi, nullptr, nullptr, nullptr, napi_default, nullptr },
        { "SetMaxWidth", nullptr, SetMaxWidthNapi, nullptr, nullptr, nullptr, napi_default, nullptr },
        { "SetMaxHeight", nullptr, SetMaxHeightNapi, nullptr, nullptr, nullptr, napi_default, nullptr },
        { "SetScaleFactor", nullptr, SetScaleFactorNapi, nullptr, nullptr, nullptr, napi_default, nullptr },
        { "SetPosition", nullptr, SetPositionNapi, nullptr, nullptr, nullptr, napi_default, nullptr },

        { "HasNewLayout", nullptr, HasNewLayoutNapi, nullptr, nullptr, nullptr, napi_default, nullptr },
        { "IsDirty", nullptr, IsDirtyNapi, nullptr, nullptr, nullptr, napi_default, nullptr },
        { "MarkDirty", nullptr, MarkDirtyNapi, nullptr, nullptr, nullptr, napi_default, nullptr },
        { "CalculateLayout", nullptr, CalculateLayoutNapi, nullptr, nullptr, nullptr, napi_default, nullptr },
        { "InsertChild", nullptr, InsertChildNapi, nullptr, nullptr, nullptr, napi_default, nullptr },
        { "RemoveChild", nullptr, RemoveChildNapi, nullptr, nullptr, nullptr, napi_default, nullptr },
        { "ResetLayoutCache", nullptr, ResetLayoutCacheNapi, nullptr, nullptr, nullptr, napi_default, nullptr },
    };

    napi_value constructor;
    napi_status status = napi_define_class(
        env, "QTNativeLayout", NAPI_AUTO_LENGTH,
        LayoutNapi::Constructor, nullptr,
        sizeof(desc) / sizeof(desc[0]), desc, &constructor
    );
    if (status != napi_ok) {
        napi_throw_error(env, nullptr, "Failed to define QTNativeLayout class");
        return nullptr;
    }

    status = napi_set_named_property(env, exports, "QTNativeLayout", constructor);
    if (status != napi_ok) {
        napi_throw_error(env, nullptr, "Failed to export QTNativeLayout class");
        return nullptr;
    }

    // 枚举也一起挂在 exports 上
    napi_value edgeObj = CreateEnumObject(env, {
        {"EdgeLeft", static_cast<int32_t>(Edge::EdgeLeft)},
        {"EdgeTop", static_cast<int32_t>(Edge::EdgeTop)},
        {"EdgeRight", static_cast<int32_t>(Edge::EdgeRight)},
        {"EdgeBottom", static_cast<int32_t>(Edge::EdgeBottom)},
        {"EdgeStart", static_cast<int32_t>(Edge::EdgeStart)},
        {"EdgeEnd", static_cast<int32_t>(Edge::EdgeEnd)},
    });
    napi_set_named_property(env, exports, "Edge", edgeObj);

    napi_value directionObj = CreateEnumObject(env, {
        {"Inherit", static_cast<int32_t>(Direction::Inherit)},
        {"LTR", static_cast<int32_t>(Direction::LTR)},
        {"RTL", static_cast<int32_t>(Direction::RTL)},
    });
    napi_set_named_property(env, exports, "Direction", directionObj);

    napi_value measureModeObj = CreateEnumObject(env, {
        {"Undefined", static_cast<int32_t>(LayoutMeasureMode::Undefined)},
        {"Exactly", static_cast<int32_t>(LayoutMeasureMode::Exactly)},
        {"AtMost", static_cast<int32_t>(LayoutMeasureMode::AtMost)},
    });
    napi_set_named_property(env, exports, "LayoutMeasureMode", measureModeObj);

    napi_value layoutEngineObj = CreateEnumObject(env, {
        {"LayoutEngineDefault", static_cast<int32_t>(LayoutEngineType::LayoutEngineDefault)},
        {"LayoutEngineTaitank", static_cast<int32_t>(LayoutEngineType::LayoutEngineTaitank)},
        {"LayoutEngineYoga", static_cast<int32_t>(LayoutEngineType::LayoutEngineYoga)},
    });
    napi_set_named_property(env, exports, "LayoutEngineType", layoutEngineObj);

    return exports;
}

}
}


//REGISTER_OH_NAPI("LayoutNode", "Init", Init)
