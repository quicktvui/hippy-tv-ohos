import { HippyEngineContext, HippyNativeModule, HippyAny, HippyModulePromise } from 'hippy';

import { BaseModule } from './BaseModule';
import { LogUtils } from 'hippy/src/main/ets/support/utils/LogUtils'

@HippyNativeModule({ name: "ESLocalStorageModule" })
export class ESLocalStorageModule extends BaseModule {
  public static readonly NAME: string = 'ESLocalStorageModule'

  constructor(ctx: HippyEngineContext) {
    super(ctx)
  }

  initialize(): void {
  }

  public call(method: string, params: Array<HippyAny>, promise: HippyModulePromise): HippyAny {
    switch (method) {
      case 'test': {
        LogUtils.d('ESTestModule', '=======test=========>>>>>');
        break;
      }
      default:
        super.call(method, params, promise);
    }
    return null;
  }
}
