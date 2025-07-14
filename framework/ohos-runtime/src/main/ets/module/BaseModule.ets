import { HippyEngineContext } from 'hippy';
import { HippyModulePromise } from 'hippy/src/main/ets/hippy_framework/modules/HippyModulePromise';
import {
  HippyNativeModuleBase
} from 'hippy/src/main/ets/hippy_framework/modules/native/HippyNativeModuleBase';
import { HippyNativeModule } from 'hippy/src/main/ets/support/annotation/HippyNativeModule';
import { HippyAny } from 'hippy/src/main/ets/support/common/HippyTypes';

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
}
