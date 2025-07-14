import { HippyAPIProvider } from 'hippy'
import {
  HippyJSModuleCreator,
  HippyNativeModuleCreator
} from 'hippy/src/main/ets/hippy_framework/modules/HippyModuleManagerImpl'
import {
  HRRenderViewCreator
} from 'hippy/src/main/ets/renderer_native/components/HippyRenderRegisterMap'
import {
  HippyNativeModuleBase
} from 'hippy/src/main/ets/hippy_framework/modules/native/HippyNativeModuleBase';

import { ESLogModule } from '../module/ESLogModule'

/**
 * 自定义 module 和 component 入口
 */
export class RuntimeAPIProvider extends HippyAPIProvider {
  getCustomNativeModuleCreatorMap(): Map<string, HippyNativeModuleCreator> | null {
    let registerMap: Map<string, HippyNativeModuleCreator> = new Map()
    registerMap.set(ESLogModule.NAME, (ctx): HippyNativeModuleBase => new ESLogModule(ctx))
    return registerMap;
  }

  getCustomJavaScriptModuleCreatorMap(): Map<string, HippyJSModuleCreator> | null {
    return null
  }

  getCustomRenderViewCreatorMap(): Map<string, HRRenderViewCreator> | null {
    let registerMap: Map<string, HRRenderViewCreator> = new Map()
    // registerMap.set("ExampleViewA", (ctx): HippyRenderBaseView => new ExampleViewA(ctx))
    return registerMap
  }

  getCustomMeasureRenderViews(): Array<string> | null {
    return null
  }

  getCustomMappingRenderViewMap(): Map<string, string> | null {
    return null
  }
}

