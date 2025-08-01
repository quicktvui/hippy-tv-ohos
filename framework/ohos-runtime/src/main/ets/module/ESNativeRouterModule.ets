import {
  HippyEngineContext,
  HippyAny,
  HippyModulePromise,
  HippyNativeModule,
  LogUtils
} from 'hippy';

import { BaseModule } from './BaseModule';

/**
 *
 */
@HippyNativeModule({ name: "ESNativeRouterModule" })
export class ESNativeRouterModule extends BaseModule {
  public static readonly NAME: string = 'ESNativeRouterModule'
  public readonly TAG: string = 'ESNativeRouterModule'

  constructor(ctx: HippyEngineContext) {
    super(ctx)
  }

  initialize(): void {
  }

  public call(method: string, params: Array<HippyAny>, promise: HippyModulePromise): HippyAny {
    switch (method) {
      case 'back': {
        //
        const navPathStack = AppStorage.get<NavPathStack>("MainNavPathStack")
        if (navPathStack) {
          navPathStack.pop(false)
          LogUtils.d(this.TAG, 'back success');
        } else {
          LogUtils.d(this.TAG, 'back error! NavPathStack is null!');
        }
        //
        break;
      }
      default:
        super.call(method, params, promise);
    }
    return null;
  }
}
