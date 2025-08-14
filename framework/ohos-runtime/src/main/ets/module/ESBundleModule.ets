import {
  HippyEngineContext,
  HippyAny,
  HippyModulePromise,
  HippyNativeModule,
  LogUtils
} from 'hippy';
import { BaseModule } from './BaseModule';
import { BusinessError } from '@ohos.base';
import { bundleManager } from '@kit.AbilityKit';

// import launcherBundleManager from '@ohos.bundle.launcherBundleManager';

@HippyNativeModule({ name: "ESBundleModule" })
export class ESBundleModule extends BaseModule {
  public static readonly NAME: string = 'ESBundleModule'
  public readonly TAG: string = 'ESBundleModule'

  constructor(ctx: HippyEngineContext) {
    super(ctx)
  }

  initialize(): void {
  }

  public call(method: string, params: Array<HippyAny>, promise: HippyModulePromise): HippyAny {
    switch (method) {
      case 'canOpenLink': {
        try {
          let link = 'esapp://test.example.com/home';
          let canOpen = bundleManager.canOpenLink(link);
          promise?.resolve(canOpen)
        } catch (error) {
          LogUtils.e(this.TAG,
            `Failed to canOpenLink. Code=${error.code}, message=${error.message}`)
          promise?.reject(error)
        }
        break;
      }
      case 'getAllLauncherAbilityInfo': {
        LogUtils.d(this.TAG, '=======test=========>>>>>');
        try {
          // launcherBundleManager.getAllLauncherAbilityInfo(100)
          //   .then((data: launcherBundleManager.LauncherAbilityInfo[]) => {
          //     console.log("data is " + JSON.stringify(data));
          //   }).catch((errData: BusinessError) => {
          //   console.error(`errData is errCode:${errData.code}  message:${errData.message}`);
          // });
        } catch (error) {
          let code = (error as BusinessError).code;
          let message = (error as BusinessError).message;
          console.error(`errData is errCode:${code}  message:${message}`);
        }
        break;
      }
      default:
        super.call(method, params, promise);
    }
    return null;
  }
}
