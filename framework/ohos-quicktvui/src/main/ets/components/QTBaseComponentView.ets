import { NodeContent } from '@kit.ArkUI'
import {
  NativeRenderContext,
  HippyAny,
  HippyCustomComponentView,
  HippyRenderCallback,
} from 'hippy'
import { HRValueUtils } from '../HRValueUtils';

export class QTBaseComponentView extends HippyCustomComponentView {
  childSlot: NodeContent | null = null

  constructor(ctx: NativeRenderContext) {
    super(ctx)
  }

  setProp(propKey: string, propValue: HippyAny): boolean {
    // console.info(QUICKTVUI_TAG,`QTRenderBaseView setProp:${propKey},propValue:${propValue}`)
    switch (propKey){
      case 'width':
        this.cssWidth = HRValueUtils.getNumber(propValue)
        return true;
      case 'height':
        this.cssHeight = HRValueUtils.getNumber(propValue);
        return true;
    }
    return super.setProp(propKey, propValue)
  }

  call(method: string, params: Array<HippyAny>, callback: HippyRenderCallback | null): void {
    //
    if (method == "getEsInfo") {
      if (callback) {
        const info = new Map<string, HippyAny>()
        callback(info)
      }
    }
  }
}
