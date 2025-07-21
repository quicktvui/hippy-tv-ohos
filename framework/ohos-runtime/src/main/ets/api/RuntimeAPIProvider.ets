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
import { ESToastModule } from '../module/ESToastModule';
import { ESNetworkModule } from '../module/ESNetworkModule';
import { ESBroadcastModule } from '../module/ESBroadcastModule';
import { ESTestModule } from '../module/ESTestModule';
import { ESRuntimeDeviceModule } from '../module/ESRuntimeDeviceModule';
import { ESDevelopModule } from '../module/ESDevelopModule';
import { ESDeviceModule } from '../module/ESDeviceModule';
import { ESPluginModule } from '../module/ESPluginModule';
import { ESWindowModule } from '../module/ESWindowModule';
import { ESPermissionModule } from '../module/ESPermissionModule';
import { ESModule } from '../module/ESModule';

/**
 * 自定义 module 和 component 入口
 */
export class RuntimeAPIProvider extends HippyAPIProvider {
  getCustomNativeModuleCreatorMap(): Map<string, HippyNativeModuleCreator> | null {
    //
    let registerMap: Map<string, HippyNativeModuleCreator> = new Map()
    registerMap.set(ESLogModule.NAME, (ctx): HippyNativeModuleBase => new ESLogModule(ctx))
    registerMap.set(ESToastModule.NAME, (ctx): HippyNativeModuleBase => new ESToastModule(ctx))
    registerMap.set(ESNetworkModule.NAME, (ctx): HippyNativeModuleBase => new ESNetworkModule(ctx))
    registerMap.set(ESBroadcastModule.NAME,
      (ctx): HippyNativeModuleBase => new ESBroadcastModule(ctx))
    registerMap.set(ESRuntimeDeviceModule.NAME,
      (ctx): HippyNativeModuleBase => new ESRuntimeDeviceModule(ctx))
    registerMap.set(ESTestModule.NAME, (ctx): HippyNativeModuleBase => new ESTestModule(ctx))
    registerMap.set(ESDevelopModule.NAME, (ctx): HippyNativeModuleBase => new ESDevelopModule(ctx))
    registerMap.set(ESDeviceModule.NAME, (ctx): HippyNativeModuleBase => new ESDeviceModule(ctx))
    registerMap.set(ESPluginModule.NAME, (ctx): HippyNativeModuleBase => new ESPluginModule(ctx))
    registerMap.set(ESWindowModule.NAME, (ctx): HippyNativeModuleBase => new ESWindowModule(ctx))
    registerMap.set(ESPermissionModule.NAME,
      (ctx): HippyNativeModuleBase => new ESPermissionModule(ctx))
    registerMap.set(ESModule.NAME,
      (ctx): HippyNativeModuleBase => new ESModule(ctx))
    //
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

