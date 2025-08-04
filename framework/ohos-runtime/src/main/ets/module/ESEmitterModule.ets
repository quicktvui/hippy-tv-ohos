import {
  HippyEngineContext,
  HippyAny,
  HippyModulePromise,
  HippyNativeModule,
  LogUtils,
  HippyRecord
} from 'hippy';

import { BaseModule } from './BaseModule';
import { emitter } from '@kit.BasicServicesKit';

/**
 *
 */
@HippyNativeModule({ name: "ESEmitterModule" })
export class ESEmitterModule extends BaseModule {
  public static readonly NAME: string = 'ESEmitterModule'
  public readonly TAG: string = 'ESEmitterModule'

  constructor(ctx: HippyEngineContext) {
    super(ctx)
  }

  initialize(): void {
  }

  public call(method: string, params: Array<HippyAny>, promise: HippyModulePromise): HippyAny {
    switch (method) {
      case 'emit': {
        const eventId = params[0] as number
        const priority = params[1] as number
        const data = params[2] as HippyRecord
        let event: emitter.InnerEvent = {
          eventId: eventId,
          priority: priority as emitter.EventPriority
        };
        let eventData: emitter.EventData = {
          data: data
        };
        LogUtils.i(this.TAG,
          `emit → eventId: ${eventId}, priority: ${priority}, data: ${JSON.stringify(data)}`);
        emitter.emit(event, eventData);
        break;
      }
      case 'off': {
        const eventId = params[0] as number
        LogUtils.i(this.TAG, `off → eventId: ${eventId}`);
        emitter.off(eventId);
        break;
      }
      case 'once': {
        const eventId = params[0] as number
        let event: emitter.InnerEvent = {
          eventId: eventId
        };
        let callback: Callback<emitter.EventData> = (eventData: emitter.EventData) => {
          LogUtils.i(this.TAG,
            `once callback → eventId: ${eventId}, data: ${JSON.stringify(eventData.data ?? null)}`);
          this.dispatchEvent(eventId + '', eventData.data ? eventData.data as HippyRecord : null);
        }
        LogUtils.i(this.TAG, `once → eventId: ${eventId}`);
        emitter.once(event, callback);
        break;
      }
      case 'on': {
        const eventId = params[0] as number
        let event: emitter.InnerEvent = {
          eventId: eventId
        };
        let callback: Callback<emitter.EventData> = (eventData: emitter.EventData) => {
          LogUtils.i(this.TAG,
            `on callback → eventId: ${eventId}, data: ${JSON.stringify(eventData.data ?? null)}`);
          this.dispatchEvent(eventId + '', eventData.data ? eventData.data as HippyRecord : null);
        }
        LogUtils.i(this.TAG, `on → eventId: ${eventId}`);
        emitter.on(event, callback);
        break;
      }
      default: {
        LogUtils.w(this.TAG, `Unknown method called: ${method}`);
        super.call(method, params, promise);
      }
    }
    return null;
  }
}
