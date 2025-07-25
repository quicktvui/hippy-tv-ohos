import { HippyEngineContext, HippyAny, HippyModulePromise, HippyNativeModule } from 'hippy';

import { BaseModule } from './BaseModule';
import { LogUtils } from 'hippy/src/main/ets/support/utils/LogUtils'
import QTAppManager from '../quick/QTAppManager';

/**
 * TODO
 */
@HippyNativeModule({ name: "ESModule" })
export class ESModule extends BaseModule {
  public static readonly NAME: string = 'ESModule'
  private readonly TAG: string = 'ESModule'

  constructor(ctx: HippyEngineContext) {
    super(ctx)
  }

  initialize(): void {
  }

  public call(method: string, params: Array<HippyAny>, promise: HippyModulePromise): HippyAny {
    switch (method) {
      //TODO
      case 'getESDeviceInfo': {
        try {
          const info = new Map<string, HippyAny>()
          info.set('cid', QTAppManager.getInstance().getAppId())
          info.set('device_ip', 'x')
          info.set('device_name', 'x')
          promise.resolve(info)
          LogUtils.e(this.TAG, 'call method: getESDeviceInfo success,' + JSON.stringify(info));
        } catch (e) {
          LogUtils.e(this.TAG, 'call method: getESDeviceInfo error,' + JSON.stringify(e));
        }

        break;
      }
    //TODO
      case 'getESSDKInfo': {
        const info = new Map<string, HippyAny>()
        info.set('cid', QTAppManager.getInstance().getAppId())
        info.set('IPAddress', '')
        info.set('deviceName', '')
        info.set('versionCode', '')
        info.set('versionName', '')
        info.set('packageName', '')
        info.set('eskit_ver_code', '')
        info.set('eskit_ver_name', '')
        info.set('miniProgramPath', this.getESAppFilePath())
        info.set('runtimePath', this.getESAppRuntimePath())
        info.set('schemes', '')
        info.set('sdkChannel', '')
        promise.resolve(info)
        break;
      }
      case 'getESSDKVersionCode': {
        promise.resolve(QTAppManager.getInstance().getVersionCode())
        break;
      }
      case 'getESSDKVersionName': {
        promise.resolve(QTAppManager.getInstance().getVersionName())
        break;
      }
      case 'getESPackageName': {
        promise.resolve(QTAppManager.getInstance().getPackageName())
        break;
      }
    //-------------------------------------------------------------------

    /**
     * 获取EsApp路径, 用于文件存储管理
     * @return
     * /data/data/APK包名/app_rpk/apps/小程序包名/files
     * 示例:/data/data/com.extscreen.runtime/app_rpk/apps/es.com.baduanjin.tv/files
     */
      case 'getESAppFilePath': {
        promise.resolve(this.getESAppFilePath())
        break;
      }
    /**
     * 获取EsApp运行时路径, 通常用于获取代码包里的assets
     * @return
     * /data/data/APK包名/app_rpk/apps/小程序包名/版本号/android
     * 示例:/data/data/com.extscreen.runtime/app_rpk/apps/es.com.baduanjin.tv/2.2.2203/android
     */
      case 'getESAppRuntimePath': {
        promise.resolve(this.getESAppRuntimePath())
        break;
      }
    //-------------------------------------------------------------------
      case 'getSupportSchemes': {
        LogUtils.d(this.TAG, '=======getSupportSchemes=========>>>>>');
        promise.resolve('')
        break;
      }
      case 'launchESPageByArgs': {
        LogUtils.d(this.TAG, '=======launchESPageByArgs=========>>>>>');
        promise.resolve([])
        break;
      }
      case 'launchESPage': {
        LogUtils.d(this.TAG, '=======launchESPage=========>>>>>');
        promise.resolve('')
        break;
      }
      case 'launchNativeApp': {
        LogUtils.d(this.TAG, '=======launchNativeApp=========>>>>>');
        promise.resolve([])
        break;
      }
      case 'launchNativeAppWithPackage': {
        LogUtils.d(this.TAG, '=======launchNativeAppWithPackage=========>>>>>');
        break;
      }
      case 'finish': {
        LogUtils.d(this.TAG, '=======finish=========>>>>>');
        break;
      }
      case 'finishAll': {
        LogUtils.d(this.TAG, '=======finishAll=========>>>>>');
        break;
      }
      case 'isModuleRegistered': {
        LogUtils.d(this.TAG, '=======isModuleRegistered=========>>>>>');
        promise.resolve(false)
        break;
      }
      case 'isComponentRegistered': {
        LogUtils.d(this.TAG, '=======isComponentRegistered=========>>>>>');
        promise.resolve(false)
        break;
      }
      default:
        super.call(method, params, promise);
    }
    return null;
  }


  //----------------------------------------------------------------------------------------
  // filesDir:        /data/storage/el2/base/haps/runtime/files
  // tempDir:         /data/storage/el2/base/haps/runtime/temp
  // bundleCodeDir:   /data/storage/el1/bundle
  // preferencesDir:  /data/storage/el2/base/haps/runtime/preferences

  /**
   * 获取EsApp路径, 用于文件存储管理
   * @return
   * /data/data/APK包名/app_rpk/apps/小程序包名/files
   * 示例:/data/data/com.extscreen.runtime/app_rpk/apps/es.com.baduanjin.tv/files
   */
  private getESAppFilePath(): string {
    return this.ctx.getAbilityContext().filesDir + "/app_rpk/apps/"
      + QTAppManager.getInstance().getPackageName() + "/files"
  }

  /**
   * 获取EsApp运行时路径, 通常用于获取代码包里的assets
   * @return
   * /data/data/APK包名/app_rpk/apps/小程序包名/版本号/android
   * 示例:/data/data/com.extscreen.runtime/app_rpk/apps/es.com.baduanjin.tv/2.2.2203/android
   */
  private getESAppRuntimePath(): string {
    return this.ctx.getAbilityContext().filesDir + "/app_rpk/apps/"
      + QTAppManager.getInstance().getPackageName() + "/files/"
      + QTAppManager.getInstance().getVersionCode() + "/ohos"
  }
}
