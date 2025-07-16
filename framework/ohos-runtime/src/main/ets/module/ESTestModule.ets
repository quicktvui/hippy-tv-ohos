import { HippyEngineContext } from 'hippy';
import { HippyModulePromise } from 'hippy/src/main/ets/hippy_framework/modules/HippyModulePromise';
import { HippyNativeModule } from 'hippy/src/main/ets/support/annotation/HippyNativeModule';
import { HippyAny } from 'hippy/src/main/ets/support/common/HippyTypes';
import { BaseModule } from './BaseModule';

@HippyNativeModule({ name: "ESTestModule" })
export class ESTestModule extends BaseModule {
  public static readonly NAME: string = 'ESTestModule'

  constructor(ctx: HippyEngineContext) {
    super(ctx)
  }

  initialize(): void {
  }

  public call(method: string, params: Array<HippyAny>, promise: HippyModulePromise): HippyAny {
    switch (method) {
      case 'test': {
        break;
      }
      default:
        super.call(method, params, promise);
    }
    return null;
  }
}
