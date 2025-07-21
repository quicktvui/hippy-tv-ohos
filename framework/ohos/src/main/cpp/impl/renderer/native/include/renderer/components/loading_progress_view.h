#pragma once

#include "renderer/arkui/loading_progress_node.h"
#include "renderer/components/custom_view.h"

namespace hippy {
inline namespace render {
inline namespace native {

class LoadingProgressView : public CustomView {
  public:
  LoadingProgressView(std::shared_ptr<NativeRenderContext> &ctx);
  virtual ~LoadingProgressView();

  LoadingProgressNode *GetLocalRootArkUINode() override;
  void CreateArkUINodeImpl() override;
  void DestroyArkUINodeImpl() override;

  private:
  std::shared_ptr<LoadingProgressNode> progressNode_;
};

} // namespace native
} // namespace render
} // namespace hippy
