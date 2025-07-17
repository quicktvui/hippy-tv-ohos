import { HippyEngineContext } from 'hippy';
import { HippyModulePromise } from 'hippy/src/main/ets/hippy_framework/modules/HippyModulePromise';
import { HippyNativeModule } from 'hippy/src/main/ets/support/annotation/HippyNativeModule';
import { HippyAny } from 'hippy/src/main/ets/support/common/HippyTypes';
import { BaseModule } from './BaseModule';
import { window } from '@kit.ArkUI';
import { BusinessError } from '@kit.BasicServicesKit';

@HippyNativeModule({ name: "ESWindowModule" })
export class ESWindowModule extends BaseModule {
  public static readonly NAME: string = 'ESWindowModule'

  constructor(ctx: HippyEngineContext) {
    super(ctx)
  }

  initialize(): void {
  }

  public call(method: string, params: Array<HippyAny>, promise: HippyModulePromise): HippyAny {
    switch (method) {
      case 'setWindowKeepScreenOn': {
        this.setWindowKeepScreenOn(params[0] as boolean).then((ret => {
          promise.resolve(params[0] as boolean)
        }), (error: BusinessError) => {
          promise.reject(JSON.stringify(error))
        })
        break;
      }
      default:
        super.call(method, params, promise);
    }
    return null;
  }

  async setWindowKeepScreenOn(value: boolean) {
    const win = await window.getLastWindow(this.ctx.getAbilityContext());
    await win.setWindowKeepScreenOn(value);
  }
}
