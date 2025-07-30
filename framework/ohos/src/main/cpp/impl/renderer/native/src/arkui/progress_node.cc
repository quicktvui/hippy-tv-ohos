/*
 *
 * Tencent is pleased to support the open source community by making
 * Hippy available.
 *
 * Copyright (C) 2019 THL A29 Limited, a Tencent company.
 * All rights reserved.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 *
 */

#include "renderer/arkui/progress_node.h"
#include "renderer/arkui/native_node_api.h"
#include "footstone/logging.h"

namespace hippy {
inline namespace render {
inline namespace native {

ProgressNode::ProgressNode()
    : ArkUINode(NativeNodeApi::GetInstance()->createNode(ArkUI_NodeType::ARKUI_NODE_PROGRESS)) {}

ProgressNode::~ProgressNode() {}

void ProgressNode::SetType(int32_t type) {
  ArkUI_NumberValue value[] = {{.i32 = type}};
  ArkUI_AttributeItem item = {value, sizeof(value) / sizeof(ArkUI_NumberValue), nullptr, nullptr};
  MaybeThrow(NativeNodeApi::GetInstance()->setAttribute(nodeHandle_, NODE_PROGRESS_TYPE, &item));
  SetSubAttributeFlag((uint32_t)AttributeFlag::PROGRESS_TYPE);
}

void ProgressNode::SetValue(int32_t value) {
  ArkUI_NumberValue values[] = {{.i32 = value}};
  ArkUI_AttributeItem item = {values, sizeof(value) / sizeof(ArkUI_NumberValue), nullptr, nullptr};
  MaybeThrow(NativeNodeApi::GetInstance()->setAttribute(nodeHandle_, NODE_PROGRESS_VALUE, &item));
  SetSubAttributeFlag((uint32_t)AttributeFlag::PROGRESS_VALUE);
}

void ProgressNode::SetTotal(int32_t total) {
  ArkUI_NumberValue value[] = {{.i32 = total}};
  ArkUI_AttributeItem item = {.value = value, .size = sizeof(value) / sizeof(ArkUI_NumberValue)};
  MaybeThrow(NativeNodeApi::GetInstance()->setAttribute(nodeHandle_, NODE_PROGRESS_TOTAL, &item));
  SetSubAttributeFlag((uint32_t)AttributeFlag::PROGRESS_TOTAL);
}

void ProgressNode::SetColor(uint32_t color) {
  ArkUI_NumberValue value[] = {{.u32 = color}};
  ArkUI_AttributeItem item = {value, sizeof(value) / sizeof(ArkUI_NumberValue), nullptr, nullptr};
  MaybeThrow(NativeNodeApi::GetInstance()->setAttribute(nodeHandle_, NODE_PROGRESS_COLOR, &item));
  SetSubAttributeFlag((uint32_t)AttributeFlag::PROGRESS_COLOR);
}

} // namespace native
} // namespace render
} // namespace hippy
