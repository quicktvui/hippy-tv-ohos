import {
  HippyEngineContext,
  HippyAny,
  HippyModulePromise,
  HippyNativeModule,
  LogUtils
} from 'hippy';

import { BaseModule } from '../BaseModule';

/**
 * 下载模块
 */
@HippyNativeModule({ name: "ESDownloadModule" })
export class ESDownloadModule extends BaseModule {
  public static readonly NAME: string = 'ESDownloadModule'
  public readonly TAG: string = 'ESDownloadModule'

  constructor(ctx: HippyEngineContext) {
    super(ctx)
  }

  initialize(): void {
  }

  public call(method: string, params: Array<HippyAny>, promise: HippyModulePromise): HippyAny {
    switch (method) {
      case 'initDefaultDownload': {
        LogUtils.d(this.TAG, '=======test=========>>>>>');
        break;
      }
      case 'initDownload': {
        LogUtils.d(this.TAG, '=======test=========>>>>>');
        break;
      }
      case 'download': {
        LogUtils.d(this.TAG, '=======test=========>>>>>');
        break;
      }
      case 'start': {
        LogUtils.d(this.TAG, '=======test=========>>>>>');
        break;
      }
      case 'stop': {
        LogUtils.d(this.TAG, '=======test=========>>>>>');
        break;
      }
      case 'cancel': {
        LogUtils.d(this.TAG, '=======test=========>>>>>');
        break;
      }
      case 'release': {
        LogUtils.d(this.TAG, '=======test=========>>>>>');
        break;
      }
      default:
        super.call(method, params, promise);
    }
    return null;
  }
}
