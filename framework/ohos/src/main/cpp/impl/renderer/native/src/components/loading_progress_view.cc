
#include "renderer/components/loading_progress_view.h"
#include "renderer/utils/hr_event_utils.h"
#include "renderer/utils/hr_value_utils.h"

namespace hippy {
inline namespace render {
inline namespace native {

LoadingProgressView::LoadingProgressView(std::shared_ptr<NativeRenderContext> &ctx)
    : CustomView(ctx) {}

LoadingProgressView::~LoadingProgressView() {}

LoadingProgressNode *LoadingProgressView::GetLocalRootArkUINode() { return progressNode_.get(); }

void LoadingProgressView::CreateArkUINodeImpl() {
  progressNode_ = std::make_shared<LoadingProgressNode>();
}

void LoadingProgressView::DestroyArkUINodeImpl() { progressNode_ = nullptr; }


} // namespace native
} // namespace render
} // namespace hippy
