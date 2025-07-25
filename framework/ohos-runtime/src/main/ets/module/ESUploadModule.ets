import {
  HippyEngineContext,
  HippyAny,
  HippyModulePromise,
  HippyNativeModule,
  LogUtils
} from 'hippy';

import { BaseModule } from './BaseModule';

/**
 * TODO
 */
@HippyNativeModule({ name: "ESUploadModule" })
export class ESUploadModule extends BaseModule {
  public static readonly NAME: string = 'ESUploadModule'
  public readonly TAG: string = 'ESUploadModule'

  constructor(ctx: HippyEngineContext) {
    super(ctx)
  }

  initialize(): void {
  }

  public call(method: string, params: Array<HippyAny>, promise: HippyModulePromise): HippyAny {
    switch (method) {
      case 'test': {
        LogUtils.d(this.TAG, '=======test=========>>>>>');
        break;
      }
      default:
        super.call(method, params, promise);
    }
    return null;
  }
}
