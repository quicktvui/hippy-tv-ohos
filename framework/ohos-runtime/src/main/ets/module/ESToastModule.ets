import { HippyEngineContext } from 'hippy';
import { HippyModulePromise } from 'hippy/src/main/ets/hippy_framework/modules/HippyModulePromise';
import { HippyNativeModule } from 'hippy/src/main/ets/support/annotation/HippyNativeModule';
import { HippyAny } from 'hippy/src/main/ets/support/common/HippyTypes';
import { BaseModule } from './BaseModule';

@HippyNativeModule({ name: "ESToastModule" })
export class ESToastModule extends BaseModule {
  public static readonly NAME: string = 'ESToastModule'

  constructor(ctx: HippyEngineContext) {
    super(ctx)
  }

  initialize(): void {
  }

  public call(method: string, params: Array<HippyAny>, promise: HippyModulePromise): HippyAny {
    switch (method) {
      case 'showToast':
      case 'showShortToast':
      case 'showLongToast':
        if (this.getContext() != null && this.getContext().getUIContext() != null) {
          this.getContext().getUIContext()!.getPromptAction().showToast({
            message: params[0] as string,
            duration: params[1] as number,
          })
        }
        break;
      default:
        super.call(method, params, promise);
    }
    return null;
  }
}
