
#include "../include/event_view.h"
#include "renderer/utils/hr_value_utils.h"

namespace hippy {
inline namespace render {
inline namespace native {

EventView::EventView(std::shared_ptr<NativeRenderContext> &ctx) : CustomView(ctx) {
}

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

StackNode *EventView::GetLocalRootArkUINode() {
  return stackNode_.get();
}

void EventView::CreateArkUINodeImpl() {
  stackNode_ = std::make_shared<StackNode>();
  textNode_ = std::make_shared<TextNode>();
  stackNode_->AddChild(textNode_.get());
  textNode_->SetTextContent("This is a custom component A.");
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

} // namespace native
} // namespace render
} // namespace hippy
