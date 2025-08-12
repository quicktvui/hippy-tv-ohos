import {
  HippyEngineContext,
  HippyAny,
  HippyModulePromise,
  HippyNativeModule,
  LogUtils
} from 'hippy';

import { BaseModule } from './BaseModule';

@HippyNativeModule({ name: "ESAudioModule" })
export class ESAudioModule extends BaseModule {
  public static readonly NAME: string = 'ESAudioModule'
  public readonly TAG: string = 'ESAudioModule'

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
