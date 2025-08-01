import {
  HippyEngineContext,
  HippyAny,
  HippyModulePromise,
  HippyNativeModule,
  LogUtils
} from 'hippy';

import { BaseModule } from './BaseModule';

/**
 * TODO 待测试
 */
@HippyNativeModule({ name: "ESAudioPlayerModule" })
export class ESAudioPlayerModule extends BaseModule {
  public static readonly NAME: string = 'ESAudioPlayerModule'
  private readonly TAG: string = 'ESAudioPlayerModule'

  constructor(ctx: HippyEngineContext) {
    super(ctx)
  }

  initialize(): void {
  }

  destroy(): void {

  }

  public call(method: string, params: Array<HippyAny>, promise: HippyModulePromise): HippyAny {
    LogUtils.d(this.TAG, '=======call=======>>>>>method:' + method + " params:" + params);
    switch (method) {
      case 'init': {
        break;
      }
      case 'play': {
        break;
      }
      case 'start': {
        break;
      }
      case 'pause': {
        break;
      }
      case 'resume': {
        break;
      }
      case 'seekTo': {
        break;
      }
      case 'stop': {
        break;
      }
      case 'setPlayRate': {
        break;
      }
      case 'setVolume': {
        break;
      }
      case 'release': {
        break;
      }
      case 'isPlaying': {
        break;
      }
      case 'isPaused': {
        break;
      }
      case 'getDuration': {
        break;
      }
      case 'getCurrentPosition': {
        break;
      }
      case 'getBufferPercentage': {
        break;
      }
      case 'getCurrentPlayRate': {
        break;
      }
      case 'setVolume': {
        break;
      }
      case 'getLeftVolume': {
        break;
      }
      case 'getRightVolume': {
        break;
      }
      default:
        super.call(method, params, promise);
    }
    return null;
  }
}
