import {
  HippyEngineContext,
  HippyNativeModuleBase,
  EventDispatcher,
  HippyAny,
  HippyModulePromise
} from 'hippy';

import { LogUtils } from 'hippy/src/main/ets/support/utils/LogUtils'
import { ESInfo } from '../api/ESInfo';

export class BaseModule extends HippyNativeModuleBase {

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
        params.set(ESInfo.ES_PROP_INFO_VERSION, 1);
        params.set(ESInfo.ES_PROP_INFO_ESKIT_VERSION, 1);
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
