
#include "../include/event_view.h"
#include "renderer/api/hippy_view_provider.h"

namespace hippy {
inline namespace render {
inline namespace native {

auto RegisterQuickTVViewCreatorsOnLoad = []() {
  HippyViewProvider::RegisterCustomViewCreator(
      "EsEventComponent", [](std::shared_ptr<NativeRenderContext> &ctx) -> std::shared_ptr<BaseView> {
        return std::make_shared<EventView>(ctx);
      });
  return 0;
}();

} // namespace native
} // namespace render
} // namespace hippy
