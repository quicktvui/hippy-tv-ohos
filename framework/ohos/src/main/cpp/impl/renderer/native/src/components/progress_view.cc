
#include "renderer/components/progress_view.h"
#include "footstone/logging.h"
#include "renderer/utils/hr_event_utils.h"
#include "renderer/utils/hr_value_utils.h"

namespace hippy {
inline namespace render {
inline namespace native {

ProgressView::ProgressView(std::shared_ptr<NativeRenderContext> &ctx) : CustomView(ctx) {}

ProgressView::~ProgressView() {}

ProgressNode *ProgressView::GetLocalRootArkUINode() { return progressNode_.get(); }

void ProgressView::CreateArkUINodeImpl() { progressNode_ = std::make_shared<ProgressNode>(); }

void ProgressView::DestroyArkUINodeImpl() { progressNode_ = nullptr; }

bool ProgressView::SetPropImpl(const std::string &propKey, const HippyValue &propValue) {
//  FOOTSTONE_DLOG(INFO) << "SetPropImpl: propKey：" << propKey << " propValue";
  //
  if (propKey == "type") {
    auto type = HRValueUtils::GetInt32(propValue, 0);
    progressNode_->SetType(type);
    return true;
  } else if (propKey == "value") {
    auto value = HRValueUtils::GetInt32(propValue, 20);
    FOOTSTONE_DLOG(INFO) << "SetPropImpl: value: propKey：" << propKey << " propValue" << value;
    progressNode_->SetValue(value);
    return true;
  } else if (propKey == "total") {
    auto total = HRValueUtils::GetInt32(propValue, 0);
    FOOTSTONE_DLOG(INFO) << "SetPropImpl: total : propKey：" << propKey << " propValue" << total;
    progressNode_->SetTotal(total);
    return true;
  } else if (propKey == "color") {
    auto color = HRValueUtils::GetUint32(propValue, 0);
    progressNode_->SetColor(color);
    return true;
  }
  return BaseView::SetPropImpl(propKey, propValue);
}

} // namespace native
} // namespace render
} // namespace hippy
