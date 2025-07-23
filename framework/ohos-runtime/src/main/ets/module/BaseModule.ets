import {
  HippyEngineContext,
  HippyNativeModuleBase,
  EventDispatcher,
  HippyAny,
  HippyModulePromise
} from 'hippy';

import { LogUtils } from 'hippy/src/main/ets/support/utils/LogUtils'

export class BaseModule extends HippyNativeModuleBase {
  public static readonly ES_PROP_INFO_VERSION = "version";
  public static readonly ES_PROP_INFO_ESKIT_VERSION = 'eskit_ver_code';

  constructor(ctx: HippyEngineContext) {
    super(ctx)
  }

  public call(method: string, params: Array<HippyAny>, promise: HippyModulePromise): HippyAny {
    switch (method) {
      case 'init': {
        break;
      }
      case 'getEsInfo': {
        const params = new Map<string, HippyAny>();
        params.set(BaseModule.ES_PROP_INFO_VERSION, 1);
        params.set(BaseModule.ES_PROP_INFO_ESKIT_VERSION, 1);
        promise.resolve(params);
        break;
      }
      default:
        super.call(method, params, promise);
    }
    return null;
  }

  dispatchEvent(eventName: string, eventParam: HippyAny) {
    try {
      if (this.ctx != null && this.ctx.getModuleManager() != null) {
        const eventModule =
          this.ctx.getModuleManager().getJavaScriptModule(EventDispatcher.MODULE_NAME);
        if (eventModule != null) {
          (eventModule as EventDispatcher).receiveNativeEvent(eventName, eventParam);
        }
      }
    } catch (e) {
      LogUtils.e('BaseModule',
        'dispatchEvent: ' + eventName + ' eventParam:' + eventParam + " error!");
    }
  }
}
