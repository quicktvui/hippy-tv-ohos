import { HippyAPIProvider } from 'hippy';

import {
  HippyJSModuleCreator
} from 'hippy/src/main/ets/hippy_framework/modules/HippyModuleManagerImpl';
import {
  HippyNativeModuleCreator
} from 'hippy/src/main/ets/hippy_framework/modules/HippyModuleManagerImpl';

import HippyRenderBaseView
  from 'hippy/src/main/ets/renderer_native/components/base/HippyRenderBaseView';
import {
  HRRenderViewCreator
} from 'hippy/src/main/ets/renderer_native/components/HippyRenderRegisterMap';

import { QTDivView } from './QTDivView';
import { QTFastListView } from './fastlist/QTFastListView';
import { QTFastFlexView } from './fastlist/QTFastFlexView';
import { QTFastItemView } from './fastlist/QTFastItemView';

export class QTAPIProvider extends HippyAPIProvider {
  getCustomNativeModuleCreatorMap(): Map<string, HippyNativeModuleCreator> | null {
    let registerMap: Map<string, HippyNativeModuleCreator> = new Map()
    // registerMap.set(ExampleNativeModule.NAME, (ctx): HippyNativeModuleBase => new ExampleNativeModule(ctx))
    // registerMap.set(ExampleNativeTurboModule.NAME, (ctx): HippyNativeModuleBase => new ExampleNativeTurboModule(ctx))
    return registerMap;
  }

  getCustomJavaScriptModuleCreatorMap(): Map<string, HippyJSModuleCreator> | null {
    return null
  }

  getCustomRenderViewCreatorMap(): Map<string, HRRenderViewCreator> | null {
    let registerMap: Map<string, HRRenderViewCreator> = new Map()
    registerMap.set("QTView", (ctx): HippyRenderBaseView => new QTDivView(ctx))
    registerMap.set("FastListView", (ctx): HippyRenderBaseView => new QTFastListView(ctx))
    registerMap.set("FastFlexView", (ctx): HippyRenderBaseView => new QTFastFlexView(ctx))
    registerMap.set("FastItemView", (ctx): HippyRenderBaseView => new QTFastItemView(ctx))
    // registerMap.set("ExampleViewB", (ctx): HippyRenderBaseView => new ExampleViewB(ctx))
    // registerMap.set("MyScrollView", (ctx): HippyRenderBaseView => new MyScrollView(ctx))
    // registerMap.set("MyTopView", (ctx): HippyRenderBaseView => new MyTopView(ctx))
    // registerMap.set("MyTabBarView", (ctx): HippyRenderBaseView => new MyTabBarView(ctx))
    // registerMap.set("MyBottomView", (ctx): HippyRenderBaseView => new MyBottomView(ctx))
    return registerMap
  }

  getCustomMeasureRenderViews(): Array<string> | null {
    return ["ExampleViewB"]
  }

  getCustomMappingRenderViewMap(): Map<string, string> | null {
    return null
  }
}
