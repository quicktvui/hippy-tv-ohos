/**
 *
 */
import { HippyNativeModule } from '../../../../support/annotation/HippyNativeModule'
import { HippyAny } from '../../../../support/common/HippyTypes'
import { HippyEngineContext } from '../../../HippyEngineContext'
import { EventDispatcher } from '../../javascript/EventDispatcher'
import { HippyNativeModuleBase } from '../HippyNativeModuleBase'

@HippyNativeModule({ name: "LifecycleEventModule" })
export class LifecycleEventModule extends HippyNativeModuleBase {
  public static readonly NAME = 'LifecycleEventModule'

  constructor(ctx: HippyEngineContext) {
    super(ctx)
  }

  public onLifecycleEvent(event: string, params: HippyAny): boolean {
    let scriptModule = this.ctx.getModuleManager().getJavaScriptModule(EventDispatcher.MODULE_NAME)
    if (scriptModule != null) {
      const evt = new Map<string, HippyAny>();
      evt.set("name", event);
      evt.set("params", params);
      (scriptModule as EventDispatcher).receiveNativeEvent("onLifecycleEvent", evt);
      return true;
    } else {
      return false;
    }
  }

  public destroy() {
  }
}
