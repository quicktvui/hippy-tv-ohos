
#include "renderer/components/event_view.h"
#include "renderer/utils/hr_value_utils.h"
#include "renderer/utils/hr_event_utils.h"
#include "footstone/logging.h"

namespace hippy {
inline namespace render {
inline namespace native {

EventView::EventView(std::shared_ptr<NativeRenderContext> &ctx) : CustomView(ctx) {}

EventView::~EventView() {
  if (!children_.empty()) {
    if (stackNode_) {
      for (const auto &child : children_) {
        stackNode_->RemoveChild(child->GetLocalRootArkUINode());
      }
    }
    children_.clear();
  }
}

StackNode *EventView::GetLocalRootArkUINode() { return stackNode_.get(); }

void EventView::CreateArkUINodeImpl() {
  stackNode_ = std::make_shared<StackNode>();
  textNode_ = std::make_shared<TextNode>();
  stackNode_->AddChild(textNode_.get());
  textNode_->SetTextContent("This is a custom component c++.");
}

void EventView::DestroyArkUINodeImpl() {
  stackNode_ = nullptr;
  textNode_ = nullptr;
}

bool EventView::SetPropImpl(const std::string &propKey, const HippyValue &propValue) {
  return BaseView::SetPropImpl(propKey, propValue);
}

void EventView::OnChildInsertedImpl(std::shared_ptr<BaseView> const &childView, int32_t index) {
  BaseView::OnChildInsertedImpl(childView, index);
  stackNode_->InsertChild(childView->GetLocalRootArkUINode(), index);
}

void EventView::OnChildRemovedImpl(std::shared_ptr<BaseView> const &childView, int32_t index) {
  BaseView::OnChildRemovedImpl(childView, index);
  stackNode_->RemoveChild(childView->GetLocalRootArkUINode());
}

void EventView::CallImpl(const std::string &method, const std::vector<HippyValue> params,
                         std::function<void(const HippyValue &result)> callback) {
  FOOTSTONE_DLOG(INFO) << "EventView call: method " << method << ", params: " << params.size();
  if (method == "sendEsMessage") {
    auto vueMessage = HRValueUtils::GetString(params[0]);

    HippyValueObjectType paramsObj;
    paramsObj.insert_or_assign("code", 100);
    paramsObj.insert_or_assign("message", std::string("native receive vue message:") + vueMessage);
    std::shared_ptr<HippyValue> retParams = std::make_shared<HippyValue>(paramsObj);
    HREventUtils::SendComponentEvent(ctx_, tag_, HREventUtils::EVENT_ES_COMPONENT_EVENT_,
                                     retParams);
    //
    if (callback) {
      callback(HippyValue("EventView ok"));
    }
  }
  //
  else {
    BaseView::CallImpl(method, params, callback);
  }
}


} // namespace native
} // namespace render
} // namespace hippy
