#pragma once

#include "renderer/arkui/progress_node.h"
#include "renderer/components/custom_view.h"

namespace hippy {
inline namespace render {
inline namespace native {

class ProgressView : public CustomView {
  public:
  ProgressView(std::shared_ptr<NativeRenderContext> &ctx);
  virtual ~ProgressView();

  ProgressNode *GetLocalRootArkUINode() override;
  void CreateArkUINodeImpl() override;
  void DestroyArkUINodeImpl() override;

  bool SetPropImpl(const std::string &propKey, const HippyValue &propValue) override;

  private:
  std::shared_ptr<ProgressNode> progressNode_;
};

} // namespace native
} // namespace render
} // namespace hippy
