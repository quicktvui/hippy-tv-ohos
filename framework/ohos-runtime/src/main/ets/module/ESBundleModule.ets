import {
  HippyEngineContext,
  HippyAny,
  HippyModulePromise,
  HippyNativeModule,
  LogUtils
} from 'hippy';
import { BaseModule } from './BaseModule';
import { BusinessError } from '@ohos.base';
import { bundleManager, common, OpenLinkOptions } from '@kit.AbilityKit';

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
          const link = params[0] as string;
          const canOpen = bundleManager.canOpenLink(link);
          LogUtils.i(this.TAG, `CanOpenLink: link: ${link} canOpen: ${canOpen}`)
          promise?.resolve(canOpen)
        } catch (error) {
          LogUtils.e(this.TAG,
            `Failed to canOpenLink. code=${error.code}, message=${error.message}`)
          promise?.reject(error)
        }
        break;
      }
      case 'openLink': {
        try {
          const link = params[0] as string;
          const appLinkingOnly = params[1] as boolean ?? false;
          const openLinkOptions: OpenLinkOptions = {
            appLinkingOnly: appLinkingOnly
          };
          const context = this.ctx.getAbilityContext() as common.UIAbilityContext;
          context.openLink(link, openLinkOptions).then(() => {
            LogUtils.i(this.TAG, `OpenLink: link: ${link}`)
            promise?.resolve(true)
          }).catch((err: BusinessError) => {
            LogUtils.e(this.TAG,
              `Failed to OpenLink. code=${err.code}, message=${err.message}`)
            promise?.reject(JSON.stringify(err))
          })
        } catch (error) {
          LogUtils.e(this.TAG,
            `Failed to OpenLink. code=${error.code}, message=${error.message}`)
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
