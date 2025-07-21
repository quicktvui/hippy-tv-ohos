import { HippyEngineContext } from 'hippy';
import { HippyModulePromise } from 'hippy/src/main/ets/hippy_framework/modules/HippyModulePromise';
import { HippyNativeModule } from 'hippy/src/main/ets/support/annotation/HippyNativeModule';
import { HippyAny } from 'hippy/src/main/ets/support/common/HippyTypes';
import { BaseModule } from './BaseModule';
import { LogUtils } from 'hippy/src/main/ets/support/utils/LogUtils'

@HippyNativeModule({ name: "ESModule" })
export class ESModule extends BaseModule {
  public static readonly NAME: string = 'ESModule'

  constructor(ctx: HippyEngineContext) {
    super(ctx)
  }

  initialize(): void {
  }

  public call(method: string, params: Array<HippyAny>, promise: HippyModulePromise): HippyAny {
    switch (method) {
      case 'getESDeviceInfo': {
        LogUtils.d('ESModule', '=======getESDeviceInfo=========>>>>>');
        promise.resolve({})
        break;
      }
      case 'getESSDKInfo': {
        LogUtils.d('ESModule', '=======getESSDKInfo=========>>>>>');
        promise.resolve({})
        break;
      }
      case 'getESSDKVersionCode': {
        LogUtils.d('ESModule', '=======getESSDKVersionCode=========>>>>>');
        promise.resolve(-1)
        break;
      }
      case 'getESSDKVersionName': {
        LogUtils.d('ESModule', '=======getESSDKVersionName=========>>>>>');
        promise.resolve('')
        break;
      }
      case 'getESPackageName': {
        LogUtils.d('ESModule', '=======getESPackageName=========>>>>>');
        promise.resolve('')
        break;
      }
      case 'getESMiniProgramPath': {
        LogUtils.d('ESModule', '=======getESMiniProgramPath=========>>>>>');
        promise.resolve('')
        break;
      }
      case 'getSupportSchemes': {
        LogUtils.d('ESModule', '=======getSupportSchemes=========>>>>>');
        promise.resolve('')
        break;
      }
      case 'launchESPageByArgs': {
        LogUtils.d('ESModule', '=======launchESPageByArgs=========>>>>>');
        promise.resolve([])
        break;
      }
      case 'launchESPage': {
        LogUtils.d('ESModule', '=======launchESPage=========>>>>>');
        promise.resolve('')
        break;
      }
      case 'launchNativeApp': {
        LogUtils.d('ESModule', '=======launchNativeApp=========>>>>>');
        promise.resolve([])
        break;
      }
      case 'launchNativeAppWithPackage': {
        LogUtils.d('ESModule', '=======launchNativeAppWithPackage=========>>>>>');
        break;
      }
      case 'finish': {
        LogUtils.d('ESModule', '=======finish=========>>>>>');
        break;
      }
      case 'finishAll': {
        LogUtils.d('ESModule', '=======finishAll=========>>>>>');
        break;
      }
      case 'isModuleRegistered': {
        LogUtils.d('ESModule', '=======isModuleRegistered=========>>>>>');
        promise.resolve(false)
        break;
      }
      case 'isComponentRegistered': {
        LogUtils.d('ESModule', '=======isComponentRegistered=========>>>>>');
        promise.resolve(false)
        break;
      }
      default:
        super.call(method, params, promise);
    }
    return null;
  }
}
